################################################################################
#
# r8168 is the Linux device driver released for Realtek Gigabit Ethernet
# controllers with PCI-Express interface.
#
# Copyright(c) 2013 Realtek Semiconductor Corp. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <http://www.gnu.org/licenses/>.
#
# Author:
# Realtek NIC software team <nicfae@realtek.com>
# No. 2, Innovation Road II, Hsinchu Science Park, Hsinchu 300, Taiwan
#
################################################################################

################################################################################
#  This product is covered by one or more of the following patents:
#  US6,570,884, US6,115,776, and US6,327,625.
################################################################################


all:	modules

CONFIG_ASPM = y
ENABLE_S5WOL = y

ifneq ($(KERNELRELEASE),)
	obj-m := r8168.o
	r8168-objs := src/r8168_n.o src/r8168_asf.o src/rtl_eeprom.o src/rtltool.o
	EXTRA_CFLAGS += -DCONFIG_R8168_NAPI
	EXTRA_CFLAGS += -DCONFIG_R8168_VLAN
	ifeq ($(CONFIG_ASPM), y)
		EXTRA_CFLAGS += -DCONFIG_ASPM
	endif
	ifeq ($(ENABLE_S5WOL), y)
		EXTRA_CFLAGS += -DENABLE_S5WOL
	endif
else
	KSRC := /lib/modules/$(shell uname -r)/build
	PWD :=$(shell pwd)

all: modules

modules:
	$(MAKE) -C $(KSRC) M=$(PWD) modules

clean:
	rm -rf src/*.o *.ko
	rm Module.symvers modules.order
endif



