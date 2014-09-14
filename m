Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaINOdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:33:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:56308 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaINOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:33:18 -0400
Date: Sun, 14 Sep 2014 16:33:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq fixes for 3.17
Message-ID: <alpine.DEB.2.10.1409141623310.4333@nanos>
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

Another pile of ARM specific irq chip fixlets:
 - Off by one bugs in the crossbar driver
 - Missing annotations
 - A bunch of "make it compile" updates

I pulled the lot today from Jason, but it has been in -next for at
least a week.

Thanks,

	tglx

------------------>
Dan Carpenter (1):
      irqchip: crossbar: Off by one bugs in init

Mark Brown (2):
      irqchip: gic-v3: Only define gic_peek_irq() when building SMP
      irqchip: gic-v3: Tag all low level accessors __maybe_unused

Naveen Krishna Chatradhi (1):
      irqchip: exynos-combiner: Fix compilation error on ARM64

Will Deacon (2):
      irqchip: gic: Make gic_default_routable_irq_domain_ops static
      irqchip: gic-v3: Declare rdist as __percpu pointer to __iomem pointer


 drivers/irqchip/exynos-combiner.c |  1 +
 drivers/irqchip/irq-crossbar.c    |  4 ++--
 drivers/irqchip/irq-gic-v3.c      | 38 +++++++++++++++++++-------------------
 drivers/irqchip/irq-gic.c         |  2 +-
 4 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index f8636a650cf6..5945223b73fa 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
+#include <linux/interrupt.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 85c2985d8bcb..bbbaf5de65d2 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -220,7 +220,7 @@ static int __init crossbar_of_init(struct device_node *node)
 			of_property_read_u32_index(node,
 						   "ti,irqs-reserved",
 						   i, &entry);
-			if (entry > max) {
+			if (entry >= max) {
 				pr_err("Invalid reserved entry\n");
 				ret = -EINVAL;
 				goto err_irq_map;
@@ -238,7 +238,7 @@ static int __init crossbar_of_init(struct device_node *node)
 			of_property_read_u32_index(node,
 						   "ti,irqs-skip",
 						   i, &entry);
-			if (entry > max) {
+			if (entry >= max) {
 				pr_err("Invalid skip entry\n");
 				ret = -EINVAL;
 				goto err_irq_map;
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 57eaa5a0b1e3..a0698b4f0303 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -36,7 +36,7 @@
 struct gic_chip_data {
 	void __iomem		*dist_base;
 	void __iomem		**redist_base;
-	void __percpu __iomem	**rdist;
+	void __iomem * __percpu	*rdist;
 	struct irq_domain	*domain;
 	u64			redist_stride;
 	u32			redist_regions;
@@ -104,7 +104,7 @@ static void gic_redist_wait_for_rwp(void)
 }
 
 /* Low level accessors */
-static u64 gic_read_iar(void)
+static u64 __maybe_unused gic_read_iar(void)
 {
 	u64 irqstat;
 
@@ -112,24 +112,24 @@ static u64 gic_read_iar(void)
 	return irqstat;
 }
 
-static void gic_write_pmr(u64 val)
+static void __maybe_unused gic_write_pmr(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" (val));
 }
 
-static void gic_write_ctlr(u64 val)
+static void __maybe_unused gic_write_ctlr(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" (val));
 	isb();
 }
 
-static void gic_write_grpen1(u64 val)
+static void __maybe_unused gic_write_grpen1(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" (val));
 	isb();
 }
 
-static void gic_write_sgi1r(u64 val)
+static void __maybe_unused gic_write_sgi1r(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
 }
@@ -200,19 +200,6 @@ static void gic_poke_irq(struct irq_data *d, u32 offset)
 	rwp_wait();
 }
 
-static int gic_peek_irq(struct irq_data *d, u32 offset)
-{
-	u32 mask = 1 << (gic_irq(d) % 32);
-	void __iomem *base;
-
-	if (gic_irq_in_rdist(d))
-		base = gic_data_rdist_sgi_base();
-	else
-		base = gic_data.dist_base;
-
-	return !!(readl_relaxed(base + offset + (gic_irq(d) / 32) * 4) & mask);
-}
-
 static void gic_mask_irq(struct irq_data *d)
 {
 	gic_poke_irq(d, GICD_ICENABLER);
@@ -401,6 +388,19 @@ static void gic_cpu_init(void)
 }
 
 #ifdef CONFIG_SMP
+static int gic_peek_irq(struct irq_data *d, u32 offset)
+{
+	u32 mask = 1 << (gic_irq(d) % 32);
+	void __iomem *base;
+
+	if (gic_irq_in_rdist(d))
+		base = gic_data_rdist_sgi_base();
+	else
+		base = gic_data.dist_base;
+
+	return !!(readl_relaxed(base + offset + (gic_irq(d) / 32) * 4) & mask);
+}
+
 static int gic_secondary_init(struct notifier_block *nfb,
 			      unsigned long action, void *hcpu)
 {
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4b959e606fe8..dda6dbc23565 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -867,7 +867,7 @@ static int gic_routable_irq_domain_xlate(struct irq_domain *d,
 	return 0;
 }
 
-const struct irq_domain_ops gic_default_routable_irq_domain_ops = {
+static const struct irq_domain_ops gic_default_routable_irq_domain_ops = {
 	.map = gic_routable_irq_domain_map,
 	.unmap = gic_routable_irq_domain_unmap,
 	.xlate = gic_routable_irq_domain_xlate,
