Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030260AbaGETrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:47:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:41234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbaGETrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:47:39 -0400
Date: Sat, 5 Jul 2014 21:47:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [Git pull] irq updates for 3.16
Message-ID: <alpine.DEB.2.10.1407052143540.22031@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
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

A few minor fixlets in ARM SoC irq drivers and a fix for a memory leak
which I introduced in the last round of cleanups :(

Thanks,

	tglx

------------------>
Florian Fainelli (1):
      irqchip: brcmstb-l2: Level-2 interrupts are edge sensitive

Keith Busch (1):
      genirq: Fix memory leak when calling irq_free_hwirqs()

Thomas Gleixner (1):
      irqchip: spear_shirq: Fix interrupt offset

Thomas Petazzoni (1):
      irqchip: armada-370-xp: Mask all interrupts during initialization.


 drivers/irqchip/irq-armada-370-xp.c | 17 +++++++++++++++--
 drivers/irqchip/irq-brcmstb-l2.c    |  2 +-
 drivers/irqchip/spear-shirq.c       |  2 +-
 kernel/irq/irqdesc.c                |  4 ++--
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index c887e6e..574aba0 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -334,6 +334,15 @@ static void armada_mpic_send_doorbell(const struct cpumask *mask,
 
 static void armada_xp_mpic_smp_cpu_init(void)
 {
+	u32 control;
+	int nr_irqs, i;
+
+	control = readl(main_int_base + ARMADA_370_XP_INT_CONTROL);
+	nr_irqs = (control >> 2) & 0x3ff;
+
+	for (i = 0; i < nr_irqs; i++)
+		writel(i, per_cpu_int_base + ARMADA_370_XP_INT_SET_MASK_OFFS);
+
 	/* Clear pending IPIs */
 	writel(0, per_cpu_int_base + ARMADA_370_XP_IN_DRBEL_CAUSE_OFFS);
 
@@ -474,7 +483,7 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 					     struct device_node *parent)
 {
 	struct resource main_int_res, per_cpu_int_res;
-	int parent_irq;
+	int parent_irq, nr_irqs, i;
 	u32 control;
 
 	BUG_ON(of_address_to_resource(node, 0, &main_int_res));
@@ -496,9 +505,13 @@ static int __init armada_370_xp_mpic_of_init(struct device_node *node,
 	BUG_ON(!per_cpu_int_base);
 
 	control = readl(main_int_base + ARMADA_370_XP_INT_CONTROL);
+	nr_irqs = (control >> 2) & 0x3ff;
+
+	for (i = 0; i < nr_irqs; i++)
+		writel(i, main_int_base + ARMADA_370_XP_INT_CLEAR_ENABLE_OFFS);
 
 	armada_370_xp_mpic_domain =
-		irq_domain_add_linear(node, (control >> 2) & 0x3ff,
+		irq_domain_add_linear(node, nr_irqs,
 				&armada_370_xp_mpic_irq_ops, NULL);
 
 	BUG_ON(!armada_370_xp_mpic_domain);
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 8ee2a36..c15c840 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -150,7 +150,7 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 
 	/* Allocate a single Generic IRQ chip for this node */
 	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-				np->full_name, handle_level_irq, clr, 0, 0);
+				np->full_name, handle_edge_irq, clr, 0, 0);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
index 3fdda3a..6ce6bd3 100644
--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -125,7 +125,7 @@ static struct spear_shirq spear320_shirq_ras2 = {
 };
 
 static struct spear_shirq spear320_shirq_ras3 = {
-	.irq_nr = 3,
+	.irq_nr = 7,
 	.irq_bit_off = 0,
 	.invalid_irq = 1,
 	.regs = {
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 7339e42..1487a12 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -455,9 +455,9 @@ EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);
  */
 void irq_free_hwirqs(unsigned int from, int cnt)
 {
-	int i;
+	int i, j;
 
-	for (i = from; cnt > 0; i++, cnt--) {
+	for (i = from, j = cnt; j > 0; i++, j--) {
 		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
 		arch_teardown_hwirq(i);
 	}
