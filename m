Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbbAMSqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:46:34 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37087 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753658AbbAMSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:46:30 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 5/5] ARM: at91/dt: define a dumb irq demultiplexer chip connected on irq1
Date: Tue, 13 Jan 2015 19:46:21 +0100
Message-Id: <1421174781-4340-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ is multiplexing several peripheral IRQs, but there's no way to
properly demultiplex those IRQs.
Use a dumb irq demux chip to achieve this demultiplexing operation.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index dd1313c..debe8d2 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -10,7 +10,7 @@
 
 #include "skeleton.dtsi"
 #include <dt-bindings/pinctrl/at91.h>
-#include <dt-bindings/interrupt-controller/irq.h>
+#include <dt-bindings/interrupt-controller/atmel-aic.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/clock/at91.h>
 
@@ -89,6 +89,7 @@
 				atmel,external-irqs = <29 30 31>;
 			};
 
+
 			ramc0: ramc@ffffea00 {
 				compatible = "atmel,at91sam9260-sdramc";
 				reg = <0xffffea00 0x200>;
@@ -97,7 +98,7 @@
 			pmc: pmc@fffffc00 {
 				compatible = "atmel,at91sam9260-pmc";
 				reg = <0xfffffc00 0x100>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux AIC_IRQ1_PMC>;
 				interrupt-controller;
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -364,7 +365,7 @@
 			pit: timer@fffffd30 {
 				compatible = "atmel,at91sam9260-pit";
 				reg = <0xfffffd30 0xf>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux AIC_IRQ1_PIT>;
 				clocks = <&mck>;
 			};
 
@@ -750,7 +751,7 @@
 			dbgu: serial@fffff200 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xfffff200 0x200>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux AIC_IRQ1_DBGU>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_dbgu>;
 				clocks = <&mck>;
@@ -959,7 +960,7 @@
 			rtc@fffffd20 {
 				compatible = "atmel,at91sam9260-rtt";
 				reg = <0xfffffd20 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux AIC_IRQ1_RTT>;
 				clocks = <&clk32k>;
 				status = "disabled";
 			};
@@ -967,7 +968,7 @@
 			watchdog@fffffd40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffd40 0x10>;
-				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+				interrupts-extended = <&dumb_irq1_demux AIC_IRQ1_WATCHDOG>;
 				atmel,watchdog-type = "hardware";
 				atmel,reset-type = "all";
 				atmel,dbg-halt;
@@ -1010,6 +1011,19 @@
 		};
 	};
 
+	dumb_irq1_demux: dumb-irq-demux@1 {
+		compatible = "irqchip-dumb-demux";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
+		irqs = <(AIC_IRQ_MASK(AIC_IRQ1_PMC) |
+			 AIC_IRQ_MASK(AIC_IRQ1_PIT) |
+			 AIC_IRQ_MASK(AIC_IRQ1_DBGU) |
+			 AIC_IRQ_MASK(AIC_IRQ1_RTT) |
+			 AIC_IRQ_MASK(AIC_IRQ1_WATCHDOG) |
+			 AIC_IRQ_MASK(AIC_IRQ1_RSTC))>;
+	};
+
 	i2c@0 {
 		compatible = "i2c-gpio";
 		gpios = <&pioA 23 GPIO_ACTIVE_HIGH /* sda */
-- 
1.9.1

