Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3FMXJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 19:09:24 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44012 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3FMXJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 19:09:22 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] irqdomain: make irq_linear_revmap() a fast path again
Date: Fri, 14 Jun 2013 00:09:17 +0100
Message-Id: <1371164957-22630-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the years, irq_linear_revmap() gained tests and checks to make sure
callers were using it safely, which while important, also make it less
of a fast path. After the irqdomain refactoring done recently, it is now
possible to make irq_linear_revmap() a fast path again. This patch moves
irq_linear_revmap() to the header file and makes it a static inline so
that interrupt controller drivers using a linear mapping can decode the
virq from a hwirq in just a couple of instructions.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---

This builds on the irqdomain rework patch series that I've already
posted. It can be found in the following branch:

git://git.secretlab.ca/git/linux irqdomain/test

 include/linux/irqdomain.h | 19 ++++++++++++++++---
 kernel/irq/irqdomain.c    | 34 ++++++++--------------------------
 2 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index fe7c57d..02f7658 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -176,6 +176,22 @@ extern void irq_domain_associate_many(struct irq_domain *domain,
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
 extern void irq_dispose_mapping(unsigned int virq);
+
+/**
+ * irq_linear_revmap() - Find a linux irq from a hw irq number.
+ * @domain: domain owning this hardware interrupt
+ * @hwirq: hardware irq number in that domain space
+ *
+ * This is a fast path alternative to irq_find_mapping() that can be
+ * called directly by irq controller code to save a handful of
+ * instructions. It is always safe to call, but won't find irqs mapped
+ * using the radix tree.
+ */
+static inline unsigned int irq_linear_revmap(struct irq_domain *domain,
+					     irq_hw_number_t hwirq)
+{
+	return hwirq < domain->revmap_size ? domain->linear_revmap[hwirq] : 0;
+}
 extern unsigned int irq_find_mapping(struct irq_domain *host,
 				     irq_hw_number_t hwirq);
 extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
@@ -189,9 +205,6 @@ static inline int irq_create_identity_mapping(struct irq_domain *host,
 	return irq_create_strict_mappings(host, hwirq, hwirq, 1);
 }
 
-extern unsigned int irq_linear_revmap(struct irq_domain *host,
-				      irq_hw_number_t hwirq);
-
 extern const struct irq_domain_ops irq_domain_simple_ops;
 
 /* stock xlate functions */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index dcd7b6c..13f2654 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -557,35 +557,17 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 			return hwirq;
 	}
 
-	return irq_linear_revmap(domain, hwirq);
+	/* Check if the hwirq is in the linear revmap. */
+	if (hwirq < domain->revmap_size)
+		return domain->linear_revmap[hwirq];
+
+	rcu_read_lock();
+	data = radix_tree_lookup(&domain->revmap_tree, hwirq);
+	rcu_read_unlock();
+	return data ? data->irq : 0;
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
-/**
- * irq_linear_revmap() - Find a linux irq from a hw irq number.
- * @domain: domain owning this hardware interrupt
- * @hwirq: hardware irq number in that domain space
- *
- * This is a fast path that can be called directly by irq controller code to
- * save a handful of instructions.
- */
-unsigned int irq_linear_revmap(struct irq_domain *domain,
-			       irq_hw_number_t hwirq)
-{
-	struct irq_data *data;
-
-	/* Check revmap bounds; complain if exceeded */
-	if (hwirq >= domain->revmap_size) {
-		rcu_read_lock();
-		data = radix_tree_lookup(&domain->revmap_tree, hwirq);
-		rcu_read_unlock();
-		return data ? data->irq : 0;
-	}
-
-	return domain->linear_revmap[hwirq];
-}
-EXPORT_SYMBOL_GPL(irq_linear_revmap);
-
 #ifdef CONFIG_IRQ_DOMAIN_DEBUG
 static int virq_debug_show(struct seq_file *m, void *private)
 {
-- 
1.8.1.2

