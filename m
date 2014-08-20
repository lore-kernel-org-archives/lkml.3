Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaHTOtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:49:40 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:47678 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaHTOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:49:36 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] irqchip: renesas-intc-irqpin: Add suspend-to-RAM wake up support
Date: Wed, 20 Aug 2014 16:49:32 +0200
Message-Id: <1408546172-22484-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the ->irq_enable() and ->irq_disable() methods to NULL to enable
lazy disable of interrupts, and set IRQCHIP_MASK_ON_SUSPEND to tell the
core that only IRQs marked as wake-ups need to stay enabled during
suspend-to-RAM.

This makes wake-up by gpio-keys from suspend-to-RAM work on
r8a7740/Armadillo.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Not tested on sh73a0/kzm9g, r8a7778/bock-w, r8a7779/marzen

Similar changes for gpio-rcar and renesas-irqc went in before, but
split in two parts:
  - commit 272012d0f748de2e ("irqchip: renesas-irqc: Use lazy disable")
  - commit 6a7e3b3007b5396a ("irqchip: renesas-irqc: Enable mask on suspend")
  - commit fba968a1e6b84be0 ("gpio: rcar: Use lazy disable")
  - commit 403961120667bed7 ("gpio: rcar: Enable mask on suspend")

However, I believe it doesn't make much sense to split this:
  - Enabling lazy disable on its own introduces a regression, as it
    causes the system to wake-up on IRQs not marked as wake-ups,
  - Adding IRQCHIP_MASK_ON_SUSPEND on its own doesn't have any impact.
---
 drivers/irqchip/irq-renesas-intc-irqpin.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-renesas-intc-irqpin.c b/drivers/irqchip/irq-renesas-intc-irqpin.c
index 3ee78f02e5d7..a9efceb0c4a0 100644
--- a/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ b/drivers/irqchip/irq-renesas-intc-irqpin.c
@@ -454,10 +454,8 @@ static int intc_irqpin_probe(struct platform_device *pdev)
 	irq_chip->name = name;
 	irq_chip->irq_mask = disable_fn;
 	irq_chip->irq_unmask = enable_fn;
-	irq_chip->irq_enable = enable_fn;
-	irq_chip->irq_disable = disable_fn;
 	irq_chip->irq_set_type = intc_irqpin_irq_set_type;
-	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
 
 	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
 					      p->number_of_irqs,
-- 
1.9.1

