Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3BBQ1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:27:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab3BBQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:35 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 5/9] gpiolib: use gpio_chips list in gpiochip_find_base
Date: Sun,  3 Feb 2013 01:29:28 +0900
Message-Id: <1359822572-26009-7-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-implement gpiochip_find_base using the list of chips instead of the
global gpio_desc[] array. This makes it both simpler and more efficient,
and is needed to remove the global descriptors array.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e473ded..af4c350 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -126,30 +126,25 @@ struct gpio_chip *gpio_to_chip(unsigned gpio)
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
 static int gpiochip_find_base(int ngpio)
 {
-	int i;
-	int spare = 0;
-	int base = -ENOSPC;
-
-	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
-		struct gpio_desc *desc = &gpio_desc[i];
-		struct gpio_chip *chip = desc->chip;
-
-		if (!chip) {
-			spare++;
-			if (spare == ngpio) {
-				base = i;
-				break;
-			}
-		} else {
-			spare = 0;
-			if (chip)
-				i -= chip->ngpio - 1;
-		}
+	struct gpio_chip *chip;
+	int base = ARCH_NR_GPIOS - ngpio;
+
+	list_for_each_entry_reverse(chip, &gpio_chips, list) {
+		/* found a free space? */
+		if (chip->base + chip->ngpio <= base)
+			break;
+		else
+			/* nope, check the space right before the chip */
+			base = chip->base - ngpio;
 	}
 
-	if (gpio_is_valid(base))
+	if (gpio_is_valid(base)) {
 		pr_debug("%s: found new base at %d\n", __func__, base);
-	return base;
+		return base;
+	} else {
+		pr_err("%s: cannot find free range\n", __func__);
+		return -ENOSPC;
+	}
 }
 
 /* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
-- 
1.8.1.1

