Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaIKOCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:02:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:12864 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaIKOCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384738284"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 01/21] irqdomain: Introduce new interfaces to support hierarchy irqdomains
Date: Thu, 11 Sep 2014 22:03:28 +0800
Message-Id: <1410444228-3134-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to use hierarchy irqdomain to suppport CPU vector assignment,
interrupt remapping controller, IO-APIC controller, MSI interrupt
and hypertransport interrupt etc on x86 platforms. So extend irqdomain
interfaces to support hierarchy irqdomain.

There are already many clients of current irqdomain interfaces.
To minimize the changes, we choose to introduce new version 2 interfaces
to support hierarchy instead of extending existing irqdomain interfaces.

According to Thomas's suggestion, the most important design decision is
to build hierarchy struct irq_data to support hierarchy irqdomain, so
hierarchy irqdomain related data could be saved in struct irq_data.
With support of hierarchy irq_data, we could also support stacked
irq_chips. This is most useful in case of set_affinity().

The new hierarchy irqdomain introduces following interfaces:
1) irq_domain_alloc_irqs()/irq_domain_free_irqs(): allocate/release IRQ
   and related resources.
2) __irq_domain_alloc_irqs(): a special version to support legacy IRQs.
3) irq_domain_activate_irq()/irq_domain_deactivate_irq(): program
   interrupt controllers to activate/deactivate interrupt.

There are also several help functions to ease irqdomain implemenations:
1) irq_domain_get_irq_data(): get irq_data associated with a specific
   irqdomain.
2) irq_domain_set_hwirq_and_chip(): save irqdomain specific data into
   irq_data.
3) irq_domain_alloc_irqs_parent()/irq_domain_free_irqs_parent(): invoke
   parent irqdomain's alloc/free callbacks.

We also changed irq_startup()/irq_shutdown() to invoke
irq_domain_activate_irq()/irq_domain_deactivate_irq() to program
interrupt controller when start/stop interrupts.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irq.h       |    3 +
 include/linux/irqdomain.h |   60 ++++++++
 kernel/irq/Kconfig        |    3 +
 kernel/irq/chip.c         |    3 +
 kernel/irq/irqdomain.c    |  349 +++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 404 insertions(+), 14 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 62af59242ddc..4b74565690ce 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -151,6 +151,9 @@ struct irq_data {
 	unsigned int		state_use_accessors;
 	struct irq_chip		*chip;
 	struct irq_domain	*domain;
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	struct irq_data		*parent_data;
+#endif
 	void			*handler_data;
 	void			*chip_data;
 	struct msi_desc		*msi_desc;
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b0f9d16e48f6..a9ddc8534c63 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -38,6 +38,7 @@
 struct device_node;
 struct irq_domain;
 struct of_device_id;
+struct irq_chip;
 
 /* Number of irqs reserved for a legacy isa controller */
 #define NUM_ISA_INTERRUPTS	16
@@ -64,6 +65,16 @@ struct irq_domain_ops {
 	int (*xlate)(struct irq_domain *d, struct device_node *node,
 		     const u32 *intspec, unsigned int intsize,
 		     unsigned long *out_hwirq, unsigned int *out_type);
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	/* extended V2 interfaces to support hierarchy irqdomains */
+	int (*alloc)(struct irq_domain *d, unsigned int virq,
+		     unsigned int nr_irqs, void *arg);
+	void (*free)(struct irq_domain *d, unsigned int virq,
+		     unsigned int nr_irqs);
+	int (*activate)(struct irq_domain *d, struct irq_data *irq_data);
+	int (*deactivate)(struct irq_domain *d, struct irq_data *irq_data);
+#endif
 };
 
 extern struct irq_domain_ops irq_generic_chip_ops;
@@ -101,6 +112,9 @@ struct irq_domain {
 	/* Optional data */
 	struct device_node *of_node;
 	struct irq_domain_chip_generic *gc;
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	struct irq_domain *parent;
+#endif
 
 	/* reverse map data. The linear map gets appended to the irq_domain */
 	irq_hw_number_t hwirq_max;
@@ -220,8 +234,54 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 			const u32 *intspec, unsigned int intsize,
 			irq_hw_number_t *out_hwirq, unsigned int *out_type);
 
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+/* V2 interfaces to support hierarchy IRQ domains. */
+extern struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
+						unsigned int virq);
+extern int irq_domain_set_hwirq_and_chip(struct irq_domain *domain,
+					 unsigned int virq,
+					 irq_hw_number_t hwirq,
+					 struct irq_chip *chip,
+					 void *chip_data);
+extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
+extern int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+				   unsigned int nr_irqs, int node, void *arg,
+				   bool realloc);
+extern void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs);
+extern int irq_domain_activate_irq(struct irq_data *irq_data);
+extern int irq_domain_deactivate_irq(struct irq_data *irq_data);
+
+static inline int irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+				unsigned int nr_irqs, int node, void *arg)
+{
+	return __irq_domain_alloc_irqs(domain, irq_base, nr_irqs, node,
+				       arg, false);
+}
+
+static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
+				int irq_base, unsigned int nr_irqs, void *arg)
+{
+	if (domain->parent && domain->parent->ops->alloc)
+		return domain->parent->ops->alloc(domain->parent, irq_base,
+						  nr_irqs, arg);
+	return -ENOSYS;
+}
+
+static inline void irq_domain_free_irqs_parent(struct irq_domain *domain,
+					int irq_base, unsigned int nr_irqs)
+{
+	if (domain->parent && domain->parent->ops->free)
+		domain->parent->ops->free(domain->parent, irq_base, nr_irqs);
+}
+#else	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
+static inline int irq_domain_activate_irq(struct irq_data *data) { return 0; }
+static inline int irq_domain_deactivate_irq(struct irq_data *data) { return 0; }
+#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
+
 #else /* CONFIG_IRQ_DOMAIN */
 static inline void irq_dispose_mapping(unsigned int virq) { }
