Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3FJAtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:49:49 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43450 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3FJAtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:49:43 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>
Subject: [RFC 08/10] irqdomain: Refactor irq_domain_associate_many()
Date: Mon, 10 Jun 2013 01:49:20 +0100
Message-Id: <1370825362-11145-9-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, irq_domain_associate_many() was designed to unwind the
mapped irqs on a failure of any individual association. However, that
proved to be a problem with certain IRQ controllers. Some of them only
support a subset of irqs, and will fail when attempting to map a
reserved IRQ. In those cases we want to map as many IRQs as possible, so
instead it is better for irq_domain_associate_many() to make a
best-effort attempt to map irqs, but not fail if any or all of them
don't succeed. If a caller really cares about how many irqs got
associated, then it should instead go back and check that all of the
irqs is cares about were mapped.

The original design open-coded the individual association code into the
body of irq_domain_associate_many(), but with no longer needing to
unwind associations, the code becomes simpler to split out
irq_domain_associate() to contain the bulk of the logic, and
irq_domain_associate_many() to be a simple loop wrapper.

This patch also adds a new error check to the associate path to make
sure it isn't called for an irq larger than the controller can handle,
and adds locking so that the irq_domain_mutex is held while setting up a
new association.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 include/linux/irqdomain.h |  22 +++---
 kernel/irq/irqdomain.c    | 185 +++++++++++++++++++++++-----------------------
 2 files changed, 101 insertions(+), 106 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index fd4b26f..f9e8e06 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -103,6 +103,7 @@ struct irq_domain {
 	struct irq_domain_chip_generic *gc;
 
 	/* reverse map data. The linear map gets appended to the irq_domain */
+	irq_hw_number_t hwirq_max;
 	unsigned int revmap_direct_max_irq;
 	unsigned int revmap_size;
 	struct radix_tree_root revmap_tree;
@@ -110,8 +111,8 @@ struct irq_domain {
 };
 
 #ifdef CONFIG_IRQ_DOMAIN
-struct irq_domain *__irq_domain_add(struct device_node *of_node,
-				    int size, int direct_max,
+struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
+				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
 				    void *host_data);
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
@@ -140,14 +141,14 @@ static inline struct irq_domain *irq_domain_add_linear(struct device_node *of_no
 					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
-	return __irq_domain_add(of_node, size, 0, ops, host_data);
+	return __irq_domain_add(of_node, size, size, 0, ops, host_data);
 }
 static inline struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
-	return __irq_domain_add(of_node, 0, max_irq, ops, host_data);
+	return __irq_domain_add(of_node, 0, max_irq, max_irq, ops, host_data);
 }
 static inline struct irq_domain *irq_domain_add_legacy_isa(
 				struct device_node *of_node,
@@ -166,14 +167,11 @@ static inline struct irq_domain *irq_domain_add_tree(struct device_node *of_node
 
 extern void irq_domain_remove(struct irq_domain *host);
 
-extern int irq_domain_associate_many(struct irq_domain *domain,
-				     unsigned int irq_base,
-				     irq_hw_number_t hwirq_base, int count);
-static inline int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
-					irq_hw_number_t hwirq)
-{
-	return irq_domain_associate_many(domain, irq, hwirq, 1);
-}
+extern int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
+					irq_hw_number_t hwirq);
+extern void irq_domain_associate_many(struct irq_domain *domain,
+				      unsigned int irq_base,
+				      irq_hw_number_t hwirq_base, int count);
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 280b804..80e9249 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -35,8 +35,8 @@ static struct irq_domain *irq_default_domain;
  * register allocated irq_domain with irq_domain_register().  Returns pointer
  * to IRQ domain, or NULL on failure.
  */
-struct irq_domain *__irq_domain_add(struct device_node *of_node,
-				    int size, int direct_max,
+struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
+				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
 				    void *host_data)
 {
@@ -52,6 +52,7 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node,
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
+	domain->hwirq_max = hwirq_max;
 	domain->revmap_size = size;
 	domain->revmap_direct_max_irq = direct_max;
 
@@ -126,7 +127,7 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 {
 	struct irq_domain *domain;
 
-	domain = __irq_domain_add(of_node, size, 0, ops, host_data);
+	domain = __irq_domain_add(of_node, size, size, 0, ops, host_data);
 	if (!domain)
 		return NULL;
 
@@ -139,7 +140,7 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 				pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
 					first_irq);
 		}
