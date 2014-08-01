Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaHAIGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:06:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:50895 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaHAIF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,778,1400050800"; 
   d="scan'208";a="570362315"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Patch] irqdomain: Introduce new interfaces to support hierarchy irqdomains
Date: Fri,  1 Aug 2014 16:08:13 +0800
Message-Id: <1406880493-18859-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
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

The new V2 interfaces include six functions:
irq_domain_{alloc|free}_irqs():
	Allocate IRQ from domain or free IRQ into domain. It's mainly
used to allocate and free resources associated with interrupt descriptor.
irq_domain_{associate|disassociate}_irqs:
	Associate or disassociate IRQ descriptor with hardware interrupt
resource(pin). It's mainly used to program interrupt controller.
irq_domain_{create|destroy}_irqs():
	Call above four interfaces to create or destroy IRQs.

There are several design points about the new interfaces.

First, architecture needs to define struct irq_map_info, which will be
used to pass architecture specific information to controller specific
callbacks.

Second, all new interfaces have parameter 'size' to support multiple
continous IRQs, which is needed by MSI when interrupt remapping is
enabled on x86.

Third, a special value IRQDOMAIN_AUTO_ASSIGN_HWIRQ is defined out of
irq_hw_number_t, which indicates that irqdomain callbacks should
automatically hardware interrupt number for clients. This will be used
to support CPU vector allocation and interrupt remapping controller
on x86 platforms.

Fourth, the flag IRQDOMAIN_FLAG_HIERARCHY is used to indicate weather
irqdomain operations are hierarchy request. The irqdomain core uses
domain and hwirq fields in struct irq_data to save domain and hardware
interrupt number, but this causes trouble when enabling hierarchy
irqdomain. We solve this limitation by:
1) Still use domain and hwirq fields in struct irq_data to save
   infomation about the out-most irqdomain.
2) For hierarchy irqdomains, the parent field in struct irq_domain is
   used to save point to parent irqdomain.
3) For hierarchy irqdomains, it must implement a private method to save
   hardware interrupt number (hwirq).

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi all,	
	We are trying to extend current irqdomain interfaces to support
hierarchy irqdomains. Please help to comment on the new interface design.
We will switch x86 irq management subsystem to use hierarchy irqdomains
once we reach agreement on the new interfaces.
Regards!
Gerry
---
 include/linux/irqdomain.h |   49 ++++++++-
 kernel/irq/irqdomain.c    |  252 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 262 insertions(+), 39 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index b0f9d16e48f6..8c3ab6b62049 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -38,9 +38,16 @@
 struct device_node;
 struct irq_domain;
 struct of_device_id;
+struct irq_map_info;
 
 /* Number of irqs reserved for a legacy isa controller */
-#define NUM_ISA_INTERRUPTS	16
+#define NUM_ISA_INTERRUPTS		16
+
+/* Auto-assign hardware pin number */
+#define IRQDOMAIN_AUTO_ASSIGN_HWIRQ	((irq_hw_number_t)-1)
+
+/* Associate/disassociate IRQ for hierarchy IRQ domain */
+#define IRQDOMAIN_FLAG_HIERARCHY	0x1
 
 /**
  * struct irq_domain_ops - Methods for irq_domain objects
@@ -64,6 +71,14 @@ struct irq_domain_ops {
 	int (*xlate)(struct irq_domain *d, struct device_node *node,
 		     const u32 *intspec, unsigned int intsize,
 		     unsigned long *out_hwirq, unsigned int *out_type);
+
+	/* extended V2 interfaces to support hierarchy irqdomains */
+	int (*alloc)(struct irq_domain *d, irq_hw_number_t *hw,
+		     unsigned int size, struct irq_map_info *info);
+	void (*free)(struct irq_domain *d, unsigned int virq,
+		     irq_hw_number_t hw, unsigned int size);
+	int (*map2)(struct irq_domain *d, unsigned int virq,
+		    irq_hw_number_t hw, struct irq_map_info *info);
 };
 
 extern struct irq_domain_ops irq_generic_chip_ops;
