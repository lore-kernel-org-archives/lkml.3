Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaDWP3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:29:39 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49615 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaDWP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:29:31 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
Date: Wed, 23 Apr 2014 17:28:09 +0200
Message-Id: <1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Many bindings use the -gpio suffix in property names. Support this in
addition to the -gpios suffix when requesting GPIOs using the new
descriptor-based API.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpio/gpiolib.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7a0b97076374..b991462c22fb 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2594,17 +2594,23 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 				      unsigned int idx,
 				      enum gpio_lookup_flags *flags)
 {
+	static const char *suffixes[] = { "gpios", "gpio" };
 	char prop_name[32]; /* 32 is max size of property name */
 	enum of_gpio_flags of_flags;
 	struct gpio_desc *desc;
+	unsigned int i;
 
-	if (con_id)
-		snprintf(prop_name, 32, "%s-gpios", con_id);
-	else
-		snprintf(prop_name, 32, "gpios");
+	for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
+		if (con_id)
+			snprintf(prop_name, 32, "%s-%s", con_id, suffixes[i]);
+		else
+			snprintf(prop_name, 32, "%s", suffixes[i]);
 
-	desc = of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
-					&of_flags);
+		desc = of_get_named_gpiod_flags(dev->of_node, prop_name, idx,
+						&of_flags);
+		if (!IS_ERR(desc))
+			break;
+	}
 
 	if (IS_ERR(desc))
 		return desc;
-- 
1.9.2