+static inline int irq_domain_activate_irq(struct irq_data *data) { return 0; }
+static inline int irq_domain_deactivate_irq(struct irq_data *data) { return 0; }
 #endif /* !CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index d269cecdfbf0..dc1f3d08892e 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -55,6 +55,9 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+config IRQ_DOMAIN_HIERARCHY
+	bool
+
 config IRQ_DOMAIN_DEBUG
 	bool "Expose hardware/virtual IRQ mapping via debugfs"
 	depends on IRQ_DOMAIN && DEBUG_FS
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6223fab9a9d2..46bd5e2190c3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/irqdomain.h>
 
 #include <trace/events/irq.h>
 
@@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, bool resend)
 	irq_state_clr_disabled(desc);
 	desc->depth = 0;
 
+	irq_domain_activate_irq(&desc->irq_data);
 	if (desc->irq_data.chip->irq_startup) {
 		ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
 		irq_state_clr_masked(desc);
@@ -199,6 +201,7 @@ void irq_shutdown(struct irq_desc *desc)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	irq_domain_deactivate_irq(&desc->irq_data);
 	irq_state_set_masked(desc);
 }
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6534ff6ce02e..e285f3abc595 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -23,6 +23,9 @@ static DEFINE_MUTEX(irq_domain_mutex);
 static DEFINE_MUTEX(revmap_trees_mutex);
 static struct irq_domain *irq_default_domain;
 
