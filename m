Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaGVHS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:18:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1483 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaGVHSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:18:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 22 Jul 2014 00:10:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/5] gpio: simplify gpiochip_export()
Date: Tue, 22 Jul 2014 16:17:40 +0900
Message-ID: <1406013463-19218-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason gpiochip_export() would invalidate all the descriptors
of a chip if exporting it to sysfs failed. This does not appear as
necessary. Remove that part of the code.

While we are at it, add a note about the non-safety of temporarily
releasing a spinlock in the middle of the loop that protects its
iterator, and explain why this is done.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib-sysfs.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 3516502059f2..f150aa288fa1 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -760,18 +760,8 @@ int gpiochip_export(struct gpio_chip *chip)
 	chip->exported = (status == 0);
 	mutex_unlock(&sysfs_lock);
 
-	if (status) {
-		unsigned long	flags;
-		unsigned	gpio;
-
-		spin_lock_irqsave(&gpio_lock, flags);
-		gpio = 0;
-		while (gpio < chip->ngpio)
-			chip->desc[gpio++].chip = NULL;
-		spin_unlock_irqrestore(&gpio_lock, flags);
-
+	if (status)
 		chip_dbg(chip, "%s: status %d\n", __func__, status);
-	}
 
 	return status;
 }
@@ -817,6 +807,14 @@ static int __init gpiolib_sysfs_init(void)
 		if (!chip || chip->exported)
 			continue;
 
+		/*
+		 * TODO we yield gpio_lock here because gpiochip_export()
+		 * acquires a mutex. This is unsafe and needs to be fixed.
+		 *
+		 * Also it would be nice to use gpiochip_find() here so we
+		 * can keep gpio_chips local to gpiolib.c, but the yield of
+		 * gpio_lock prevents us from doing this.
+		 */
 		spin_unlock_irqrestore(&gpio_lock, flags);
 		status = gpiochip_export(chip);
 		spin_lock_irqsave(&gpio_lock, flags);
-- 
2.0.1

