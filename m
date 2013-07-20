Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3GTOvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:51:52 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:52661 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173Ab3GTOvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:51:50 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH] pinctrl: at91: choose appropriate handler for level interrupts
Date: Sat, 20 Jul 2013 16:51:33 +0200
Message-Id: <1374331893-16009-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 11734973255523268780
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation handle both edge and level interrupts with the
'handle_simple_irq' handler.

Level interrupts are active as long as the pin stays at the configured
level (low or high). In this case we have to use 'handle_level_irq' which
mask the interrupt until the handle has treated it.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pinctrl/pinctrl-at91.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 5d7529e..76e108d 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1241,18 +1241,22 @@ static int alt_gpio_irq_type(struct irq_data *d, unsigned type)
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
+		irq_set_handler(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_ESR);
 		writel_relaxed(mask, pio + PIO_REHLSR);
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
+		irq_set_handler(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_ESR);
 		writel_relaxed(mask, pio + PIO_FELLSR);
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
+		irq_set_handler(d->irq, handle_level_irq);
 		writel_relaxed(mask, pio + PIO_LSR);
 		writel_relaxed(mask, pio + PIO_FELLSR);
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
+		irq_set_handler(d->irq, handle_level_irq);
 		writel_relaxed(mask, pio + PIO_LSR);
 		writel_relaxed(mask, pio + PIO_REHLSR);
 		break;
@@ -1261,6 +1265,7 @@ static int alt_gpio_irq_type(struct irq_data *d, unsigned type)
 		 * disable additional interrupt modes:
 		 * fall back to default behavior
 		 */
+		irq_set_handler(d->irq, handle_simple_irq);
 		writel_relaxed(mask, pio + PIO_AIMDR);
 		return 0;
 	case IRQ_TYPE_NONE:
@@ -1402,6 +1407,8 @@ static int at91_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 							irq_hw_number_t hw)
 {
 	struct at91_gpio_chip	*at91_gpio = h->host_data;
+	void __iomem		*pio = at91_gpio->regbase;
+	u32			mask = 1 << hw;
 
 	irq_set_lockdep_class(virq, &gpio_lock_class);
 
@@ -1409,8 +1416,13 @@ static int at91_gpio_irq_map(struct irq_domain *h, unsigned int virq,
 	 * Can use the "simple" and not "edge" handler since it's
 	 * shorter, and the AIC handles interrupts sanely.
 	 */
-	irq_set_chip_and_handler(virq, &gpio_irqchip,
-				 handle_simple_irq);
+	irq_set_chip(virq, &gpio_irqchip);
+	if ((at91_gpio->ops == &at91sam9x5_ops) &&
+	    (readl_relaxed(pio + PIO_AIMMR) & mask) &&
+	    (readl_relaxed(pio + PIO_ELSR) & mask))
+		irq_set_handler(virq, handle_level_irq);
+	else
+		irq_set_handler(virq, handle_simple_irq);
 	set_irq_flags(virq, IRQF_VALID);
 	irq_set_chip_data(virq, at91_gpio);
 
-- 
1.7.9.5