@@ -99,6 +114,7 @@ struct irq_domain {
 	void *host_data;
 
 	/* Optional data */
+	struct irq_domain *parent;
 	struct device_node *of_node;
 	struct irq_domain_chip_generic *gc;
 
@@ -115,6 +131,7 @@ struct irq_domain *__irq_domain_add(struct device_node *of_node, int size,
 				    irq_hw_number_t hwirq_max, int direct_max,
 				    const struct irq_domain_ops *ops,
 				    void *host_data);
+
 struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
 					 unsigned int size,
 					 unsigned int first_irq,
@@ -143,6 +160,7 @@ static inline struct irq_domain *irq_domain_add_linear(struct device_node *of_no
 {
 	return __irq_domain_add(of_node, size, size, 0, ops, host_data);
 }
+
 static inline struct irq_domain *irq_domain_add_nomap(struct device_node *of_node,
 					 unsigned int max_irq,
 					 const struct irq_domain_ops *ops,
@@ -150,6 +168,7 @@ static inline struct irq_domain *irq_domain_add_nomap(struct device_node *of_nod
 {
 	return __irq_domain_add(of_node, 0, max_irq, max_irq, ops, host_data);
 }
+
 static inline struct irq_domain *irq_domain_add_legacy_isa(
 				struct device_node *of_node,
 				const struct irq_domain_ops *ops,
@@ -158,6 +177,7 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
 				     host_data);
 }
+
 static inline struct irq_domain *irq_domain_add_tree(struct device_node *of_node,
 					 const struct irq_domain_ops *ops,
 					 void *host_data)
@@ -177,6 +197,7 @@ extern void irq_domain_disassociate(struct irq_domain *domain,
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
+
 extern void irq_dispose_mapping(unsigned int virq);
 
 /**
@@ -194,6 +215,7 @@ static inline unsigned int irq_linear_revmap(struct irq_domain *domain,
 {
 	return hwirq < domain->revmap_size ? domain->linear_revmap[hwirq] : 0;
 }
+
 extern unsigned int irq_find_mapping(struct irq_domain *host,
 				     irq_hw_number_t hwirq);
 extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
@@ -220,6 +242,31 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
 			const u32 *intspec, unsigned int intsize,
 			irq_hw_number_t *out_hwirq, unsigned int *out_type);
 
+/* V2 interfaces to support hierarchy IRQ domains. */
+extern int irq_domain_alloc_descs(struct irq_domain *domain, int virq,
+				  irq_hw_number_t hwirq, unsigned int size,
+				  int node);
+extern void irq_domain_free_descs(struct irq_domain *domain, unsigned int virq,
+				  unsigned int size);
+extern int irq_domain_alloc_irqs(struct irq_domain *domain,
+				 irq_hw_number_t *hwirq, unsigned int size,
+				 struct irq_map_info *info);
+extern void irq_domain_free_irqs(struct irq_domain *domain, unsigned int virq,
+				 irq_hw_number_t hwirq, unsigned int size);
+extern int irq_domain_associate_irqs(struct irq_domain *domain,
+				     unsigned int irq, irq_hw_number_t hwirq,
+				     unsigned int size, u32 flags,
+				     struct irq_map_info *info);
+extern void irq_domain_disassociate_irqs(struct irq_domain *domain,
+					 unsigned int irq,
+					 irq_hw_number_t hwirq,
+					 unsigned int size, u32 flags);
+extern int irq_domain_create_irqs(struct irq_domain *domain,
+				  irq_hw_number_t *hwirq, unsigned int size,
+				  struct irq_map_info *info);
+extern void irq_domain_destroy_irqs(struct irq_domain *domain,
+				    unsigned int virq, irq_hw_number_t hwirq,
+				    unsigned int size);
 #else /* CONFIG_IRQ_DOMAIN */
 static inline void irq_dispose_mapping(unsigned int virq) { }
 #endif /* !CONFIG_IRQ_DOMAIN */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6534ff6ce02e..e1f4e0685fdd 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -174,10 +174,8 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 
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
@@ -231,31 +229,45 @@ void irq_set_default_host(struct irq_domain *domain)
 }
 EXPORT_SYMBOL_GPL(irq_set_default_host);
 
-void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
+static void __irq_domain_disassociate(struct irq_domain *domain,
+				      unsigned int irq, irq_hw_number_t hwirq,
+				      u32 flags)
 {
 	struct irq_data *irq_data = irq_get_irq_data(irq);
-	irq_hw_number_t hwirq;
 
-	if (WARN(!irq_data || irq_data->domain != domain,
-		 "virq%i doesn't exist; cannot disassociate\n", irq))
-		return;
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain,
+			 "domain for virq%i is NULL; cannot disassociate\n",
+			 irq))
+			return;
+	}
 
-	hwirq = irq_data->hwirq;
-	irq_set_status_flags(irq, IRQ_NOREQUEST);
+	if (!(flags & IRQDOMAIN_FLAG_HIERARCHY)) {
+		if (WARN(!irq_data || irq_data->domain != domain,
+			 "virq%i doesn't exist; cannot disassociate\n", irq))
+			return;
 
-	/* remove chip and handler */
-	irq_set_chip_and_handler(irq, NULL, NULL);
+		if (hwirq == IRQDOMAIN_AUTO_ASSIGN_HWIRQ)
+			hwirq = irq_data->hwirq;
+		irq_set_status_flags(irq, IRQ_NOREQUEST);
 
-	/* Make sure it's completed */
-	synchronize_irq(irq);
+		/* remove chip and handler */
+		irq_set_chip_and_handler(irq, NULL, NULL);
+
+		/* Make sure it's completed */
+		synchronize_irq(irq);
+	}
 
 	/* Tell the PIC about it */
 	if (domain->ops->unmap)
 		domain->ops->unmap(domain, irq);
 	smp_mb();
 
-	irq_data->domain = NULL;
-	irq_data->hwirq = 0;
+	if (!(flags & IRQDOMAIN_FLAG_HIERARCHY)) {
+		irq_data->domain = NULL;
+		irq_data->hwirq = 0;
+	}
 
 	/* Clear reverse map for this hwirq */
 	if (hwirq < domain->revmap_size) {
@@ -267,38 +279,66 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 	}
 }
 
