Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaKQLAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:00:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:1455 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaKQLAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:00:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487988981"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [Patch V3 3/9] irqdomain: Implement a method to automatically call parent domain's alloc/free
Date: Mon, 17 Nov 2014 19:03:16 +0800
Message-Id: <1416222202-28002-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flags to irq_domain.flags to control whether the irqdomain core
should automatically call parent irqdomain's alloc/free callbacks. It
help to reduce hierarchy irqdomains users' code size.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/irqdomain.h |   24 ++++++-----------
 kernel/irq/irqdomain.c    |   66 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 72 insertions(+), 18 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index fbe542967c20..ad92b0b15945 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -130,6 +130,8 @@ struct irq_domain {
 };
 
 #define	IRQ_DOMAIN_FLAG_HIERARCHY	0x1
+/* Framework automatically calls parent domain's alloc()/free() */
+#define	IRQ_DOMAIN_FLAG_AUTO_RECURSIVE	0x2
 #define	IRQ_DOMAIN_FLAG_ARCH1		0x10000
 
 #ifdef CONFIG_IRQ_DOMAIN
@@ -274,22 +276,12 @@ extern void irq_domain_free_irqs_common(struct irq_domain *domain,
 					unsigned int nr_irqs);
 extern void irq_domain_free_irqs_top(struct irq_domain *domain,
 				     unsigned int virq, unsigned int nr_irqs);
-
-static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
-			unsigned int irq_base, unsigned int nr_irqs, void *arg)
-{
-	if (domain->parent && domain->parent->ops->alloc)
-		return domain->parent->ops->alloc(domain->parent, irq_base,
-						  nr_irqs, arg);
-	return -ENOSYS;
-}
-
-static inline void irq_domain_free_irqs_parent(struct irq_domain *domain,
-				unsigned int irq_base, unsigned int nr_irqs)
-{
-	if (domain->parent && domain->parent->ops->free)
-		domain->parent->ops->free(domain->parent, irq_base, nr_irqs);
-}
+extern int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
+					unsigned int irq_base,
+					unsigned int nr_irqs, void *arg);
+extern void irq_domain_free_irqs_parent(struct irq_domain *domain,
+					unsigned int irq_base,
+					unsigned int nr_irqs);
 
 static inline bool irq_domain_is_hierarchy(struct irq_domain *domain)
 {
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 705fb573e509..03fc7d018324 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -925,6 +925,43 @@ void irq_domain_free_irqs_top(struct irq_domain *domain, unsigned int virq,
 	irq_domain_free_irqs_common(domain, virq, nr_irqs);
 }
 
+static bool irq_domain_is_auto_recursive(struct irq_domain *domain)
+{
+	return domain->flags & IRQ_DOMAIN_FLAG_AUTO_RECURSIVE;
+}
+
+static void irq_domain_free_irqs_recursive(struct irq_domain *domain,
+					   unsigned int irq_base,
+					   unsigned int nr_irqs)
+{
+	domain->ops->free(domain, irq_base, nr_irqs);
+	if (irq_domain_is_auto_recursive(domain)) {
+		BUG_ON(!domain->parent);
+		irq_domain_free_irqs_recursive(domain->parent, irq_base,
+					       nr_irqs);
+	}
+}
+
+static int irq_domain_alloc_irqs_recursive(struct irq_domain *domain,
+					   unsigned int irq_base,
+					   unsigned int nr_irqs, void *arg)
+{
+	int ret = 0;
+	struct irq_domain *parent = domain->parent;
+	bool recursive = irq_domain_is_auto_recursive(domain);
+
+	BUG_ON(recursive && !parent);
+	if (recursive)
+		ret = irq_domain_alloc_irqs_recursive(parent, irq_base,
+						      nr_irqs, arg);
+	if (ret >= 0)
+		ret = domain->ops->alloc(domain, irq_base, nr_irqs, arg);
+	if (ret < 0 && recursive)
+		irq_domain_free_irqs_recursive(parent, irq_base, nr_irqs);
+
+	return ret;
+}
+
 /**
  * __irq_domain_alloc_irqs - Allocate IRQs from domain
  * @domain: domain to allocate from
@@ -981,7 +1018,7 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 	}
 
 	mutex_lock(&irq_domain_mutex);
-	ret = domain->ops->alloc(domain, virq, nr_irqs, arg);
+	ret = irq_domain_alloc_irqs_recursive(domain, virq, nr_irqs, arg);
 	if (ret < 0) {
 		mutex_unlock(&irq_domain_mutex);
 		goto out_free_irq_data;
@@ -1016,13 +1053,38 @@ void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs)
 	mutex_lock(&irq_domain_mutex);
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_remove_irq(virq + i);
-	data->domain->ops->free(data->domain, virq, nr_irqs);
+	irq_domain_free_irqs_recursive(data->domain, virq, nr_irqs);
 	mutex_unlock(&irq_domain_mutex);
 
 	irq_domain_free_irq_data(virq, nr_irqs);
 	irq_free_descs(virq, nr_irqs);
 }
 
+int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
+				 unsigned int irq_base, unsigned int nr_irqs,
+				 void *arg)
+{
+	/* irq_domain_alloc_irqs_recursive() has called parent's alloc() */
+	if (irq_domain_is_auto_recursive(domain))
+		return 0;
+
+	domain = domain->parent;
+	if (domain)
+		return irq_domain_alloc_irqs_recursive(domain, irq_base,
+						       nr_irqs, arg);
+
+	return -ENOSYS;
+}
+
+void irq_domain_free_irqs_parent(struct irq_domain *domain,
+				 unsigned int irq_base, unsigned int nr_irqs)
+{
+	/* irq_domain_free_irqs_recursive() will call parent's free */
+	if (!irq_domain_is_auto_recursive(domain))
+		irq_domain_free_irqs_recursive(domain->parent, irq_base,
+					       nr_irqs);
+}
+
 /**
  * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
  *			     interrupt
-- 
1.7.10.4

