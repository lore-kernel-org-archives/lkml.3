Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaJ1EU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:20:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7656 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaJ1EUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:20:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Oct 2014 21:20:13 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] Documentation: gpio: guidelines for bindings
Date: Tue, 28 Oct 2014 13:20:34 +0900
Message-ID: <1414470034-16143-1-git-send-email-acourbot@nvidia.com>
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
 Documentation/devicetree/bindings/gpio/gpio.txt | 41 +++++++++++++++++--------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 3fb8f53071b8..1043f8b47433 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -13,13 +13,23 @@ properties, each containing a 'gpio-list':
 	gpio-specifier : Array of #gpio-cells specifying specific gpio
 			 (controller specific)
 
-GPIO properties should be named "[<name>-]gpios". The exact
-meaning of each gpios property must be documented in the device tree
+GPIO properties should be named "[<name>-]gpios", with <name> being the con_id
+argument that is passed to gpiod_get(). While a NULL con_id is accepted by the
+GPIO API for compatibility reasons (resolving to the "gpios" property), it is
+not allowed for new bindings.
+
+GPIO properties can contain one or more GPIO phandles, but only in exceptional
+cases should they contain more than one. If your device uses several GPIOs with
+distinct functions, reference each of them under its own property, giving it a
+meaningful name. The only case where an array of GPIOs is accepted is when
+several GPIOs serve the same function (e.g. a parallel data line). In that case
+individual GPIOs can be retrieved using gpiod_get_index().
+
+The exact meaning of each gpios property must be documented in the device tree
 binding for each device.
 
 For example, the following could be used to describe GPIO pins used
-as chip select lines; with chip selects 0, 1 and 3 populated, and chip
-select 2 left empty:
+as device enable and bit-banged data signals:
 
 	gpio1: gpio1 {
 		gpio-controller
@@ -30,10 +40,16 @@ select 2 left empty:
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
+
+The "enable" GPIO can then be retrieved using gpiod_get(dev, "enable", ...),
+and the data GPIOs are reached by calling gpiod_get_index(dev, "data", idx, ...)
+where idx can go from 0 to 3 included.
 
 Note that gpio-specifier length is controller dependent.  In the
 above example, &gpio1 uses 2 cells to specify a gpio, while &gpio2
@@ -42,16 +58,17 @@ only uses one.
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

