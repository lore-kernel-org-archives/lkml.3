Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3BBQ1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:27:48 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:47651 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab3BBQ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:41 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 8/9] gpiolib: use gpio_chips list in gpio_to_desc
Date: Sun,  3 Feb 2013 01:29:31 +0900
Message-Id: <1359822572-26009-10-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the list of chips to find the descriptor corresponding to a GPIO
number instead of directly picking the entry of the global gpio_desc[]
array, which is due to be removed.

This turns the complexity of converting a GPIO number into a descriptor
from O(1) to O(n) where n is the number of GPIO chips in the system.
Since n is ought to be small anyway, there should be no noticeable
performance impact. Moreover, GPIO users who care for speed already have
implemented their own gpio_get_value() and gpio_set_value() with a
fast path for the GPIO numbers that matter and this change does not
affect such use cases.

The descriptor-based GPIO API, due to be introduced soon, will make this
lookup unnecessary.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9599b9a..0247c48 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -122,10 +122,21 @@ static int gpio_chip_hwgpio(const struct gpio_desc *desc)
  */
 static struct gpio_desc *gpio_to_desc(unsigned gpio)
 {
-	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
-		return NULL;
-	else
-		return &gpio_desc[gpio];
+	struct gpio_chip *chip;
+
+	list_for_each_entry(chip, &gpio_chips, list) {
+		int gpio_min = chip->base;
+		int gpio_max = gpio_min + chip->ngpio;
+		if (gpio >= gpio_min && gpio < gpio_max)
+			return &chip->desc[gpio - gpio_min];
+		else if (gpio < gpio_min)
+			/* gpio_chips are ordered by base, so we won't get any
+			 * hit if we arrive here... */
+			break;
+	}
+
+	pr_warn("%s: no registered chip to handle GPIO %d\n", __func__, gpio);
+	return NULL;
 }
 
 /**
-- 
1.8.1.1

