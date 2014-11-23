Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaKXU1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:27:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaKXU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:26:58 -0500
Date: Sun, 23 Nov 2014 10:11:28 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-36d727310cb9f85efb5ac089ffb1797e7c3538e1@git.kernel.org>
Cc: bhelgaas@google.com, tglx@linutronix.de, grant.likely@linaro.org,
        matthias.bgg@gmail.com, marc.zyngier@arm.com, hpa@zytor.com,
        wangyijing@huawei.com, yingjoe.chen@mediatek.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, bp@alien8.de, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, mingo@kernel.org
Reply-To: tglx@linutronix.de, bhelgaas@google.com, grant.likely@linaro.org,
        matthias.bgg@gmail.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        mingo@kernel.org, benh@kernel.crashing.org, jiang.liu@linux.intel.com,
        hpa@zytor.com, marc.zyngier@arm.com, tony.luck@intel.com,
        yingjoe.chen@mediatek.com, wangyijing@huawei.com
In-Reply-To: <1416061447-9472-4-git-send-email-jiang.liu@linux.intel.com>
References: <1416061447-9472-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] irqdomain:
  Implement a method to automatically call parent domains alloc/free
Git-Commit-ID: 36d727310cb9f85efb5ac089ffb1797e7c3538e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36d727310cb9f85efb5ac089ffb1797e7c3538e1
Gitweb:     http://git.kernel.org/tip/36d727310cb9f85efb5ac089ffb1797e7c3538e1
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sat, 15 Nov 2014 22:24:01 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:46 +0100

irqdomain: Implement a method to automatically call parent domains alloc/free

Add a flags to irq_domain.flags to control whether the irqdomain core
should automatically call parent irqdomain's alloc/free callbacks. It
help to reduce hierarchy irqdomains users' code size.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Link: http://lkml.kernel.org/r/1416061447-9472-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdomain.h | 24 ++++++--------
 kernel/irq/irqdomain.c    | 82 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 17 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 7aca1ad..dd2709b 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -134,6 +134,9 @@ enum {
 	/* Irq domain is hierarchical */
 	IRQ_DOMAIN_FLAG_HIERARCHY	= (1 << 0),
 
+	/* Core calls alloc/free recursive through the domain hierarchy. */
+	IRQ_DOMAIN_FLAG_AUTO_RECURSIVE	= (1 << 1),
+
 	/*
 	 * Flags starting from IRQ_DOMAIN_FLAG_NONCORE are reserved
 	 * for implementation specific purposes and ignored by the
@@ -285,22 +288,13 @@ extern void irq_domain_free_irqs_common(struct irq_domain *domain,
 extern void irq_domain_free_irqs_top(struct irq_domain *domain,
 				     unsigned int virq, unsigned int nr_irqs);
 
-static inline int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
-					       unsigned int irq_base,
-					       unsigned int nr_irqs, void *arg)
-{
-	if (domain->parent && domain->parent->ops->alloc)
-		return domain->parent->ops->alloc(domain->parent, irq_base,
-						  nr_irqs, arg);
-	return -ENOSYS;
-}
+extern int irq_domain_alloc_irqs_parent(struct irq_domain *domain,
+					unsigned int irq_base,
+					unsigned int nr_irqs, void *arg);
 
-static inline void irq_domain_free_irqs_parent(struct irq_domain *domain,
-				unsigned int irq_base, unsigned int nr_irqs)
-{
-	if (domain->parent && domain->parent->ops->free)
-		domain->parent->ops->free(domain->parent, irq_base, nr_irqs);
-}
+extern void irq_domain_free_irqs_parent(struct irq_domain *domain,
+					unsigned int irq_base,
+					unsigned int nr_irqs);
 
 static inline bool irq_domain_is_hierarchy(struct irq_domain *domain)
 {
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4e62832..9c88db7 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -960,6 +960,43 @@ void irq_domain_free_irqs_top(struct irq_domain *domain, unsigned int virq,
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
  * @domain:	domain to allocate from
@@ -1016,7 +1053,7 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 	}
 
 	mutex_lock(&irq_domain_mutex);
-	ret = domain->ops->alloc(domain, virq, nr_irqs, arg);
+	ret = irq_domain_alloc_irqs_recursive(domain, virq, nr_irqs, arg);
 	if (ret < 0) {
 		mutex_unlock(&irq_domain_mutex);
 		goto out_free_irq_data;
@@ -1051,7 +1088,7 @@ void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs)
 	mutex_lock(&irq_domain_mutex);
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_remove_irq(virq + i);
-	data->domain->ops->free(data->domain, virq, nr_irqs);
+	irq_domain_free_irqs_recursive(data->domain, virq, nr_irqs);
 	mutex_unlock(&irq_domain_mutex);
 
 	irq_domain_free_irq_data(virq, nr_irqs);
@@ -1059,6 +1096,47 @@ void irq_domain_free_irqs(unsigned int virq, unsigned int nr_irqs)
 }
 
 /**
+ * irq_domain_alloc_irqs_parent - Allocate interrupts from parent domain
+ * @irq_base:	Base IRQ number
+ * @nr_irqs:	Number of IRQs to allocate
+ * @arg:	Allocation data (arch/domain specific)
+ *
+ * Check whether the domain has been setup recursive. If not allocate
+ * through the parent domain.
+ */
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
+	return -ENOSYS;
+}
+
+/**
+ * irq_domain_free_irqs_parent - Free interrupts from parent domain
+ * @irq_base:	Base IRQ number
+ * @nr_irqs:	Number of IRQs to free
+ *
+ * Check whether the domain has been setup recursive. If not free
+ * through the parent domain.
+ */
+void irq_domain_free_irqs_parent(struct irq_domain *domain,
+				 unsigned int irq_base, unsigned int nr_irqs)
+{
+	/* irq_domain_free_irqs_recursive() will call parent's free */
+	if (!irq_domain_is_auto_recursive(domain) && domain->parent)
+		irq_domain_free_irqs_recursive(domain->parent, irq_base,
+					       nr_irqs);
+}
+
+/**
  * irq_domain_activate_irq - Call domain_ops->activate recursively to activate
  *			     interrupt
  * @irq_data:	outermost irq_data associated with interrupt
