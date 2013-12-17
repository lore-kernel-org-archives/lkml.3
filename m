Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3LQTjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:39:14 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37887 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3LQTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:39:08 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH v3 08/21] ARM: pxa27x: device tree support ICP DAS LP-8x4x
Date: Tue, 17 Dec 2013 23:37:38 +0400
Message-Id: <1387309071-22382-9-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387309071-22382-1-git-send-email-ynvich@gmail.com>
References: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
 <1387309071-22382-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICP DAS calls LP-8x4x 'programmable automation controller'. It is
an industrial computer based on PXA270 SoC. They ship it with a 2.6.19
kernel and proprietary kernel module and userspace library to access
its industrial IO.

This patch allows to boot the device with a modern kernel with device
tree. It adds support for:
* MMC card interface on PXA270
* USB 1.1 port on PXA270
* 2 NOR flash devices
* 2 onboard ethernet Davicom DM9000 devices
* 3 serial UART ports on PXA270
* front panel red LED
* 64bit 1-wire system ID chip
* 16 kiB EEPROM (reading)

Support for these devices will be added in separate patches, since
they are not currently supported by the kernel:
* DS1302 RTC
* 512kiB SRAM
* FPGA irq chip
* 3 built-in 16550A serial UART ports
* industrial IO parallel bus
* 10 position rotary switch
* 8 pin DIP switch
* 16 kiB EEPROM (writing)
* serial interface for digital and analog industrial IO modules on
  parallel bus (all I-87... modules)
* digital and analog industrial IO modules for parallel bus:
  ** I-8024 4 port analog output
  ** I-8041 32 port digital output
  ** I-8042 16 port digital output/16 port digital input

Not supported for now:
* VGA interface on PXA270 for lack of dts binding
* the rest of parallel bus (I-8...) modules for lack of hardware
* GPIO reset for lack of relevance (watchdog reset is working)

NOTE: USB support requires U-Boot patch series which setups GPIO.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
   v2..v3
   * added extbus which maps synchronous, static, and variable-latency
     I/O (VLIO) interfaces of PXA27x SoC as suggested by Arnd Bergmann
   * map is placed into platform include
   * configured existing kernel drivers to support:
     - front panel LED using gpio-leds
     - 64bit 1-wire system ID chip using w1-gpio
     - 16 kiB EEPROM using at24 over i2c-gpio
   * number change (06/16 -> 08/21)

   v1..v2
   * drop left-over extern declaration
   * use of_have_populated_dt() instead of a static variable
   * drop wildcards in compatible
   * drop machine-special machine description
   * number changed from 9 to 6 (dropped patches)

 arch/arm/boot/dts/Makefile          |   1 +
 arch/arm/boot/dts/pxa27x-lp8x4x.dts | 153 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/pxa27x.dtsi       |  17 ++++
 arch/arm/configs/lp8x4x_defconfig   | 168 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/Kconfig           |  15 ++++
 arch/arm/mach-pxa/Makefile          |   1 +
 arch/arm/mach-pxa/pxa27x-dt.c       |  64 ++++++++++++++
 7 files changed, 419 insertions(+)
 create mode 100644 arch/arm/boot/dts/pxa27x-lp8x4x.dts
 create mode 100644 arch/arm/configs/lp8x4x_defconfig
 create mode 100644 arch/arm/mach-pxa/pxa27x-dt.c

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index d57c1a6..c4752ff 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -206,6 +206,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	dra7-evm.dtb
 dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-ethernet-disk-mini-v2.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
+dtb-$(CONFIG_MACH_PXA27X_DT) += pxa27x-lp8x4x.dtb
 dtb-$(CONFIG_ARCH_U8500) += ste-snowball.dtb \
 	ste-hrefprev60-stuib.dtb \
 	ste-hrefprev60-tvk.dtb \
