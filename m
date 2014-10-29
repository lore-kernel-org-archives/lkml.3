Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaJ2INa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:13:30 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2472 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaJ2INX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:13:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 Oct 2014 01:08:31 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2] Documentation: gpio: guidelines for bindings
Date: Wed, 29 Oct 2014 17:13:14 +0900
Message-ID: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ACPI supports named GPIO properties, either through ACPI 5.1 or
the per-driver ACPI GPIO mappings, we can be more narrow about the way
GPIOs should be specified in Device Tree bindings.

This patch updates the GPIO DT bindings documentation to highlight the
following rules for new GPIO bindings:

- All new bindings must have a meaningful name (e.g. the "gpios"
  property must not be used)
- The only suffix allowed is "-gpios", no matter the number of
  descriptors in the property
- GPIOs can only be grouped under the same property when they serve the
  same purpose, a case that should remain exceptional (e.g. bit-banged
  data lines).

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Rafael J. Wysocki <rjw@rjwysocki.net>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changes since v1:
- Rewritten in OS-neutral manner.

 Documentation/devicetree/bindings/gpio/gpio.txt | 40 ++++++++++++++++---------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 3fb8f53071b8..b9bd1d64cfa6 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -13,13 +13,22 @@ properties, each containing a 'gpio-list':
 	gpio-specifier : Array of #gpio-cells specifying specific gpio
 			 (controller specific)
 
-GPIO properties should be named "[<name>-]gpios". The exact
-meaning of each gpios property must be documented in the device tree
-binding for each device.
+GPIO properties should be named "[<name>-]gpios", with <name> being the purpose
+of this GPIO for the device. While a non-existent <name> is considered valid
+for compatibility reasons (resolving to the "gpios" property), it is not allowed
+for new bindings.
 
-For example, the following could be used to describe GPIO pins used
-as chip select lines; with chip selects 0, 1 and 3 populated, and chip
-select 2 left empty:
+GPIO properties can contain one or more GPIO phandles, but only in exceptional
+cases should they contain more than one. If your device uses several GPIOs with
+distinct functions, reference each of them under its own property, giving it a
+meaningful name. The only case where an array of GPIOs is accepted is when
+several GPIOs serve the same function (e.g. a parallel data line).
+
+The exact purpose of each gpios property must be documented in the device tree
+binding of the device.
+
+The following example could be used to describe GPIO pins used as device enable
+and bit-banged data signals:
 
 	gpio1: gpio1 {
 		gpio-controller
@@ -30,10 +39,12 @@ select 2 left empty:
 		 #gpio-cells = <1>;
 	};
 	[...]
-	 chipsel-gpios = <&gpio1 12 0>,
-			 <&gpio1 13 0>,
-			 <0>, /* holes are permitted, means no GPIO 2 */
-			 <&gpio2 2>;
+
+	enable-gpios = <&gpio2 2>;
+	data-gpios = <&gpio1 12 0>,
+		     <&gpio1 13 0>,
+		     <&gpio1 14 0>,
+		     <&gpio1 15 0>;
 
 Note that gpio-specifier length is controller dependent.  In the
 above example, &gpio1 uses 2 cells to specify a gpio, while &gpio2
@@ -42,16 +53,17 @@ only uses one.
 gpio-specifier may encode: bank, pin position inside the bank,
 whether pin is open-drain and whether pin is logically inverted.
 Exact meaning of each specifier cell is controller specific, and must
-be documented in the device tree binding for the device.
+be documented in the device tree binding for the device. Use the macros
+defined in include/dt-bindings/gpio/gpio.h whenever possible:
 
 Example of a node using GPIOs:
 
 	node {
-		gpios = <&qe_pio_e 18 0>;
+		enable-gpios = <&qe_pio_e 18 GPIO_ACTIVE_HIGH>;
 	};
 
-In this example gpio-specifier is "18 0" and encodes GPIO pin number,
-and GPIO flags as accepted by the "qe_pio_e" gpio-controller.
+GPIO_ACTIVE_HIGH is 0, so in this example gpio-specifier is "18 0" and encodes
+GPIO pin number, and GPIO flags as accepted by the "qe_pio_e" gpio-controller.
 
 1.1) GPIO specifier best practices
 ----------------------------------
-- 
2.1.2

