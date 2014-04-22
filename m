Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaDVNQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:16:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48467 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756042AbaDVNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:12:50 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 05/11] ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
Date: Tue, 22 Apr 2014 15:12:34 +0200
Message-Id: <1398172360-7837-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398172360-7837-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the old main and clk definitions (fixed rate clk) by the new main and
slow clk subtree definition (ck = mux(rc_osc, osc)).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 61 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index eabcfdb..ceb274f 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -58,6 +58,18 @@
 		reg = <0x20000000 0x8000000>;
 	};
 
+	slow_xtal: slow_xtal {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
+	main_xtal: main_xtal {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <0>;
+	};
+
 	clocks {
 		adc_op_clk: adc_op_clk{
 			compatible = "fixed-clock";
@@ -749,18 +761,29 @@
 				#size-cells = <0>;
 				#interrupt-cells = <1>;
 
-				clk32k: slck {
-					compatible = "fixed-clock";
+				main_rc_osc: main_rc_osc {
+					compatible = "atmel,at91sam9x5-clk-main-rc-osc";
 					#clock-cells = <0>;
-					clock-frequency = <32768>;
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_MOSCRCS>;
+					clock-frequency = <12000000>;
+					clock-accuracy = <50000000>;
 				};
 
-				main: mainck {
-					compatible = "atmel,at91rm9200-clk-main";
+				main_osc: main_osc {
+					compatible = "atmel,at91rm9200-clk-main-osc";
 					#clock-cells = <0>;
 					interrupt-parent = <&pmc>;
 					interrupts = <AT91_PMC_MOSCS>;
-					clocks = <&clk32k>;
+					clocks = <&main_xtal>;
+				};
+
+				main: mainck {
+					compatible = "atmel,at91sam9x5-clk-main";
+					#clock-cells = <0>;
+					interrupt-parent = <&pmc>;
+					interrupts = <AT91_PMC_MOSCSELS>;
+					clocks = <&main_rc_osc &main_osc>;
 				};
 
 				plla: pllack {
@@ -1089,6 +1112,32 @@
 				status = "disabled";
 			};
 
+			sckc@fffffe50 {
+				compatible = "atmel,at91sam9x5-sckc";
+				reg = <0xfffffe50 0x4>;
+
+				slow_rc_osc: slow_rc_osc {
+					compatible = "atmel,at91sam9x5-clk-slow-rc-osc";
+					#clock-cells = <0>;
+					clock-frequency = <32768>;
+					clock-accuracy = <50000000>;
+					atmel,startup-time-usec = <75>;
+				};
+
+				slow_osc: slow_osc {
+					compatible = "atmel,at91sam9x5-clk-slow-osc";
+					#clock-cells = <0>;
+					clocks = <&slow_xtal>;
+					atmel,startup-time-usec = <1200000>;
+				};
+
+				clk32k: slowck {
+					compatible = "atmel,at91sam9x5-clk-slow";
+					#clock-cells = <0>;
+					clocks = <&slow_rc_osc &slow_osc>;
+				};
+			};
+
 			rtc@fffffeb0 {
 				compatible = "atmel,at91rm9200-rtc";
 				reg = <0xfffffeb0 0x30>;
-- 
1.8.3.2

