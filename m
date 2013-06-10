Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3FJAvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:51:24 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61419 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3FJAti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:49:38 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC 04/10] irqdomain: merge linear and tree reverse mappings.
Date: Mon, 10 Jun 2013 01:49:16 +0100
Message-Id: <1370825362-11145-5-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Keeping them separate makes irq_domain more complex and adds a lot of
code (as proven by the diffstat).  Merging them simplifies the whole
scheme.  This change makes it so both the tree and linear methods can be
used by the same irq_domain instance.  If the hwirq is less than the
->linear_size, then the linear map is used to reverse map the hwirq.
Otherwise the radix tree is used.  The test for which map to use is no
more expensive that the existing code, so the performance of fast path
is preserved.

It also means that complex interrupt controllers can use both the
linear map and a tree in the same domain.  This may be useful for an
interrupt controller with a base set of core irqs and a large number
of GPIOs which might be used as irqs.  The linear map could cover the
core irqs, and the tree used for thas irqs.  The linear map could
cover the core irqs, and the tree used for the gpios.

v2: Drop reorganization of revmap data

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/irqdomain.h |  18 ++++----
 kernel/irq/irqdomain.c    | 107 +++++++++++++---------------------------------
 2 files changed, 39 insertions(+), 86 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index e5e513c..1cbb741 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -75,7 +75,6 @@ struct irq_domain_chip_generic;
  * @link: Element in global irq_domain list.
  * @revmap_type: Method used for reverse mapping hwirq numbers to linux irq. This
  *               will be one of the IRQ_DOMAIN_MAP_* values.
- * @revmap_data: Revmap method specific data.
  * @ops: pointer to irq_domain methods
  * @host_data: private data pointer for use by owner.  Not touched by irq_domain
  *             core code.
@@ -93,10 +92,9 @@ struct irq_domain {
 
 	/* type of reverse mapping_technique */
 	unsigned int revmap_type;
-	union {
+	struct {
 		struct {
 			unsigned int size;
-			unsigned int *revmap;
 		} linear;
 		struct {
 			unsigned int max_irq;
@@ -111,11 +109,13 @@ struct irq_domain {
 	struct device_node *of_node;
 	/* Optional pointer to generic interrupt chips */
 	struct irq_domain_chip_generic *gc;
+
+	/* Linear reverse map */
+	unsigned int linear_revmap[];
 };
 
 #define IRQ_DOMAIN_MAP_NOMAP 1 /* no fast reverse mapping */
 #define IRQ_DOMAIN_MAP_LINEAR 2 /* linear map of interrupts */
-#define IRQ_DOMAIN_MAP_TREE 3 /* radix tree */
 
 #ifdef CONFIG_IRQ_DOMAIN
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
@@ -137,10 +137,6 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
-struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
-					 const struct irq_domain_ops *ops,
-					 void *host_data);
-
 extern struct irq_domain *irq_find_host(struct device_node *node);
 extern void irq_set_default_host(struct irq_domain *host);
 
@@ -152,6 +148,12 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
 				     host_data);
 }
+static inline struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
+					 const struct irq_domain_ops *ops,
+					 void *host_data)
+{
+	return irq_domain_add_linear(of_node, 0, ops, host_data);
+}
 
 extern void irq_domain_remove(struct irq_domain *host);
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b1b5e67..5a1d8ec 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -34,22 +34,24 @@ static struct irq_domain *irq_default_domain;
  * to IRQ domain, or NULL on failure.
  */
 static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
-					   unsigned int revmap_type,
+					   unsigned int revmap_type, int size,
 					   const struct irq_domain_ops *ops,
 					   void *host_data)
 {
 	struct irq_domain *domain;
 
-	domain = kzalloc_node(sizeof(*domain), GFP_KERNEL,
-			      of_node_to_nid(of_node));
+	domain = kzalloc_node(sizeof(*domain) + (sizeof(unsigned int) * size),
+			      GFP_KERNEL, of_node_to_nid(of_node));
 	if (WARN_ON(!domain))
 		return NULL;
 
 	/* Fill structure */
+	INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
 	domain->revmap_type = revmap_type;
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
+	domain->revmap_data.linear.size = size;
 
 	return domain;
 }
@@ -81,22 +83,12 @@ void irq_domain_remove(struct irq_domain *domain)
 {
 	mutex_lock(&irq_domain_mutex);
 
-	switch (domain->revmap_type) {
-	case IRQ_DOMAIN_MAP_TREE:
-		/*
-		 * radix_tree_delete() takes care of destroying the root
-		 * node when all entries are removed. Shout if there are
-		 * any mappings left.
-		 */
-		WARN_ON(domain->revmap_data.tree.height);
-		break;
-	case IRQ_DOMAIN_MAP_LINEAR:
-		kfree(domain->revmap_data.linear.revmap);
-		domain->revmap_data.linear.size = 0;
-		break;
-	case IRQ_DOMAIN_MAP_NOMAP:
-		break;
-	}
+	/*
+	 * radix_tree_delete() takes care of destroying the root
+	 * node when all entries are removed. Shout if there are
+	 * any mappings left.
+	 */
+	WARN_ON(domain->revmap_data.tree.height);
 
 	list_del(&domain->link);
 
@@ -223,20 +215,11 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 void *host_data)
 {
 	struct irq_domain *domain;
-	unsigned int *revmap;
 
-	revmap = kzalloc_node(sizeof(*revmap) * size, GFP_KERNEL,
-			      of_node_to_nid(of_node));
-	if (WARN_ON(!revmap))
+	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LINEAR, size, ops, host_data);
+	if (!domain)
 		return NULL;
 
