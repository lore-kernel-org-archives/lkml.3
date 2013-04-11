Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937709Ab3DKAHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937451Ab3DKAHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 26/30] irqchip: exynos: allocate combiner_data dynamically
Date: Thu, 11 Apr 2013 02:05:08 +0200
Message-Id: <1365638712-1028578-27-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TeuCgir7DtoYAh8MAFbNDidwvu9/ldR9v5TVsxR4V9q
 U8/vSGM5nlXREO/E84/vQD9D70rUBBlERGs9KDs7vz/P7CMahK
 nzn5BQ07WyDwkan0XVbHVlqjwVPu2QWyR2z0AX7/eUBbzMnzBU
 hCT74xf85lpO0FUUmIv7Wppw37Zs/2Ek0Lb/3IK604heYbv2m+
 gqo7vbvk+2g8kiz5VMRnZkiBIuAGoEK5xQRKBtn7in3+haegyq
 Le+sZOUsYqXtlcR6JgtuAbDnvnRDWR1B5Zk9Ber79br/adiOSW
 EPslpM5Y4ma4pAgXlkoWpb18gD/Rax74arR8I1MKpLqsdUng+5
 0GbxTisZvixH14Ad3GJGKL4szIu4776wSZjwBTgEpgBHPTCkKn
 B8CoMRFE+MwbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of combiners on a given SoC is a platform specific
constant, and we cannot encode this number on a multiplatform
kernel since the header file defining it is not available.

Allocating the structure dynamically ends up cleaner anyway
since we keep all the data local.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/exynos-combiner.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index e7aef59..ffb10aa 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -12,6 +12,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/of_address.h>
@@ -38,7 +39,6 @@ struct combiner_chip_data {
 };
 
 static struct irq_domain *combiner_irq_domain;
-static struct combiner_chip_data combiner_data[MAX_COMBINER_NR];
 
 static inline void __iomem *combiner_base(struct irq_data *data)
 {
@@ -115,26 +115,26 @@ static struct irq_chip combiner_chip = {
 #endif
 };
 
-static void __init combiner_cascade_irq(unsigned int combiner_nr,
+static void __init combiner_cascade_irq(struct combiner_chip_data *combiner_data,
 					unsigned int irq)
 {
-	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
+	if (irq_set_handler_data(irq, combiner_data) != 0)
 		BUG();
 	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
 }
 
-static void __init combiner_init_one(unsigned int combiner_nr,
+static void __init combiner_init_one(struct combiner_chip_data *combiner_data,
+				     unsigned int combiner_nr,
 				     void __iomem *base, unsigned int irq)
 {
-	combiner_data[combiner_nr].base = base;
-	combiner_data[combiner_nr].irq_offset = irq_find_mapping(
+	combiner_data->base = base;
+	combiner_data->irq_offset = irq_find_mapping(
 		combiner_irq_domain, combiner_nr * IRQ_IN_COMBINER);
-	combiner_data[combiner_nr].irq_mask = 0xff << ((combiner_nr % 4) << 3);
-	combiner_data[combiner_nr].parent_irq = irq;
+	combiner_data->irq_mask = 0xff << ((combiner_nr % 4) << 3);
+	combiner_data->parent_irq = irq;
 
 	/* Disable all interrupts */
-	__raw_writel(combiner_data[combiner_nr].irq_mask,
-		     base + COMBINER_ENABLE_CLEAR);
+	__raw_writel(combiner_data->irq_mask, base + COMBINER_ENABLE_CLEAR);
 }
 
 #ifdef CONFIG_OF
@@ -169,6 +169,8 @@ static int combiner_irq_domain_xlate(struct irq_domain *d,
 static int combiner_irq_domain_map(struct irq_domain *d, unsigned int irq,
 				   irq_hw_number_t hw)
 {
+	struct combiner_chip_data *combiner_data = d->host_data;
+
 	irq_set_chip_and_handler(irq, &combiner_chip, handle_level_irq);
 	irq_set_chip_data(irq, &combiner_data[hw >> 3]);
 	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
@@ -203,6 +205,7 @@ void __init combiner_init(void __iomem *combiner_base,
 {
 	int i, irq, irq_base;
 	unsigned int nr_irq;
+	struct combiner_chip_data *combiner_data;
 
 	nr_irq = max_nr * IRQ_IN_COMBINER;
 
@@ -212,8 +215,14 @@ void __init combiner_init(void __iomem *combiner_base,
 		pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
 	}
 
+	combiner_data = kcalloc(max_nr, sizeof (*combiner_data), GFP_KERNEL);
+	if (!combiner_data) {
+		pr_warning("%s: could not allocate combiner data\n", __func__);
+		return;
+	}
+
 	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
-				&combiner_irq_domain_ops, &combiner_data);
+				&combiner_irq_domain_ops, combiner_data);
 	if (WARN_ON(!combiner_irq_domain)) {
 		pr_warning("%s: irq domain init failed\n", __func__);
 		return;
@@ -228,8 +237,9 @@ void __init combiner_init(void __iomem *combiner_base,
 		if (np)
 			irq = irq_of_parse_and_map(np, i);
 #endif
-		combiner_init_one(i, combiner_base + (i >> 2) * 0x10, irq);
-		combiner_cascade_irq(i, irq);
+		combiner_init_one(&combiner_data[i], i,
+				  combiner_base + (i >> 2) * 0x10, irq);
+		combiner_cascade_irq(&combiner_data[i], irq);
 	}
 }
 
-- 
1.8.1.2

