Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3GBLEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:04:00 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:55377 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3GBLDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:03:54 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/7] ARM: kirkwood: move device tree nodes to DT irqchip and clocksource
Date: Tue,  2 Jul 2013 13:03:38 +0200
Message-Id: <1372763023-12374-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent support for true irqchip and clocksource drivers for Orion
SoCs, now make use of it on DT enabled Kirkwood boards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
--- 
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood.dtsi |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index ad56dd8..204f44f 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -20,13 +20,6 @@
 	       gpio0 = &gpio0;
 	       gpio1 = &gpio1;
 	};
-	intc: interrupt-controller {
-		compatible = "marvell,orion-intc", "marvell,intc";
-		interrupt-controller;
-		#interrupt-cells = <1>;
-		reg = <0xf1020204 0x04>,
-		      <0xf1020214 0x04>;
-	};
 
 	ocp@f1000000 {
 		compatible = "simple-bus";
@@ -37,6 +30,30 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 
+		timer: timer@20300 {
+			compatible = "marvell,orion-timer";
+			reg = <0x20300 0x20>;
+			interrupt-parent = <&bridge_intc>;
+			interrupts = <1>, <2>;
+			clocks = <&core_clk 0>;
+		};
+
+		intc: main-interrupt-ctrl@20200 {
+			compatible = "marvell,orion-intc";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0x20200 0x10>, <0x20210 0x10>;
+		};
+
+		bridge_intc: bridge-interrupt-ctrl@20110 {
+			compatible = "marvell,orion-bridge-intc";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0x20110 0x8>;
+			interrupts = <1>;
+			marvell,#interrupts = <6>;
+		};
+
 		core_clk: core-clocks@10030 {
 			compatible = "marvell,kirkwood-core-clock";
 			reg = <0x10030 0x4>;
@@ -103,9 +120,11 @@
 			#clock-cells = <1>;
 		};
 
-		wdt@20300 {
+		wdt: watchdog-timer@20300 {
 			compatible = "marvell,orion-wdt";
 			reg = <0x20300 0x28>;
+			interrupt-parent = <&bridge_intc>;
+			interrupts = <3>;
 			clocks = <&gate_clk 7>;
 			status = "okay";
 		};
-- 
1.7.2.5

