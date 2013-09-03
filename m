Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab3ICKkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:40:14 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62852 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731Ab3ICKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:40:12 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gpio: Fix crash in gpiod_set_debounce()
Date: Tue,  3 Sep 2013 12:39:27 +0200
Message-Id: <1378204768-18013-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return an error if neither the ->set() nor the ->set_debounce() function
is implemented by the chip. Furthermore move locking further down so the
lock doesn't have to be unlocked on error. This is safe to do because at
this point the lock doesn't protect anything.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Linus,

Feel free to squash this into the commit that introduced these:

	fc9bbfb: gpio: improve error path in gpiolib

Thierry

 drivers/gpio/gpiolib.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index acd19c9..9f8a134 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1777,14 +1777,15 @@ static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&gpio_lock, flags);
-
 	chip = desc->chip;
 	if (!chip->set || !chip->set_debounce) {
 	  pr_warn("%s: missing set() or set_debounce() operations\n",
 		  __func__);
+		return -EIO;
 	}
 
+	spin_lock_irqsave(&gpio_lock, flags);
+
 	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
-- 
1.8.4

