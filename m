Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3LFCT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:19:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34579 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3LFCTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:19:03 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Milo Kim <milo.kim@ti.com>
Subject: [PATCH RESEND v5 4/4] Documentation: add LP3943 DT bindings and document
Date: Fri, 6 Dec 2013 11:18:44 +0900
Message-ID: <1386296324-23039-5-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386296324-23039-1-git-send-email-milo.kim@ti.com>
References: <1386296324-23039-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bindings for LP3943 MFD, GPIO and PWM controller are added.

Cc: devicetree@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
Acked-by: Thierry Reding <thierry.reding@gmail.com>
---
 .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 +++++++++++++
 Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 +++++++++++
 .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++++++++++++++++++
 3 files changed, 128 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt b/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
new file mode 100644
index 0000000..80fcb7d
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
@@ -0,0 +1,37 @@
+TI/National Semiconductor LP3943 GPIO controller
+
+Required properties:
+  - compatible: "ti,lp3943-gpio"
+  - gpio-controller: Marks the device node as a GPIO controller.
+  - #gpio-cells: Should be 2. See gpio.txt in this directory for a
+                 description of the cells format.
+
+Example:
+Simple LED controls with LP3943 GPIO controller
+
+&i2c4 {
+	lp3943@60 {
+		compatible = "ti,lp3943";
+		reg = <0x60>;
+
+		gpioex: gpio {
+			compatible = "ti,lp3943-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+	};
+};
+
+leds {
+	compatible = "gpio-leds";
+	indicator1 {
+		label = "indi1";
+		gpios = <&gpioex 9 GPIO_ACTIVE_LOW>;
+	};
+
+	indicator2 {
+		label = "indi2";
+		gpios = <&gpioex 10 GPIO_ACTIVE_LOW>;
+		default-state = "off";
+	};
+};
diff --git a/Documentation/devicetree/bindings/mfd/lp3943.txt b/Documentation/devicetree/bindings/mfd/lp3943.txt
new file mode 100644
index 0000000..e8591d6
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/lp3943.txt
@@ -0,0 +1,33 @@
+TI/National Semiconductor LP3943 MFD driver
+
+Required properties:
+  - compatible: "ti,lp3943"
+  - reg: I2C slave address. From 0x60 to 0x67.
+
+LP3943 consists of two sub-devices, lp3943-gpio and lp3943-pwm.
+
+For the LP3943 GPIO properties please refer to:
+Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
+
+For the LP3943 PWM properties please refer to:
+Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
+
+Example:
+
+lp3943@60 {
+	compatible = "ti,lp3943";
+	reg = <0x60>;
+
+	gpioex: gpio {
+		compatible = "ti,lp3943-gpio";
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	pwm3943: pwm {
+		compatible = "ti,lp3943-pwm";
+		#pwm-cells = <2>;
+		ti,pwm0 = <8 9 10>;
+		ti,pwm1 = <15>;
+	};
+};
diff --git a/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt b/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
new file mode 100644
index 0000000..7bd9d3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
@@ -0,0 +1,58 @@
+TI/National Semiconductor LP3943 PWM controller
+
+Required properties:
+  - compatible: "ti,lp3943-pwm"
+  - #pwm-cells: Should be 2. See pwm.txt in this directory for a
+                description of the cells format.
+                Note that this hardware limits the period length to the
+                range 6250~1600000.
+  - ti,pwm0 or ti,pwm1: Output pin number(s) for PWM channel 0 or 1.
+    0 = output 0
+    1 = output 1
+    .
+    .
+    15 = output 15
+
+Example:
+PWM 0 is for RGB LED brightness control
+PWM 1 is for brightness control of LP8557 backlight device
+
+&i2c3 {
+	lp3943@60 {
+		compatible = "ti,lp3943";
+		reg = <0x60>;
+
+		/*
+		 * PWM 0 : output 8, 9 and 10
+		 * PWM 1 : output 15
+		 */
+		pwm3943: pwm {
+			compatible = "ti,lp3943-pwm";
+			#pwm-cells = <2>;
+			ti,pwm0 = <8 9 10>;
+			ti,pwm1 = <15>;
+		};
+	};
+
+};
+
+/* LEDs control with PWM 0 of LP3943 */
+pwmleds {
+	compatible = "pwm-leds";
+	rgb {
+		label = "indi::rgb";
+		pwms = <&pwm3943 0 10000>;
+		max-brightness = <255>;
+	};
+};
+
+&i2c4 {
+	/* Backlight control with PWM 1 of LP3943 */
+	backlight@2c {
+		compatible = "ti,lp8557";
+		reg = <0x2c>;
+
+		pwms = <&pwm3943 1 10000>;
+		pwm-names = "lp8557";
+	};
+};
-- 
1.7.10.4

