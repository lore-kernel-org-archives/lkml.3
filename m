Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3KAWFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:05:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3KAWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:05:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.10 43/54] gpio/lynxpoint: check if the interrupt is enabled in IRQ handler
Date: Fri,  1 Nov 2013 15:04:11 -0700
Message-Id: <20131101220216.164381741@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 03d152d5582abc8a1c19cb107164c3724bbd4be4 upstream.

Checking LP_INT_STAT is not enough in the interrupt handler because its
contents get updated regardless of whether the pin has interrupt enabled or
not. This causes the driver to loop forever for GPIOs that are pulled up.

Fix this by checking the interrupt enable bit for the pin as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-lynxpoint.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -248,14 +248,15 @@ static void lp_gpio_irq_handler(unsigned
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


