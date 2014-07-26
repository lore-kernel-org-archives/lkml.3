Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022AbaGZCoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:12 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6658 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaGZCnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:50 -0400
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
Subject: [RFC PATCH 03/11] PCI/MSI: Refactor pci_dev_msi_enabled()
Date: Sat, 26 Jul 2014 11:08:40 +0800
Message-ID: <1406344128-27055-4-git-send-email-wangyijing@huawei.com>
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

Pci_dev_msi_enabled() is used to check whether device
MSI/MSIX enabled. Refactor this function  to suuport
checking only device MSI or MSIX enabled.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/cris/arch-v32/drivers/pci/bios.c     |    2 +-
 arch/frv/mb93090-mb00/pci-vdk.c           |    2 +-
 arch/ia64/pci/pci.c                       |    4 ++--
 arch/powerpc/kernel/eeh_driver.c          |    2 +-
 arch/x86/pci/common.c                     |    5 +++--
 drivers/block/nvme-core.c                 |    4 ++--
 drivers/dma/ioat/dma.c                    |    2 +-
 drivers/firewire/ohci.c                   |    2 +-
 drivers/gpu/drm/i915/i915_dma.c           |    4 ++--
 drivers/misc/mei/hw-me.c                  |    2 +-
 drivers/misc/mei/hw-txe.c                 |    2 +-
 drivers/misc/mei/pci-me.c                 |    4 ++--
 drivers/misc/mei/pci-txe.c                |    4 ++--
 drivers/misc/mic/host/mic_debugfs.c       |    4 ++--
 drivers/misc/mic/host/mic_intr.c          |    8 ++++----
 drivers/ntb/ntb_hw.c                      |    2 +-
 drivers/pci/irq.c                         |    4 ++--
 drivers/pci/msi.c                         |   15 +++++++++------
 drivers/pci/pci.c                         |    6 +++---
 drivers/pci/pcie/portdrv_core.c           |    4 ++--
 drivers/scsi/esas2r/esas2r_init.c         |    4 ++--
 drivers/scsi/esas2r/esas2r_ioctl.c        |    4 ++--
 drivers/scsi/hpsa.c                       |    4 ++--
 drivers/staging/crystalhd/crystalhd_lnx.c |    2 +-
 drivers/xen/xen-pciback/pciback_ops.c     |   12 ++++++------
 include/linux/pci.h                       |   12 ++++++++++--
 virt/kvm/assigned-dev.c                   |    2 +-
 27 files changed, 67 insertions(+), 55 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index 64a5fb9..d9d8332 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -93,7 +93,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pcibios_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!dev->msi_enabled)
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE))
 		pcibios_enable_irq(dev);
 	return 0;
 }
diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index efa5d65..b96c128 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -409,7 +409,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
-	if (!dev->msi_enabled)
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE))
 		pcibios_enable_irq(dev);
 	return 0;
 }
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 291a582..da8ddff 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -568,7 +568,7 @@ pcibios_enable_device (struct pci_dev *dev, int mask)
 	if (ret < 0)
 		return ret;
 
-	if (!dev->msi_enabled)
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE))
 		return acpi_pci_irq_enable(dev);
 	return 0;
 }
@@ -577,7 +577,7 @@ void
 pcibios_disable_device (struct pci_dev *dev)
 {
 	BUG_ON(atomic_read(&dev->enable_cnt));
-	if (!dev->msi_enabled)
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE))
 		acpi_pci_irq_disable(dev);
 }
 
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 420da61..e3f2074 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -123,7 +123,7 @@ static void eeh_disable_irq(struct pci_dev *dev)
 	 * effectively disabled by the DMA Stopped state
 	 * when an EEH error occurs.
 	 */
