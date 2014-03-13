Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaCMSFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:05:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbaCMSE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:04:29 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 2/4] irqchip: sun4i: Fix irq 0 not working
Date: Thu, 13 Mar 2014 19:03:52 +0100
Message-Id: <1394733834-26839-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
References: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SUN4I_IRQ_VECTOR_REG containing 0 can mean one of 3 things:
1) no more irqs pending
2) irq 0 pending
3) spurious irq

So if we immediately get a reading of 0, check the irq-pending reg
to differentiate between 2 and 3. We only do this once to avoid
the extra check in the common case of 1) hapening after having
read the vector-reg once.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/irqchip/irq-sun4i.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index a5438d8..5c25048 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -140,10 +140,24 @@ static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *re
 {
 	u32 irq, hwirq;
 
+	/*
+	 * hwirq == 0 can mean one of 3 things:
+	 * 1) no more irqs pending
+	 * 2) irq 0 pending
+	 * 3) spurious irq
+	 * So if we immediately get a reading of 0, check the irq-pending reg
+	 * to differentiate between 2 and 3. We only do this once to avoid
+	 * the extra check in the common case of 1 hapening after having
+	 * read the vector-reg once.
+	 */
 	hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
-	while (hwirq != 0) {
+	if (hwirq == 0 &&
+		  !(readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0)) & BIT(0)))
+		return;
+
+	do {
 		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
 		handle_IRQ(irq, regs);
 		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
-	}
+	} while (hwirq != 0);
 }
-- 
1.9.0

