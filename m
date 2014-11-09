Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaKIPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:09:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:48513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbaKIPJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:09:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933238"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 10/17] PCI, MSI: Split MSI code into PCI dependent and PCI independent parts
Date: Sun,  9 Nov 2014 23:10:32 +0800
Message-Id: <1415545839-28263-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some interrupt controllers, such as DMAR and HPET interrupt controllers,
make use of the same mechanism as PCI MSI interrupt, but they are not
PCI compatible. So split MSI code into PCI dependent part and PCI
independent part for code reuse later.

PCI dependent part is still hosted in drivers/pci/msi.c and a new file
kernel/irq/msi.c is created to host PCI independent part.

Use CONFIG_PCI_MSI to guard PCI dependent code in file include/linux/msi.h,
especially guarding PCI related fields in struct msi_desc.
For backward compatibility, we choose to conditionally embedded PCI
related fields in struct msi_desc instead of introducing
struct pci_msi_desc.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/Kconfig |    4 +++-
 drivers/pci/msi.c   |   50 ----------------------------------------
 include/linux/msi.h |   64 ++++++++++++++++++++++++++++++---------------------
 kernel/irq/Kconfig  |   10 +++++++-
 kernel/irq/Makefile |    1 +
 kernel/irq/msi.c    |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 112 insertions(+), 78 deletions(-)
 create mode 100644 kernel/irq/msi.c

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 022e89745f86..7a8f1c5e65af 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -4,6 +4,7 @@
 config PCI_MSI
 	bool "Message Signaled Interrupts (MSI and MSI-X)"
 	depends on PCI
+	select GENERIC_MSI_IRQ
 	help
 	   This allows device drivers to enable MSI (Message Signaled
 	   Interrupts).  Message Signaled Interrupts enable a device to
@@ -18,7 +19,8 @@ config PCI_MSI
 
 config PCI_MSI_IRQ_DOMAIN
 	bool
-	depends on PCI_MSI && IRQ_DOMAIN_HIERARCHY
+	depends on PCI_MSI
+	select GENERIC_MSI_IRQ_DOMAIN
 
 config PCI_DEBUG
 	bool "PCI Debugging"
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index cc6207e3b6bc..e1814f4be4b9 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -280,24 +280,6 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 	__read_msi_msg(entry, msg);
 }
 
