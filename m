Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaLYR6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 12:58:12 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38137 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaLYR5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 12:57:36 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jaedon.shin@gmail.com, abrestic@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V6 23/25] MIPS: BMIPS: Refresh BCM3384 DTS files
Date: Thu, 25 Dec 2014 09:49:18 -0800
Message-Id: <1419529760-9520-24-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
References: <1419529760-9520-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DT bindings for this platform have changed as the bootloader and
product requirements evolved.  In particular, there are both
Linux-on-Zephyr and Linux-on-Viper configurations.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/boot/dts/brcm/bcm3384.dtsi        | 109 ------------------------
 arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi | 126 ++++++++++++++++++++++++++++
 arch/mips/boot/dts/brcm/bcm93384wvg.dts     |   9 +-
 3 files changed, 127 insertions(+), 117 deletions(-)
 delete mode 100644 arch/mips/boot/dts/brcm/bcm3384.dtsi
 create mode 100644 arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi

diff --git a/arch/mips/boot/dts/brcm/bcm3384.dtsi b/arch/mips/boot/dts/brcm/bcm3384.dtsi
deleted file mode 100644
index 21b074a..0000000
diff --git a/arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi b/arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi
new file mode 100644
index 0000000..a7bd856
--- /dev/null
+++ b/arch/mips/boot/dts/brcm/bcm3384_zephyr.dtsi
@@ -0,0 +1,126 @@
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "brcm,bcm3384", "brcm,bcm33843";
+
+	memory@0 {
+		device_type = "memory";
+
+		/* Typical range.  The bootloader should fill this in. */
+		reg = <0x0 0x08000000>;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		/* On BMIPS5000 this is 1/8th of the CPU core clock */
+		mips-hpt-frequency = <100000000>;
+
+		cpu@0 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "brcm,bmips5000";
+			device_type = "cpu";
+			reg = <1>;
+		};
+	};
+
+	cpu_intc: cpu_intc {
+		#address-cells = <0>;
+		compatible = "mti,cpu-interrupt-controller";
+
+		interrupt-controller;
+		#interrupt-cells = <1>;
+	};
+
+	clocks {
+		periph_clk: periph_clk {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <54000000>;
+		};
+	};
+
+	aliases {
+		uart0 = &uart0;
+	};
+
+	ubus {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		compatible = "brcm,ubus", "simple-bus";
+		ranges;
+		dma-ranges = <0x00000000 0x08000000 0x08000000>,
+			     <0x08000000 0x00000000 0x08000000>;
+
+		periph_intc: periph_intc@14e00038 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x14e00038 0x4 0x14e0003c 0x4>,
+			      <0x14e00340 0x4 0x14e00344 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <4>;
+		};
+
+		zmips_intc: zmips_intc@104b0060 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x104b0060 0x4 0x104b0064 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&periph_intc>;
+			interrupts = <29>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		iop_intc: iop_intc@14e00058 {
+			compatible = "brcm,bcm3380-l2-intc";
+			reg = <0x14e00058 0x4 0x14e0005c 0x4>;
+
+			interrupt-controller;
+			#interrupt-cells = <1>;
+
+			interrupt-parent = <&cpu_intc>;
+			interrupts = <6>;
+			brcm,int-map-mask = <0xffffffff>;
+		};
+
+		uart0: serial@14e00520 {
+			compatible = "brcm,bcm6345-uart";
+			reg = <0x14e00520 0x18>;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <2>;
+			clocks = <&periph_clk>;
+			status = "disabled";
+		};
+
+		ehci0: usb@15400300 {
+			compatible = "brcm,bcm3384-ehci", "generic-ehci";
+			reg = <0x15400300 0x100>;
+			big-endian;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <41>;
+			status = "disabled";
+		};
+
+		ohci0: usb@15400400 {
+			compatible = "brcm,bcm3384-ohci", "generic-ohci";
+			reg = <0x15400400 0x100>;
+			big-endian;
+			no-big-frame-no;
+			interrupt-parent = <&periph_intc>;
+			interrupts = <40>;
+			status = "disabled";
+		};
+	};
+};
diff --git a/arch/mips/boot/dts/brcm/bcm93384wvg.dts b/arch/mips/boot/dts/brcm/bcm93384wvg.dts
index 8317411..d1e44a1 100644
--- a/arch/mips/boot/dts/brcm/bcm93384wvg.dts
+++ b/arch/mips/boot/dts/brcm/bcm93384wvg.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "bcm3384.dtsi"
+/include/ "bcm3384_zephyr.dtsi"
 
 / {
 	compatible = "brcm,bcm93384wvg", "brcm,bcm3384";
@@ -10,13 +10,6 @@
 		bootargs = "console=ttyS0,115200";
 		stdout-path = &uart0;
 	};
-
-	memory@0 {
-		device_type = "memory";
-		reg = <0x0 0x04000000>;
-		dma-xor-mask = <0x08000000>;
-		dma-xor-limit = <0x0fffffff>;
-	};
 };
 
 &uart0 {
-- 
2.1.1

