Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3AOHjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:39:45 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35144 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3AOHjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:39:11 -0500
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, tglx@linutronix.de,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH 2/3] irq: Add hw continuous IRQs map to virtual continuous IRQs support
Date: Tue, 15 Jan 2013 15:38:55 +0800
Message-Id: <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011507-3568-0000-0000-00000307D109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a function irq_create_mapping_many() which can associate
multiple MSIs to a continous irq mapping.

This is needed to enable multiple MSI support for pSeries.

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 include/linux/irq.h       |    2 +
 include/linux/irqdomain.h |    3 ++
 kernel/irq/irqdomain.c    |   61 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 60ef45b..e00a7ec 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -592,6 +592,8 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 #define irq_alloc_desc_from(from, node)		\
 	irq_alloc_descs(-1, from, 1, node)
 
+#define irq_alloc_desc_n(nevc, node)		\
+	irq_alloc_descs(-1, 0, nevc, node)
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 0d5b17b..831dded 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -168,6 +168,9 @@ extern int irq_create_strict_mappings(struct irq_domain *domain,
 				      unsigned int irq_base,
 				      irq_hw_number_t hwirq_base, int count);
 
+extern int irq_create_mapping_many(struct irq_domain *domain,
+					irq_hw_number_t hwirq_base, int count);
+
 static inline int irq_create_identity_mapping(struct irq_domain *host,
 					      irq_hw_number_t hwirq)
 {
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 96f3a1d..38648e6 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -636,6 +636,67 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 }
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
 
+/**
+ * irq_create_mapping_many - Map a range of hw IRQs to a range of virtual IRQs
+ * @domain: domain owning the interrupt range
+ * @hwirq_base: beginning of continuous hardware IRQ range
+ * @count: Number of interrupts to map
+ *
+ * This routine is used for allocating and mapping a range of hardware
+ * irqs to virtual IRQs where the virtual irq numbers are not at pre-defined
+ * locations.
+ *
+ * Greater than 0 is returned upon success, while any failure to establish a
+ * static mapping is treated as an error.
+ */
+int irq_create_mapping_many(struct irq_domain *domain,
+		irq_hw_number_t hwirq_base, int count)
+{
+	int ret, irq_base;
+	int virq, i;
+
+	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq_base);
+
+	/* Look for default domain if nececssary */
+	if (!domain)
+		domain = irq_default_domain;
+	if (!domain) {
+		pr_warn("irq_create_mapping called for NULL domain, hwirq=%lx\n"
+			, hwirq_base);
+		WARN_ON(1);
+		return 0;
+	}
+	pr_debug("-> using domain @%p\n", domain);
+
+	/* For IRQ_DOMAIN_MAP_LEGACY, get the first virtual interrupt number */
+	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
+		return irq_domain_legacy_revmap(domain, hwirq_base);
+
+	/* Check if mapping already exists */
+	for (i = 0; i < count; i++) {
+		virq = irq_find_mapping(domain, hwirq_base+i);
+		if (virq) {
+			pr_debug("existing mapping on virq %d,"
+					" now dispose it first\n", virq);
+			irq_dispose_mapping(virq);
+		}
+	}
+
+	/* Allocate the continuous virtual interrupt numbers */
+	irq_base = irq_alloc_desc_n(count, of_node_to_nid(domain->of_node));
+	if (unlikely(irq_base < 0))
+		return  irq_base;
+
+	ret = irq_domain_associate_many(domain, irq_base, hwirq_base, count);
+	if (unlikely(ret < 0)) {
+		irq_free_descs(irq_base, count);
+		return ret;
+	}
+
+	return irq_base;
+}
+EXPORT_SYMBOL_GPL(irq_create_mapping_many);
+
 unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
-- 
1.7.7.6