-void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
-{
-	/* Assert that the cache is valid, assuming that
-	 * valid messages are not all-zeroes. */
-	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
-		 entry->msg.data));
-
-	*msg = entry->msg;
-}
-
-void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__get_cached_msi_msg(entry, msg);
-}
-EXPORT_SYMBOL_GPL(get_cached_msi_msg);
-
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
@@ -1101,22 +1083,6 @@ int pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries,
 EXPORT_SYMBOL(pci_enable_msix_range);
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
-int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			    bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct msi_msg msg;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		irq_chip_compose_msi_msg(data, &msg);
-		irq_chip_write_msi_msg(data, &msg);
-	}
-
-	return ret;
-}
-
 void pci_msi_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
 {
 	struct msi_desc *desc = irq_data->msi_desc;
@@ -1177,22 +1143,6 @@ static void msi_domain_free(struct irq_domain *domain, unsigned int virq,
 	irq_domain_free_irqs_top(domain, virq, nr_irqs);
 }
 
-void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
-	irq_chip_write_msi_msg(irq_data, &msg);
-}
-
-void msi_domain_deactivate(struct irq_domain *domain, struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
-	irq_chip_write_msi_msg(irq_data, &msg);
-}
-
 static struct irq_domain_ops msi_domain_ops = {
 	.alloc = msi_domain_alloc,
 	.free = msi_domain_free,
diff --git a/include/linux/msi.h b/include/linux/msi.h
index bd0f9d8c6fe1..19502186a64d 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -4,25 +4,24 @@
 #include <linux/kobject.h>
 #include <linux/list.h>
 
+struct irq_data;
+struct irq_chip;
+struct irq_domain;
+struct device_node;
+
 struct msi_msg {
 	u32	address_lo;	/* low 32 bits of msi message address */
 	u32	address_hi;	/* high 32 bits of msi message address */
 	u32	data;		/* 16 bits of msi message data */
 };
 
-/* Helper functions */
-struct irq_data;
-struct msi_desc;
-void mask_msi_irq(struct irq_data *data);
-void unmask_msi_irq(struct irq_data *data);
-void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
-void read_msi_msg(unsigned int irq, struct msi_msg *msg);
-void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
-void write_msi_msg(unsigned int irq, struct msi_msg *msg);
-
 struct msi_desc {
+	struct list_head list;
+	unsigned int irq;
+	unsigned int nvec_used;		/* number of messages */
+	struct msi_msg msg;		/* Last set MSI message */
+
+#ifdef CONFIG_PCI_MSI
 	struct {
 		__u8	is_msix	: 1;
 		__u8	multiple: 3;	/* log2 num of messages allocated */
@@ -34,21 +33,40 @@ struct msi_desc {
 	} msi_attrib;
 
 	u32 masked;			/* mask bits */
-	unsigned int irq;
-	unsigned int nvec_used;		/* number of messages */
-	struct list_head list;
 
 	union {
 		void __iomem *mask_base;
 		u8 mask_pos;
 	};
 	struct pci_dev *dev;
-
-	/* Last set MSI message */
-	struct msi_msg msg;
+#endif
 };
 
 /*
+ * Some drivers unconditionally reference {mask|unmask}_msi_irq(),
+ * so can't guard them with CONFIG_PCI_MSI
+ */
+void mask_msi_irq(struct irq_data *data);
+void unmask_msi_irq(struct irq_data *data);
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
+
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
+			    bool force);
+void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data);
+void msi_domain_deactivate(struct irq_domain *domain,
+			   struct irq_data *irq_data);
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
+
+#ifdef CONFIG_PCI_MSI
+/* Helper functions */
+void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
+void read_msi_msg(unsigned int irq, struct msi_msg *msg);
+void write_msi_msg(unsigned int irq, struct msi_msg *msg);
+
+/*
  * The arch hooks to setup up msi irqs. Those functions are
  * implemented as weak symbols so that they /can/ be overriden by
  * architecture specific code if needed.
@@ -76,14 +94,6 @@ struct msi_chip {
 };
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN
-struct irq_domain;
-struct irq_chip;
-
-int msi_domain_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			    bool force);
-void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data);
-void msi_domain_deactivate(struct irq_domain *domain,
-			   struct irq_data *irq_data);
 struct irq_domain *msi_create_irq_domain(struct device_node *of_node,
 					 struct irq_chip *chip,
 					 struct irq_domain *parent);
@@ -95,4 +105,6 @@ irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg);
 void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t hwirq);
 #endif /* CONFIG_PCI_MSI_IRQ_DOMAIN */
 
+#endif /* CONFIG_PCI_MSI */
+
 #endif /* LINUX_MSI_H */
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index e9b580eccc01..9c4c5d4d58e9 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -57,7 +57,15 @@ config IRQ_DOMAIN
 
 config IRQ_DOMAIN_HIERARCHY
 	bool
-	depends on IRQ_DOMAIN
+	select IRQ_DOMAIN
+
+config GENERIC_MSI_IRQ
+	bool
+
+config GENERIC_MSI_IRQ_DOMAIN
+	bool
+	select IRQ_DOMAIN_HIERARCHY
+	select GENERIC_MSI_IRQ
 
 config HANDLE_DOMAIN_IRQ
 	bool
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index fff17381f0af..d12123526e2b 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
+obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
new file mode 100644
index 000000000000..6ae0bd7ee204
--- /dev/null
+++ b/kernel/irq/msi.c
@@ -0,0 +1,61 @@
+/*
+ * linux/kernel/irq/msi.c
+ *
+ * Copyright (C) 2014 Intel Corp.
+ * Author: Jiang Liu <jiang.liu@linux.intel.com>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This file contains common code to support Message Signalled Interrupt for
+ * PCI compatible and non PCI compatible devices.
+ */
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	*msg = entry->msg;
+}
+
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__get_cached_msi_msg(entry, msg);
+}
+EXPORT_SYMBOL_GPL(get_cached_msi_msg);
+
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
+int msi_domain_set_affinity(struct irq_data *irq_data,
+			    const struct cpumask *mask, bool force)
+{
+	struct irq_data *parent = irq_data->parent_data;
+	struct msi_msg msg;
+	int ret;
+
+	ret = parent->chip->irq_set_affinity(parent, mask, force);
+	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
+		BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+		irq_chip_write_msi_msg(irq_data, &msg);
+	}
+
+	return ret;
+}
+
+void msi_domain_activate(struct irq_domain *domain, struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
+}
+
+void msi_domain_deactivate(struct irq_domain *domain, struct irq_data *irq_data)
+{
+	struct msi_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+	irq_chip_write_msi_msg(irq_data, &msg);
+}
+#endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
-- 
1.7.10.4