+static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
+				  irq_hw_number_t hwirq, int node);
+
 /**
  * __irq_domain_add() - Allocate a new irq_domain data structure
  * @of_node: optional device-tree node of the interrupt controller
@@ -30,7 +33,7 @@ static struct irq_domain *irq_default_domain;
  * @hwirq_max: Maximum number of interrupts supported by controller
  * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
  *              direct mapping
- * @ops: map/unmap domain callbacks
+ * @ops: domain callbacks
  * @host_data: Controller private data pointer
  *
  * Allocates and initialize and irq_domain structure.
@@ -109,7 +112,7 @@ EXPORT_SYMBOL_GPL(irq_domain_remove);
  * @first_irq: first number of irq block assigned to the domain,
  *	pass zero to assign irqs on-the-fly. If first_irq is non-zero, then
  *	pre-map all of the irqs in the domain to virqs starting at first_irq.
- * @ops: map/unmap domain callbacks
+ * @ops: domain callbacks
  * @host_data: Controller private data pointer
  *
  * Allocates an irq_domain, and optionally if first_irq is positive then also
@@ -174,10 +177,8 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 
 	domain = __irq_domain_add(of_node, first_hwirq + size,
 				  first_hwirq + size, 0, ops, host_data);
-	if (!domain)
-		return NULL;
-
-	irq_domain_associate_many(domain, first_irq, first_hwirq, size);
+	if (domain)
+		irq_domain_associate_many(domain, first_irq, first_hwirq, size);
 
 	return domain;
 }
@@ -388,7 +389,6 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
-	unsigned int hint;
 	int virq;
 
 	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
@@ -410,12 +410,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	/* Allocate a virtual interrupt number */
-	hint = hwirq % nr_irqs;
-	if (hint == 0)
-		hint++;
-	virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
-	if (virq <= 0)
-		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
+	virq = irq_domain_alloc_descs(-1, 1, hwirq,
+				      of_node_to_nid(domain->of_node));
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
@@ -490,7 +486,13 @@ unsigned int irq_create_of_mapping(struct of_phandle_args *irq_data)
 	}
 
 	/* Create mapping */
-	virq = irq_create_mapping(domain, hwirq);
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+	if (domain->ops->alloc)
+		virq = irq_domain_alloc_irqs(domain, -1, 1, NUMA_NO_NODE,
+					     irq_data);
+	else
+#endif
+		virq = irq_create_mapping(domain, hwirq);
 	if (!virq)
 		return virq;
 
@@ -540,7 +542,11 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 		return 0;
 
 	if (hwirq < domain->revmap_direct_max_irq) {
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+		data = irq_domain_get_irq_data(domain, hwirq);
+#else
 		data = irq_get_irq_data(hwirq);
+#endif
 		if (data && (data->domain == domain) && (data->hwirq == hwirq))
 			return hwirq;
 	}
