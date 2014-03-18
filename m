Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbaCRUWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:22:30 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:56821 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbaCRUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:19:30 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 05/11] ARM: at91/dt: move sama5d3 SoC to the new main/slow clk model
Date: Tue, 18 Mar 2014 21:18:38 +0100
Message-Id: <1395173924-3648-6-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the old main and clk definitions (fixed rate clk) by the new main and
slow clk subtree definition (ck = mux(rc_osc, osc)).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3.dtsi |   61 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 3d5faf8..015797d 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -59,6 +59,18 @@
 	};
 
 	clocks {
+		slow_xtal: slow_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+
+		main_xtal: main_xtal {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <0>;
+		};
+
 		adc_op_clk: adc_op_clk{
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
@@ -760,18 +772,29 @@
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
@@ -1100,6 +1123,32 @@
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
1.7.9.5

