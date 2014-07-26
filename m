Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbaGZCoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45738 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaGZCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:52 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 11/11] x86/MSI: Refactor x86 MSI code
Date: Sat, 26 Jul 2014 11:08:48 +0800
Message-ID: <1406344128-27055-12-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/x86/include/asm/io_apic.h       |    2 +-
 arch/x86/include/asm/irq_remapping.h |    4 +-
 arch/x86/include/asm/pci.h           |    6 ++--
 arch/x86/include/asm/x86_init.h      |   10 +++---
 arch/x86/kernel/apic/io_apic.c       |   23 +++++++--------
 arch/x86/kernel/x86_init.c           |   12 ++++----
 drivers/iommu/amd_iommu.c            |   16 ++++++----
 drivers/iommu/intel_irq_remapping.c  |    9 ++++--
 drivers/iommu/irq_remapping.c        |   51 ++++++++++++++++-----------------
 drivers/iommu/irq_remapping.h        |    6 ++--
 drivers/msi/msi.c                    |    3 +-
 11 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 90f97b4..692a90f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -158,7 +158,7 @@ extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
 				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
-extern void native_compose_msi_msg(struct pci_dev *pdev,
+extern void native_compose_msi_msg(struct msi_irqs *msi,
 				   unsigned int irq, unsigned int dest,
 				   struct msi_msg *msg, u8 hpet_id);
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b7747c4..a10003d 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -47,7 +47,7 @@ extern int setup_ioapic_remapped_entry(int irq,
 				       int vector,
 				       struct io_apic_irq_attr *attr);
 extern void free_remapped_irq(int irq);
-extern void compose_remapped_msi_msg(struct pci_dev *pdev,
+extern void compose_remapped_msi_msg(struct msi_irqs *msi,
 				     unsigned int irq, unsigned int dest,
 				     struct msi_msg *msg, u8 hpet_id);
 extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
@@ -77,7 +77,7 @@ static inline int setup_ioapic_remapped_entry(int irq,
 	return -ENODEV;
 }
 static inline void free_remapped_irq(int irq) { }
-static inline void compose_remapped_msi_msg(struct pci_dev *pdev,
+static inline void compose_remapped_msi_msg(struct msi_irqs *msi,
 					    unsigned int irq, unsigned int dest,
 					    struct msi_msg *msg, u8 hpet_id)
 {
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 0892ea0..04c9ef6 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,10 +96,10 @@ extern void pci_iommu_alloc(void);
 #ifdef CONFIG_PCI_MSI
 /* implemented in arch/x86/kernel/apic/io_apic. */
 struct msi_desc;
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+int native_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
-void native_restore_msi_irqs(struct pci_dev *dev);
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+void native_restore_msi_irqs(struct msi_irqs *msi);
+int setup_msi_irq(struct msi_irqs *msi, struct msi_desc *msidesc,
 		  unsigned int irq_base, unsigned int irq_offset);
 #else
 #define native_setup_msi_irqs		NULL
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da..8e42f17 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -170,18 +170,18 @@ struct x86_platform_ops {
 	void (*apic_post_init)(void);
 };
 
-struct pci_dev;
+struct msi_irqs;
 struct msi_msg;
 struct msi_desc;
 
 struct x86_msi_ops {
-	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
-	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
+	int (*setup_msi_irqs)(struct msi_irqs *msi, int nvec, int type);
+	void (*compose_msi_msg)(struct msi_irqs *msi, unsigned int irq,
 				unsigned int dest, struct msi_msg *msg,
 			       u8 hpet_id);
 	void (*teardown_msi_irq)(unsigned int irq);
-	void (*teardown_msi_irqs)(struct pci_dev *dev);
-	void (*restore_msi_irqs)(struct pci_dev *dev);
+	void (*teardown_msi_irqs)(struct msi_irqs *msi);
+	void (*restore_msi_irqs)(struct msi_irqs *msi);
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
 	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index b833042..3cb4a6a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2939,7 +2939,7 @@ void arch_teardown_hwirq(unsigned int irq)
 /*
  * MSI message composition
  */
-void native_compose_msi_msg(struct pci_dev *pdev,
+void native_compose_msi_msg(struct msi_irqs *msi,
 			    unsigned int irq, unsigned int dest,
 			    struct msi_msg *msg, u8 hpet_id)
 {
@@ -2970,7 +2970,7 @@ void native_compose_msi_msg(struct pci_dev *pdev,
 }
 
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+static int msi_compose_msg(struct msi_irqs *msi, unsigned int irq,
 			   struct msi_msg *msg, u8 hpet_id)
 {
 	struct irq_cfg *cfg;
@@ -2990,7 +2990,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	if (err)
 		return err;
 
-	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+	x86_msi.compose_msi_msg(msi, irq, dest, msg, hpet_id);
 
 	return 0;
 }
@@ -3032,15 +3032,16 @@ static struct irq_chip msi_chip = {
 	.irq_retrigger		= ioapic_retrigger_irq,
 };
 
-int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+int setup_msi_irq(struct msi_irqs *msi, struct msi_desc *msidesc,
 		  unsigned int irq_base, unsigned int irq_offset)
 {
 	struct irq_chip *chip = &msi_chip;
 	struct msi_msg msg;
 	unsigned int irq = irq_base + irq_offset;
 	int ret;
+	struct pci_dev *dev = msi->data;
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(msi, irq, &msg, -1);
 	if (ret < 0)
 		return ret;
 
@@ -3062,24 +3063,22 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	return 0;
 }
 
-int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type)
 {
 	struct msi_desc *msidesc;
 	unsigned int irq;
-	int node, ret;
+	int ret;
 
 	/* Multiple MSI vectors only supported with interrupt remapping */
 	if (type == MSI_TYPE && nvec > 1)
 		return 1;
 
-	node = dev_to_node(&dev->dev);
-
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_alloc_hwirq(node);
+	list_for_each_entry(msidesc, &msi->msi_list, list) {
+		irq = irq_alloc_hwirq(msi->node);
 		if (!irq)
 			return -ENOSPC;
 
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
+		ret = setup_msi_irq(msi, msidesc, irq, 0);
 		if (ret < 0) {
 			irq_free_hwirq(irq);
 			return ret;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e48b674..a277faf 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -121,14 +121,14 @@ struct x86_msi_ops x86_msi = {
 };
 
 /* MSI arch specific hooks */
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int arch_setup_msi_irqs(struct msi_irqs *msi, int nvec, int type)
 {
-	return x86_msi.setup_msi_irqs(dev, nvec, type);
+	return x86_msi.setup_msi_irqs(msi, nvec, type);
 }
 
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+void arch_teardown_msi_irqs(struct msi_irqs *msi)
 {
-	x86_msi.teardown_msi_irqs(dev);
+	x86_msi.teardown_msi_irqs(msi);
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
@@ -136,9 +136,9 @@ void arch_teardown_msi_irq(unsigned int irq)
 	x86_msi.teardown_msi_irq(irq);
 }
 
-void arch_restore_msi_irqs(struct pci_dev *dev)
+void arch_restore_msi_irqs(struct msi_irqs *msi)
 {
-	x86_msi.restore_msi_irqs(dev);
+	x86_msi.restore_msi_irqs(msi);
 }
 u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4aec6a2..0e45cb7 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4237,7 +4237,7 @@ static int free_irq(int irq)
 	return 0;
 }
 
-static void compose_msi_msg(struct pci_dev *pdev,
+static void compose_msi_msg(struct msi_irqs *msi,
 			    unsigned int irq, unsigned int dest,
 			    struct msi_msg *msg, u8 hpet_id)
 {
@@ -4265,33 +4265,35 @@ static void compose_msi_msg(struct pci_dev *pdev,
 	msg->data       = irte_info->index;
 }
 
-static int msi_alloc_irq(struct pci_dev *pdev, int irq, int nvec)
+static int msi_alloc_irq(struct msi_irqs *msi, int irq, int nvec)
 {
 	struct irq_cfg *cfg;
 	int index;
 	u16 devid;
+	struct pci_dev *dev = msi->data;
 
-	if (!pdev)
+	if (!dev)
 		return -EINVAL;
 
 	cfg = irq_get_chip_data(irq);
 	if (!cfg)
 		return -EINVAL;
 
-	devid = get_device_id(&pdev->dev);
+	devid = get_device_id(&dev->dev);
 	index = alloc_irq_index(cfg, devid, nvec);
 
 	return index < 0 ? MAX_IRQS_PER_TABLE : index;
 }
 
-static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+static int msi_setup_irq(struct msi_irqs *msi, unsigned int irq,
 			 int index, int offset)
 {
 	struct irq_2_irte *irte_info;
 	struct irq_cfg *cfg;
 	u16 devid;
+	struct pci_dev *dev = msi->data;
 
-	if (!pdev)
+	if (!dev)
 		return -EINVAL;
 
 	cfg = irq_get_chip_data(irq);
@@ -4301,7 +4303,7 @@ static int msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
 	if (index >= MAX_IRQS_PER_TABLE)
 		return 0;
 
-	devid		= get_device_id(&pdev->dev);
+	devid		= get_device_id(&dev->dev);
 	irte_info	= &cfg->irq_2_irte;
 
 	cfg->remapped	      = 1;
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9b17489..d6bde63 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1027,7 +1027,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return 0;
 }
 
-static void intel_compose_msi_msg(struct pci_dev *pdev,
+static void intel_compose_msi_msg(struct msi_irqs *msi,
 				  unsigned int irq, unsigned int dest,
 				  struct msi_msg *msg, u8 hpet_id)
 {
@@ -1035,6 +1035,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 	struct irte irte;
 	u16 sub_handle = 0;
 	int ir_index;
+	struct pci_dev *pdev = msi->data;
 
 	cfg = irq_get_chip_data(irq);
 
@@ -1064,10 +1065,11 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
  * and allocate 'nvec' consecutive interrupt-remapping table entries
  * in it.
  */
-static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
+static int intel_msi_alloc_irq(struct msi_irqs *msi, int irq, int nvec)
 {
 	struct intel_iommu *iommu;
 	int index;
+	struct pci_dev *dev = msi->data;
 
 	down_read(&dmar_global_lock);
 	iommu = map_dev_to_ir(dev);
@@ -1089,11 +1091,12 @@ static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
 	return index;
 }
 
-static int intel_msi_setup_irq(struct pci_dev *pdev, unsigned int irq,
+static int intel_msi_setup_irq(struct msi_irqs *msi, unsigned int irq,
 			       int index, int sub_handle)
 {
 	struct intel_iommu *iommu;
 	int ret = -ENOENT;
+	struct pci_dev *pdev = msi->data;
 
 	down_read(&dmar_global_lock);
 	iommu = map_dev_to_ir(pdev);
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index a3b1805..1fe14e5 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -24,8 +24,8 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
-static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+static int msi_alloc_remapped_irq(struct msi_irqs *msi, int irq, int nvec);
+static int msi_setup_remapped_irq(struct msi_irqs *msi, unsigned int irq,
 				  int index, int sub_handle);
 static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask,
@@ -49,19 +49,19 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
-static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
+static int do_setup_msi_irqs(struct msi_irqs *msi, int nvec)
 {
 	int ret, sub_handle, nvec_pow2, index = 0;
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
-	WARN_ON(!list_is_singular(&dev->msi_list));
-	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+	WARN_ON(!list_is_singular(&msi->msi_list));
+	msidesc = list_entry(msi->msi_list.next, struct msi_desc, list);
 	WARN_ON(msidesc->irq);
 	WARN_ON(msidesc->msi_attrib.multiple);
 	WARN_ON(msidesc->nvec_used);
 
-	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
+	irq = irq_alloc_hwirqs(nvec, msi->node);
 	if (irq == 0)
 		return -ENOSPC;
 
@@ -70,18 +70,18 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
-			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
+			index = msi_alloc_remapped_irq(msi, irq, nvec_pow2);
 			if (index < 0) {
 				ret = index;
 				goto error;
 			}
 		} else {
-			ret = msi_setup_remapped_irq(dev, irq + sub_handle,
+			ret = msi_setup_remapped_irq(msi, irq + sub_handle,
 						     index, sub_handle);
 			if (ret < 0)
 				goto error;
 		}
-		ret = setup_msi_irq(dev, msidesc, irq, sub_handle);
+		ret = setup_msi_irq(msi, msidesc, irq, sub_handle);
 		if (ret < 0)
 			goto error;
 	}
@@ -101,30 +101,29 @@ error:
 	return ret;
 }
 
-static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
+static int do_setup_msix_irqs(struct msi_irqs *msi, int nvec)
 {
 	int node, ret, sub_handle, index = 0;
 	struct msi_desc *msidesc;
 	unsigned int irq;
 
-	node		= dev_to_node(&dev->dev);
 	sub_handle	= 0;
 
-	list_for_each_entry(msidesc, &dev->msi_list, list) {
+	list_for_each_entry(msidesc, &msi->msi_list, list) {
 
-		irq = irq_alloc_hwirq(node);
+		irq = irq_alloc_hwirq(msi->node);
 		if (irq == 0)
 			return -1;
 
 		if (sub_handle == 0)
-			ret = index = msi_alloc_remapped_irq(dev, irq, nvec);
+			ret = index = msi_alloc_remapped_irq(msi, irq, nvec);
 		else
-			ret = msi_setup_remapped_irq(dev, irq, index, sub_handle);
+			ret = msi_setup_remapped_irq(msi, irq, index, sub_handle);
 
 		if (ret < 0)
 			goto error;
 
-		ret = setup_msi_irq(dev, msidesc, irq, 0);
+		ret = setup_msi_irq(msi, msidesc, irq, 0);
 		if (ret < 0)
 			goto error;
 
@@ -139,13 +138,13 @@ error:
 	return ret;
 }
 
-static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
+static int irq_remapping_setup_msi_irqs(struct msi_irqs *msi,
 					int nvec, int type)
 {
 	if (type == MSI_TYPE)
-		return do_setup_msi_irqs(dev, nvec);
+		return do_setup_msi_irqs(msi, nvec);
 	else
-		return do_setup_msix_irqs(dev, nvec);
+		return do_setup_msix_irqs(msi, nvec);
 }
 
 static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
@@ -314,33 +313,33 @@ void free_remapped_irq(int irq)
 		remap_ops->free_irq(irq);
 }
 
-void compose_remapped_msi_msg(struct pci_dev *pdev,
+void compose_remapped_msi_msg(struct msi_irqs *msi,
 			      unsigned int irq, unsigned int dest,
 			      struct msi_msg *msg, u8 hpet_id)
 {
 	struct irq_cfg *cfg = irq_get_chip_data(irq);
 
 	if (!irq_remapped(cfg))
-		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+		native_compose_msi_msg(msi, irq, dest, msg, hpet_id);
 	else if (remap_ops && remap_ops->compose_msi_msg)
-		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
+		remap_ops->compose_msi_msg(msi, irq, dest, msg, hpet_id);
 }
 
-static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)
+static int msi_alloc_remapped_irq(struct msi_irqs *msi, int irq, int nvec)
 {
 	if (!remap_ops || !remap_ops->msi_alloc_irq)
 		return -ENODEV;
 
-	return remap_ops->msi_alloc_irq(pdev, irq, nvec);
+	return remap_ops->msi_alloc_irq(msi, irq, nvec);
 }
 
-static int msi_setup_remapped_irq(struct pci_dev *pdev, unsigned int irq,
+static int msi_setup_remapped_irq(struct msi_irqs *msi, unsigned int irq,
 				  int index, int sub_handle)
 {
 	if (!remap_ops || !remap_ops->msi_setup_irq)
 		return -ENODEV;
 
-	return remap_ops->msi_setup_irq(pdev, irq, index, sub_handle);
+	return remap_ops->msi_setup_irq(msi, irq, index, sub_handle);
 }
 
 int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 90c4dae..59c4cfb 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -69,15 +69,15 @@ struct irq_remap_ops {
 	int (*free_irq)(int);
 
 	/* Create MSI msg to use for interrupt remapping */
-	void (*compose_msi_msg)(struct pci_dev *,
+	void (*compose_msi_msg)(struct msi_irqs *,
 				unsigned int, unsigned int,
 				struct msi_msg *, u8);
 
 	/* Allocate remapping resources for MSI */
-	int (*msi_alloc_irq)(struct pci_dev *, int, int);
+	int (*msi_alloc_irq)(struct msi_irqs *, int, int);
 
 	/* Setup the remapped MSI irq */
-	int (*msi_setup_irq)(struct pci_dev *, unsigned int, int, int);
+	int (*msi_setup_irq)(struct msi_irqs *, unsigned int, int, int);
 
 	/* Setup interrupt remapping for an HPET MSI */
 	int (*setup_hpet_msi)(unsigned int, unsigned int);
diff --git a/drivers/msi/msi.c b/drivers/msi/msi.c
index 3fbd539..8462c6c 100644
--- a/drivers/msi/msi.c
+++ b/drivers/msi/msi.c
@@ -510,9 +510,8 @@ int msix_capability_init(struct msi_irqs *msi, void __iomem *base,
 
 	/* Set MSI-X enabled bits and unmask the function */
 	msi_set_intx(msi, 0);
-	msi->msix_enabled = 1;
-
 	msi_set_enable(msi, 1, MSIX_TYPE);
+	msi->msix_enabled = 1;
 
 	return 0;
 
-- 
1.7.1