-int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
-			 irq_hw_number_t hwirq)
+void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
+{
+	__irq_domain_disassociate(domain, irq, IRQDOMAIN_AUTO_ASSIGN_HWIRQ, 0);
+}
+
+static int __irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+				  irq_hw_number_t hwirq, u32 flags,
+				  struct irq_map_info *info)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	int ret;
 
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain,
+			 "domain for virq%i is NULL; cannot associate\n", virq))
+			return -EINVAL;
+	}
+
 	if (WARN(hwirq >= domain->hwirq_max,
 		 "error: hwirq 0x%x is too large for %s\n", (int)hwirq, domain->name))
 		return -EINVAL;
 	if (WARN(!irq_data, "error: virq%i is not allocated", virq))
 		return -EINVAL;
-	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
+	if (!(flags & IRQDOMAIN_FLAG_HIERARCHY) &&
+	    WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
-	irq_data->hwirq = hwirq;
-	irq_data->domain = domain;
-	if (domain->ops->map) {
-		ret = domain->ops->map(domain, virq, hwirq);
+	/*
+	 * When supporting hierarchy irqdomains, hwirq and domain fields in
+	 * struct irq_data are used to store information for the outer-most
+	 * domain. And the parent field in struct irq_domain may be used to
+	 * store parent domain. But architecture needs provide a way to save
+	 * hwirq for inner domains.
+	 */
+	if (!(flags & IRQDOMAIN_FLAG_HIERARCHY)) {
+		mutex_lock(&irq_domain_mutex);
+		irq_data->hwirq = hwirq;
+		irq_data->domain = domain;
+	}
+
+	if (domain->ops->map || domain->ops->map2) {
+		if (domain->ops->map2)
+			ret = domain->ops->map2(domain, virq, hwirq, info);
+		else
+			ret = domain->ops->map(domain, virq, hwirq);
 		if (ret != 0) {
 			/*
 			 * If map() returns -EPERM, this interrupt is protected
 			 * by the firmware or some other service and shall not
 			 * be mapped. Don't bother telling the user about it.
 			 */
-			if (ret != -EPERM) {
+			if (ret != -EPERM)
 				pr_info("%s didn't like hwirq-0x%lx to VIRQ%i mapping (rc=%d)\n",
 				       domain->name, hwirq, virq, ret);
+			if (!(flags & IRQDOMAIN_FLAG_HIERARCHY)) {
+				irq_data->domain = NULL;
+				irq_data->hwirq = 0;
+				mutex_unlock(&irq_domain_mutex);
 			}
-			irq_data->domain = NULL;
-			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -314,12 +354,20 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 		radix_tree_insert(&domain->revmap_tree, hwirq, irq_data);
 		mutex_unlock(&revmap_trees_mutex);
 	}
-	mutex_unlock(&irq_domain_mutex);
+
+	if (!(flags & IRQDOMAIN_FLAG_HIERARCHY))
+		mutex_unlock(&irq_domain_mutex);
 
 	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
 }
+
+int irq_domain_associate(struct irq_domain *domain, unsigned int irq,
+			 irq_hw_number_t hwirq)
+{
+	return __irq_domain_associate(domain, irq, hwirq, 0, NULL);
+}
 EXPORT_SYMBOL_GPL(irq_domain_associate);
 
 void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
@@ -331,11 +379,144 @@ void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 		of_node_full_name(domain->of_node), irq_base, (int)hwirq_base, count);
 
 	for (i = 0; i < count; i++) {
-		irq_domain_associate(domain, irq_base + i, hwirq_base + i);
+		__irq_domain_associate(domain, irq_base + i, hwirq_base + i,
+				       0, NULL);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_domain_associate_many);
 
+int irq_domain_associate_irqs(struct irq_domain *domain, unsigned int irq,
+			      irq_hw_number_t hwirq, unsigned int size,
+			      u32 flags, struct irq_map_info *info)
+{
+	int ret;
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		ret = __irq_domain_associate(domain, irq + i, hwirq + i,
+					     flags, info);
+		if (ret) {
+			irq_domain_disassociate_irqs(domain, irq, hwirq,
+						     i, flags);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+void irq_domain_disassociate_irqs(struct irq_domain *domain, unsigned int irq,
+				  irq_hw_number_t hwirq, unsigned int size,
+				  u32 flags)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++)
+		__irq_domain_disassociate(domain, irq + i, hwirq + i, flags);
+}
+
+int irq_domain_alloc_descs(struct irq_domain *domain, int virq,
+			   irq_hw_number_t hwirq, unsigned int size, int node)
+{
+	unsigned int hint;
+
+	/* Allocate a virtual interrupt number */
+	if (virq >= 0) {
+		virq = irq_alloc_descs(virq, virq, size, node);
+	} else {
+		hint = hwirq % nr_irqs;
+		if (hint == 0)
+			hint++;
+		virq = irq_alloc_descs_from(hint, size, node);
+		if (virq <= 0)
+			virq = irq_alloc_descs_from(1, size, node);
+	}
+
+	return virq;
+}
+
+void irq_domain_free_descs(struct irq_domain *domain, unsigned int virq,
+			   unsigned int size)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++)
+		irq_free_desc(virq + i);
+}
+
+int irq_domain_alloc_irqs(struct irq_domain *domain, irq_hw_number_t *hwirq,
+			  unsigned int size, struct irq_map_info *info)
+{
+	int virq;
+
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain, "domain is NULL; cannot allocate irq\n"))
+			return -EINVAL;
+	}
+
+	if (*hwirq != IRQDOMAIN_AUTO_ASSIGN_HWIRQ) {
+		/* Check if mapping already exists */
+		virq = irq_find_mapping(domain, *hwirq);
+		if (virq) {
+			pr_debug("-> existing mapping on virq %d\n", virq);
+			return -EEXIST;
+		}
+	} else if (!domain->ops->alloc) {
+		pr_debug("-> ops->alloc() is NULL\n");
+		return -ENOSYS;
+	}
+
+	if (domain->ops->alloc)
+		virq = domain->ops->alloc(domain, hwirq, size, info);
+	else
+		virq = irq_domain_alloc_descs(domain, -1, *hwirq, size,
+					      of_node_to_nid(domain->of_node));
+
+	return virq;
+}
+
+void irq_domain_free_irqs(struct irq_domain *domain, unsigned int virq,
+			  irq_hw_number_t hwirq, unsigned int size)
+{
+	if (domain == NULL) {
+		domain = irq_default_domain;
+		if (WARN(!domain, "domain is NULL; cannot free irq%d\n",
+			 virq))
+			return;
+	}
+
+	if (domain->ops->free)
+		domain->ops->free(domain, virq, hwirq, size);
+	else
+		irq_domain_free_descs(domain, virq, size);
+}
+
+int irq_domain_create_irqs(struct irq_domain *domain, irq_hw_number_t *hwirq,
+			   unsigned int size, struct irq_map_info *info)
+{
+	int virq, ret;
+
+	virq = irq_domain_alloc_irqs(domain, hwirq, size, info);
+	if (virq >= 0) {
+		ret = irq_domain_associate_irqs(domain, virq, *hwirq, size,
+						0, info);
+		if (ret < 0) {
+			irq_domain_free_irqs(domain, virq, *hwirq, size);
+			virq = -1;
+		}
+	}
+
+	return virq;
+}
+
+void irq_domain_destroy_irqs(struct irq_domain *domain, unsigned int virq,
+			     irq_hw_number_t hwirq, unsigned int size)
+{
+	irq_domain_disassociate_irqs(domain, virq, hwirq, size, 0);
+	irq_domain_free_irqs(domain, virq, hwirq, size);
+}
+
 /**
  * irq_create_direct_mapping() - Allocate an irq for direct mapping
  * @domain: domain to allocate the irq for or NULL for default domain
@@ -388,7 +569,6 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
-	unsigned int hint;
 	int virq;
 
 	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
@@ -410,12 +590,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	/* Allocate a virtual interrupt number */
-	hint = hwirq % nr_irqs;
-	if (hint == 0)
-		hint++;
-	virq = irq_alloc_desc_from(hint, of_node_to_nid(domain->of_node));
-	if (virq <= 0)
-		virq = irq_alloc_desc_from(1, of_node_to_nid(domain->of_node));
+	virq = irq_domain_alloc_descs(domain, -1, hwirq, 1,
+				      of_node_to_nid(domain->of_node));
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
-- 
1.7.10.4