diff --git a/arch/arm/boot/dts/pxa27x-lp8x4x.dts b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
new file mode 100644
index 0000000..6a780fe
--- /dev/null
+++ b/arch/arm/boot/dts/pxa27x-lp8x4x.dts
@@ -0,0 +1,153 @@
+/* Device tree for ICP DAS LP-8x4x */
+/dts-v1/;
+
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+#include "pxa27x.dtsi"
+
+/ {
+	model = "ICP DAS LP-8x4x programmable automation controller";
+	compatible = "marvell,lp8x4x", "marvell,pxa270";
+
+	aliases {
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+	};
+
+	memory {
+		reg = <0xa0000000 0x08000000>;
+	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vmmc: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "vmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
+
+	pxabus {
+		pxairq: interrupt-controller@40d00000 {
+			marvell,intc-priority;
+			marvell,intc-nr-irqs = <34>;
+		};
+
+		uart@40100000 {
+			status = "okay";
+		};
+
+		uart@40200000 {
+			status = "okay";
+		};
+
+		uart@40700000 {
+			status = "okay";
+		};
+
+		mmc@41100000 {
+			status = "okay";
+			vmmc-supply = <&vmmc>;
+		};
+
+		ohci@4c000000 {
+			status = "okay";
+			marvell,port-mode = <3>;
+			marvell,oc-mode-perport;
+			marvell,enable-port1;
+		};
+
+		leds {
+			compatible = "gpio-leds";
+
+			status {
+				gpios = <&gpio 84 1>;
+				linux,default-trigger = "heartbeat";
+			};
+		};
+
+		i2c: i2c-gpio {
+			compatible = "i2c-gpio";
+			gpios = <&gpio 22 0 /* sda */
+				 &gpio 12 0 /* scl */>;
+			i2c-gpio,delay-us = <1>;
+			i2c-gpio,timeout-ms = <1>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			eeprom@50 {
+				compatible = "atmel,24c128";
+				reg = <0x50>;
+				pagesize = <64>;
+			};
+		};
+
+		w1: w1-gpio {
+			compatible = "w1-gpio";
+			gpios = <&gpio 83 0>;
+		};
+	};
+
+	extbus {
+		flash@0 {
+			compatible = "cfi-flash";
+			reg = <0 0 0x02000000>;
+			bank-width = <4>;
+			device-width = <2>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			fs@0 {
+				label = "u-boot";
+				reg = <0 0x40000>;
+			};
+			fs@40000 {
+				label = "settings";
+				reg = <0x40000 0x40000>;
+			};
+			fs@80000 {
+				label = "kernel";
+				reg = <0x80000 0x280000>;
+			};
+			fs@300000 {
+				label = "root_fs";
+				reg = <0x300000 0x1d00000>;
+			};
+		};
+
+		flash@1 {
+			compatible = "cfi-flash";
+			reg = <1 0x0 0x01000000>;
+			bank-width = <2>;
+			device-width = <1>;
+		};
+
+		netio@3 {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 3 0 0x02000000>;
+			interrupt-parent = <&gpio>;
+
+			eth0: eth@0 {
+				compatible = "davicom,dm9000";
+				reg = <0x0 0x2
+				       0x4000 0x2>;
+				interrupts = <9 IRQ_TYPE_EDGE_RISING>;
+				status = "okay";
+			};
+
+			eth1: eth@1000000 {
+				compatible = "davicom,dm9000";
+				reg = <0x1000000 0x2
+				       0x1004000 0x2>;
+				interrupts = <82 IRQ_TYPE_EDGE_RISING>;
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index c2a90c5..29d878d 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -31,4 +31,21 @@
 			dma-names = "rx", "tx";
 		};
 	};
+
+	extbus {
+		/*
+		 * PXA27x synchrous, static and
+		 * variable-latency IO interfaces
+		 */
+	        compatible = "simple-bus";
+
+		#address-cells = <2>; /* first cell is nCS, second is address */
+		#size-cells = <1>;
+		ranges = <0 0 0 0x04000000
+			  1 0 0x04000000 0x04000000
+			  2 0 0x08000000 0x04000000
+			  3 0 0x0c000000 0x04000000
+			  4 0 0x10000000 0x04000000
+			  5 0 0x14000000 0x04000000>;
+	};
 };
diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
new file mode 100644
index 0000000..9f1efb6
--- /dev/null
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -0,0 +1,168 @@
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_RCU_BOOST=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_NAMESPACES=y
+# CONFIG_UTS_NS is not set
+# CONFIG_IPC_NS is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+# CONFIG_UID16 is not set
+# CONFIG_SHMEM is not set
+CONFIG_EMBEDDED=y
+# CONFIG_COMPAT_BRK is not set
+CONFIG_SLOB=y
+CONFIG_JUMP_LABEL=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+# CONFIG_LBDAF is not set
+CONFIG_BLK_CMDLINE_PARSER=y
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_EFI_PARTITION is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_PXA=y
+CONFIG_MACH_PXA27X_DT=y
+# CONFIG_ARM_THUMB is not set
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_COMPACTION is not set
+# CONFIG_CROSS_MEMORY_ATTACH is not set
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE="init=/sbin/init root=/dev/mmcblk0p1 rw rootfstype=ext4 console=ttyS0,115200 mem=128M rootwait"
+# CONFIG_SUSPEND is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_BRIDGE=m
+CONFIG_BRIDGE_VLAN_FILTERING=y
+CONFIG_VLAN_8021Q=m
+CONFIG_VLAN_8021Q_GVRP=y
+CONFIG_VLAN_8021Q_MVRP=y
+# CONFIG_WIRELESS is not set
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_FW_LOADER is not set
+CONFIG_MTD=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_PROC_DEVICETREE=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_LOOP_MIN_COUNT=2
+CONFIG_EEPROM_AT24=m
+CONFIG_SCSI=y
+# CONFIG_SCSI_PROC_FS is not set
+CONFIG_BLK_DEV_SD=y
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+CONFIG_BONDING=m
+CONFIG_MACVLAN=m
+CONFIG_MACVTAP=m
+CONFIG_TUN=m
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+CONFIG_DM9000=y
+CONFIG_DM9000_FORCE_SIMPLE_PHY_POLL=y
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+CONFIG_PPP=m
+CONFIG_PPP_BSDCOMP=m
+CONFIG_PPP_DEFLATE=m
+CONFIG_PPPOE=m
+CONFIG_PPP_ASYNC=m
+CONFIG_PPP_SYNC_TTY=m
+CONFIG_SLIP=m
+CONFIG_SLIP_COMPRESSED=y
+# CONFIG_WLAN is not set
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=800
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=600
+CONFIG_INPUT_EVDEV=y
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=40
+CONFIG_SERIAL_8250_RUNTIME_UARTS=40
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_MANY_PORTS=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_PXA=y
+CONFIG_HW_RANDOM=y
+CONFIG_I2C=m
+# CONFIG_I2C_COMPAT is not set
+CONFIG_I2C_GPIO=m
+CONFIG_W1=m
+CONFIG_W1_MASTER_GPIO=m
+CONFIG_W1_SLAVE_SMEM=m
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_SA1100_WATCHDOG=m
+CONFIG_REGULATOR=y
+CONFIG_REGULATOR_FIXED_VOLTAGE=y
+CONFIG_FB=y
+CONFIG_FB_PXA=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_LOGO=y
+CONFIG_USB=m
+CONFIG_USB_OHCI_HCD=m
+CONFIG_USB_ACM=m
+CONFIG_USB_PRINTER=m
+CONFIG_USB_STORAGE=m
+CONFIG_USB_SERIAL=m
+CONFIG_MMC=y
+CONFIG_MMC_PXA=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_PXA=m
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_REISERFS_FS=m
+CONFIG_ISO9660_FS=m
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_NTFS_FS=m
+CONFIG_NTFS_RW=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_COMPRESSION_OPTIONS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V4=y
+CONFIG_ROOT_NFS=y
+CONFIG_CIFS=m
+CONFIG_CIFS_STATS=y
+CONFIG_CODA_FS=m
+CONFIG_NLS_DEFAULT="cp855"
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_CODEPAGE_855=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_UTF8=y
+CONFIG_PRINTK_TIME=y
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 96100db..df3a79d 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -4,6 +4,21 @@ menu "Intel PXA2xx/PXA3xx Implementations"
 
 comment "Intel/Marvell Dev Platforms (sorted by hardware release time)"
 
+config MACH_PXA27X_DT
+	bool "Support PXA27x platforms from device tree"
+	select PXA27x
+	select USE_OF
+	help
+	  Include support for Marvell PXA27x based platforms using
+	  the device tree.
+
+	  While MACH_PXA27X_DT when enabled should boot any PXA27x
+	  compatible machine, it still makes sense to select specific
+	  machines. Those options will select required features and
+	  provide per-machine errata workarounds.
+
+	  If unsure, say Y.
+
 config MACH_PXA3XX_DT
 	bool "Support PXA3xx platforms from device tree"
 	select CPU_PXA300
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 648867a..adaa72a 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_CPU_PXA930)	+= pxa930.o
 # NOTE: keep the order of boards in accordance to their order in Kconfig
 
 # Device Tree support
+obj-$(CONFIG_MACH_PXA27X_DT)	+= pxa27x-dt.o
 obj-$(CONFIG_MACH_PXA3XX_DT)	+= pxa-dt.o
 
 # Intel/Marvell Dev Platforms
diff --git a/arch/arm/mach-pxa/pxa27x-dt.c b/arch/arm/mach-pxa/pxa27x-dt.c
new file mode 100644
index 0000000..865cf46
--- /dev/null
+++ b/arch/arm/mach-pxa/pxa27x-dt.c
@@ -0,0 +1,64 @@
+/*
+ *  linux/arch/arm/mach-pxa/pxa27x-dt.c
+ *
+ *  Copyright (C) 2013 Sergei Ianovich
+ *
+ *  based mostly on linux/arch/arm/mach-pxa/pxa-dt.c by Daniel Mack
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <asm/io.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <mach/irqs.h>
+#include <mach/pxa27x.h>
+
+#include "generic.h"
+
+#ifdef CONFIG_PXA27x
+static const struct of_dev_auxdata pxa27x_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("mrvl,pxa-uart",	    0x40100000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("mrvl,pxa-uart",	    0x40200000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("mrvl,pxa-uart",	    0x40700000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("mrvl,pxa-uart",	    0x41600000, "pxa2xx-uart.3", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-mmc",   0x41100000, "pxa2xx-mci.0", NULL),
+	OF_DEV_AUXDATA("intel,pxa27x-gpio", 0x40e00000, "pxa27x-gpio", NULL),
+	OF_DEV_AUXDATA("marvell,pxa-ohci",  0x4c000000, "pxa27x-ohci", NULL),
+	OF_DEV_AUXDATA("mrvl,pxa-i2c",	    0x40301680, "pxa2xx-i2c.0", NULL),
+	{}
+};
+
+static void __init pxa27x_dt_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     pxa27x_auxdata_lookup, NULL);
+}
+
+static const char * const pxa27x_dt_board_compat[] __initconst = {
+	"marvell,pxa270",
+	"marvell,pxa271",
+	"marvell,pxa272",
+	NULL,
+};
+
+#endif
+
+#ifdef CONFIG_PXA27x
+DT_MACHINE_START(PXA27X_DT, "Marvell PXA27x (Device Tree Support)")
+	.map_io		= pxa27x_map_io,
+	.init_irq	= pxa27x_dt_init_irq,
+	.handle_irq	= pxa27x_handle_irq,
+	.init_time	= pxa_timer_init,
+	.restart	= pxa_restart,
+	.init_machine	= pxa27x_dt_init,
+	.dt_compat	= pxa27x_dt_board_compat,
+MACHINE_END
+
+#endif
-- 
1.8.4.2

