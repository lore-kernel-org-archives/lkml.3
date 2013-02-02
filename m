Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3BBQ1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:27:35 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:51541 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab3BBQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:27 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/9] gpiolib: link all gpio_chips using a list
Date: Sun,  3 Feb 2013 01:29:24 +0900
Message-Id: <1359822572-26009-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a list member to gpio_chip that allows all chips to be parsed
quickly. The current method requires parsing the entire GPIO integer
space, which is painfully slow. Using a list makes many chip operations
that involve lookup or parsing faster, and also simplifies the code. It
is also necessary to eventually get rid of the global gpio_desc[] array.

The list of gpio_chips is always ordered by base GPIO number to ensure
chips traversal is done in the right order.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c     | 51 +++++++++++++++++++++++++++++++++++++++-------
 include/asm-generic/gpio.h |  2 ++
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e27877a..0050766 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3,6 +3,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
+#include <linux/list.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/debugfs.h>
@@ -71,6 +72,8 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+static LIST_HEAD(gpio_chips);
+
 #ifdef CONFIG_GPIO_SYSFS
 static DEFINE_IDR(dirent_idr);
 #endif
@@ -1013,6 +1016,43 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+/*
+ * Add a new chip to the global chips list, keeping the list of chips sorted
+ * by base order.
+ *
+ * Return -EBUSY if the new chip overlaps with some other chip's integer
+ * space.
+ */
+static int gpiochip_add_to_list(struct gpio_chip *chip)
+{
+	struct list_head *pos = &gpio_chips;
+	struct gpio_chip *_chip;
+	int err = 0;
+
+	/* find where to insert our chip */
+	list_for_each(pos, &gpio_chips) {
+		_chip = list_entry(pos, struct gpio_chip, list);
+		/* shall we insert before _chip? */
+		if (_chip->base >= chip->base + chip->ngpio)
+			break;
+	}
+
+	/* are we stepping on the chip right before? */
+	if (pos != &gpio_chips && pos->prev != &gpio_chips) {
+		_chip = list_entry(pos->prev, struct gpio_chip, list);
+		if (_chip->base + _chip->ngpio > chip->base) {
+			dev_err(chip->dev,
+			       "GPIO integer space overlap, cannot add chip\n");
+			err = -EBUSY;
+		}
+	}
+
+	if (!err)
+		list_add_tail(&chip->list, pos);
+
+	return err;
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -1054,13 +1094,8 @@ int gpiochip_add(struct gpio_chip *chip)
 		chip->base = base;
 	}
 
-	/* these GPIO numbers must not be managed by another gpio_chip */
-	for (id = base; id < base + chip->ngpio; id++) {
-		if (gpio_desc[id].chip != NULL) {
-			status = -EBUSY;
-			break;
-		}
-	}
+	status = gpiochip_add_to_list(chip);
+
 	if (status == 0) {
 		for (id = base; id < base + chip->ngpio; id++) {
 			gpio_desc[id].chip = chip;
@@ -1134,6 +1169,8 @@ int gpiochip_remove(struct gpio_chip *chip)
 	if (status == 0) {
 		for (id = chip->base; id < chip->base + chip->ngpio; id++)
 			gpio_desc[id].chip = NULL;
+
+		list_del(&chip->list);
 	}
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 2034e69..b562f95 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -53,6 +53,7 @@ struct device_node;
  * @label: for diagnostics
  * @dev: optional device providing the GPIOs
  * @owner: helps prevent removal of modules exporting active GPIOs
+ * @list: links gpio_chips together for traversal
  * @request: optional hook for chip-specific activation, such as
  *	enabling module power and clock; may sleep
  * @free: optional hook for chip-specific deactivation, such as
@@ -98,6 +99,7 @@ struct gpio_chip {
 	const char		*label;
 	struct device		*dev;
 	struct module		*owner;
+	struct list_head        list;
 
 	int			(*request)(struct gpio_chip *chip,
 						unsigned offset);
-- 
1.8.1.1

