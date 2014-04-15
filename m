Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaDOHXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:23:45 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:36241 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaDOHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:22:26 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: [PATCH 1/7] gpiolib: gpiolib-of: Implement device tree gpio-names based lookup
Date: Tue, 15 Apr 2014 14:41:35 +0800
Message-Id: <1397544101-18135-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397544101-18135-1-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides of_get_gpiod_flags_by_name(), which looks up GPIO
phandles by name only, through gpios/gpio-names, and not by index.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/gpio/gpiolib-of.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_gpio.h   |  3 +++
 2 files changed, 51 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 2024d45..5c586fa 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -97,6 +97,54 @@ struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 EXPORT_SYMBOL(of_get_named_gpiod_flags);
 
 /**
+ * of_get_gpiod_flags_by_name() - Get a GPIO descriptor and flags by name
+ * @np:		device node to get GPIO from
+ * @name:	matching name of gpio phandle
+ * @flags:	a flags pointer to fill in
+ *
+ * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
+ * value on the error condition. If @flags is not NULL the function also fills
+ * in flags for the GPIO.
+ */
+struct gpio_desc *of_get_gpiod_flags_by_name(struct device_node *np,
+		const char *name, enum of_gpio_flags *flags)
+{
+	/* Return -EPROBE_DEFER to support probe() functions to be called
+	 * later when the GPIO actually becomes available
+	 */
+	struct gg_data gg_data = {
+		.flags = flags,
+		.out_gpio = ERR_PTR(-EPROBE_DEFER)
+	};
+	int index = 0;
+	int ret;
+
+	/* exit if no name given */
+	if (!name)
+		return ERR_PTR(-EINVAL);
+
+	/* .of_xlate might decide to not fill in the flags, so clear it. */
+	if (flags)
+		*flags = 0;
+
+	if (name)
+		index = of_property_match_string(np, "gpio-names", name);
+
+	ret = of_parse_phandle_with_args(np, "gpios", "#gpio-cells", index,
+					 &gg_data.gpiospec);
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+
+	of_node_put(gg_data.gpiospec.np);
+
+	return gg_data.out_gpio;
+}
+EXPORT_SYMBOL(of_get_gpiod_flags_by_names);
+
+/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index f14123a..134331f 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -51,6 +51,9 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 extern struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags);
 
+extern struct gpio_desc *of_get_gpiod_flags_by_name(struct device_node *np,
+		const char *name, enum of_gpio_flags *flags);
+
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 
-- 
1.9.1

