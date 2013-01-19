Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3ASGoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 01:44:07 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:63762 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3ASGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 01:44:04 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: olof@lixom.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@lists.infradead.org, arm@kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] dts: vt8500: Add initial dts support for WM8850
Date: Sat, 19 Jan 2013 19:44:28 +1300
Message-Id: <1358577868-29042-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a soc dtsi for the Wondermedia WM8850.

A board dts file is also included for the W70v2 tablet, with support
for all the drivers currently in mainline.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
Hi Olof,

Sorry this is a bit late.

Regards
Tony P

 arch/arm/boot/dts/Makefile         |    3 +-
 arch/arm/boot/dts/wm8850-w70v2.dts |   47 ++++++++
 arch/arm/boot/dts/wm8850.dtsi      |  224 ++++++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/wm8850-w70v2.dts
 create mode 100644 arch/arm/boot/dts/wm8850.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 5ebb44f..8a75991 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -151,7 +151,8 @@ dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2p-ca5s.dtb \
 	xenvm-4.2.dtb
 dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8505-ref.dtb \
-	wm8650-mid.dtb
+	wm8650-mid.dtb \
+	wm8850-w70v2.dtb
 dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
 
 targets += dtbs
diff --git a/arch/arm/boot/dts/wm8850-w70v2.dts b/arch/arm/boot/dts/wm8850-w70v2.dts
new file mode 100644
index 0000000..fcc660c
--- /dev/null
+++ b/arch/arm/boot/dts/wm8850-w70v2.dts
@@ -0,0 +1,47 @@
+/*
+ * wm8850-w70v2.dts
+ *  - Device tree file for Wondermedia WM8850 Tablet
+ *  - 'W70-V2' mainboard
+ *  - HongLianYing 'HLY070ML268-21A' 7" LCD panel
+ *
+ * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * Licensed under GPLv2 or later
+ */
+
+/dts-v1/;
+/include/ "wm8850.dtsi"
+
+/ {
+	model = "Wondermedia WM8850-W70v2 Tablet";
+
+	/*
+	 * Display node is based on Sascha Hauer's patch on dri-devel.
+	 * Added a bpp property to calculate the size of the framebuffer
+	 * until the binding is formalized.
+	 */
+	display: display@0 {
+		modes {
+			mode0: mode@0 {
+				hactive = <800>;
+				vactive = <480>;
+				hback-porch = <88>;
+				hfront-porch = <40>;
+				hsync-len = <0>;
+				vback-porch = <32>;
+				vfront-porch = <11>;
+				vsync-len = <1>;
+				clock = <0>;	/* unused but required */
+				bpp = <16>;	/* non-standard but required */
+			};
+		};
+	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&pwm 0 50000 1>;	/* duty inverted */
+
+		brightness-levels = <0 40 60 80 100 130 190 255>;
+		default-brightness-level = <5>;
+	};
+};
diff --git a/arch/arm/boot/dts/wm8850.dtsi b/arch/arm/boot/dts/wm8850.dtsi
new file mode 100644
index 0000000..2dbc39c
--- /dev/null
+++ b/arch/arm/boot/dts/wm8850.dtsi
@@ -0,0 +1,224 @@
+/*
+ * wm8850.dtsi - Device tree file for Wondermedia WM8850 SoC
+ *
+ * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * Licensed under GPLv2 or later
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "wm,wm8850";
+
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+		serial3 = &uart3;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		ranges;
+		interrupt-parent = <&intc0>;
+
+		intc0: interrupt-controller@d8140000 {
+			compatible = "via,vt8500-intc";
+			interrupt-controller;
+			reg = <0xd8140000 0x10000>;
+			#interrupt-cells = <1>;
+		};
+
+		/* Secondary IC cascaded to intc0 */
+		intc1: interrupt-controller@d8150000 {
+			compatible = "via,vt8500-intc";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0xD8150000 0x10000>;
+			interrupts = <56 57 58 59 60 61 62 63>;
+		};
+
+		gpio: gpio-controller@d8110000 {
+			compatible = "wm,wm8650-gpio";
+			gpio-controller;
+			reg = <0xd8110000 0x10000>;
+			#gpio-cells = <3>;
+		};
+
+		pmc@d8130000 {
+			compatible = "via,vt8500-pmc";
+			reg = <0xd8130000 0x1000>;
+
+			clocks {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				ref25: ref25M {
+					#clock-cells = <0>;
+					compatible = "fixed-clock";
+					clock-frequency = <25000000>;
+				};
+
+				ref24: ref24M {
+					#clock-cells = <0>;
+					compatible = "fixed-clock";
+					clock-frequency = <24000000>;
+				};
+
+				plla: plla {
+					#clock-cells = <0>;
+					compatible = "wm,wm8750-pll-clock";
+					clocks = <&ref25>;
+					reg = <0x200>;
+				};
+
+				pllb: pllb {
+					#clock-cells = <0>;
+					compatible = "wm,wm8750-pll-clock";
+					clocks = <&ref25>;
+					reg = <0x204>;
+				};
+
+				clkuart0: uart0 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x254>;
+					enable-bit = <24>;
+				};
+
+				clkuart1: uart1 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x254>;
+					enable-bit = <25>;
+				};
+
+                                clkuart2: uart2 {
+                                        #clock-cells = <0>;
+                                        compatible = "via,vt8500-device-clock";
+                                        clocks = <&ref24>;
+                                        enable-reg = <0x254>;
+                                        enable-bit = <26>;
+                                };
+
+                                clkuart3: uart3 {
+                                        #clock-cells = <0>;
+                                        compatible = "via,vt8500-device-clock";
+                                        clocks = <&ref24>;
+                                        enable-reg = <0x254>;
+                                        enable-bit = <27>;
+                                };
+
+				clkpwm: pwm {
+ 					#clock-cells = <0>;
+ 					compatible = "via,vt8500-device-clock";
+					clocks = <&pllb>;
+					divisor-reg = <0x350>;
+					enable-reg = <0x250>;
+					enable-bit = <17>;
+ 				};
+
+				clksdhc: sdhc {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&pllb>;
+					divisor-reg = <0x330>;
+					divisor-mask = <0x3f>;
+					enable-reg = <0x250>;
+					enable-bit = <0>;
+				};
+			};
+		};
+
+		fb@d8051700 {
+			compatible = "wm,wm8505-fb";
+			reg = <0xd8051700 0x200>;
+			display = <&display>;
+			default-mode = <&mode0>;
+		};
+
+		ge_rops@d8050400 {
+			compatible = "wm,prizm-ge-rops";
+			reg = <0xd8050400 0x100>;
+		};
+
+		pwm: pwm@d8220000 {
+			#pwm-cells = <3>;
+			compatible = "via,vt8500-pwm";
+			reg = <0xd8220000 0x100>;
+			clocks = <&clkpwm>;
+		};
+
+		timer@d8130100 {
+			compatible = "via,vt8500-timer";
+			reg = <0xd8130100 0x28>;
+			interrupts = <36>;
+		};
+
+		ehci@d8007900 {
+			compatible = "via,vt8500-ehci";
+			reg = <0xd8007900 0x200>;
+			interrupts = <26>;
+		};
+
+		uhci@d8007b00 {
+			compatible = "platform-uhci";
+			reg = <0xd8007b00 0x200>;
+			interrupts = <26>;
+		};
+
+		uhci@d8008d00 {
+			compatible = "platform-uhci";
+			reg = <0xd8008d00 0x200>;
+			interrupts = <26>;
+		};
+
+		uart0: uart@d8200000 {
+			compatible = "via,vt8500-uart";
+			reg = <0xd8200000 0x1040>;
+			interrupts = <32>;
+			clocks = <&clkuart0>;
+		};
+
+		uart1: uart@d82b0000 {
+			compatible = "via,vt8500-uart";
+			reg = <0xd82b0000 0x1040>;
+			interrupts = <33>;
+			clocks = <&clkuart1>;
+		};
+
+                uart2: uart@d8210000 {
+                        compatible = "via,vt8500-uart";
+                        reg = <0xd8210000 0x1040>;
+                        interrupts = <47>;
+                        clocks = <&clkuart2>;
+                };
+
+                uart3: uart@d82c0000 {
+                        compatible = "via,vt8500-uart";
+                        reg = <0xd82c0000 0x1040>;
+                        interrupts = <50>;
+                        clocks = <&clkuart3>;
+                };
+
+		rtc@d8100000 {
+			compatible = "via,vt8500-rtc";
+			reg = <0xd8100000 0x10000>;
+			interrupts = <48>;
+		};
+
+		sdhc@d800a000 {
+			compatible = "wm,wm8505-sdhc";
+			reg = <0xd800a000 0x1000>;
+			interrupts = <20 21>;
+			clocks = <&clksdhc>;
+			bus-width = <4>;
+			sdon-inverted;
+		};
+	};
+};
-- 
1.7.9.5

