Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaK2Jxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:53:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:36720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaK2Jx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:53:29 -0500
Date: Sat, 29 Nov 2014 10:53:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] irq updates for 3.18
Message-ID: <alpine.DEB.2.11.1411291050450.3961@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Three fixlets from the ARM SoC camp:
 - Correct irqdomain initialization for atmel-aic
 - Correct error handling for device tree parsing in bcm controllers

Thanks,

	tglx

------------------>
Boris Brezillon (1):
      irqchip: atmel-aic: Fix irqdomain initialization

Dmitry Torokhov (2):
      irqchip: bcm7120-l2: Fix error handling of irq_of_parse_and_map
      irqchip: brcmstb-l2: Fix error handling of irq_of_parse_and_map


 drivers/irqchip/irq-atmel-aic-common.c | 6 +++---
 drivers/irqchip/irq-bcm7120-l2.c       | 4 ++--
 drivers/irqchip/irq-brcmstb-l2.c       | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 6ae3cdee0681..cc4f9d80122e 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -217,8 +217,9 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 	}
 
 	ret = irq_alloc_domain_generic_chips(domain, 32, 1, name,
-					     handle_level_irq, 0, 0,
-					     IRQCHIP_SKIP_SET_WAKE);
+					     handle_fasteoi_irq,
+					     IRQ_NOREQUEST | IRQ_NOPROBE |
+					     IRQ_NOAUTOEN, 0, 0);
 	if (ret)
 		goto err_domain_remove;
 
@@ -230,7 +231,6 @@ struct irq_domain *__init aic_common_of_init(struct device_node *node,
 		gc->unused = 0;
 		gc->wake_enabled = ~0;
 		gc->chip_types[0].type = IRQ_TYPE_SENSE_MASK;
-		gc->chip_types[0].handler = handle_fasteoi_irq;
 		gc->chip_types[0].chip.irq_eoi = irq_gc_eoi;
 		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
 		gc->chip_types[0].chip.irq_shutdown = aic_common_shutdown;
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index b9f4fb808e49..5fb38a2ac226 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -101,9 +101,9 @@ static int bcm7120_l2_intc_init_one(struct device_node *dn,
 	int parent_irq;
 
 	parent_irq = irq_of_parse_and_map(dn, irq);
-	if (parent_irq < 0) {
+	if (!parent_irq) {
 		pr_err("failed to map interrupt %d\n", irq);
-		return parent_irq;
+		return -EINVAL;
 	}
 
 	data->irq_map_mask |= be32_to_cpup(map_mask + irq);
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index c15c840987d2..14691a4cb84c 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -135,9 +135,9 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	__raw_writel(0xffffffff, data->base + CPU_CLEAR);
 
 	data->parent_irq = irq_of_parse_and_map(np, 0);
-	if (data->parent_irq < 0) {
+	if (!data->parent_irq) {
 		pr_err("failed to find parent interrupt\n");
-		ret = data->parent_irq;
+		ret = -EINVAL;
 		goto out_unmap;
 	}
 
