Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3KIUhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 15:37:47 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:48939 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3KIUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 15:37:42 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>
Subject: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
Date: Sat,  9 Nov 2013 21:37:31 +0100
Message-Id: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DTS and defconfig for the Terasic DE0-Nano Development and Education
Board running ORPSoC.  This board contains an Altera Cyclone IV FPGA with
support chips and I/O.

The DTS was derived from published versions by Kevin Mehall and Marek
Czerski.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kevin Mehall <contact@kevinmehall.net>
Cc: Marek Czerski <ma.czerski@gmail.com>
---
Notable changes:
  - Change flash0 to spansion,s25sl064p, due to kernel message
    m25p80 spi32766.0: found s25sl064p, expected m25p10
  - Use reg-shift instead of regstep for i2c0, due to kernel message
    ocores-i2c a0000000.ocores: regstep property deprecated, use reg-shift

 arch/openrisc/boot/dts/de0_nano.dts      |  158 ++++++++++++++++++++++++++++++
 arch/openrisc/configs/de0_nano_defconfig |   86 ++++++++++++++++
 2 files changed, 244 insertions(+)
 create mode 100644 arch/openrisc/boot/dts/de0_nano.dts
 create mode 100644 arch/openrisc/configs/de0_nano_defconfig

diff --git a/arch/openrisc/boot/dts/de0_nano.dts b/arch/openrisc/boot/dts/de0_nano.dts
new file mode 100644
index 000000000000..42f91b5184d9
--- /dev/null
+++ b/arch/openrisc/boot/dts/de0_nano.dts
@@ -0,0 +1,158 @@
+/dts-v1/;
+/ {
+	compatible = "opencores,de0_nano";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&pic>;
+
+	chosen {
+		bootargs = "console=uart,mmio,0x90000000,115200";
+	};
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x00000000 0x02000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@0 {
+			compatible = "opencores,or1200-rtlsvn481";
+			reg = <0>;
+			clock-frequency = <50000000>;
+		};
+	};
+
+	/*
+	 * OR1K PIC is built into CPU and accessed via special purpose
+	 * registers.  It is not addressable and, hence, has no 'reg'
+	 * property.
+	 */
+	pic: pic {
+		compatible = "opencores,or1k-pic";
+		#interrupt-cells = <1>;
+		interrupt-controller;
+	};
+
+	serial0: serial@90000000 {
+		compatible = "opencores,uart16550-rtlsvn105", "ns16550a";
+		reg = <0x90000000 0x100>;
+		interrupts = <2>;
+		clock-frequency = <50000000>;
+	};
+
+	i2c0: ocores@a0000000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "opencores,i2c-ocores";
+		reg = <0xa0000000 0x8>;
+		interrupts = <10>;
+		clock-frequency = <50000000>;
+
+		reg-shift = <0>;	/* 8 bit registers */
+		reg-io-width = <1>;	/* 8 bit read/write */
+
+		adxl34x@1d {
+			compatible = "adxl34x";
+			reg = <0x1d>;
+			interrupts = <26>;
+		};
+		eeprom@50 {
+			compatible = "at24,24c02";
+			reg = <0x50>;
+			pagesize = <8>;
+		};
+	};
+
+	spi0: spi0@b0000000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "opencores,spi-simple";
+		reg = <0xb0000000 0x5>;
+
+		flash0: mtd@0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "spansion,s25sl064p";
+			reg = <0>;
+			spi-max-frequency = <40000000>;
+			m25p,fast-read;
+
+			partition@0 {
+				label = "FPGA image";
+				reg = <0x00000000 0x000b0000>;
+				read-only;
+			};
+			partition@b0000 {
+				label = "bootloader";
+				reg = <0x000b0000 0x00050000>;
+				read-only;
+			};
+			partition@100000 {
+				label = "free space";
+				reg = <0x00100000 0x00700000>;
+			};
+		};
+	};
+
+	spi1: spi1@b1000000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "opencores,spi-simple";
+		reg = <0xb1000000 0x5>;
+
+		adc@0 {
+			compatible = "adcxx,adcxx8s";
+			reg = <0>;
+			spi-max-frequency = <1000000>;
+		};
+	};
+
+	gpio0: gpio@91000000 {
+		compatible = "opencores,jbtrivial";
+		reg = <0x91000000 0x2>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		xlnx,data-offset = <0>;
+		xlnx,tri-offset = <1>;
+		xlnx,gpio-width = <8>;
+	};
+
+	gpio-leds {
+		compatible = "gpio-leds";
+		heartbeat {
+			label = "Heartbeat";
+			gpios = <&gpio0 0 0x0>;
+			linux,default-trigger = "heartbeat";
+		};
+		led1 {
+			label = "led1";
+			gpios = <&gpio0 1 0>;
+		};
+		led2 {
+			label = "led2";
+			gpios = <&gpio0 2 0>;
+		};
+		led3 {
+			label = "led3";
+			gpios = <&gpio0 3 0>;
+		};
+		led4 {
+			label = "led4";
+			gpios = <&gpio0 4 0>;
+		};
+		led5 {
+			label = "led5";
+			gpios = <&gpio0 5 0>;
+		};
+		led6 {
+			label = "led6";
+			gpios = <&gpio0 6 0>;
+		};
+		led7 {
+			label = "led7";
+			gpios = <&gpio0 7 0>;
+		};
+	};
+};
diff --git a/arch/openrisc/configs/de0_nano_defconfig b/arch/openrisc/configs/de0_nano_defconfig
new file mode 100644
index 000000000000..bce8f4862e5e
--- /dev/null
+++ b/arch/openrisc/configs/de0_nano_defconfig
@@ -0,0 +1,86 @@
+CONFIG_CROSS_COMPILE="or32-linux-"
+CONFIG_NO_HZ=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE="arch/openrisc/support/initramfs arch/openrisc/support/initramfs.devnodes"
+# CONFIG_RD_GZIP is not set
+CONFIG_EXPERT=y
+# CONFIG_KALLSYMS is not set
+# CONFIG_EPOLL is not set
+# CONFIG_TIMERFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_AIO is not set
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_COMPAT_BRK is not set
+CONFIG_SLOB=y
+CONFIG_MODULES=y
+# CONFIG_BLOCK is not set
+CONFIG_OPENRISC_BUILTIN_DTB="de0_nano"
+CONFIG_HZ_100=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+CONFIG_TCP_CONG_ADVANCED=y
+# CONFIG_TCP_CONG_BIC is not set
+# CONFIG_TCP_CONG_CUBIC is not set
+# CONFIG_TCP_CONG_WESTWOOD is not set
+# CONFIG_TCP_CONG_HTCP is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FW_LOADER is not set
+CONFIG_MTD=y
+CONFIG_MTD_M25P80=y
+# CONFIG_M25PXX_USE_FAST_READ is not set
+CONFIG_PROC_DEVICETREE=y
+CONFIG_EEPROM_AT24=y
+CONFIG_NETDEVICES=y
+# CONFIG_ETHERNET is not set
+# CONFIG_WLAN is not set
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+CONFIG_INPUT_MISC=y
+CONFIG_INPUT_ADXL34X=y
+# CONFIG_INPUT_ADXL34X_SPI is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_I2C=y
+# CONFIG_I2C_COMPAT is not set
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_OCORES=y
+CONFIG_SPI=y
+CONFIG_SPI_OCSIMPLE=y
+CONFIG_GPIO_JBTRIVIAL=y
+CONFIG_SENSORS_ADCXX=y
+# CONFIG_HID is not set
+# CONFIG_USB_SUPPORT is not set
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_ONESHOT=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_GPIO=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_LEDS_TRIGGER_TRANSIENT=y
+# CONFIG_DNOTIFY is not set
+CONFIG_TMPFS=y
+CONFIG_NFS_FS=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
-- 
1.7.9.5