-	if (dev->msi_enabled || dev->msix_enabled)
+	if (pci_dev_msi_enabled(dev, MSI_TYPE | MSIX_TYPE))
 		return;
 
 	if (!irq_has_action(dev->irq))
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 059a76c..4597940 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -662,14 +662,15 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!pci_dev_msi_enabled(dev))
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE | MSIX_TYPE))
 		return pcibios_enable_irq(dev);
 	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq)
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE | MSIX_TYPE) 
+			&& pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
 
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 02351e2..f96b90f 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -2325,9 +2325,9 @@ static int nvme_dev_map(struct nvme_dev *dev)
 
 static void nvme_dev_unmap(struct nvme_dev *dev)
 {
-	if (dev->pci_dev->msi_enabled)
+	if (pci_dev_msi_enabled(dev->pci_dev, MSI_TYPE))
 		pci_disable_msi(dev->pci_dev);
-	else if (dev->pci_dev->msix_enabled)
+	else if (pci_dev_msi_enabled(dev->pci_dev, MSIX_TYPE))
 		pci_disable_msix(dev->pci_dev);
 
 	if (dev->bar) {
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 4e3549a..a11dac1 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -1088,7 +1088,7 @@ static void ioat1_intr_quirk(struct ioatdma_device *device)
 	u32 dmactrl;
 
 	pci_read_config_dword(pdev, IOAT_PCI_DMACTRL_OFFSET, &dmactrl);
-	if (pdev->msi_enabled)
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE))
 		dmactrl |= IOAT_PCI_DMACTRL_MSI_EN;
 	else
 		dmactrl &= ~IOAT_PCI_DMACTRL_MSI_EN;
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5798541..ec0a794 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3705,7 +3705,7 @@ static int pci_probe(struct pci_dev *dev,
 	if (!(ohci->quirks & QUIRK_NO_MSI))
 		pci_enable_msi(dev);
 	if (request_irq(dev->irq, irq_handler,
-			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
+			pci_dev_msi_enabled(dev, MSI_TYPE | MSIX_TYPE) ? 0 : IRQF_SHARED,
 			ohci_driver_name, ohci)) {
 		ohci_err(ohci, "failed to allocate interrupt %d\n", dev->irq);
 		err = -EIO;
diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 4c22a5b..0c248fe 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1745,7 +1745,7 @@ out_gem_unload:
 	WARN_ON(unregister_oom_notifier(&dev_priv->mm.oom_notifier));
 	unregister_shrinker(&dev_priv->mm.shrinker);
 
-	if (dev->pdev->msi_enabled)
+	if (pci_dev_msi_enabled(dev->pdev, MSI_TYPE))
 		pci_disable_msi(dev->pdev);
 
 	intel_teardown_gmbus(dev);
@@ -1826,7 +1826,7 @@ int i915_driver_unload(struct drm_device *dev)
 	cancel_work_sync(&dev_priv->gpu_error.work);
 	i915_destroy_error_state(dev);
 
-	if (dev->pdev->msi_enabled)
+	if (pci_dev_msi_enabled(dev->pdev, MSI_TYPE))
 		pci_disable_msi(dev->pdev);
 
 	intel_opregion_fini(dev);
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 6a2d272..d7595d4 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -647,7 +647,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 
 	/* Ack the interrupt here
 	 * In case of MSI we don't go through the quick handler */
-	if (pci_dev_msi_enabled(dev->pdev))
+	if (pci_dev_msi_enabled(dev->pdev, MSI_TYPE | MSIX_TYPE))
 		mei_clear_interrupts(dev);
 
 	/* check if ME wants a reset */
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index 9327378..8c2d95c 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -951,7 +951,7 @@ irqreturn_t mei_txe_irq_thread_handler(int irq, void *dev_id)
 	mutex_lock(&dev->device_lock);
 	mei_io_list_init(&complete_list);
 
-	if (pci_dev_msi_enabled(dev->pdev))
+	if (pci_dev_msi_enabled(dev->pdev, MSI_TYPE | MSIX_TYPE))
 		mei_txe_check_and_ack_intrs(dev, true);
 
 	/* show irq events */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1b46c64..283fc09 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -181,7 +181,7 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_enable_msi(pdev);
 
 	 /* request and enable interrupt */
-	if (pci_dev_msi_enabled(pdev))
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE))
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_me_irq_thread_handler,
@@ -329,7 +329,7 @@ static int mei_me_pci_resume(struct device *device)
 	pci_enable_msi(pdev);
 
 	/* request and enable interrupt */
-	if (pci_dev_msi_enabled(pdev))
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE))
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_me_irq_thread_handler,
diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index 2343c62..a3bf202 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -124,7 +124,7 @@ static int mei_txe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mei_clear_interrupts(dev);
 
 	/* request and enable interrupt  */
-	if (pci_dev_msi_enabled(pdev))
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE))
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_txe_irq_thread_handler,
@@ -272,7 +272,7 @@ static int mei_txe_pci_resume(struct device *device)
 	mei_clear_interrupts(dev);
 
 	/* request and enable interrupt */