-		WARN_ON(irq_domain_associate_many(domain, first_irq, 0, size));
+		irq_domain_associate_many(domain, first_irq, 0, size);
 	}
 
 	return domain;
@@ -170,11 +171,12 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 {
 	struct irq_domain *domain;
 
-	domain = __irq_domain_add(of_node, first_hwirq + size, 0, ops, host_data);
+	domain = __irq_domain_add(of_node, first_hwirq + size,
+				  first_hwirq + size, 0, ops, host_data);
 	if (!domain)
 		return NULL;
 
-	WARN_ON(irq_domain_associate_many(domain, first_irq, first_hwirq, size));
+	irq_domain_associate_many(domain, first_irq, first_hwirq, size);
 
 	return domain;
 }
@@ -228,109 +230,109 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-static void irq_domain_disassociate_many(struct irq_domain *domain,
-					 unsigned int irq_base, int count)
+static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 {
-	/*
-	 * disassociate in reverse order;
-	 * not strictly necessary, but nice for unwinding
-	 */
-	while (count--) {
-		int irq = irq_base + count;
-		struct irq_data *irq_data = irq_get_irq_data(irq);
-		irq_hw_number_t hwirq;
+	struct irq_data *irq_data = irq_get_irq_data(irq);
+	irq_hw_number_t hwirq;
 
-		if (WARN_ON(!irq_data || irq_data->domain != domain))
-			continue;
+	if (WARN(!irq_data || irq_data->domain != domain,
+		 "virq%i doesn't exist; cannot disassociate\n", irq))
+		return;
 
-		hwirq = irq_data->hwirq;
-		irq_set_status_flags(irq, IRQ_NOREQUEST);
+	hwirq = irq_data->hwirq;
+	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
-		/* remove chip and handler */
-		irq_set_chip_and_handler(irq, NULL, NULL);
+	/* remove chip and handler */
+	irq_set_chip_and_handler(irq, NULL, NULL);
 
-		/* Make sure it's completed */
-		synchronize_irq(irq);
+	/* Make sure it's completed */
+	synchronize_irq(irq);
 
-		/* Tell the PIC about it */
-		if (domain->ops->unmap)
-			domain->ops->unmap(domain, irq);
-		smp_mb();
+	/* Tell the PIC about it */
+	if (domain->ops->unmap)
+		domain->ops->unmap(domain, irq);
+	smp_mb();
 
-		irq_data->domain = NULL;
-		irq_data->hwirq = 0;
+	irq_data->domain = NULL;
+	irq_data->hwirq = 0;
 
-		/* Clear reverse map for this hwirq */
-		if (hwirq < domain->revmap_size) {
-			domain->linear_revmap[hwirq] = 0;
-		} else {
-			mutex_lock(&revmap_trees_mutex);
-			radix_tree_delete(&domain->revmap_tree, hwirq);
-			mutex_unlock(&revmap_trees_mutex);
-		}
+	/* Clear reverse map for this hwirq */
+	if (hwirq < domain->revmap_size) {
+		domain->linear_revmap[hwirq] = 0;
+	} else {
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_delete(&domain->revmap_tree, hwirq);
+		mutex_unlock(&revmap_trees_mutex);
 	}
 }
 
-int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
-			      irq_hw_number_t hwirq_base, int count)
+int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq)
 {
-	unsigned int virq = irq_base;
-	irq_hw_number_t hwirq = hwirq_base;
-	int i, ret;
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+	int ret;
 
-	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
-		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
+	if (WARN(hwirq >= domain->hwirq_max,
+		 "error: hwirq 0x%x is too large for %s\n", (int)hwirq, domain->name))
+		return -EINVAL;
+	if (WARN(!irq_data, "error: virq%i is not allocated", virq))
+		return -EINVAL;
+	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
+		return -EINVAL;
 
-	for (i = 0; i < count; i++) {
-		struct irq_data *irq_data = irq_get_irq_data(virq + i);
-
-		if (WARN(!irq_data, "error: irq_desc not allocated; "
-			 "irq=%i hwirq=0x%x\n", virq + i, (int)hwirq + i))
-			return -EINVAL;
-		if (WARN(irq_data->domain, "error: irq_desc already associated; "
-			 "irq=%i hwirq=0x%x\n", virq + i, (int)hwirq + i))
-			return -EINVAL;
-	};
-
-	for (i = 0; i < count; i++, virq++, hwirq++) {
-		struct irq_data *irq_data = irq_get_irq_data(virq);
-
-		irq_data->hwirq = hwirq;
-		irq_data->domain = domain;
-		if (domain->ops->map) {
-			ret = domain->ops->map(domain, virq, hwirq);
-			if (ret != 0) {
-				/*
-				 * If map() returns -EPERM, this interrupt is protected
-				 * by the firmware or some other service and shall not
-				 * be mapped. Don't bother telling the user about it.
-				 */
-				if (ret != -EPERM) {
-					pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
-					       domain->name, hwirq, virq, ret);
-				}
-				irq_data->domain = NULL;
-				irq_data->hwirq = 0;
-				continue;
+	mutex_lock(&irq_domain_mutex);
+	irq_data->hwirq = hwirq;
+	irq_data->domain = domain;
+	if (domain->ops->map) {
+		ret = domain->ops->map(domain, virq, hwirq);
+		if (ret != 0) {
+			/*
+			 * If map() returns -EPERM, this interrupt is protected
+			 * by the firmware or some other service and shall not
+			 * be mapped. Don't bother telling the user about it.
+			 */
+			if (ret != -EPERM) {
+				pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
+				       domain->name, hwirq, virq, ret);
 			}
-			/* If not already assigned, give the domain the chip's name */
-			if (!domain->name && irq_data->chip)
-				domain->name = irq_data->chip->name;
+			irq_data->domain = NULL;
+			irq_data->hwirq = 0;
+			mutex_unlock(&irq_domain_mutex);
+			return ret;
 		}
 
-		if (hwirq < domain->revmap_size) {
-			domain->linear_revmap[hwirq] = virq;
-		} else {
-			mutex_lock(&revmap_trees_mutex);
-			radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
-			mutex_unlock(&revmap_trees_mutex);
-		}
+		/* If not already assigned, give the domain the chip's name */
+		if (!domain->name && irq_data->chip)
+			domain->name = irq_data->chip->name;
+	}
 
-		irq_clear_status_flags(virq, IRQ_NOREQUEST);
+	if (hwirq < domain->revmap_size) {
+		domain->linear_revmap[hwirq] = virq;
+	} else {
+		mutex_lock(&revmap_trees_mutex);
+		radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
+		mutex_unlock(&revmap_trees_mutex);
 	}
+	mutex_unlock(&irq_domain_mutex);
+
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_domain_associate);
+
+void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
+			       irq_hw_number_t hwirq_base, int count)
+{
+	int i;
+
+	pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
+		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
+
+	for (i = 0; i < count; i++) {
+		irq_domain_associate(domain, irq_base + i, hwirq_base + i);
+	}
+}
 EXPORT_SYMBOL_GPL(irq_domain_associate_many);
 
 /**
@@ -460,12 +462,7 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 	if (unlikely(ret < 0))
 		return ret;
 
-	ret = irq_domain_associate_many(domain, irq_base, hwirq_base, count);
-	if (unlikely(ret < 0)) {
-		irq_free_descs(irq_base, count);
-		return ret;
-	}
-
+	irq_domain_associate_many(domain, irq_base, hwirq_base, count);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
@@ -535,7 +532,7 @@ void irq_dispose_mapping(unsigned int virq)
 	if (WARN_ON(domain == NULL))
 		return;
 
-	irq_domain_disassociate_many(domain, virq, 1);
+	irq_domain_disassociate(domain, virq);
 	irq_free_desc(virq);
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
-- 
1.8.1.2