@@ -709,3 +715,318 @@ const struct irq_domain_ops irq_domain_simple_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
+
+static int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
+				  irq_hw_number_t hwirq, int node)
+{
+	unsigned int hint;
+
+	if (virq >= 0) {
+		virq = irq_alloc_descs(virq, virq, nr_irqs, node);
+	} else {
+		hint = hwirq % nr_irqs;
+		if (hint == 0)
+			hint++;
+		virq = irq_alloc_descs_from(hint, nr_irqs, node);
+		if (virq <= 0 && hint > 1)
+			virq = irq_alloc_descs_from(1, nr_irqs, node);
+	}
+
+	return virq;
+}
+
+#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
+static void irq_domain_free_descs(unsigned int virq, unsigned int nr_irqs)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_irqs; i++)
+		irq_free_desc(virq + i);
+}
+
+static void irq_domain_insert_irq(int virq)
+{
+	struct irq_data *data;
+
+	for (data = irq_get_irq_data(virq); data; data = data->parent_data) {
+		struct irq_domain *domain = data->domain;
+		irq_hw_number_t hwirq = data->hwirq;
+
+		if (hwirq < domain->revmap_size) {
+			domain->linear_revmap[hwirq] = virq;
+		} else {
+			mutex_lock(&revmap_trees_mutex);
+			radix_tree_insert(&domain->revmap_tree, hwirq, data);
+			mutex_unlock(&revmap_trees_mutex);
+		}
+
+		/* If not already assigned, give the domain the chip's name */
+		if (!domain->name && data->chip)
+			domain->name = data->chip->name;
+	}
+
+	irq_clear_status_flags(virq, IRQ_NOREQUEST);
+}
+
+static void irq_domain_remove_irq(int virq)
+{
+	struct irq_data *data;
+
+	irq_set_status_flags(virq, IRQ_NOREQUEST);
+	irq_set_chip_and_handler(virq, NULL, NULL);
+	synchronize_irq(virq);
+	smp_mb();
+
+	for (data = irq_get_irq_data(virq); data; data = data->parent_data) {
+		struct irq_domain *domain = data->domain;
+		irq_hw_number_t hwirq = data->hwirq;
+
+		if (hwirq < domain->revmap_size) {
+			domain->linear_revmap[hwirq] = 0;
+		} else {
+			mutex_lock(&revmap_trees_mutex);
+			radix_tree_delete(&domain->revmap_tree, hwirq);
+			mutex_unlock(&revmap_trees_mutex);
+		}
+	}
+}
+
+static struct irq_data *irq_domain_insert_irq_data(struct irq_domain *domain,
+						   struct irq_data *child)
+{
+	struct irq_data *irq_data;
+
+	irq_data = kzalloc_node(sizeof(*irq_data), GFP_KERNEL, child->node);
+	if (irq_data) {
+		child->parent_data = irq_data;
+		irq_data->irq = child->irq;
+		irq_data->node = child->node;
+		irq_data->domain = domain;
+	}
+
+	return irq_data;
+}
+
+static void irq_domain_free_irq_data(unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+	struct irq_data *irq_data, *tmp;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_get_irq_data(virq + i);
+		tmp = irq_data->parent_data;
+		irq_data->parent_data = NULL;
+		irq_data->domain = NULL;
+
+		while (tmp) {
+			irq_data = tmp;
+			tmp = tmp->parent_data;
+			kfree(irq_data);
+		}
+	}
+}
+
+static int irq_domain_alloc_irq_data(struct irq_domain *domain,
+				     unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+	struct irq_data *irq_data;
+	struct irq_domain *parent;
+
+	/* The outmost irq_data is embedded in struct irq_desc */
+	for (i = 0; i < nr_irqs; i++) {
+		irq_data = irq_get_irq_data(virq + i);
+		irq_data->domain = domain;
+
+		for (parent = domain->parent; parent; parent = parent->parent) {
+			irq_data = irq_domain_insert_irq_data(parent, irq_data);
+			if (!irq_data) {
+				irq_domain_free_irq_data(virq, i + 1);
+				return -ENOMEM;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * irq_domain_get_irq_data - Get irq_data assoicated with @virq and  @domain
+ * @domain: domain to match
+ * @virq: IRQ number to get irq_data
+ */
+struct irq_data *irq_domain_get_irq_data(struct irq_domain *domain,
+					 unsigned int virq)
+{
+	struct irq_data *irq_data;
+
+	for (irq_data = irq_get_irq_data(virq); irq_data;
+	     irq_data = irq_data->parent_data)
+		if (irq_data->domain == domain)
+			return irq_data;
+
+	return NULL;
+}
+
+int irq_domain_set_hwirq_and_chip(struct irq_domain *domain, unsigned int virq,
+				  irq_hw_number_t hwirq, struct irq_chip *chip,
+				  void *chip_data)
+{
+	struct irq_data *irq_data = irq_domain_get_irq_data(domain, virq);
+
+	if (!irq_data)
+		return -ENOENT;
+
+	irq_data->hwirq = hwirq;
+	irq_data->chip = chip;
+	irq_data->chip_data = chip_data;
+
+	return 0;
+}
+
+void irq_domain_reset_irq_data(struct irq_data *irq_data)
+{
+	irq_data->hwirq = 0;
+	irq_data->chip = NULL;
+	irq_data->chip_data = NULL;
+}
+
+/**
+ * irq_domain_alloc_irqs - Allocate IRQs from domain
+ * @domain: domain to allocate from
+ * @irq_base: allocate specified IRQ nubmer if irq_base >= 0
+ * @nr_irqs: number of IRQs to allocate
+ * @node: NUMA node id for memory allocation
+ * @arg: domain specific argument
+ * @realloc: IRQ descriptors have already been allocated if true
+ *
+ * Allocate IRQ numbers and initialized all data structures to support
+ * hiearchy IRQ domains.
+ * Parameter @realloc is mainly to support legacy IRQs.
+ * Returns error code or allocated IRQ number
+ */
+int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
+			    unsigned int nr_irqs, int node, void *arg,
+			    bool realloc)
+{
+	int i, ret, virq;
+
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain, "domain is NULL; cannot allocate IRQ\n"))
+			return -EINVAL;
+	}
+
+	if (!domain->ops->alloc) {
+		pr_debug("domain->ops->alloc() is NULL\n");
+		return -ENOSYS;
+	}
+
+	if (realloc && irq_base >= 0) {
+		virq =  irq_base;
+	} else {
+		virq = irq_domain_alloc_descs(irq_base, nr_irqs, 0, node);
+		if (virq < 0) {
+			pr_debug("cannot allocate IRQ(base %d, count %d)\n",
+				 irq_base, nr_irqs);
+			return virq;
+		}
+	}
+
+	if (irq_domain_alloc_irq_data(domain, virq, nr_irqs)) {
+		pr_debug("cannot allocate memory for IRQ%d\n", virq);
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	mutex_lock(&irq_domain_mutex);
+	ret = domain->ops->alloc(domain, virq, nr_irqs, arg);
+	if (ret < 0) {
+		mutex_unlock(&irq_domain_mutex);
+		goto out_free_irq_data;
+	}
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_insert_irq(virq + i);
+	mutex_unlock(&irq_domain_mutex);
+
+	return virq;
+
+out_free_irq_data:
+	irq_domain_free_irq_data(virq, nr_irqs);
+out_free_desc:
+	irq_domain_free_descs(virq, nr_irqs);
+	return ret;
+}
+
+/**
+ * irq_domain_free_irqs - Free IRQ number and assoicated data structures
+ * @virq: base IRQ number
+ * @nr_irqs: number of IRQs to free
+ */
+void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs)
+{
+	int i;
+	struct irq_data *data = irq_get_irq_data(virq);
+
+	if (WARN(!data || !data->domain || !data->domain->ops->free,
+		 "NULL pointer, cannot free irq\n"))
+		return;
+
+	mutex_lock(&irq_domain_mutex);
+	for (i = 0; i < nr_irqs; i++)
+		irq_domain_remove_irq(virq + i);
+	data->domain->ops->free(data->domain, virq, nr_irqs);
+	mutex_unlock(&irq_domain_mutex);
+
+	irq_domain_free_irq_data(virq, nr_irqs);
+	irq_domain_free_descs(virq, nr_irqs);
+}
+
+/**
+ * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
+ *			     interrupt
+ * @irq_data: out most irq_data associated with interrupt
+ *
+ * It calls domain_ops->activate to program interrupt controllers, so the
+ * interrupt could actually delivered.
+ */
+int irq_domain_activate_irq(struct irq_data *irq_data)
+{
+	int ret = 0;
+
+	if (irq_data && irq_data->domain) {
+		struct irq_domain *domain = irq_data->domain;
+
+		if (irq_data->parent_data)
+			ret = irq_domain_activate_irq(irq_data->parent_data);
+		if (ret == 0 && domain->ops->activate)
+			ret = domain->ops->activate(domain, irq_data);
+	}
+
+	return ret;
+}
+
+/**
+ * irq_domain_deactivate_irq - Call domain_ops->deactivate recursively to
+ *			       deactivate interrupt
+ * @irq_data: out most irq_data associated with interrupt
+ *
+ * It calls domain_ops->deactivate to program interrupt controllers to disable
+ * interrupt delivery.
+ */
+int irq_domain_deactivate_irq(struct irq_data *irq_data)
+{
+	int ret = 0;
+
+	if (irq_data && irq_data->domain) {
+		struct irq_domain *domain = irq_data->domain;
+
+		if (domain->ops->deactivate)
+			ret = domain->ops->deactivate(domain, irq_data);
+		if (ret == 0 && irq_data->parent_data)
+			ret = irq_domain_deactivate_irq(irq_data->parent_data);
+	}
+
+	return ret;
+}
+#endif	/* CONFIG_IRQ_DOMAIN_HIERARCHY */
-- 
1.7.10.4

