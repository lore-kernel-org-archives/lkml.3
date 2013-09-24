Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3IXIGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:06:35 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:16935 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3IXIGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:06:31 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <cooloney@gmail.com>, <rpurdie@rpsys.net>
CC: <linux-leds@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] leds-gpio: of: led should not be created if its status is disabled
Date: Tue, 24 Sep 2013 16:04:22 +0800
Message-ID: <1380009863-6454-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now the leds-gpio driver will create every child led node without
checking the status is disabled or not.

for example, if we have a led node like d3, and its status is disabled:
	leds {
		d3 {
			label = "d3";
			gpios = <&pioE 24 0>;
			status = "disabled";
		};
	};

we except the d3 should not be created. And the gpios should not be
request as well.

But current driver will create d3 and request its gpio.

This patch fix this by using for_each_available_child_of_node() to
enumerate all child nodes. So the disabled node will be inavilable.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/leds/leds-gpio.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index e8b01e5..9bb4e04 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -167,23 +167,23 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node, *child;
 	struct gpio_leds_priv *priv;
-	int count, ret;
+	int count = 0, ret;
 
 	/* count LEDs in this device, so we know how much to allocate */
-	count = of_get_child_count(np);
-	if (!count)
-		return ERR_PTR(-ENODEV);
-
-	for_each_child_of_node(np, child)
+	for_each_available_child_of_node(np, child) {
+		count++;
 		if (of_get_gpio(child, 0) == -EPROBE_DEFER)
 			return ERR_PTR(-EPROBE_DEFER);
+	}
+	if (!count)
+		return ERR_PTR(-ENODEV);
 
 	priv = devm_kzalloc(&pdev->dev, sizeof_gpio_leds_priv(count),
 			GFP_KERNEL);
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
-	for_each_child_of_node(np, child) {
+	for_each_available_child_of_node(np, child) {
 		struct gpio_led led = {};
 		enum of_gpio_flags flags;
 		const char *state;
-- 
1.7.9.5

