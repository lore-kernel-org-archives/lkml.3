Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbbALQMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:12:55 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:45994 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbALQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:12:47 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/6] gpio: fix gpio-chip list corruption
Date: Mon, 12 Jan 2015 17:12:25 +0100
Message-Id: <1421079149-2236-3-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1421079149-2236-1-git-send-email-johan@kernel.org>
References: <1421079149-2236-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix potential corruption of gpio-chip list due to failure to remove the
chip from the list before returning in gpiochip_add error path.

The chip could be long gone when the global list is next traversed,
something which could lead to a null-pointer dereference. In the best
case (chip not deallocated) we are just leaking the gpio range.

Fixes: 14e85c0e69d5 ("gpio: remove gpio_descs global array")
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 89c59f5f1924..ac5944b4e4d8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -248,7 +248,8 @@ int gpiochip_add(struct gpio_chip *chip)
 		base = gpiochip_find_base(chip->ngpio);
 		if (base < 0) {
 			status = base;
-			goto unlock;
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			goto err_free_descs;
 		}
 		chip->base = base;
 	}
@@ -288,11 +289,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	acpi_gpiochip_add(chip);
 
 	status = gpiochip_export(chip);
-	if (status) {
-		acpi_gpiochip_remove(chip);
-		of_gpiochip_remove(chip);
-		goto fail;
-	}
+	if (status)
+		goto err_remove_chip;
 
 	pr_debug("%s: registered GPIOs %d to %d on device: %s\n", __func__,
 		chip->base, chip->base + chip->ngpio - 1,
@@ -300,9 +298,14 @@ int gpiochip_add(struct gpio_chip *chip)
 
 	return 0;
 
-unlock:
+err_remove_chip:
+	acpi_gpiochip_remove(chip);
+	of_gpiochip_remove(chip);
+	spin_lock_irqsave(&gpio_lock, flags);
+	list_del(&chip->list);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
+err_free_descs:
 	kfree(descs);
 	chip->desc = NULL;
 
-- 
2.0.5

