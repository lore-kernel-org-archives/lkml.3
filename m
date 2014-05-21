Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaEUO27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:28:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54756 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaEUO2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:28:55 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v4 2/5] Power: reset: add bindings for keystone reset driver
Date: Wed, 21 May 2014 17:27:31 +0300
Message-ID: <1400682454-24535-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400682454-24535-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This node is intended to allow SoC reset in case of software reset
or appropriate watchdogs.

The Keystone SoCs can contain up to 4 watchdog timers to reset
SoC. Each watchdog timer event input is connected to the Reset Mux
block. The Reset Mux block can be configured to cause reset or not.

Additionally soft or hard reset can be configured.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../bindings/power/reset/keystone-reset.txt        | 66 ++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/keystone-reset.txt

diff --git a/Documentation/devicetree/bindings/power/reset/keystone-reset.txt b/Documentation/devicetree/bindings/power/reset/keystone-reset.txt
new file mode 100644
index 0000000..64cb7b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/keystone-reset.txt
@@ -0,0 +1,66 @@
+* Device tree bindings for Texas Instruments keystone reset
+
+This node is intended to allow SoC reset in case of software reset
+of selected watchdogs.
+
+The Keystone SoCs can contain up to 4 watchdog timers to reset
+SoC. Each watchdog timer event input is connected to the Reset Mux
+block. The Reset Mux block can be configured to cause reset or not.
+
+Additionally soft or hard reset can be configured.
+
+Required properties:
+
+- compatible:		ti,keystone-reset
+
+- ti,syscon-pll:	syscon register range used to access pll controller
+			registers in order to use reset control registers.
+
+- ti,syscon-dev:	syscon register range used to access device state
+			control registers in order to use mux block registers
+			for all watchdogs.
+
+Optional properties:
+
+- ti,soft-reset:	Boolean option indicating soft reset.
+			By default hard reset is used.
+
+- ti,wdt_list:		WDT list that can cause SoC reset. It's not related
+			to WDT driver, it's just needed to enable a SoC related
+			reset that's triggered by one of WDTs. The list is
+			in format: <0>, <2>; It can be in random order and
+			begins from 0 to 3, as keystone can contain up to 4 SoC
+			reset watchdogs and can be in random order.
+
+Example 1:
+Setup keystone reset so that in case software reset or
+WDT0 is triggered it issues hard reset for SoC.
+
+pllctrl: pll_controller {
+	compatible = "syscon";
+	reg = <0x2310000 0x200>;
+};
+
+devctrl: device_state_control {
+	compatible = "syscon";
+	reg = <0x2620000 0x1000>;
+};
+
+rstctrl: reset-controller {
+	compatible = "ti,keystone-reset";
+	ti,syscon-pll = <&pllctrl>;
+	ti,syscon-dev = <&devctrl>;
+	ti,wdt_list = <0>;
+};
+
+Example 2:
+Setup keystone reset so that in case of software reset or
+WDT0 or WDT2 is triggered it issues soft reset for SoC.
+
+rstctrl: reset-controller {
+	compatible = "ti,keystone-reset";
+	ti,syscon-pll = <&pllctrl>;
+	ti,syscon-dev = <&devctrl>;
+	ti,wdt_list = <0>, <2>;
+	ti,soft-reset;
+};
-- 
1.8.3.2

