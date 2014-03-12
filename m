Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbaCLRRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaCLRRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:17:43 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 4/4] irqchip: sun4i: Use handle_fasteoi_late_irq for the ENMI (irq 0)
Date: Wed, 12 Mar 2014 18:17:07 +0100
Message-Id: <1394644627-12315-5-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394644627-12315-1-git-send-email-hdegoede@redhat.com>
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ENMI needs to have the ack done *after* clearing the interrupt source,
otherwise we will get a spurious interrupt for each real interrupt. Switch
to the new handle_fasteoi_late_irq handler which gives us the desired behavior.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/irqchip/irq-sun4i.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 8a2fbee..4b1c874 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -77,15 +77,22 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
 static struct irq_chip sun4i_irq_chip = {
 	.name		= "sun4i_irq",
 	.irq_ack	= sun4i_irq_ack,
+	.irq_eoi	= sun4i_irq_ack, /* For the ENMI */
 	.irq_mask	= sun4i_irq_mask,
 	.irq_unmask	= sun4i_irq_unmask,
+	.flags		= IRQCHIP_EOI_THREADED, /* Only affects the ENMI */
 };
 
 static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
 			 irq_hw_number_t hw)
 {
-	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
-				 handle_level_irq);
+	if (hw == 0) /* IRQ 0, the ENMI needs special handling */
+		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
+					 handle_fasteoi_late_irq);
+	else
+		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
+					 handle_level_irq);
+
 	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);
 
 	return 0;
-- 
1.9.0

