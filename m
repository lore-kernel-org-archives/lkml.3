Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3BIKea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:34:30 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35805 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3BIKe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:34:29 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpiolib: Fix locking on gpio debugfs files
Date: Sat,  9 Feb 2013 10:34:22 +0000
Message-Id: <1360406062-14982-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs files really need to hold the gpiolib spinlock before
accessing the list. Otherwise chip addition/removal will cause an oops.

Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/gpiolib.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8ccf68b..807c9d3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1884,29 +1884,35 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 static void *gpiolib_seq_start(struct seq_file *s, loff_t *pos)
 {
+	unsigned long flags;
 	struct gpio_chip *chip = NULL;
 	loff_t index = *pos;
 
-	/* REVISIT this isn't locked against gpio_chip removal ... */
-
 	s->private = "";
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	list_for_each_entry(chip, &gpio_chips, list)
-		if (index-- == 0)
+		if (index-- == 0) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
 			return chip;
+		}
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	return NULL;
 }
 
 static void *gpiolib_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
+	unsigned long flags;
 	struct gpio_chip *chip = v;
 	void *ret = NULL;
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	if (list_is_last(&chip->list, &gpio_chips))
 		ret = NULL;
 	else
 		ret = list_entry(chip->list.next, struct gpio_chip, list);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	s->private = "\n";
 	++*pos;
-- 
1.7.10.4

