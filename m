Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab3BBQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:29:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59613 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3BBQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:31 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/9] gpiolib: use gpio_chips list in gpiochip_find
Date: Sun,  3 Feb 2013 01:29:26 +0900
Message-Id: <1359822572-26009-5-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the GPIO chips list is much faster than parsing the entire GPIO
number space.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 4ceb4a7..92f9ee4 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1194,20 +1194,17 @@ struct gpio_chip *gpiochip_find(void *data,
 				int (*match)(struct gpio_chip *chip,
 					     void *data))
 {
-	struct gpio_chip *chip = NULL;
+	struct gpio_chip *chip;
 	unsigned long flags;
-	int i;
 
 	spin_lock_irqsave(&gpio_lock, flags);
-	for (i = 0; i < ARCH_NR_GPIOS; i++) {
-		if (!gpio_desc[i].chip)
-			continue;
-
-		if (match(gpio_desc[i].chip, data)) {
-			chip = gpio_desc[i].chip;
+	list_for_each_entry(chip, &gpio_chips, list)
+		if (match(chip, data))
 			break;
-		}
-	}
+
+	/* No match? */
+	if (&chip->list == &gpio_chips)
+		chip = NULL;
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	return chip;
-- 
1.8.1.1

