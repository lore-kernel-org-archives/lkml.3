Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaAUPzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:55:24 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:59196 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaAUPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:55:21 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] pinctrl: at91: use locked variant of irq_set_handler
Date: Tue, 21 Jan 2014 16:55:18 +0100
Message-ID: <1390319718-12285-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting the gpio irq type, use the __irq_set_handler_locked()
variant instead of the irq_set_handler() to prevent false
spinlock recursion warning.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # v3.12
---
 drivers/pinctrl/pinctrl-at91.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index a7549c4c83b4..7d7a21c20931 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1260,22 +1260,22 @@ static int alt_gpio_irq_type(struct irq_data *d, unsigned type)
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-		irq_set_handler(d->irq, handle_simple_irq);
+		__irq_set_handler_locked(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_ESR);
 		writel_relaxed(mask, pio + PIO_REHLSR);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		irq_set_handler(d->irq, handle_simple_irq);
+		__irq_set_handler_locked(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_ESR);
 		writel_relaxed(mask, pio + PIO_FELLSR);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		irq_set_handler(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 		writel_relaxed(mask, pio + PIO_LSR);
 		writel_relaxed(mask, pio + PIO_FELLSR);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		irq_set_handler(d->irq, handle_level_irq);
+		__irq_set_handler_locked(d->irq, handle_level_irq);
 		writel_relaxed(mask, pio + PIO_LSR);
 		writel_relaxed(mask, pio + PIO_REHLSR);
 		break;
@@ -1284,7 +1284,7 @@ static int alt_gpio_irq_type(struct irq_data *d, unsigned type)
 		 * disable additional interrupt modes:
 		 * fall back to default behavior
 		 */
-		irq_set_handler(d->irq, handle_simple_irq);
+		__irq_set_handler_locked(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_AIMDR);
 		return 0;
 	case IRQ_TYPE_NONE:
-- 
1.8.2.2

