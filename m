Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaLCHto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:49:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaLCHtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:49:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852195"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 01/25] genirq: Introduce irq_set_vcpu_affinity() to target an interrupt to a VCPU
Date: Wed,  3 Dec 2014 15:39:30 +0800
Message-Id: <1417592394-24343-2-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

With Posted-Interrupts support in Intel CPU and IOMMU, an external
interrupt from assigned-devices could be directly delivered to a
virtual CPU in a virtual machine. Instead of hacking KVM and Intel
IOMMU drivers, we propose a platform independent interface to target
an interrupt to a specific virtual CPU in a virtual machine, or set
virtual CPU affinity for an interrupt.

By adopting this new interface and the hierarchy irqdomain, we could
easily support posted-interrupts on Intel platforms, and also provide
flexible enough interfaces for other platforms to support similar
features.

We may also cooperate between set_affinity() and set_vcpu_affinity()
in IRQ core or irq chip drivers.

Here is the usage scenario for this interface:
Guest update MSI/MSI-X interrupt configuration
	-->QEMU and KVM handle this
	-->KVM call this interface (passing posted interrupts descriptor
	   and guest vector)
	-->irq core will transfer the control to IOMMU
	-->IOMMU will do the real work of updating IRTE (IRTE has new
	   format for VT-d Posted-Interrupts)

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 include/linux/irq.h |    4 ++++
 kernel/irq/chip.c   |   14 ++++++++++++++
 kernel/irq/manage.c |   20 ++++++++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index f26e736..83abafc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -324,6 +324,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_set_vcpu_affinity:	optional to target a virtual CPU in a virtual
+ *				machine
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -362,6 +364,7 @@ struct irq_chip {
 
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
+	int		(*irq_set_vcpu_affinity)(struct irq_data *data, void *vcpu_info);
 
 	unsigned long	flags;
 };
@@ -416,6 +419,7 @@ extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
 extern int irq_set_affinity_locked(struct irq_data *data,
 				   const struct cpumask *cpumask, bool force);
+extern int irq_set_vcpu_affinity(unsigned int irq, void *vcpu_info);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void irq_move_irq(struct irq_data *data);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6f1c7a5..fe0908f 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -948,6 +948,20 @@ int irq_chip_retrigger_hierarchy(struct irq_data *data)
 
 	return -ENOSYS;
 }
+
+/**
+ * irq_chip_set_vcpu_affinity_parent - Set vcpu affinity on the parent interrupt
+ * @data:	Pointer to interrupt specific data
+ * @dest:	The vcpu affinity information
+ */
+int irq_chip_set_vcpu_affinity_parent(struct irq_data *data, void *vcpu_info)
+{
+	data = data->parent_data;
+	if (data->chip->irq_set_vcpu_affinity)
+		return data->chip->irq_set_vcpu_affinity(data, vcpu_info);
+
+	return -ENOSYS;
+}
 #endif
 
 /**
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8069237..bd3a1ba 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -247,6 +247,26 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
+int irq_set_vcpu_affinity(unsigned int irq, void *vcpu_info)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip;
+	unsigned long flags;
+	int ret = -ENOSYS;
+
+	if (!desc)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	chip = desc->irq_data.chip;
+	if (chip && chip->irq_set_vcpu_affinity)
+		ret = chip->irq_set_vcpu_affinity(irq_desc_get_irq_data(desc),
+						  vcpu_info);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(irq_set_vcpu_affinity);
+
 static void irq_affinity_notify(struct work_struct *work)
 {
 	struct irq_affinity_notify *notify =
-- 
1.7.1

