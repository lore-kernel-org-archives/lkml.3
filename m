Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaKTHGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:06:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:64934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbaKTHGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,422,1413270000"; 
   d="scan'208";a="610938932"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        pbonzini@redhat.com, gleb@kernel.org, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [RFC Patch V1] genirq: Introduce irq_set_vcpu_affinity() to target an interrupt to a VCPU
Date: Thu, 20 Nov 2014 15:10:00 +0800
Message-Id: <1416467404-5031-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Guest update MSI/MSI-X interrupt configuratoin
	-->QEMU and KVM handle this
	-->KVM call this interface (passing posted interrupts descriptor
	   and guest vector)
	-->irq core will transfer the control to IOMMU
	-->IOMMU will do the real work of updating IRTE (IRTE has new
	   format for VT-d Posted-Interrupts)

You can find the VT-d Posted-Interrtups Spec. in the following URL:
http://www.intel.com/content/www/us/en/intelligent-systems/intel-technology/vt-directed-io-spec.html

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 include/linux/irq.h |    6 ++++++
 kernel/irq/manage.c |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 8badf34baf0f..0a3c8ac38ffb 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -29,6 +29,7 @@
 struct seq_file;
 struct module;
 struct msi_msg;
+struct irq_vcpu_id;
 
 /*
  * IRQ line status.
@@ -323,6 +324,8 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  *				irq_request_resources
  * @irq_compose_msi_msg:	optional to compose message content for MSI
  * @irq_write_msi_msg:	optional to write message content for MSI
+ * @irq_set_vcpu_affinity:	optional to target a virtual CPU in a virtual
+ *				machine
  * @flags:		chip specific flags
  */
 struct irq_chip {
@@ -362,6 +365,8 @@ struct irq_chip {
 	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
 
+	int		(*irq_set_vcpu_affinity)(struct irq_data *data, struct irq_vcpu_id *vcpu_id);
+
 	unsigned long	flags;
 };
 
@@ -415,6 +420,7 @@ extern void irq_cpu_online(void);
 extern void irq_cpu_offline(void);
 extern int irq_set_affinity_locked(struct irq_data *data,
 				   const struct cpumask *cpumask, bool force);
+extern int irq_set_vcpu_affinity(unsigned int irq, struct irq_vcpu_id *vcpu_id);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_PENDING_IRQ)
 void irq_move_irq(struct irq_data *data);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 80692373abd6..4ae8f243293a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -247,6 +247,25 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
+int irq_set_vcpu_affinity(unsigned int irq, struct irq_vcpu_id *vcpu_id)
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
+		ret = chip->irq_set_vcpu_affinity(&desc->irq_data, vcpu_id);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	return ret;
+}
+
 static void irq_affinity_notify(struct work_struct *work)
 {
 	struct irq_affinity_notify *notify =
-- 
1.7.10.4

