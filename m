Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbbAGJKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:10:30 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:43007 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbbAGJJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:09:13 -0500
From: Olliver Schinagl <oliver+list@schinagl.nl>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Olliver Schinagl <oliver@schinagl.nl>, Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [PATCH v1 2/4] gpio: add parameter to allow the use named gpios
Date: Wed,  7 Jan 2015 10:08:40 +0100
Message-Id: <1420621722-7428-3-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl>
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

The gpio binding document says that new code should always use named
gpios. Patch 40b73183 added support to parse a list of gpios from child
nodes, but does not make it possible to use named gpios. This patch adds
the con_id property and implements it is done in gpiolib.c, where the
old-style of using unnamed gpios still works.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 drivers/gpio/devres.c                     | 16 +++++++++++++++-
 drivers/input/keyboard/gpio_keys_polled.c |  2 +-
 drivers/leds/leds-gpio.c                  |  2 +-
 include/linux/gpio/consumer.h             |  1 +
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 13dbd3d..b7fbe1c 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -111,23 +111,37 @@ EXPORT_SYMBOL(__devm_gpiod_get_index);
 /**
  * devm_get_gpiod_from_child - get a GPIO descriptor from a device's child node
  * @dev:	GPIO consumer
+ * @con_id:	function within the GPIO consumer
  * @child:	firmware node (child of @dev)
  *
  * GPIO descriptors returned from this function are automatically disposed on
  * driver detach.
  */
 struct gpio_desc *devm_get_gpiod_from_child(struct device *dev,
+					    const char *con_id,
 					    struct fwnode_handle *child)
 {
+	static const char const *suffixes[] = { "gpios", "gpio" };
+	char prop_name[32]; /* 32 is max size of property name */
 	struct gpio_desc **dr;
 	struct gpio_desc *desc;
+	unsigned int i;
 
 	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpio_desc *),
 			  GFP_KERNEL);
 	if (!dr)
 		return ERR_PTR(-ENOMEM);
 
-	desc = fwnode_get_named_gpiod(child, "gpios");
+	for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
+		if (con_id)
+			snprintf(prop_name, 32, "%s-%s", con_id, suffixes[i]);
+		else
+			snprintf(prop_name, 32, "%s", suffixes[i]);
+
+		desc = fwnode_get_named_gpiod(child, prop_name);
+		if (!IS_ERR(desc) || (PTR_ERR(desc) == -EPROBE_DEFER))
+			break;
+	}
 	if (IS_ERR(desc)) {
 		devres_free(dr);
 		return desc;
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 90df4df..097d721 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -125,7 +125,7 @@ static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct
 	device_for_each_child_node(dev, child) {
 		struct gpio_desc *desc;
 
-		desc = devm_get_gpiod_from_child(dev, child);
+		desc = devm_get_gpiod_from_child(dev, NULL, child);
 		if (IS_ERR(desc)) {
 			error = PTR_ERR(desc);
 			if (error != -EPROBE_DEFER)
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 7ea1ea42..8e5af69 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -184,7 +184,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
 		struct gpio_led led = {};
 		const char *state = NULL;
 
-		led.gpiod = devm_get_gpiod_from_child(dev, child);
+		led.gpiod = devm_get_gpiod_from_child(dev, NULL, child);
 		if (IS_ERR(led.gpiod)) {
 			fwnode_handle_put(child);
 			goto err;
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 45afc2d..ed20759 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -110,6 +110,7 @@ struct fwnode_handle;
 struct gpio_desc *fwnode_get_named_gpiod(struct fwnode_handle *fwnode,
 					 const char *propname);
 struct gpio_desc *devm_get_gpiod_from_child(struct device *dev,
+					    const char *con_id,
 					    struct fwnode_handle *child);
 #else /* CONFIG_GPIOLIB */
 
-- 
2.1.4

