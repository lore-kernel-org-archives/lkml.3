Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3FNVIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:08:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64437 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3FNVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:08:19 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 05/11] irqdomain: Eliminate revmap type
Date: Fri, 14 Jun 2013 22:08:00 +0100
Message-Id: <1371244086-9189-6-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NOMAP irq_domain type is only used by a handful of interrupt
controllers and it unnecessarily complicates the code by adding special
cases on how to look up mappings and different revmap functions are used
for each type which need to validate the correct type is passed to it
before performing the reverse map. Eliminating the revmap_type and
making a single reverse mapping function simplifies the code. It also
shouldn't be any slower than having separate revmap functions because
the type of the revmap needed to be checked anyway.

The linear and tree revmap types were already merged in a previous
patch. This patch rolls the NOMAP or direct mapping behaviour into the
same domain code making is possible for an irq domain to do any mapping
type; linear, tree or direct; and that the mapping will be transparent
to the interrupt controller driver.

With this change, direct mappings will get stored in the linear or tree
mapping for consistency. Reverse mapping from the hwirq to virq will go
through the normal lookup process. However, any controller using a
direct mapping can take advantage of knowing that hwirq==virq for any
mapped interrupts skip doing a revmap lookup when handling IRQs.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 include/linux/irqdomain.h | 48 +++++++++++++++++------------------------
 kernel/irq/generic-chip.c |  5 +----
 kernel/irq/irqdomain.c    | 55 +++++++++++++++++++----------------------------
 3 files changed, 43 insertions(+), 65 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 1cbb741..51ef84a 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -73,50 +73,42 @@ struct irq_domain_chip_generic;
 /**
  * struct irq_domain - Hardware interrupt number translation object
  * @link: Element in global irq_domain list.
- * @revmap_type: Method used for reverse mapping hwirq numbers to linux irq. This
- *               will be one of the IRQ_DOMAIN_MAP_* values.
+ * @name: Name of interrupt domain
  * @ops: pointer to irq_domain methods
  * @host_data: private data pointer for use by owner.  Not touched by irq_domain
  *             core code.
- * @irq_base: Start of irq_desc range assigned to the irq_domain.  The creator
- *            of the irq_domain is responsible for allocating the array of
- *            irq_desc structures.
- * @nr_irq: Number of irqs managed by the irq domain
- * @hwirq_base: Starting number for hwirqs managed by the irq domain
- * @of_node: (optional) Pointer to device tree nodes associated with the
- *           irq_domain.  Used when decoding device tree interrupt specifiers.
+ *
+ * Optional elements
+ * @of_node: Pointer to device tree nodes associated with the irq_domain. Used
+ *           when decoding device tree interrupt specifiers.
+ * @gc: Pointer to a list of generic chips. There is a helper function for
+ *      setting up one or more generic chips for interrupt controllers
+ *      drivers using the generic chip library which uses this pointer.
+ *
+ * Revmap data, used internally by irq_domain
+ * @revmap_direct_max_irq: The largest hwirq that can be set for controllers that
+ *                         support direct mapping
+ * @revmap_size: Size of the linear map table @linear_revmap[]
+ * @revmap_tree: Radix map tree for hwirqs that don't fit in the linear map
+ * @linear_revmap: Linear table of hwirq->virq reverse mappings
  */
 struct irq_domain {
 	struct list_head link;
 	const char *name;
-
-	/* type of reverse mapping_technique */
-	unsigned int revmap_type;
-	struct {
-		struct {
-			unsigned int size;
-		} linear;
-		struct {
-			unsigned int max_irq;
-		} nomap;
-		struct radix_tree_root tree;
-	} revmap_data;
 	const struct irq_domain_ops *ops;
 	void *host_data;
-	irq_hw_number_t inval_irq;
 
-	/* Optional device node pointer */
+	/* Optional data */
 	struct device_node *of_node;
-	/* Optional pointer to generic interrupt chips */
 	struct irq_domain_chip_generic *gc;
 
-	/* Linear reverse map */
+	/* reverse map data. The linear map gets appended to the irq_domain */
+	unsigned int revmap_direct_max_irq;
+	unsigned int revmap_size;
+	struct radix_tree_root revmap_tree;
 	unsigned int linear_revmap[];
 };
 
-#define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
-#define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
-
 #ifdef CONFIG_IRQ_DOMAIN
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 unsigned int size,
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index ca98cc5..4b01106 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -270,10 +270,7 @@ int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 	if (d->gc)
 		return -EBUSY;
 
-	if (d->revmap_type != IRQ_DOMAIN_MAP_LINEAR)
-		return -EINVAL;
-
-	numchips = d->revmap_data.linear.size / irqs_per_chip;
+	numchips = d->revmap_size / irqs_per_chip;
 	if (!numchips)
 		return -EINVAL;
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5a1d8ec..c38be78 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -25,7 +25,6 @@ static struct irq_domain *irq_default_domain;
 /**
  * irq_domain_alloc() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
- * @revmap_type: type of reverse mapping to use
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  *
@@ -34,7 +33,7 @@ static struct irq_domain *irq_default_domain;
  * to IRQ domain, or NULL on failure.
  */
 static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
-					   unsigned int revmap_type, int size,
+					   int size,
 					   const struct irq_domain_ops *ops,
 					   void *host_data)
 {
@@ -46,12 +45,11 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 		return NULL;
 
 	/* Fill structure */
-	INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
-	domain->revmap_type = revmap_type;
+	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
-	domain->revmap_data.linear.size = size;
+	domain->revmap_size = size;
 
 	return domain;
 }
