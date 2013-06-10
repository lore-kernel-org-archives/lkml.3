Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3FJAtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 20:49:43 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47106 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3FJAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 20:49:41 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>
Subject: [RFC 06/10] irqdomain: Clean up aftermath of irq_domain refactoring
Date: Mon, 10 Jun 2013 01:49:18 +0100
Message-Id: <1370825362-11145-7-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After refactoring the irqdomain code, there are a number of API
functions that are merely empty wrappers around core code. Drop those
wrappers out of the C file and replace them with static inlines in the
header.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 arch/powerpc/platforms/cell/beat_interrupt.c |   2 +-
 arch/powerpc/platforms/powermac/smp.c        |   2 +-
 include/linux/irqdomain.h                    |  31 +++++--
 kernel/irq/irqdomain.c                       | 127 ++++++++-------------------
 4 files changed, 62 insertions(+), 100 deletions(-)

diff --git a/arch/powerpc/platforms/cell/beat_interrupt.c b/arch/powerpc/platforms/cell/beat_interrupt.c
index 8c6dc42..9e5dfbc 100644
--- a/arch/powerpc/platforms/cell/beat_interrupt.c
+++ b/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -239,7 +239,7 @@ void __init beatic_init_IRQ(void)
 	ppc_md.get_irq = beatic_get_irq;
 
 	/* Allocate an irq host */
-	beatic_host = irq_domain_add_nomap(NULL, 0, &beatic_pic_host_ops, NULL);
+	beatic_host = irq_domain_add_nomap(NULL, ~0, &beatic_pic_host_ops, NULL);
 	BUG_ON(beatic_host == NULL);
 	irq_set_default_host(beatic_host);
 }
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index bdb738a..f921067 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -192,7 +192,7 @@ static int psurge_secondary_ipi_init(void)
 {
 	int rc = -ENOMEM;
 
-	psurge_host = irq_domain_add_nomap(NULL, 0, &psurge_host_ops, NULL);
+	psurge_host = irq_domain_add_nomap(NULL, ~0, &psurge_host_ops, NULL);
 
 	if (psurge_host)
 		psurge_secondary_virq = irq_create_direct_mapping(psurge_host);
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 51ef84a..fd4b26f 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -110,6 +110,10 @@ struct irq_domain {
 };
 
 #ifdef CONFIG_IRQ_DOMAIN
+struct irq_domain *__irq_domain_add(struct device_node *of_node,
+				    int size, int direct_max,
+				    const struct irq_domain_ops *ops,
+				    void *host_data);
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 unsigned int size,
 					 unsigned int first_irq,
@@ -121,17 +125,30 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 					 irq_hw_number_t first_hwirq,
 					 const struct irq_domain_ops *ops,
 					 void *host_data);
-struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
+extern struct irq_domain *irq_find_host(struct device_node *node);
+extern void irq_set_default_host(struct irq_domain *host);
+
+/**
+ * irq_domain_add_linear() - Allocate and register a linear revmap irq_domain.
+ * @of_node: pointer to interrupt controller's device tree node.
+ * @size: Number of interrupts in the domain.
+ * @ops: map/unmap domain callbacks
+ * @host_data: Controller private data pointer
+ */
+static inline struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
 					 unsigned int size,
 					 const struct irq_domain_ops *ops,
-					 void *host_data);
-struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
+					 void *host_data)
+{
+	return __irq_domain_add(of_node, size, 0, ops, host_data);
+}
+static inline struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
-					 void *host_data);
-extern struct irq_domain *irq_find_host(struct device_node *node);
-extern void irq_set_default_host(struct irq_domain *host);
-
+					 void *host_data)
+{
+	return __irq_domain_add(of_node, 0, max_irq, ops, host_data);
+}
 static inline struct irq_domain *irq_domain_add_legacy_isa(
 				struct device_node *of_node,
 				const struct irq_domain_ops *ops,
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index c38be78..e0db59e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -23,8 +23,11 @@ static DEFINE_MUTEX(revmap_trees_mutex);
 static struct irq_domain *irq_default_domain;
 
 /**
- * irq_domain_alloc() - Allocate a new irq_domain data structure
+ * __irq_domain_add() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
+ * @size: Size of linear map; 0 for radix mapping only
+ * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
+ *              direct mapping
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  *
@@ -32,10 +35,10 @@ static struct irq_domain *irq_default_domain;
  * register allocated irq_domain with irq_domain_register().  Returns pointer
  * to IRQ domain, or NULL on failure.
  */
-static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
-					   int size,
-					   const struct irq_domain_ops *ops,
-					   void *host_data)
+struct irq_domain *__irq_domain_add(struct device_node *of_node,
+				    int size, int direct_max,
+				    const struct irq_domain_ops *ops,
+				    void *host_data)
 {
 	struct irq_domain *domain;
 
@@ -50,23 +53,16 @@ static struct irq_domain *irq_domain_alloc(struct device_node *of_node,
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);
 	domain->revmap_size = size;
+	domain->revmap_direct_max_irq = direct_max;
 
-	return domain;
-}
-
-static void irq_domain_free(struct irq_domain *domain)
-{
-	of_node_put(domain->of_node);
-	kfree(domain);
-}
-
-static void irq_domain_add(struct irq_domain *domain)
-{
 	mutex_lock(&irq_domain_mutex);
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
+
 	pr_debug("Added domain %s\n", domain->name);
+	return domain;
 }
