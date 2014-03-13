Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaCMUj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaCMUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:39:28 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/3] irqchip: sun4i: simplify sun4i_irq_ack
Date: Thu, 13 Mar 2014 20:50:02 +0100
Message-Id: <1394740202-1952-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394740202-1952-1-git-send-email-hdegoede@redhat.com>
References: <1394740202-1952-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we only ack irq 0 the code can be simplified a lot.

Also switch from read / modify / write to a simple write clear:
1) This is what the android code does (it has a hack for acking irq 0
  in its unmask code doing this)
2) read / modify / write simply does not make sense for an irq status
  register like this, if the other bits are writeable (and the data sheet says
  they are not) they should be write 1 to clear, since otherwise a read /
  modify / write can race with a device raising an interrupt and then clear
  the pending bit unintentionally

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/irqchip/irq-sun4i.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 6a8c88d..75615b5 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -41,16 +41,11 @@ static asmlinkage void __exception_irq_entry sun4i_handle_irq(struct pt_regs *re
 static void sun4i_irq_ack(struct irq_data *irqd)
 {
 	unsigned int irq = irqd_to_hwirq(irqd);
-	unsigned int irq_off = irq % 32;
-	int reg = irq / 32;
-	u32 val;
 
 	if (irq != 0)
 		return; /* Only IRQ 0 / the ENMI needs to be acked */
 
-	val = readl(sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
-	writel(val | (1 << irq_off),
-	       sun4i_irq_base + SUN4I_IRQ_PENDING_REG(reg));
+	writel(BIT(0), sun4i_irq_base + SUN4I_IRQ_PENDING_REG(0));
 }
 
 static void sun4i_irq_mask(struct irq_data *irqd)
-- 
1.9.0

