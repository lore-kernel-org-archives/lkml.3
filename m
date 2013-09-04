Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab3IDLa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:30:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14263 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762442Ab3IDLan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:30:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Sep 2013 04:27:54 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 5/5] gpiolib: update documentation
Date: Wed, 4 Sep 2013 20:29:29 +0900
Message-ID: <1378294169-22661-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sections about the new gpiod interface in the documentation,
explaining the motivations behind it and the differences with respect to
the legacy API.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/gpio.txt | 119 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index 6f83fa9..e254a38 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -87,6 +87,38 @@ Note that these operations include I/O barriers on platforms which need to
 use them; drivers don't need to add them explicitly.
 
 
+GPIO interfaces
+---------------
+The GPIO framework has quite a bit of history behind it. Currently there exist
+two different (although very similar) ways of using GPIOs:
+
+  - The legacy integer-based interface represents GPIOs as integers. This is
+    the "historic" way of accessing GPIOs and it was done so because it makes
+    GPIOs easy to represent and also allows for the compiler to statically know
+    the GPIO number and use fast-paths on GPIOs for which performance matters.
+    However, GPIOs can easily be forged this way, and the maximum number of
+    GPIOs in the system must be known in advance. Functions of this interface
+    are prefixed with "gpio_".
+
+  - The new descriptor-based interface represents GPIOs as an opaque pointer.
+    This ensures GPIOs are properly acquired before usage, and also does not
+    presume anything about their underlying implementation. This interface
+    provides get/put functions to acquire GPIOs according to their function for
+    a particular device, similarly to e.g. the regulator framework. For these
+    reasons, it is the preferred way to access GPIOs. Its functions are prefixed
+    with "gpiod_".
+
+Both interfaces rely on gpiolib. Actually, the older integer-based interface is
+built as inline functions on top of the new descriptor interface. It is possible
+and easy to convert a GPIO descriptor to an integer and vice-versa, although it
+is recommended that drivers stick to using a single interface, preferably the
+new descriptor-based one.
+
+The remainder of this document will describes the old integer-based interface,
+up to the last section which details the differences of the descriptor-based
+interface.
+
+
 Identifying GPIOs
 -----------------
 GPIOs are identified by unsigned integers in the range 0..MAX_INT.  That
@@ -773,3 +805,90 @@ differences between boards from user space.  This only affects the
 sysfs interface.  Polarity change can be done both before and after
 gpio_export(), and previously enabled poll(2) support for either
 rising or falling edge will be reconfigured to follow this setting.
+
+
+GPIO descriptor interface
+=========================
+A more secure, alternative GPIO interface using descriptors is also available.
+Instead of relying on integers (which can easily be forged and used without
+being properly requested) to reference GPIOs, it uses a system of opaque
+descriptors that must be properly obtained and disposed through the common
+get/put set of functions. This ensures that all GPIO descriptors are valid at
+any time and makes it unnecessary to check the validity of a GPIO. Apart from
+this difference, the interface is similar to the integer-based one, excepted
+that the gpio_ prefix is changed to gpiod_. There is only one difference in
+behavior: for GPIOs acquired with a GPIOF_ACTIVE_LOW flag, or for which the
+active low property has been set through the sysfs interface, the get/set_value
+functions will take the active low property into account when setting the value.
+The old interface ignores this property, and its get/set_value work with the
+actual physical level of the GPIO.
+
+Using GPIOs
+-----------
+GPIO consumers should include <linux/gpio/consumer.h> which declares the
+consumer-side GPIO functions. GPIOs are obtained through gpiod_get:
+
+ struct gpio_desc *gpiod_get(struct device *dev, const char *con_id);
+
+This will return the GPIO descriptor corresponding to the con_id function of
+dev, or an error code in case of error. A devm variant is also available:
+
+ struct gpio_desc *devm_gpiod_get(struct device *dev, const char *con_id);
+
+GPIO descriptors are disposed using the corresponding put functions:
+
+ void gpiod_put(struct gpio_desc *desc);
+ void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
+
+A valid descriptor can then be used with one of the gpiod_ functions. Their
+interface is identical to the integer-based API, excepted that they take a GPIO
+descriptor instead of an integer:
+
+ int gpiod_direction_input(struct gpio_desc *desc);
+ int gpiod_direction_output(struct gpio_desc *desc, int value);
+ int gpiod_get_value(struct gpio_desc *desc);
+ void gpiod_set_value(struct gpio_desc *desc, int value);
+ ...
+
+If you need to convert a descriptor to an integer or vice-versa, you can use
+gpio_to_desc or desc_to_gpio:
+
+ struct gpio_desc *gpio_to_desc(unsigned gpio);
+ int desc_to_gpio(const struct gpio_desc *desc);
+
+The same GPIO can be used by both interfaces as long as it has properly been
+acquired by one of them (i.e. using either gpio_request() or gpiod_get()).
+
+Declaring GPIOs
+---------------
+GPIOs can be made available for devices either through board-specific lookup
+tables, or using the device tree.
+
+Board-specific lookup tables match a device name and consumer ID to a GPIO chip
+and GPIO number relative to that chip. They are declared as follows:
+
+ static struct gpio_lookup board_gpio_lookup[] = {
+     GPIO_LOOKUP("tegra-gpio", 28, "backlight.1", "power", GPIOF_ACTIVE_LOW),
+ };
+
+ static void __init board_init(void)
+ {
+     ...
+     gpiod_add_table(board_gpio_lookup,
+     ARRAY_SIZE(board_gpio_lookup));
+     ...
+ }
+
+In the driver side, the following code:
+
+ gpiod_get(dev, "power");
+
+will return the descriptor for GPIO 28 of the "tegra-gpio" chip provided
+strcmp(dev_name(dev), "backlight.1") == 0. This GPIO will be active low.
+
+If the device tree is used, then the same "power" GPIO can be declared into the
+device's node as follows:
+
+ power-gpios = <&gpio 28 GPIO_ACTIVE_LOW>;
+
+Note that gpiod_get() only allows to access the first GPIO specifier.
\ No newline at end of file
-- 
1.8.4