-	domain = irq_domain_alloc(of_node, IRQ_DOMAIN_MAP_LINEAR, ops, host_data);
-	if (!domain) {
-		kfree(revmap);
-		return NULL;
-	}
-	domain->revmap_data.linear.size = size;
-	domain->revmap_data.linear.revmap = revmap;
 	irq_domain_add(domain);
 	return domain;
 }
@@ -248,7 +231,7 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 void *host_data)
 {
 	struct irq_domain *domain = irq_domain_alloc(of_node,
-					IRQ_DOMAIN_MAP_NOMAP, ops, host_data);
+					IRQ_DOMAIN_MAP_NOMAP, 0, ops, host_data);
 	if (domain) {
 		domain->revmap_data.nomap.max_irq = max_irq ? max_irq : ~0;
 		irq_domain_add(domain);
@@ -258,28 +241,6 @@ struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 EXPORT_SYMBOL_GPL(irq_domain_add_nomap);
 
 /**
- * irq_domain_add_tree()
- * @of_node: pointer to interrupt controller's device tree node.
- * @ops: map/unmap domain callbacks
- *
- * Note: The radix tree will be allocated later during boot automatically
- * (the reverse mapping will use the slow path until that happens).
- */
-struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
-					 const struct irq_domain_ops *ops,
-					 void *host_data)
-{
-	struct irq_domain *domain = irq_domain_alloc(of_node,
-					IRQ_DOMAIN_MAP_TREE, ops, host_data);
-	if (domain) {
-		INIT_RADIX_TREE(&domain->revmap_data.tree, GFP_KERNEL);
-		irq_domain_add(domain);
-	}
-	return domain;
-}
-EXPORT_SYMBOL_GPL(irq_domain_add_tree);
-
-/**
  * irq_find_host() - Locates a domain for a given device node
  * @node: device-tree node of the interrupt controller
  */
@@ -359,17 +320,13 @@ static void irq_domain_disassociate_many(struct irq_domain *domain,
 		irq_data->domain = NULL;
 		irq_data->hwirq = 0;
 
-		/* Clear reverse map */
-		switch(domain->revmap_type) {
-		case IRQ_DOMAIN_MAP_LINEAR:
-			if (hwirq < domain->revmap_data.linear.size)
-				domain->revmap_data.linear.revmap[hwirq] = 0;
-			break;
-		case IRQ_DOMAIN_MAP_TREE:
+		/* Clear reverse map for this hwirq */
+		if (hwirq < domain->revmap_data.linear.size) {
+			domain->linear_revmap[hwirq] = 0;
+		} else {
 			mutex_lock(&revmap_trees_mutex);
 			radix_tree_delete(&domain->revmap_data.tree, hwirq);
 			mutex_unlock(&revmap_trees_mutex);
-			break;
 		}
 	}
 }
@@ -421,16 +378,12 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 				domain->name = irq_data->chip->name;
 		}
 
-		switch (domain->revmap_type) {
-		case IRQ_DOMAIN_MAP_LINEAR:
-			if (hwirq < domain->revmap_data.linear.size)
-				domain->revmap_data.linear.revmap[hwirq] = virq;
-			break;
-		case IRQ_DOMAIN_MAP_TREE:
+		if (hwirq < domain->revmap_data.linear.size) {
+			domain->linear_revmap[hwirq] = virq;
+		} else {
 			mutex_lock(&revmap_trees_mutex);
 			radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
 			mutex_unlock(&revmap_trees_mutex);
-			break;
 		}
 
 		irq_clear_status_flags(virq, IRQ_NOREQUEST);
@@ -667,13 +620,6 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 	switch (domain->revmap_type) {
 	case IRQ_DOMAIN_MAP_LINEAR:
 		return irq_linear_revmap(domain, hwirq);
-	case IRQ_DOMAIN_MAP_TREE:
-		rcu_read_lock();
-		data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
-		rcu_read_unlock();
-		if (data)
-			return data->irq;
-		break;
 	case IRQ_DOMAIN_MAP_NOMAP:
 		data = irq_get_irq_data(hwirq);
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
@@ -696,13 +642,18 @@ EXPORT_SYMBOL_GPL(irq_find_mapping);
 unsigned int irq_linear_revmap(struct irq_domain *domain,
 			       irq_hw_number_t hwirq)
 {
+	struct irq_data *data;
 	BUG_ON(domain->revmap_type != IRQ_DOMAIN_MAP_LINEAR);
 
 	/* Check revmap bounds; complain if exceeded */
-	if (WARN_ON(hwirq >= domain->revmap_data.linear.size))
-		return 0;
+	if (hwirq >= domain->revmap_data.linear.size) {
+		rcu_read_lock();
+		data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
+		rcu_read_unlock();
+		return data ? data->irq : 0;
+	}
 
-	return domain->revmap_data.linear.revmap[hwirq];
+	return domain->linear_revmap[hwirq];
 }
 EXPORT_SYMBOL_GPL(irq_linear_revmap);
 
-- 
1.8.1.2

