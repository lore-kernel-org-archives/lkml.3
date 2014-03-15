Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaCOPGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbaCOPFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:05:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 1/2] irqchip: sun4i: Use handle_fasteoi_irq for all interrupts
Date: Sat, 15 Mar 2014 16:04:53 +0100
Message-Id: <1394895894-8891-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394895894-8891-1-git-send-email-hdegoede@redhat.com>
References: <1394895894-8891-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the sun4i irq chip does not require any action and clears the interrupt
when the level goes back to inactive, we don't need to mask / unmask for
non oneshot IRQs, to achieve this we make sun4i_irq_ack a nop for all irqs
except irq 0 and use handle_fasteoi_irq for all interrupts.

Now there might be a case when the device reactivates the interrupt
before the RETI. But that does not matter as we run the primary
interrupt handlers with interrupts disabled.

This also allows us to get rid of needing to use 2 irq_chip structs, this
means that the IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED will now influence
all interrupts rather then just irq 0, but that does not matter as the eoi
is now a nop anyways for all interrupts but irq 0.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/irqchip/irq-sun4i.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index a0ed1ea..6a8c88d 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -45,6 +45,9 @@ static void sun4i_irq_ack(struct irq_data *irqd)
 	int reg = irq / 32;
 	u32 val;
 
+	if (irq != 0)
+		return; /* Only IRQ 0 / the ENMI needs to be acked */
+
 	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
 	writel(val | (1 << irq_off),
 	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
@@ -76,13 +79,6 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
 
 static struct irq_chip sun4i_irq_chip = {
 	.name		= "sun4i_irq",
-	.irq_mask	= sun4i_irq_mask,
-	.irq_unmask	= sun4i_irq_unmask,
-};
-
-/* IRQ 0 / the ENMI needs a late eoi call */
-static struct irq_chip sun4i_irq_chip_enmi = {
-	.name		= "sun4i_irq",
 	.irq_eoi	= sun4i_irq_ack,
 	.irq_mask	= sun4i_irq_mask,
 	.irq_unmask	= sun4i_irq_unmask,
@@ -92,13 +88,7 @@ static struct irq_chip sun4i_irq_chip_enmi = {
 static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw)
 {
-	if (hw == 0)
-		irq_set_chip_and_handler(virq, &sun4i_irq_chip_enmi,
-					 handle_fasteoi_irq);
-	else
-		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
-					 handle_level_irq);
-
+	irq_set_chip_and_handler(virq, &sun4i_irq_chip, handle_fasteoi_irq);
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
-- 
1.9.0

