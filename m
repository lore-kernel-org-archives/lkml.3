Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3ILBei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:34:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46513 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3ILBeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:34:36 -0400
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <devicetree@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH 4/4] Documentation: add LP3943 DT bindings and document
Date: Thu, 12 Sep 2013 10:34:23 +0900
Message-ID: <1378949663-6338-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bindings for LP3943 MFD, GPIO and PWM controller are added.
And LP3943 driver document is added also.

Cc: devicetree@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 Documentation/00-INDEX                             |    2 +
 .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 ++++++++++++
 Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 +++++++++++
 .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++++++++++++++++
 Documentation/lp3943.txt                           |   62 ++++++++++++++++++++
 5 files changed, 192 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
 create mode 100644 Documentation/lp3943.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 0c4cc68..5dd921f 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -285,6 +285,8 @@ logo.gif
 	- full colour GIF image of Linux logo (penguin - Tux).
 logo.txt
 	- info on creator of above logo & site to get additional images from.
+lp3943.txt
+	- info on LP3943 MFD driver structure.
 m68k/
 	- directory with info about Linux on Motorola 68k architecture.
 magic-number.txt
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
diff --git a/Documentation/lp3943.txt b/Documentation/lp3943.txt
new file mode 100644
index 0000000..576ebd0
--- /dev/null
+++ b/Documentation/lp3943.txt
@@ -0,0 +1,62 @@
+TI/National Semiconductor LP3943 MFD driver
+===========================================
+
+LP3943 is an integrated device capable of driving 16 output channels.
+It can be used for GPIO expander and PWM generators.
+LP3493 registers are controlled via the I2C interface.
+
+Driver structure
+----------------
+                                  LED control    General usage for a device
+                                  ___________   ____________________________
+
+  LP3943 MFD ---- GPIO expander    leds-gpio        eg) HW enable pin
+              |
+              --- PWM generator    leds-pwm         eg) PWM input
+
+
+Why do we need GPIO and PWM drivers instead of LED driver?
+To support LED control and general usage, GPIO and PWM drivers are necessary.
+
+According to the datasheet(1), it's just a LED driver which has 16 channels.
+But here is another application, a GPIO expander.(2)
+
+  (1) http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
+  (2) http://www.ti.com/lit/an/snva287a/snva287a.pdf
+
+Internal two PWM channels are used for LED dimming effect.
+And each output pin can be used as a GPIO as well.
+LED functionality can work with GPIOs or PWMs.
+LEDs can be controlled with legacy leds-gpio(static brightness) or
+leds-pwm drivers(dynamic brightness control).
+Additionally, it can be used for generic GPIO and PWM controller.
+For example, a GPIO is HW enable pin of a device.
+PWM is input pin of a backlight device.
+
+
+LP3943 PWM port map
+-------------------
+Each PWM channel can be mapped to one or multiple output pins.
+
+For example, PWM 0 is used for a backlight device.
+PWM 1 is for RGB LEDs.
+
+  PWM channel    Output pins    PWM consumer
+  ___________    ___________    ____________
+  PWM 0          pin 1          backlight
+  PWM 1          pin 7, 8, 9    RGB LEDs
+
+Then, PWM port map is as below.
+PWM 0: num_outputs = 1, output = pin 1
+PWM 1: num_outputs = 3, output = pin 7, 8, 9
+
+The 'lp3943_pwm_map' structure is used for this feature.
+
+
+Device tree supported
+---------------------
+Please refer to the documents below.
+
+Documentation/devicetree/bindings/mfd/lp3943.txt
+Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
+Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
-- 
1.7.9.5

