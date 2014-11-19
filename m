Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaKSP7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:59:15 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:54156 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbaKSP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:57:41 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5/7] [RFC] ARM: shmobile: sh73a0 dtsi: Add PM domain support
Date: Wed, 19 Nov 2014 16:57:32 +0100
Message-Id: <1416412654-6508-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
References: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a device node for the System Controller, with subnodes that
represent the hardware power area hierarchy.
Hook up all devices to their respective PM domains.

Add memory-controller nodes for the SDRAM Bus State Controllers (SBSC1
and SBSC2), which lie in the A4BC0 resp. A4BC1 PM domains, to prevent
them from being powered down.
There are no documented bindings for the SBSC yet (so far there's still
no need for a driver), but all properties follow the standard
conventions.

Note that unlike on R-Mobile A1 (r8a7740), PM domain D4 can be powered
down without ill effects on s2ram behavior, just like on SH-Mobile AP4
(sh7372).  Hence we can postpone adding a (minimal) device node for the
Coresight-ETM hardware block.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Question: Should I make sbsc1 and sbsc2 minimal nodes for now, i.e. only
	  retain their "compatible" and "power-domains" properties?
---
 arch/arm/boot/dts/sh73a0.dtsi | 159 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 157 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0.dtsi b/arch/arm/boot/dts/sh73a0.dtsi
index c7ab55e55e23f8cb..0ba0892d21a7affd 100644
--- a/arch/arm/boot/dts/sh73a0.dtsi
+++ b/arch/arm/boot/dts/sh73a0.dtsi
@@ -26,12 +26,14 @@
 			compatible = "arm,cortex-a9";
 			reg = <0>;
 			clock-frequency = <1196000000>;
+			power-domains = <&pd_a2sl>;
 		};
 		cpu@1 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a9";
 			reg = <1>;
 			clock-frequency = <1196000000>;
+			power-domains = <&pd_a2sl>;
 		};
 	};
 
@@ -43,6 +45,24 @@
 		      <0xf0000100 0x100>;
 	};
 
+	sbsc2: memory-controller@fb400000 {
+		compatible = "renesas,sbsc-sh73a0";
+		reg = <0xfb400000 0x400>;
+		interrupts = <0 37 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 38 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "sec", "temp";
+		power-domains = <&pd_a4bc1>;
+	};
+
+	sbsc1: memory-controller@fe400000 {
+		compatible = "renesas,sbsc-sh73a0";
+		reg = <0xfe400000 0x400>;
+		interrupts = <0 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 36 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "sec", "temp";
+		power-domains = <&pd_a4bc0>;
+	};
+
 	pmu {
 		compatible = "arm,cortex-a9-pmu";
 		interrupts = <0 55 IRQ_TYPE_LEVEL_HIGH>,
@@ -53,11 +73,12 @@
 		compatible = "renesas,cmt-48-sh73a0", "renesas,cmt-48";
 		reg = <0xe6138000 0x200>;
 		interrupts = <0 65 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp3_clks SH73A0_CLK_CMT1>;
+		clock-names = "fck";
+		power-domains = <&pd_c5>;
 
 		renesas,channels-mask = <0x3f>;
 
-		clocks = <&mstp3_clks SH73A0_CLK_CMT1>;
-		clock-names = "fck";
 		status = "disabled";
 	};
 
@@ -79,6 +100,7 @@
 			      0 7 IRQ_TYPE_LEVEL_HIGH
 			      0 8 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp5_clks SH73A0_CLK_INTCA0>;
+		power-domains = <&pd_a4s>;
 	};
 
 	irqpin1: irqpin@e6900004 {
@@ -99,6 +121,7 @@
 			      0 15 IRQ_TYPE_LEVEL_HIGH
 			      0 16 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp5_clks SH73A0_CLK_INTCA0>;
+		power-domains = <&pd_a4s>;
 		control-parent;
 	};
 
@@ -120,6 +143,7 @@
 			      0 23 IRQ_TYPE_LEVEL_HIGH
 			      0 24 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp5_clks SH73A0_CLK_INTCA0>;
+		power-domains = <&pd_a4s>;
 	};
 
 	irqpin3: irqpin@e690000c {
@@ -140,6 +164,7 @@
 			      0 31 IRQ_TYPE_LEVEL_HIGH
 			      0 32 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp5_clks SH73A0_CLK_INTCA0>;
+		power-domains = <&pd_a4s>;
 	};
 
 	i2c0: i2c@e6820000 {
@@ -152,6 +177,7 @@
 			      0 169 IRQ_TYPE_LEVEL_HIGH
 			      0 170 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks SH73A0_CLK_IIC0>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -165,6 +191,7 @@
 			      0 53 IRQ_TYPE_LEVEL_HIGH
 			      0 54 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks SH73A0_CLK_IIC1>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -178,6 +205,7 @@
 			      0 173 IRQ_TYPE_LEVEL_HIGH
 			      0 174 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp0_clks SH73A0_CLK_IIC2>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -191,6 +219,7 @@
 			      0 185 IRQ_TYPE_LEVEL_HIGH
 			      0 186 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp4_clks SH73A0_CLK_IIC3>;
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -204,6 +233,7 @@
 			      0 189 IRQ_TYPE_LEVEL_HIGH
 			      0 190 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp4_clks SH73A0_CLK_IIC4>;
+		power-domains = <&pd_c5>;
 		status = "disabled";
 	};
 