-	if (pci_dev_msi_enabled(pdev))
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE))
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_txe_irq_thread_handler,
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
index 028ba5d..6e1a553 100644
--- a/drivers/misc/mic/host/mic_debugfs.c
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -376,9 +376,9 @@ static int mic_msi_irq_info_show(struct seq_file *s, void *pos)
 	struct pci_dev *pdev = container_of(mdev->sdev->parent,
 		struct pci_dev, dev);
 
-	if (pci_dev_msi_enabled(pdev)) {
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE)) {
 		for (i = 0; i < mdev->irq_info.num_vectors; i++) {
-			if (pdev->msix_enabled) {
+			if (pci_dev_msi_enabled(pdev, MSIX_TYPE)) {
 				entry = mdev->irq_info.msix_entries[i].entry;
 				vector = mdev->irq_info.msix_entries[i].vector;
 			} else {
diff --git a/drivers/misc/mic/host/mic_intr.c b/drivers/misc/mic/host/mic_intr.c
index dbc5afd..9eab900 100644
--- a/drivers/misc/mic/host/mic_intr.c
+++ b/drivers/misc/mic/host/mic_intr.c
@@ -468,7 +468,7 @@ struct mic_irq *mic_request_irq(struct mic_device *mdev,
 		}
 
 		entry = 0;
-		if (pci_dev_msi_enabled(pdev)) {
+		if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE)) {
 			mdev->irq_info.mic_msi_map[entry] |= (1 << offset);
 			mdev->intr_ops->program_msi_to_src_map(mdev,
 				entry, offset, true);
@@ -526,7 +526,7 @@ void mic_free_irq(struct mic_device *mdev,
 			dev_warn(mdev->sdev->parent, "Error unregistering callback\n");
 			return;
 		}
-		if (pci_dev_msi_enabled(pdev)) {
+		if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE)) {
 			mdev->irq_info.mic_msi_map[entry] &= ~(BIT(src_id));
 			mdev->intr_ops->program_msi_to_src_map(mdev,
 				entry, src_id, false);
@@ -589,7 +589,7 @@ void mic_free_interrupts(struct mic_device *mdev, struct pci_dev *pdev)
 		kfree(mdev->irq_info.msix_entries);
 		pci_disable_msix(pdev);
 	} else {
-		if (pci_dev_msi_enabled(pdev)) {
+		if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE)) {
 			free_irq(pdev->irq, mdev);
 			kfree(mdev->irq_info.mic_msi_map);
 			pci_disable_msi(pdev);
@@ -617,7 +617,7 @@ void mic_intr_restore(struct mic_device *mdev)
 	struct pci_dev *pdev = container_of(mdev->sdev->parent,
 		struct pci_dev, dev);
 
-	if (!pci_dev_msi_enabled(pdev))
+	if (!pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE))
 		return;
 
 	for (entry = 0; entry < mdev->irq_info.num_vectors; entry++) {
diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 372e08c..868f685 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1306,7 +1306,7 @@ static void ntb_free_interrupts(struct ntb_device *ndev)
 	} else {
 		free_irq(pdev->irq, ndev);
 
-		if (pci_dev_msi_enabled(pdev))
+		if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE))
 			pci_disable_msi(pdev);
 	}
 }
