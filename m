Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaLHSph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:45:37 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:25136 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbaLHSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:45:34 -0500
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="52708856"
From: Ray Jui <rjui@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v3 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
Date: Mon, 8 Dec 2014 10:47:44 -0800
Message-ID: <1418064468-8512-3-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418064468-8512-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1418064468-8512-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the GPIO device tree binding for Broadcom Cygnus SoC

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
---
 .../devicetree/bindings/gpio/brcm,cygnus-gpio.txt  |   82 ++++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt

diff --git a/Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt b/Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt
new file mode 100644
index 0000000..c477271
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt
@@ -0,0 +1,82 @@
+Broadcom Cygnus GPIO Controller
+
+Required properties:
+
+- compatible:
+    Must be "brcm,cygnus-gpio"
+
+- reg:
+    Define the base and range of the I/O address space that contain the Cygnus
+GPIO controller registers
+
+- ngpios:
+    Total number of GPIOs the controller provides
+
+- #gpio-cells:
+    Must be two. The first cell is the GPIO pin number (within the
+controller's domain) and the second cell is used for the following:
+    bit[0]: polarity (0 for normal and 1 for inverted)
+    bit[18:16]: internal pull up/down: 0 - pull up/down disabled
+                                       1 - pull up enabled
+                                       2 - pull down enabled
+    bit[22:20]: drive strength: 0 - 2 mA
+                                1 - 4 mA
+                                2 - 6 mA
+                                3 - 8 mA
+                                4 - 10 mA
+                                5 - 12 mA
+                                6 - 14 mA
+                                7 - 16 mA
+
+- gpio-controller:
+    Specifies that the node is a GPIO controller
+
+Optional properties:
+
+- interrupt-controller:
+    Specifies that the node is an interrupt controller. Not all Cygnus GPIO
+interfaces support interrupt, e.g., the CRMU GPIO controller does not have its
+interrupt routed to the main processor's GIC
+
+- interrupts:
+    The interrupt outputs from the GPIO controller.
+
+- no-drv-stregnth:
+    Specifies the GPIO controller does not support drive strength configuration
+
+Example:
+	gpio_asiu: gpio@180a5000 {
+		compatible = "brcm,cygnus-gpio";
+		reg = <0x180a5000 0x668>;
+		ngpios = <122>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		interrupt-controller;
+		interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
+	};
+
+	gpio_crmu: gpio@03024800 {
+		compatible = "brcm,cygnus-crmu-gpio";
+		reg = <0x03024800 0x50>;
+		ngpios = <6>;
+		#gpio-cells = <2>;
+		gpio-controller;
+		no-drv-stregnth;
+	};
+
+	/*
+	 * Touchscreen that uses the ASIU GPIO 100, with internal pull-up
+	 * enabled
+	 */
+	tsc {
+		...
+		...
+		gpio-event = <&gpio_asiu 100 0x10000>;
+	};
+
+	/* Bluetooth that uses the CRMU GPIO 2, with polarity inverted */
+	bluetooth {
+		...
+		...
+		bcm,rfkill-bank-sel = <&gpio_crmu 2 1>
+	}
-- 
1.7.9.5