@@ -213,6 +243,7 @@
 		interrupts = <0 140 IRQ_TYPE_LEVEL_HIGH
 			      0 141 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks SH73A0_CLK_MMCIF0>;
+		power-domains = <&pd_a3sp>;
 		reg-io-width = <4>;
 		status = "disabled";
 	};
@@ -224,6 +255,7 @@
 			      0 84 IRQ_TYPE_LEVEL_HIGH
 			      0 85 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks SH73A0_CLK_SDHI0>;
+		power-domains = <&pd_a3sp>;
 		cap-sd-highspeed;
 		status = "disabled";
 	};
@@ -235,6 +267,7 @@
 		interrupts = <0 88 IRQ_TYPE_LEVEL_HIGH
 			      0 89 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks SH73A0_CLK_SDHI1>;
+		power-domains = <&pd_a3sp>;
 		toshiba,mmc-wrprotect-disable;
 		cap-sd-highspeed;
 		status = "disabled";
@@ -246,6 +279,7 @@
 		interrupts = <0 104 IRQ_TYPE_LEVEL_HIGH
 			      0 105 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks SH73A0_CLK_SDHI2>;
+		power-domains = <&pd_a3sp>;
 		toshiba,mmc-wrprotect-disable;
 		cap-sd-highspeed;
 		status = "disabled";
@@ -257,6 +291,7 @@
 		interrupts = <0 72 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA0>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -266,6 +301,7 @@
 		interrupts = <0 73 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA1>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -275,6 +311,7 @@
 		interrupts = <0 74 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA2>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -284,6 +321,7 @@
 		interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA3>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -293,6 +331,7 @@
 		interrupts = <0 78 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA4>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -302,6 +341,7 @@
 		interrupts = <0 79 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA5>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -311,6 +351,7 @@
 		interrupts = <0 156 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks SH73A0_CLK_SCIFA6>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -320,6 +361,7 @@
 		interrupts = <0 143 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFA7>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -329,6 +371,7 @@
 		interrupts = <0 80 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp2_clks SH73A0_CLK_SCIFB>;
 		clock-names = "sci_ick";
+		power-domains = <&pd_a3sp>;
 		status = "disabled";
 	};
 
@@ -347,6 +390,117 @@
 			<&irqpin2 4 0>, <&irqpin2 5 0>, <&irqpin2 6 0>, <&irqpin2 7 0>,
 			<&irqpin3 0 0>, <&irqpin3 1 0>, <&irqpin3 2 0>, <&irqpin3 3 0>,
 			<&irqpin3 4 0>, <&irqpin3 5 0>, <&irqpin3 6 0>, <&irqpin3 7 0>;
+		power-domains = <&pd_c5>;
+	};
+
+	sysc: system-controller@e6180000 {
+		compatible = "renesas,sysc-sh73a0", "renesas,sysc-rmobile";
+		reg = <0xe6180000 8000>, <0xe6188000 8000>;
+
+		pm-domains {
+			pd_c5: c5 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				#power-domain-cells = <0>;
+
+				pd_c4: c4@0 {
+					reg = <0>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_d4: d4@1 {
+					reg = <1>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4bc0: a4bc0@4 {
+					reg = <4>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4bc1: a4bc1@5 {
+					reg = <5>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4lc0: a4lc0@6 {
+					reg = <6>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4lc1: a4lc1@7 {
+					reg = <7>;
+					#power-domain-cells = <0>;
+				};
+
+				pd_a4mp: a4mp@8 {
+					reg = <8>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					#power-domain-cells = <0>;
+
+					pd_a3mp: a3mp@9 {
+						reg = <9>;
+						#power-domain-cells = <0>;
+					};
+
+					pd_a3vc: a3vc@10 {
+						reg = <10>;
+						#power-domain-cells = <0>;
+					};
+				};
+
+				pd_a4rm: a4rm@12 {
+					reg = <12>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					#power-domain-cells = <0>;
+
+					pd_a3r: a3r@13 {
+						reg = <13>;
+						#address-cells = <1>;
+						#size-cells = <0>;
+						#power-domain-cells = <0>;
+
+						pd_a2rv: a2rv@14 {
+							reg = <14>;
+							#address-cells = <1>;
+							#size-cells = <0>;
+							#power-domain-cells = <0>;
+						};
+					};
+				};
+
+				pd_a4s: a4s@16 {
+					reg = <16>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					#power-domain-cells = <0>;
+
+					pd_a3sp: a3sp@17 {
+						reg = <17>;
+						#power-domain-cells = <0>;
+					};
+
+					pd_a3sg: a3sg@18 {
+						reg = <18>;
+						#power-domain-cells = <0>;
+					};
+
+					pd_a3sm: a3sm@19 {
+						reg = <19>;
+						#address-cells = <1>;
+						#size-cells = <0>;
+						#power-domain-cells = <0>;
+
+						pd_a2sl: a2sl@20 {
+							reg = <20>;
+							#power-domain-cells = <0>;
+						};
+					};
+				};
+			};
+		};
 	};
 
 	sh_fsi2: sound@ec230000 {
@@ -354,6 +508,7 @@
 		compatible = "renesas,fsi2-sh73a0", "renesas,sh_fsi2";
 		reg = <0xec230000 0x400>;
 		interrupts = <0 146 0x4>;
+		power-domains = <&pd_a4mp>;
 		status = "disabled";
 	};
 
-- 
1.9.1

