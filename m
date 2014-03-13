Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaCMSE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:04:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbaCMSEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:04:34 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 4/4] irqchip: sun4i: Don't ack IRQs != 0, fix acking of IRQ 0
Date: Thu, 13 Mar 2014 19:03:54 +0100
Message-Id: <1394733834-26839-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All IRQs except for IRQ 0 seem to not need acking, so drop acking for them.

The ENMI needs to have the ack done *after* clearing the interrupt source,
otherwise we will get a spurious interrupt for each real interrupt.

So use the new IRQCHIP_EOI_THREADED flag for this in combination with
handle_fasteoi_irq. This uses a separate irq_chip struct for IRQ 0,
since we only want this behavior for IRQ 0.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/irqchip/irq-sun4i.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 8a2fbee..a0ed1ea 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -76,16 +76,29 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
 
 static struct irq_chip sun4i_irq_chip = {
 	.name		= "sun4i_irq",
-	.irq_ack	= sun4i_irq_ack,
 	.irq_mask	= sun4i_irq_mask,
 	.irq_unmask	= sun4i_irq_unmask,
 };
 
+/* IRQ 0 / the ENMI needs a late eoi call */
+static struct irq_chip sun4i_irq_chip_enmi = {
+	.name		= "sun4i_irq",
+	.irq_eoi	= sun4i_irq_ack,
+	.irq_mask	= sun4i_irq_mask,
+	.irq_unmask	= sun4i_irq_unmask,
+	.flags		= IRQCHIP_EOI_THREADED | IRQCHIP_EOI_IF_HANDLED,
+};
+
 static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
-				 handle_level_irq);
+	if (hw == 0)
+		irq_set_chip_and_handler(virq, &sun4i_irq_chip_enmi,
+					 handle_fasteoi_irq);
+	else
+		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
+					 handle_level_irq);
+
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
-- 
1.9.0

