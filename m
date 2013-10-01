Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3JAOgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:36:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:59159 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3JAOgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:36:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="301756023"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] gpio/lynxpoint: check if the interrupt is enabled in IRQ handler
Date: Tue,  1 Oct 2013 17:35:43 +0300
Message-Id: <1380638143-20040-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking LP_INT_STAT is not enough in the interrupt handler because its
contents get updated regardless of whether the pin has interrupt enabled or
not. This causes the driver to loop forever for GPIOs that are pulled up.

Fix this by checking the interrupt enable bit for the pin as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-lynxpoint.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 2d9ca60..41b5913 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -248,14 +248,15 @@ static void lp_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 	struct lp_gpio *lg = irq_data_get_irq_handler_data(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, pin, mask;
-	unsigned long reg, pending;
+	unsigned long reg, ena, pending;
 	unsigned virq;
 
 	/* check from GPIO controller which pin triggered the interrupt */
 	for (base = 0; base < lg->chip.ngpio; base += 32) {
 		reg = lp_gpio_reg(&lg->chip, base, LP_INT_STAT);
+		ena = lp_gpio_reg(&lg->chip, base, LP_INT_ENABLE);
 
-		while ((pending = inl(reg))) {
+		while ((pending = (inl(reg) & inl(ena)))) {
 			pin = __ffs(pending);
 			mask = BIT(pin);
 			/* Clear before handling so we don't lose an edge */
-- 
1.8.4.rc3

