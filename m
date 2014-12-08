Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaLHVc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:32:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61005 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaLHVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:32:24 -0500
From: Olof Johansson <olof@lixom.net>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: rjui@broadcom.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] gpio: bcm-kona: memory corruption fix
Date: Mon,  8 Dec 2014 13:34:33 -0800
Message-Id: <1418074473-10811-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one instance the base address of the internal controller state
structure is passed into a function doing writel to an offset of
the pointer passed in is used, instead of the register base.

Once I found the bug, I also went back to check for other sparse
warnings in the file, but found none. This one, however, triggered:

drivers/gpio/gpio-bcm-kona.c:552:47: warning: incorrect type in argument 1 (different address spaces)
drivers/gpio/gpio-bcm-kona.c:552:47:    expected void [noderef] <asn:2>*reg_base
drivers/gpio/gpio-bcm-kona.c:552:47:    got struct bcm_kona_gpio *kona_gpio
drivers/gpio/gpio-bcm-kona.c:556:47: warning: incorrect type in argument 1 (different address spaces)
drivers/gpio/gpio-bcm-kona.c:556:47:    expected void [noderef] <asn:2>*reg_base
drivers/gpio/gpio-bcm-kona.c:556:47:    got struct bcm_kona_gpio *kona_gpio

As far as I can tell, this bug has been here for a long time and is
not new, but I found it when hunting down another heisenbug on this
platform.

Not marking for stable since I am unaware of any upstream user of kona
on a product that would benefit from it.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/gpio/gpio-bcm-kona.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index de0801e..d552cca 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -549,11 +549,11 @@ static void bcm_kona_gpio_reset(struct bcm_kona_gpio *kona_gpio)
 	/* disable interrupts and clear status */
 	for (i = 0; i < kona_gpio->num_bank; i++) {
 		/* Unlock the entire bank first */
-		bcm_kona_gpio_write_lock_regs(kona_gpio, i, UNLOCK_CODE);
+		bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, i, UNLOCK_CODE);
 		writel(0xffffffff, reg_base + GPIO_INT_MASK(i));
 		writel(0xffffffff, reg_base + GPIO_INT_STATUS(i));
 		/* Now re-lock the bank */
-		bcm_kona_gpio_write_lock_regs(kona_gpio, i, LOCK_CODE);
+		bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, i, LOCK_CODE);
 	}
 }
 
-- 
1.7.10.4

