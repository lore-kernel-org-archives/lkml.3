Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab3BBQ1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:27:54 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46131 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3BBQ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:44 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 9/9] gpiolib: dynamically allocate descriptors array
Date: Sun,  3 Feb 2013 01:29:32 +0900
Message-Id: <1359822572-26009-11-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate the GPIO descriptor's memory dynamically when GPIO chips are
added instead of using the static gpio_desc[] array. gpio_desc[] is now
totally unused and therefore removed.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 0247c48..893cf94 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -41,7 +41,7 @@
 #define	extra_checks	0
 #endif
 
-/* gpio_lock prevents conflicts during gpio_desc[] table updates.
+/* gpio_lock prevents conflicts during gpio descriptors updates.
  * While any GPIO is requested, its gpio_chip is not removable;
  * each GPIO's "requested" flag serves as a lock and refcount.
  */
@@ -70,7 +70,6 @@ struct gpio_desc {
 	const char		*label;
 #endif
 };
-static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
 #define GPIO_OFFSET_VALID(chip, offset) (offset >= 0 && offset < chip->ngpio)
 
@@ -1163,6 +1162,13 @@ int gpiochip_add(struct gpio_chip *chip)
 		goto fail;
 	}
 
+	chip->desc = kzalloc(sizeof(struct gpio_desc) * chip->ngpio,
+			     GFP_KERNEL);
+	if (!chip->desc) {
+		status = -ENOMEM;
+		goto fail;
+	}
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	if (base < 0) {
@@ -1177,8 +1183,6 @@ int gpiochip_add(struct gpio_chip *chip)
 	status = gpiochip_add_to_list(chip);
 
 	if (status == 0) {
-		chip->desc = &gpio_desc[chip->base];
-
 		for (id = 0; id < chip->ngpio; id++) {
 			struct gpio_desc *desc = &chip->desc[id];
 			desc->chip = chip;
@@ -1218,6 +1222,8 @@ unlock:
 
 	return 0;
 fail:
+	kfree(chip->desc);
+
 	/* failures here can mean systems won't boot... */
 	pr_err("gpiochip_add: gpios %d..%d (%s) failed to register\n",
 		chip->base, chip->base + chip->ngpio - 1,
@@ -1261,6 +1267,8 @@ int gpiochip_remove(struct gpio_chip *chip)
 	if (status == 0)
 		gpiochip_unexport(chip);
 
+	kfree(chip->desc);
+
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
-- 
1.8.1.1

