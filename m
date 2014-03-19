Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbaCSLhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:37:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250AbaCSLhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:37:04 -0400
Date: Wed, 19 Mar 2014 04:36:42 -0700
From: tip-bot for Hans de Goede <tipbot@zytor.com>
Message-ID: <tip-915b78ce8ef0178305cb100e830832a866b42faa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hdegoede@redhat.com, tglx@linutronix.de,
        maxime.ripard@free-electrons.com
In-Reply-To: <1394895894-8891-2-git-send-email-hdegoede@redhat.com>
References: <1394895894-8891-2-git-send-email-hdegoede@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: sun4i:
  Use handle_fasteoi_irq for all interrupts
Git-Commit-ID: 915b78ce8ef0178305cb100e830832a866b42faa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  915b78ce8ef0178305cb100e830832a866b42faa
Gitweb:     http://git.kernel.org/tip/915b78ce8ef0178305cb100e830832a866b42faa
Author:     Hans de Goede <hdegoede@redhat.com>
AuthorDate: Sat, 15 Mar 2014 16:04:53 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Mar 2014 12:34:29 +0100

irqchip: sun4i: Use handle_fasteoi_irq for all interrupts

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
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@googlegroups.com
Link: http://lkml.kernel.org/r/1394895894-8891-2-git-send-email-hdegoede@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-sun4i.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 2029cc5..003a146 100644
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
