Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaKXUVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:21:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49132 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaKXUVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:21:52 -0500
Date: Sun, 23 Nov 2014 10:13:07 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-d9109698be6e7439e6082aa00d79d4556114739b@git.kernel.org>
Cc: wangyijing@huawei.com, tglx@linutronix.de, marc.zyngier@arm.com,
        matthias.bgg@gmail.com, yingjoe.chen@mediatek.com, tony.luck@intel.com,
        hpa@zytor.com, grant.likely@linaro.org, bp@alien8.de,
        bhelgaas@google.com, jiang.liu@linux.intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, agordeev@redhat.com
Reply-To: agordeev@redhat.com, grant.likely@linaro.org, tony.luck@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiang.liu@linux.intel.com, bp@alien8.de, bhelgaas@google.com,
        marc.zyngier@arm.com, tglx@linutronix.de, wangyijing@huawei.com,
        yingjoe.chen@mediatek.com, matthias.bgg@gmail.com
In-Reply-To: <1416061447-9472-7-git-send-email-jiang.liu@linux.intel.com>
References: <1416061447-9472-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/irqdomain] genirq: Introduce msi_domain_alloc/free_irqs(
 )
Git-Commit-ID: d9109698be6e7439e6082aa00d79d4556114739b
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

Commit-ID:  d9109698be6e7439e6082aa00d79d4556114739b
Gitweb:     http://git.kernel.org/tip/d9109698be6e7439e6082aa00d79d4556114739b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Sat, 15 Nov 2014 22:24:04 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 23 Nov 2014 13:01:47 +0100

genirq: Introduce msi_domain_alloc/free_irqs()

Introduce msi_domain_{alloc|free}_irqs() to alloc/free interrupts
from generic MSI irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Link: http://lkml.kernel.org/r/1416061447-9472-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/msi.h | 29 +++++++++++++++++++++
 kernel/irq/msi.c    | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/linux/msi.h b/include/linux/msi.h
index b5ca245..7a93a98 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -115,6 +115,9 @@ struct msi_controller {
 };
 
 #ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+
+#include <asm/msi.h>
+
 struct irq_domain;
 struct irq_chip;
 struct device_node;
@@ -125,6 +128,18 @@ struct msi_domain_info;
  * @get_hwirq:		Retrieve the resulting hw irq number
  * @msi_init:		Domain specific init function for MSI interrupts
  * @msi_free:		Domain specific function to free a MSI interrupts
+ * @msi_check:		Callback for verification of the domain/info/dev data
+ * @msi_prepare:	Prepare the allocation of the interrupts in the domain
+ * @msi_finish:		Optional callbacl to finalize the allocation
+ * @set_desc:		Set the msi descriptor for an interrupt
+ * @handle_error:	Optional error handler if the allocation fails
+ *
+ * @get_hwirq, @msi_init and @msi_free are callbacks used by
+ * msi_create_irq_domain() and related interfaces
+ *
+ * @msi_check, @msi_prepare, @msi_finish, @set_desc and @handle_error
+ * are callbacks used by msi_irq_domain_alloc_irqs() and related
+ * interfaces which are based on msi_desc.
  */
 struct msi_domain_ops {
 	irq_hw_number_t	(*get_hwirq)(struct msi_domain_info *info, void *arg);
@@ -135,6 +150,17 @@ struct msi_domain_ops {
 	void		(*msi_free)(struct irq_domain *domain,
 				    struct msi_domain_info *info,
 				    unsigned int virq);
+	int		(*msi_check)(struct irq_domain *domain,
+				     struct msi_domain_info *info,
+				     struct device *dev);
+	int		(*msi_prepare)(struct irq_domain *domain,
+				       struct device *dev, int nvec,
+				       msi_alloc_info_t *arg);
+	void		(*msi_finish)(msi_alloc_info_t *arg, int retval);
+	void		(*set_desc)(msi_alloc_info_t *arg,
+				    struct msi_desc *desc);
+	int		(*handle_error)(struct irq_domain *domain,
+					struct msi_desc *desc, int error);
 };
 
 /**
@@ -155,6 +181,9 @@ int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
 struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 					 struct msi_domain_info *info,
 					 struct irq_domain *parent);
+int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
+			  int nvec);
+void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev);
 struct msi_domain_info *msi_get_domain_info(struct irq_domain *domain);
 
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 5e0cef4..23111aa 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -13,6 +13,9 @@
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
 
+/* Temparory solution for building, will be removed later */
+#include <linux/pci.h>
+
 #ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
 /**
  * msi_domain_set_affinity - Generic affinity setter function for MSI domains
@@ -127,6 +130,78 @@ struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 }
 
 /**
+ * msi_domain_alloc_irqs - Allocate interrupts from a MSI interrupt domain
+ * @domain:	The domain to allocate from
+ * @dev:	Pointer to device struct of the device for which the interrupts
+ *		are allocated
+ * @nvec:	The number of interrupts to allocate
+ *
+ * Returns 0 on success or an error code.
+ */
+int msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
+			  int nvec)
+{
+	struct msi_domain_info *info = domain->host_data;
+	struct msi_domain_ops *ops = info->ops;
+	msi_alloc_info_t arg;
+	struct msi_desc *desc;
+	int i, ret, virq = -1;
+
+	ret = ops->msi_check(domain, info, dev);
+	if (ret == 0)
+		ret = ops->msi_prepare(domain, dev, nvec, &arg);
+	if (ret)
+		return ret;
+
+	for_each_msi_entry(desc, dev) {
+		ops->set_desc(&arg, desc);
+
+		virq = __irq_domain_alloc_irqs(domain, -1, desc->nvec_used,
+					       dev_to_node(dev), &arg, false);
+		if (virq < 0) {
+			ret = -ENOSPC;
+			if (ops->handle_error)
+				ret = ops->handle_error(domain, desc, ret);
+			if (ops->msi_finish)
+				ops->msi_finish(&arg, ret);
+			return ret;
+		}
+
+		for (i = 0; i < desc->nvec_used; i++)
+			irq_set_msi_desc_off(virq, i, desc);
+	}
+
+	if (ops->msi_finish)
+		ops->msi_finish(&arg, 0);
+
+	for_each_msi_entry(desc, dev) {
+		if (desc->nvec_used == 1)
+			dev_dbg(dev, "irq %d for MSI\n", virq);
+		else
+			dev_dbg(dev, "irq [%d-%d] for MSI\n",
+				virq, virq + desc->nvec_used - 1);
+	}
+
+	return 0;
+}
+
+/**
+ * msi_domain_free_irqs - Free interrupts from a MSI interrupt @domain associated tp @dev
+ * @domain:	The domain to managing the interrupts
+ * @dev:	Pointer to device struct of the device for which the interrupts
+ *		are free
+ */
+void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
+{
+	struct msi_desc *desc;
+
+	for_each_msi_entry(desc, dev) {
+		irq_domain_free_irqs(desc->irq, desc->nvec_used);
+		desc->irq = 0;
+	}
+}
+
+/**
  * msi_get_domain_info - Get the MSI interrupt domain info for @domain
  * @domain:	The interrupt domain to retrieve data from
  *
