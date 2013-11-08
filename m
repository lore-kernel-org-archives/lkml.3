Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3KHGqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:46:23 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62519 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3KHGqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:46:17 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, linux-gpio@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio
Date: Fri,  8 Nov 2013 12:15:55 +0530
Message-Id: <1383893156-28010-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch fixes a check for offset in gpio_to_irq_unbanked()
and also assigns gpio_irq, gpio_unbanked of chips[0] to
appropriate values which is used in gpio_to_irq_unbanked()
function.

Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/gpio/gpio-davinci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 8847adf..84be701 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -327,7 +327,7 @@ static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 	 * NOTE:  we assume for now that only irqs in the first gpio_chip
 	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
 	 */
-	if (offset < d->irq_base)
+	if (offset < d->gpio_unbanked)
 		return d->gpio_irq + offset;
 	else
 		return -ENODEV;
@@ -419,6 +419,8 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 
 		/* pass "bank 0" GPIO IRQs to AINTC */
 		chips[0].chip.to_irq = gpio_to_irq_unbanked;
+		chips[0].gpio_irq = bank_irq;
+		chips[0].gpio_unbanked = pdata->gpio_unbanked;
 		binten = BIT(0);
 
 		/* AINTC handles mask/unmask; GPIO handles triggering */
-- 
1.7.9.5

