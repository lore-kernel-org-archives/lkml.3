Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3KPMlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 07:41:04 -0500
Received: from gnurou.org ([207.192.72.5]:53213 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3KPMk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 07:40:59 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: fix find_chip_by_name()
Date: Sat, 16 Nov 2013 21:39:32 +0900
Message-Id: <1384605572-9811-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_chip_by_name() was incorrectly implemented by using
gpio_lookup_list instead of gpiod_chips to iterate through all the
registered GPIO controllers. This patch reimplements it by using
gpiochip_find() with a custom search function, which simplifies the code
on top of fixing the mistake.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 9f3326b..63bbf5b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1307,6 +1307,18 @@ struct gpio_chip *gpiochip_find(void *data,
 }
 EXPORT_SYMBOL_GPL(gpiochip_find);
 
+static int gpiochip_match_name(struct gpio_chip *chip, void *data)
+{
+	const char *name = data;
+
+	return !strcmp(chip->label, name);
+}
+
+static struct gpio_chip *find_chip_by_name(const char *name)
+{
+	return gpiochip_find((void *)name, gpiochip_match_name);
+}
+
 #ifdef CONFIG_PINCTRL
 
 /**
@@ -2212,23 +2224,6 @@ void gpiod_add_table(struct gpiod_lookup *table, size_t size)
 	mutex_unlock(&gpio_lookup_lock);
 }
 
-/*
- * Caller must have a acquired gpio_lookup_lock
- */
-static struct gpio_chip *find_chip_by_name(const char *name)
-{
-	struct gpio_chip *chip = NULL;
-
-	list_for_each_entry(chip, &gpio_lookup_list, list) {
-		if (chip->label == NULL)
-			continue;
-		if (!strcmp(chip->label, name))
-			break;
-	}
-
-	return chip;
-}
-
 #ifdef CONFIG_OF
 static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 				      unsigned int idx, unsigned long *flags)
-- 
1.8.4.2