+EXPORT_SYMBOL_GPL(__irq_domain_add);
 
 /**
  * irq_domain_remove() - Remove an irq domain.
@@ -99,30 +95,28 @@ void irq_domain_remove(struct irq_domain *domain)
 
 	pr_debug("Removed domain %s\n", domain->name);
 
-	irq_domain_free(domain);
+	of_node_put(domain->of_node);
+	kfree(domain);
 }
 EXPORT_SYMBOL_GPL(irq_domain_remove);
 
 /**
- * irq_domain_add_simple() - Allocate and register a simple irq_domain.
+ * irq_domain_add_simple() - Register an irq_domain and optionally map a range of irqs
  * @of_node: pointer to interrupt controller's device tree node.
  * @size: total number of irqs in mapping
  * @first_irq: first number of irq block assigned to the domain,
- *	pass zero to assign irqs on-the-fly. This will result in a
- *	linear IRQ domain so it is important to use irq_create_mapping()
- *	for each used IRQ, especially when SPARSE_IRQ is enabled.
+ *	pass zero to assign irqs on-the-fly. If first_irq is non-zero, then
+ *	pre-map all of the irqs in the domain to virqs starting at first_irq.
  * @ops: map/unmap domain callbacks
  * @host_data: Controller private data pointer
  *
- * Allocates a legacy irq_domain if irq_base is positive or a linear
- * domain otherwise. For the legacy domain, IRQ descriptors will also
- * be allocated.
+ * Allocates an irq_domain, and optionally if first_irq is positive then also
+ * allocate irq_descs and map all of the hwirqs to virqs starting at first_irq.
  *
  * This is intended to implement the expected behaviour for most
- * interrupt controllers which is that a linear mapping should
- * normally be used unless the system requires a legacy mapping in
- * order to support supplying interrupt numbers during non-DT
- * registration of devices.
+ * interrupt controllers. If device tree is used, then first_irq will be 0 and
+ * irqs get mapped dynamically on the fly. However, if the controller requires
+ * static virq assignments (non-DT boot) then it will set that up correctly.
  */
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 unsigned int size,
@@ -130,33 +124,25 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
 					 void *host_data)
 {
-	if (first_irq > 0) {
-		int irq_base;
+	struct irq_domain *domain;
+
+	domain = __irq_domain_add(of_node, size, 0, ops, host_data);
+	if (!domain)
+		return NULL;
 
+	if (first_irq > 0) {
 		if (IS_ENABLED(CONFIG_SPARSE_IRQ)) {
-			/*
-			 * Set the descriptor allocator to search for a
-			 * 1-to-1 mapping, such as irq_alloc_desc_at().
-			 * Use of_node_to_nid() which is defined to
-			 * numa_node_id() on platforms that have no custom
-			 * implementation.
-			 */
-			irq_base = irq_alloc_descs(first_irq, first_irq, size,
-						   of_node_to_nid(of_node));
-			if (irq_base < 0) {
+			/* attempt to allocated irq_descs */
+			int rc = irq_alloc_descs(first_irq, first_irq, size,
+						 of_node_to_nid(of_node));
+			if (rc < 0)
 				pr_info("Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
 					first_irq);
-				irq_base = first_irq;
-			}
-		} else
-			irq_base = first_irq;
-
-		return irq_domain_add_legacy(of_node, size, irq_base, 0,
-					     ops, host_data);
+		}
+		WARN_ON(irq_domain_associate_many(domain, first_irq, 0, size));
 	}
 
-	/* A linear domain is the default */
-	return irq_domain_add_linear(of_node, size, ops, host_data);
+	return domain;
 }
 EXPORT_SYMBOL_GPL(irq_domain_add_simple);
 
@@ -184,11 +170,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 {
 	struct irq_domain *domain;
 
-	pr_debug("Setting up legacy domain virq[%i:%i] ==> hwirq[%i:%i]\n",
-		 first_irq, first_irq + size - 1,
-		 (int)first_hwirq, (int)first_hwirq + size -1);
-
-	domain = irq_domain_add_linear(of_node, first_hwirq + size, ops, host_data);
+	domain = __irq_domain_add(of_node, first_hwirq + size, 0, ops, host_data);
 	if (!domain)
 		return NULL;
 
@@ -199,43 +181,6 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 EXPORT_SYMBOL_GPL(irq_domain_add_legacy);
 
 /**
- * irq_domain_add_linear() - Allocate and register a linear revmap irq_domain.
- * @of_node: pointer to interrupt controller's device tree node.
- * @size: Number of interrupts in the domain.
- * @ops: map/unmap domain callbacks
- * @host_data: Controller private data pointer
- */
-struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
-					 unsigned int size,
-					 const struct irq_domain_ops *ops,
-					 void *host_data)
-{
-	struct irq_domain *domain;
-
-	domain = irq_domain_alloc(of_node, size, ops, host_data);
-	if (!domain)
-		return NULL;
-
-	irq_domain_add(domain);
-	return domain;
-}
-EXPORT_SYMBOL_GPL(irq_domain_add_linear);
-
-struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
-					 unsigned int max_irq,
-					 const struct irq_domain_ops *ops,
-					 void *host_data)
-{
-	struct irq_domain *domain = irq_domain_alloc(of_node, 0, ops, host_data);
-	if (domain) {
-		domain->revmap_direct_max_irq = max_irq ? max_irq : ~0;
-		irq_domain_add(domain);
-	}
-	return domain;
-}
-EXPORT_SYMBOL_GPL(irq_domain_add_nomap);
-
-/**
  * irq_find_host() - Locates a domain for a given device node
  * @node: device-tree node of the interrupt controller
  */
-- 
1.8.1.2

