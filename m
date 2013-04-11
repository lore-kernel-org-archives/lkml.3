Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937723Ab3DKAHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937015Ab3DKAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 28/30] irqchip: exynos: pass irq_base from platform
Date: Thu, 11 Apr 2013 02:05:10 +0200
Message-Id: <1365638712-1028578-29-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VTn/f+lgHrr0LvTDJsIOZQ4Y1ExMo8pDwnUq/NM64Ir
 HTqzM9Q36DnIm5AvNVO1rNaFHkq0m/37kGVoblhe1svidUIqfD
 ezbqtLbYoroLFZ8PQqXwKs7tjfrc0snJ7miV9A1KfEyatnBssY
 sCDnZK8pE68iGXhNdAgu4DbfAYNaZnW5LXEBK9sq/LzXgbg6Qj
 6ZF45GoyXHCfJTW6XM7/hNB7aGBokFF8DEvddWs1rVf2FjjH/1
 MEbXIWgg36iXMVSXnzv2kDjKARtz8TwnBa+Vy6qRAJEqoumBGD
 uIImsv4MVsni0ORyBqgM0O4Rwa9s7eIpylnKKlZu1aDFj4kM+N
 LeILZx0iv0InjTfG1MP0/I6B9YApnKBHYkAYLL2J0kDyu0W1mo
 MC7F5Lnwyw+QQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform code knows the IRQ base, while the irqchip driver
should really not. This is a littly hacky because we still
hardwire the IRQ base to 160 for the combiner in the DT case,
when we should really use -1. Removing that line will cause
a linear IRQ domain to be use, as we should.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-exynos/common.c     |  3 ++-
 arch/arm/mach-exynos/common.h     |  2 +-
 drivers/irqchip/exynos-combiner.c | 23 +++++++++++++----------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index b0e0b41..0634f99 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -479,7 +479,8 @@ void __init exynos4_init_irq(void)
 #endif
 
 	if (!of_have_populated_dt())
-		combiner_init(S5P_VA_COMBINER_BASE, NULL, max_combiner_nr());
+		combiner_init(S5P_VA_COMBINER_BASE, NULL,
+			      max_combiner_nr(), COMBINER_IRQ(0, 0));
 
 	/*
 	 * The parameters of s5p_init_irq() are for VIC init.
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 49bebd1..60dd35c 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -72,7 +72,7 @@ void exynos4212_register_clocks(void);
 
 struct device_node;
 void combiner_init(void __iomem *combiner_base, struct device_node *np,
-			unsigned int max_nr);
+			unsigned int max_nr, int irq_base);
 
 extern struct smp_operations exynos_smp_ops;
 
diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index 31a4e96..7e876b5 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -207,27 +207,22 @@ static unsigned int combiner_lookup_irq(int group)
 
 void __init combiner_init(void __iomem *combiner_base,
 			  struct device_node *np,
-			  unsigned int max_nr)
+			  unsigned int max_nr,
+			  int irq_base)
 {
-	int i, irq, irq_base;
+	int i, irq;
 	unsigned int nr_irq;
 	struct combiner_chip_data *combiner_data;
 
 	nr_irq = max_nr * IRQ_IN_COMBINER;
 
-	irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
-	if (IS_ERR_VALUE(irq_base)) {
-		irq_base = COMBINER_IRQ(0, 0);
-		pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
-	}
-
 	combiner_data = kcalloc(max_nr, sizeof (*combiner_data), GFP_KERNEL);
 	if (!combiner_data) {
 		pr_warning("%s: could not allocate combiner data\n", __func__);
 		return;
 	}
 
-	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
+	combiner_irq_domain = irq_domain_add_simple(np, nr_irq, irq_base,
 				&combiner_irq_domain_ops, combiner_data);
 	if (WARN_ON(!combiner_irq_domain)) {
 		pr_warning("%s: irq domain init failed\n", __func__);
@@ -254,6 +249,7 @@ static int __init combiner_of_init(struct device_node *np,
 {
 	void __iomem *combiner_base;
 	unsigned int max_nr;
+	int irq_base = -1;
 
 	combiner_base = of_iomap(np, 0);
 	if (!combiner_base) {
@@ -267,7 +263,14 @@ static int __init combiner_of_init(struct device_node *np,
 			__func__, max_nr);
 	}
 
-	combiner_init(combiner_base, np, max_nr);
+	/* 
+	 * FIXME: This is a hardwired COMBINER_IRQ(0,0). Once all devices
+	 * get their IRQ from DT, remove this in order to get dynamic
+	 * allocation.
+	 */
+	irq_base = 160;
+
+	combiner_init(combiner_base, np, max_nr, irq_base);
 
 	return 0;
 }
-- 
1.8.1.2