@@ -67,8 +65,7 @@ static void irq_domain_add(struct irq_domain *domain)
 	mutex_lock(&irq_domain_mutex);
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
-	pr_debug("Allocated domain of type %d @0x%p\n",
-		 domain->revmap_type, domain);
+	pr_debug("Added domain %s\n", domain->name);
 }
 
 /**
@@ -88,7 +85,7 @@ void irq_domain_remove(struct irq_domain *domain)
 	 * node when all entries are removed. Shout if there are
 	 * any mappings left.
 	 */
-	WARN_ON(domain->revmap_data.tree.height);
+	WARN_ON(domain->revmap_tree.height);
 
 	list_del(&domain->link);
 
@@ -100,8 +97,7 @@ void irq_domain_remove(struct irq_domain *domain)
 
 	mutex_unlock(&irq_domain_mutex);
 
-	pr_debug("Removed domain of type %d @0x%p\n",
-		 domain->revmap_type, domain);
+	pr_debug("Removed domain %s\n", domain->name);
 
 	irq_domain_free(domain);
 }
@@ -216,7 +212,7 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 {
 	struct irq_domain *domain;
 
-	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LINEAR, size, ops, host_data);
+	domain = irq_domain_alloc(of_node, size, ops, host_data);
 	if (!domain)
 		return NULL;
 
@@ -230,10 +226,9 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
-	struct irq_domain *domain = irq_domain_alloc(of_node,
-					IRQ_DOMAIN_MAP_NOMAP, 0, ops, host_data);
+	struct irq_domain *domain = irq_domain_alloc(of_node, 0, ops, host_data);
 	if (domain) {
-		domain->revmap_data.nomap.max_irq = max_irq ? max_irq : ~0;
+		domain->revmap_direct_max_irq = max_irq ? max_irq : ~0;
 		irq_domain_add(domain);
 	}
 	return domain;
@@ -321,11 +316,11 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 		irq_data->hwirq = 0;
 
 		/* Clear reverse map for this hwirq */
-		if (hwirq < domain->revmap_data.linear.size) {
+		if (hwirq < domain->revmap_size) {
 			domain->linear_revmap[hwirq] = 0;
 		} else {
 			mutex_lock(&revmap_trees_mutex);
-			radix_tree_delete(&domain->revmap_data.tree, hwirq);
+			radix_tree_delete(&domain->revmap_tree, hwirq);
 			mutex_unlock(&revmap_trees_mutex);
 		}
 	}
@@ -378,11 +373,11 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 				domain->name = irq_data->chip->name;
 		}
 
-		if (hwirq < domain->revmap_data.linear.size) {
+		if (hwirq < domain->revmap_size) {
 			domain->linear_revmap[hwirq] = virq;
 		} else {
 			mutex_lock(&revmap_trees_mutex);
-			radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
+			radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
 			mutex_unlock(&revmap_trees_mutex);
 		}
 
@@ -399,7 +394,9 @@ EXPORT_SYMBOL_GPL(irq_domain_associate_many);
  *
  * This routine is used for irq controllers which can choose the hardware
  * interrupt numbers they generate. In such a case it's simplest to use
- * the linux irq as the hardware interrupt number.
+ * the linux irq as the hardware interrupt number. It still uses the linear
+ * or radix tree to store the mapping, but the irq controller can optimize
+ * the revmap path by using the hwirq directly.
  */
 unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 {
@@ -408,17 +405,14 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 	if (domain == NULL)
 		domain = irq_default_domain;
 
-	if (WARN_ON(!domain || domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP))
-		return 0;
-
 	virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
 	if (!virq) {
 		pr_debug("create_direct virq allocation failed\n");
 		return 0;
 	}
-	if (virq >= domain->revmap_data.nomap.max_irq) {
+	if (virq >= domain->revmap_direct_max_irq) {
 		pr_err("ERROR: no free irqs available below %i maximum\n",
-			domain->revmap_data.nomap.max_irq);
+			domain->revmap_direct_max_irq);
 		irq_free_desc(virq);
 		return 0;
 	}
@@ -617,17 +611,13 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 	if (domain == NULL)
 		return 0;
 
-	switch (domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_LINEAR:
-		return irq_linear_revmap(domain, hwirq);
-	case IRQ_DOMAIN_MAP_NOMAP:
+	if (hwirq < domain->revmap_direct_max_irq) {
 		data = irq_get_irq_data(hwirq);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
 			return hwirq;
-		break;
 	}
 
-	return 0;
+	return irq_linear_revmap(domain, hwirq);
 }
 EXPORT_SYMBOL_GPL(irq_find_mapping);
 
@@ -643,12 +633,11 @@ unsigned int irq_linear_revmap(struct irq_domain *domain,
 			       irq_hw_number_t hwirq)
 {
 	struct irq_data *data;
-	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
 
 	/* Check revmap bounds; complain if exceeded */
-	if (hwirq >= domain->revmap_data.linear.size) {
+	if (hwirq >= domain->revmap_size) {
 		rcu_read_lock();
-		data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
+		data = radix_tree_lookup(&domain->revmap_tree, hwirq);
 		rcu_read_unlock();
 		return data ? data->irq : 0;
 	}
-- 
1.8.1.2

