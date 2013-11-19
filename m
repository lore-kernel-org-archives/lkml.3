Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3KSFYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:24:19 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:41568
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab3KSFYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:24:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>, <bhelgaas@google.com>,
        <agraf@suse.de>, <scottwood@freescale.com>,
        <stuart.yoder@freescale.com>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 7/9 v2] pci: msi: Extend msi iova setting interface to powerpc arch
Date: Tue, 19 Nov 2013 10:47:11 +0530
Message-ID: <1384838233-24847-8-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we Keep track of devices which have msi page mapping to specific
iova page for all msi bank. When composing MSI address and data then
this list will be traversed. If device found in the list then use
configured iova page otherwise iova page will be taken as before.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
v2
 - new patch

 arch/powerpc/sysdev/fsl_msi.c |   90 +++++++++++++++++++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_msi.h |   16 ++++++-
 2 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index eeebbf0..52d2beb 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -137,6 +137,75 @@ static int fsl_msi_get_region(int region_num, struct msi_region *region)
 	return -ENODEV;
 }
 
+/* Add device to the list which have iova page mapping */
+static int fsl_msi_add_iova_device(struct fsl_msi *msi_data,
+				   struct pci_dev *pdev, dma_addr_t iova)
+{
+	struct fsl_msi_device *device;
+
+	mutex_lock(&msi_data->lock);
+	list_for_each_entry(device, &msi_data->device_list, list) {
+		/* If mapping already exits then update with new page mapping */
+		if (device->dev == pdev) {
+			device->iova = iova;
+			mutex_unlock(&msi_data->lock);
+			return 0;
+		}
+	}
+
+	device = kzalloc(sizeof(struct fsl_msi_device), GFP_KERNEL);
+	if (!device) {
+		pr_err("%s: Memory allocation failed\n", __func__);
+		mutex_unlock(&msi_data->lock);
+		return -ENOMEM;
+	}
+
+	device->dev = pdev;
+	device->iova = iova;
+	list_add_tail(&device->list, &msi_data->device_list);
+	mutex_unlock(&msi_data->lock);
+	return 0;
+}
+
+/* Remove device to the list which have iova page mapping */
+static int fsl_msi_del_iova_device(struct fsl_msi *msi_data,
+				   struct pci_dev *pdev)
+{
+	struct fsl_msi_device *device;
+
+	mutex_lock(&msi_data->lock);
+	list_for_each_entry(device, &msi_data->device_list, list) {
+		if (device->dev == pdev) {
+			list_del(&device->list);
+			kfree(device);
+			break;
+		}
+	}
+	mutex_unlock(&msi_data->lock);
+	return 0;
+}
+
+/* set/clear device iova mapping for the requested msi region */
+static int fsl_msi_set_iova(struct pci_dev *pdev, int region_num,
+			    dma_addr_t iova, bool set)
+{
+	struct fsl_msi *msi_data;
+	int ret = -EINVAL;
+
+	list_for_each_entry(msi_data, &msi_head, list) {
+		if (msi_data->bank_index != region_num)
+			continue;
+
+		if (set)
+			ret = fsl_msi_add_iova_device(msi_data, pdev, iova);
+		else
+			ret = fsl_msi_del_iova_device(msi_data, pdev);
+
+		break;
+	}
+	return ret;
+}
+
 static int fsl_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 {
 	if (type == PCI_CAP_ID_MSIX)
@@ -167,6 +236,7 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 				struct msi_msg *msg,
 				struct fsl_msi *fsl_msi_data)
 {
+	struct fsl_msi_device *device;
 	struct fsl_msi *msi_data = fsl_msi_data;
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	u64 address; /* Physical address of the MSIIR */
@@ -181,6 +251,15 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 		address = fsl_pci_immrbar_base(hose) +
 			   (msi_data->msiir & 0xfffff);
 
+	mutex_lock(&msi_data->lock);
+	list_for_each_entry(device, &msi_data->device_list, list) {
+		if (device->dev == pdev) {
+			address = device->iova | (msi_data->msiir & 0xfff);
+			break;
+		}
+	}
+	mutex_unlock(&msi_data->lock);
+
 	msg->address_lo = lower_32_bits(address);
 	msg->address_hi = upper_32_bits(address);
 
@@ -356,6 +435,7 @@ static int fsl_of_msi_remove(struct platform_device *ofdev)
 	struct fsl_msi *msi = platform_get_drvdata(ofdev);
 	int virq, i;
 	struct fsl_msi_cascade_data *cascade_data;
+	struct fsl_msi_device *device;
 
 	if (msi->list.prev != NULL)
 		list_del(&msi->list);
@@ -371,6 +451,13 @@ static int fsl_of_msi_remove(struct platform_device *ofdev)
 		msi_bitmap_free(&msi->bitmap);
 	if ((msi->feature & FSL_PIC_IP_MASK) != FSL_PIC_IP_VMPIC)
 		iounmap(msi->msi_regs);
+
+	mutex_lock(&msi->lock);
+	list_for_each_entry(device, &msi->device_list, list) {
+		list_del(&device->list);
+		kfree(device);
+	}
+	mutex_unlock(&msi->lock);
 	kfree(msi);
 
 	return 0;
@@ -436,6 +523,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "No memory for MSI structure\n");
 		return -ENOMEM;
 	}
+	INIT_LIST_HEAD(&msi->device_list);
+	mutex_init(&msi->lock);
 	platform_set_drvdata(dev, msi);
 
 	msi->irqhost = irq_domain_add_linear(dev->dev.of_node,
@@ -558,6 +647,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		ppc_md.msi_check_device = fsl_msi_check_device;
 		ppc_md.msi_get_region_count = fsl_msi_get_region_count;
 		ppc_md.msi_get_region = fsl_msi_get_region;
+		ppc_md.msi_set_iova = fsl_msi_set_iova;
 	} else if (ppc_md.setup_msi_irqs != fsl_setup_msi_irqs) {
 		dev_err(&dev->dev, "Different MSI driver already installed!\n");
 		err = -ENODEV;
diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
index a2cc5a2..4da2af9 100644
--- a/arch/powerpc/sysdev/fsl_msi.h
+++ b/arch/powerpc/sysdev/fsl_msi.h
@@ -27,9 +27,16 @@
 #define FSL_PIC_IP_IPIC   0x00000002
 #define FSL_PIC_IP_VMPIC  0x00000003
 
+/* List of devices having specific iova page mapping */
+struct fsl_msi_device {
+	struct list_head list;
+	struct pci_dev *dev;
+	dma_addr_t iova;
+};
+
 struct fsl_msi {
 	struct irq_domain *irqhost;
-
+	struct mutex lock;
 	unsigned long cascade_irq;
 	phys_addr_t msiir; /* MSIIR Address in CCSR */
 	u32 ibs_shift; /* Shift of interrupt bit select */
@@ -37,7 +44,12 @@ struct fsl_msi {
 	void __iomem *msi_regs;
 	u32 feature;
 	int msi_virqs[NR_MSI_REG_MAX];
-
+	/*
+	 * Keep track of devices which have msi page mapping to specific
+	 * iova page. Default this is NULL which means legacy way of
+	 * setting iova will be used.
+	 */
+	struct list_head device_list;
 	/*
 	 * During probe each bank is assigned a index number.
 	 * index number start from 0.
-- 
1.7.0.4