diff --git a/drivers/pci/irq.c b/drivers/pci/irq.c
index 6684f15..e3e3293 100644
--- a/drivers/pci/irq.c
+++ b/drivers/pci/irq.c
@@ -36,10 +36,10 @@ static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
  */
 enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *pdev)
 {
-	if (pdev->msi_enabled || pdev->msix_enabled) {
+	if (pci_dev_msi_enabled(pdev, MSI_TYPE | MSIX_TYPE)) {
 		enum pci_lost_interrupt_reason ret;
 
-		if (pdev->msix_enabled) {
+		if (pci_dev_msi_enabled(pdev, MSIX_TYPE)) {
 			pci_note_irq_problem(pdev, "MSIX routing failure");
 			ret = PCI_LOST_IRQ_DISABLE_MSIX;
 		} else {
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e416dc0..d5c8e56 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -125,7 +125,7 @@ static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 			if (irq == entry->irq)
 				break;
 		}
-	} else if (dev->msi_enabled)  {
+	} else if (pci_dev_msi_enabled(dev, MSI_TYPE))  {
 		entry = irq_get_msi_desc(irq);
 	}
 
@@ -439,7 +439,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	u16 control;
 	struct msi_desc *entry;
 
-	if (!dev->msi_enabled)
+	if (!pci_dev_msi_enabled(dev, MSI_TYPE))
 		return;
 
 	entry = irq_get_msi_desc(dev->irq);
@@ -878,7 +878,8 @@ void pci_msi_shutdown(struct pci_dev *dev)
 	struct msi_desc *desc;
 	u32 mask;
 
-	if (!pci_msi_enable || !dev || !dev->msi_enabled)
+	if (!pci_msi_enable || !dev || 
+			!pci_dev_msi_enabled(dev, MSI_TYPE))
 		return;
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -899,7 +900,8 @@ void pci_msi_shutdown(struct pci_dev *dev)
 
 void pci_disable_msi(struct pci_dev *dev)
 {
-	if (!pci_msi_enable || !dev || !dev->msi_enabled)
+	if (!pci_msi_enable || !dev || 
+			!pci_dev_msi_enabled(dev, MSI_TYPE))
 		return;
 
 	pci_msi_shutdown(dev);
@@ -972,7 +974,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	WARN_ON(!!dev->msix_enabled);
 
 	/* Check whether driver already requested for MSI irq */
-	if (dev->msi_enabled) {
+	if (pci_dev_msi_enabled(dev, MSI_TYPE)) {
 		dev_info(&dev->dev, "can't enable MSI-X (MSI IRQ already assigned)\n");
 		return -EINVAL;
 	}
@@ -1001,7 +1003,8 @@ void pci_msix_shutdown(struct pci_dev *dev)
 
 void pci_disable_msix(struct pci_dev *dev)
 {
-	if (!pci_msi_enable || !dev || !dev->msix_enabled)
+	if (!pci_msi_enable || !dev || 
+			!pci_dev_msi_enabled(dev, MSIX_TYPE))
 		return;
 
 	pci_msix_shutdown(dev);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 74043a2..6e9e7bd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1206,7 +1206,7 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
-	if (dev->msi_enabled || dev->msix_enabled)
+	if (pci_dev_msi_enabled(dev, MSI_TYPE | MSIX_TYPE))
 		return 0;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
@@ -1361,9 +1361,9 @@ static void pcim_release(struct device *gendev, void *res)
 	struct pci_devres *this = res;
 	int i;
 
-	if (dev->msi_enabled)
+	if (pci_dev_msi_enabled(dev, MSI_TYPE))
 		pci_disable_msi(dev);
-	if (dev->msix_enabled)
+	if (pci_dev_msi_enabled(dev, MSIX_TYPE))
 		pci_disable_msix(dev);
 
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 2f0ce66..7a1b6ec 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -235,9 +235,9 @@ static int init_service_irqs(struct pci_dev *dev, int *irqs, int mask)
 
 static void cleanup_service_irqs(struct pci_dev *dev)
 {
-	if (dev->msix_enabled)
+	if (pci_dev_msi_enabled(dev, MSIX_TYPE))
 		pci_disable_msix(dev);
-	else if (dev->msi_enabled)
+	else if (pci_dev_msi_enabled(dev, MSI_TYPE))
 		pci_disable_msi(dev);
 }
 
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 6776931..444f64d 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -617,8 +617,8 @@ void esas2r_kill_adapter(int i)
 			       &(a->pcid->dev),
 			       "pci_disable_device() called.  msix_enabled: %d "
 			       "msi_enabled: %d irq: %d pin: %d",
-			       a->pcid->msix_enabled,
-			       a->pcid->msi_enabled,
+			       pci_dev_msi_enabled(a->pcid, MSIX_TYPE),
+			       pci_dev_msi_enabled(a->pcid, MSI_TYPE),
 			       a->pcid->irq,
 			       a->pcid->pin);
 
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index d89a027..31e06bd 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -810,9 +810,9 @@ static int hba_ioctl_callback(struct esas2r_adapter *a,
 
 		gai->pci.msi_vector_cnt = 1;
 
-		if (a->pcid->msix_enabled)
+		if (pci_dev_msi_enabled(a->pcid, MSIX_TYPE))
 			gai->pci.interrupt_mode = ATTO_GAI_PCIIM_MSIX;
-		else if (a->pcid->msi_enabled)
+		else if (pci_dev_msi_enabled(a->pcid, MSI_TYPE))
 			gai->pci.interrupt_mode = ATTO_GAI_PCIIM_MSI;
 		else
 			gai->pci.interrupt_mode = ATTO_GAI_PCIIM_LEGACY;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 31184b3..964d809 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6707,10 +6707,10 @@ static void hpsa_free_irqs_and_disable_msix(struct ctlr_info *h)
 	free_irqs(h);
 #ifdef CONFIG_PCI_MSI
 	if (h->msix_vector) {
-		if (h->pdev->msix_enabled)
+		if (pci_dev_msi_enabled(h->pdev, MSIX_TYPE))
 			pci_disable_msix(h->pdev);
 	} else if (h->msi_vector) {
-		if (h->pdev->msi_enabled)
+		if (pci_dev_msi_enabled(h->pdev, MSI_TYPE))
 			pci_disable_msi(h->pdev);
 	}
 #endif /* CONFIG_PCI_MSI */
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index e6fb331..9459b42 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -45,7 +45,7 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 		return -EINVAL;
 	}
 
-	if (adp->pdev->msi_enabled)
+	if (pci_msi_dev_enabled(adp->pdev, MSI_TYPE))
 		adp->msi = 1;
 	else
 		adp->msi = pci_enable_msi(adp->pdev);
diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index c4a0666..fee2f19 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -64,8 +64,8 @@ static void xen_pcibk_control_isr(struct pci_dev *dev, int reset)
 		dev_data->irq_name,
 		dev_data->irq,
 		pci_is_enabled(dev) ? "on" : "off",
-		dev->msi_enabled ? "MSI" : "",
-		dev->msix_enabled ? "MSI/X" : "",
+		pci_dev_msi_enabled(dev, MSI_TYPE) ? "MSI" : "",
+		pci_dev_msi_enabled(dev, MSIX_TYPE) ? "MSI/X" : "",
 		dev_data->isr_on ? "enable" : "disable",
 		enable ? "enable" : "disable");
 
@@ -90,8 +90,8 @@ out:
 		dev_data->irq_name,
 		dev_data->irq,
 		pci_is_enabled(dev) ? "on" : "off",
-		dev->msi_enabled ? "MSI" : "",
-		dev->msix_enabled ? "MSI/X" : "",
+		pci_dev_msi_enabled(dev, MSI_TYPE) ? "MSI" : "",
+		pci_dev_msi_enabled(dev, MSIX_TYPE) ? "MSI/X" : "",
 		enable ? (dev_data->isr_on ? "enabled" : "failed to enable") :
 			(dev_data->isr_on ? "failed to disable" : "disabled"));
 }
@@ -111,9 +111,9 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
 #ifdef CONFIG_PCI_MSI
 		/* The guest could have been abruptly killed without
 		 * disabling MSI/MSI-X interrupts.*/
-		if (dev->msix_enabled)
+		if (pci_dev_msi_enabled(dev, MSIX_TYPE))
 			pci_disable_msix(dev);
-		if (dev->msi_enabled)
+		if (pci_dev_msi_enabled(dev, MSI_TYPE))
 			pci_disable_msi(dev);
 #endif
 		if (pci_is_enabled(dev))
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6ed3647..c6c01ae 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -33,6 +33,7 @@
 
 #include <linux/pci_ids.h>
 
+#include <linux/msi.h>
 /*
  * The PCI interface treats multi-function devices as independent
  * devices.  The slot/function address of each device is encoded
@@ -506,9 +507,16 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
 }
 
 #ifdef CONFIG_PCI_MSI
-static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
+static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev, int type)
 {
-	return pci_dev->msi_enabled || pci_dev->msix_enabled;
+	bool enabled = 0;
+
+	if (type & MSI_TYPE)
+		enabled |= pci_dev->msi_enabled;
+	if (type & MSIX_TYPE)
+		enabled |= pci_dev->msix_enabled;
+
+	return enabled;
 }
 #else
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev) { return false; }
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index bf06577..4634bd0 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -366,7 +366,7 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
 {
 	int r;
 
-	if (!dev->dev->msi_enabled) {
+	if (!pci_dev_msi_enabled(dev->dev, MSI_TYPE)) {
 		r = pci_enable_msi(dev->dev);
 		if (r)
 			return r;
-- 
1.7.1

