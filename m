Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaIGS60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:58:26 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:43359 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752183AbaIGS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:58:25 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 1/3] PCI/MSI/PPC: Remove arch_msi_check_device()
Date: Sun,  7 Sep 2014 20:57:53 +0200
Message-Id: <a7a806c4f531ba80386e9d0baf69571a827ea59c.1410078503.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410078503.git.agordeev@redhat.com>
References: <cover.1410078503.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving MSI checks from arch_msi_check_device() function to
arch_setup_msi_irqs() function makes code more compact and
allows removing unnecessary hook arch_msi_check_device()
from generic MSI code.

Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-pci@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/powerpc/include/asm/machdep.h     |  2 --
 arch/powerpc/kernel/msi.c              | 12 +---------
 arch/powerpc/platforms/cell/axon_msi.c |  9 --------
 arch/powerpc/platforms/powernv/pci.c   | 19 ++++-----------
 arch/powerpc/platforms/pseries/msi.c   | 42 +++++++++++++---------------------
 arch/powerpc/sysdev/fsl_msi.c          | 12 +++-------
 arch/powerpc/sysdev/mpic_pasemi_msi.c  | 11 ++-------
 arch/powerpc/sysdev/mpic_u3msi.c       | 28 +++++++++--------------
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c  | 18 +++++----------
 arch/powerpc/sysdev/ppc4xx_msi.c       | 19 +++++----------
 10 files changed, 50 insertions(+), 122 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index b125cea..3af7216 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -136,8 +136,6 @@ struct machdep_calls {
 	int		(*pci_setup_phb)(struct pci_controller *host);
 
 #ifdef CONFIG_PCI_MSI
-	int		(*msi_check_device)(struct pci_dev* dev,
-					    int nvec, int type);
 	int		(*setup_msi_irqs)(struct pci_dev *dev,
 					  int nvec, int type);
 	void		(*teardown_msi_irqs)(struct pci_dev *dev);
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..71bd161 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -13,7 +13,7 @@
 
 #include <asm/machdep.h>
 
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	if (!ppc_md.setup_msi_irqs || !ppc_md.teardown_msi_irqs) {
 		pr_debug("msi: Platform doesn't provide MSI callbacks.\n");
@@ -24,16 +24,6 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
-	if (ppc_md.msi_check_device) {
-		pr_debug("msi: Using platform check routine.\n");
-		return ppc_md.msi_check_device(dev, nvec, type);
-	}
-
-        return 0;
-}
-
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
-{
 	return ppc_md.setup_msi_irqs(dev, nvec, type);
 }
 
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 85825b5..862b327 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -199,14 +199,6 @@ out_error:
 	return msic;
 }
 
-static int axon_msi_check_device(struct pci_dev *dev, int nvec, int type)
-{
-	if (!find_msi_translator(dev))
-		return -ENODEV;
-
-	return 0;
-}
-
 static int setup_msi_msg_address(struct pci_dev *dev, struct msi_msg *msg)
 {
 	struct device_node *dn;
@@ -416,7 +408,6 @@ static int axon_msi_probe(struct platform_device *device)
 
 	ppc_md.setup_msi_irqs = axon_msi_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = axon_msi_teardown_msi_irqs;
-	ppc_md.msi_check_device = axon_msi_check_device;
 
 	axon_msi_debug_setup(dn, msic);
 
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index b854b57..b45c492 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -46,29 +46,21 @@
 //#define cfg_dbg(fmt...)	printk(fmt)
 
 #ifdef CONFIG_PCI_MSI
-static int pnv_msi_check_device(struct pci_dev* pdev, int nvec, int type)
-{
-	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
-	struct pnv_phb *phb = hose->private_data;
-	struct pci_dn *pdn = pci_get_pdn(pdev);
-
-	if (pdn && pdn->force_32bit_msi && !phb->msi32_support)
-		return -ENODEV;
-
-	return (phb && phb->msi_bmp.bitmap) ? 0 : -ENODEV;
-}
-
 static int pnv_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	struct pnv_phb *phb = hose->private_data;
+	struct pci_dn *pdn = pci_get_pdn(pdev);
 	struct msi_desc *entry;
 	struct msi_msg msg;
 	int hwirq;
 	unsigned int virq;
 	int rc;
 
-	if (WARN_ON(!phb))
+	if (WARN_ON(!phb) || !phb->msi_bmp.bitmap)
+		return -ENODEV;
+
+	if (pdn && pdn->force_32bit_msi && !phb->msi32_support)
 		return -ENODEV;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
@@ -860,7 +852,6 @@ void __init pnv_pci_init(void)
 
 	/* Configure MSIs */
 #ifdef CONFIG_PCI_MSI
-	ppc_md.msi_check_device = pnv_msi_check_device;
 	ppc_md.setup_msi_irqs = pnv_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
 #endif
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 18ff462..e68c196 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -336,26 +336,6 @@ out:
 	return request;
 }
 
-static int rtas_msi_check_device(struct pci_dev *pdev, int nvec, int type)
-{
-	int quota, rc;
-
-	if (type == PCI_CAP_ID_MSIX)
-		rc = check_req_msix(pdev, nvec);
-	else
-		rc = check_req_msi(pdev, nvec);
-
-	if (rc)
-		return rc;
-
-	quota = msi_quota_for_device(pdev, nvec);
-
-	if (quota && quota < nvec)
-		return quota;
-
-	return 0;
-}
-
 static int check_msix_entries(struct pci_dev *pdev)
 {
 	struct msi_desc *entry;
@@ -397,15 +377,24 @@ static void rtas_hack_32bit_msi_gen2(struct pci_dev *pdev)
 static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 {
 	struct pci_dn *pdn;
-	int hwirq, virq, i, rc;
+	int hwirq, virq, i, quota, rc;
 	struct msi_desc *entry;
 	struct msi_msg msg;
 	int nvec = nvec_in;
 	int use_32bit_msi_hack = 0;
 
-	pdn = pci_get_pdn(pdev);
-	if (!pdn)
-		return -ENODEV;
+	if (type == PCI_CAP_ID_MSIX)
+		rc = check_req_msix(pdev, nvec);
+	else
+		rc = check_req_msi(pdev, nvec);
+
+	if (rc)
+		return rc;
+
+	quota = msi_quota_for_device(pdev, nvec);
+
+	if (quota && quota < nvec)
+		return quota;
 
 	if (type == PCI_CAP_ID_MSIX && check_msix_entries(pdev))
 		return -EINVAL;
@@ -416,12 +405,14 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 	 */
 	if (type == PCI_CAP_ID_MSIX) {
 		int m = roundup_pow_of_two(nvec);
-		int quota = msi_quota_for_device(pdev, m);
+		quota = msi_quota_for_device(pdev, m);
 
 		if (quota >= m)
 			nvec = m;
 	}
 
+	pdn = pci_get_pdn(pdev);
+
 	/*
 	 * Try the new more explicit firmware interface, if that fails fall
 	 * back to the old interface. The old interface is known to never
@@ -526,7 +517,6 @@ static int rtas_msi_init(void)
 	WARN_ON(ppc_md.setup_msi_irqs);
 	ppc_md.setup_msi_irqs = rtas_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = rtas_teardown_msi_irqs;
-	ppc_md.msi_check_device = rtas_msi_check_device;
 
 	WARN_ON(ppc_md.pci_irq_fixup);
 	ppc_md.pci_irq_fixup = rtas_msi_pci_irq_fixup;
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 77efbae..b32e79d 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -109,14 +109,6 @@ static int fsl_msi_init_allocator(struct fsl_msi *msi_data)
 	return 0;
 }
 
-static int fsl_msi_check_device(struct pci_dev *pdev, int nvec, int type)
-{
-	if (type == PCI_CAP_ID_MSIX)
-		pr_debug("fslmsi: MSI-X untested, trying anyway.\n");
-
-	return 0;
-}
-
 static void fsl_teardown_msi_irqs(struct pci_dev *pdev)
 {
 	struct msi_desc *entry;
@@ -173,6 +165,9 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	struct msi_msg msg;
 	struct fsl_msi *msi_data;
 
+	if (type == PCI_CAP_ID_MSIX)
+		pr_debug("fslmsi: MSI-X untested, trying anyway.\n");
+
 	/*
 	 * If the PCI node has an fsl,msi property, then we need to use it
 	 * to find the specific MSI.
@@ -527,7 +522,6 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 	if (!ppc_md.setup_msi_irqs) {
 		ppc_md.setup_msi_irqs = fsl_setup_msi_irqs;
 		ppc_md.teardown_msi_irqs = fsl_teardown_msi_irqs;
-		ppc_md.msi_check_device = fsl_msi_check_device;
 	} else if (ppc_md.setup_msi_irqs != fsl_setup_msi_irqs) {
 		dev_err(&dev->dev, "Different MSI driver already installed!\n");
 		err = -ENODEV;
diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
index 38e6238..15dccd3 100644
--- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -63,14 +63,6 @@ static struct irq_chip mpic_pasemi_msi_chip = {
 	.name			= "PASEMI-MSI",
 };
 
-static int pasemi_msi_check_device(struct pci_dev *pdev, int nvec, int type)
-{
-	if (type == PCI_CAP_ID_MSIX)
-		pr_debug("pasemi_msi: MSI-X untested, trying anyway\n");
-
-	return 0;
-}
-
 static void pasemi_msi_teardown_msi_irqs(struct pci_dev *pdev)
 {
 	struct msi_desc *entry;
@@ -97,6 +89,8 @@ static int pasemi_msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	struct msi_msg msg;
 	int hwirq;
 
+	if (type == PCI_CAP_ID_MSIX)
+		pr_debug("pasemi_msi: MSI-X untested, trying anyway\n");
 	pr_debug("pasemi_msi_setup_msi_irqs, pdev %p nvec %d type %d\n",
 		 pdev, nvec, type);
 
@@ -169,7 +163,6 @@ int mpic_pasemi_msi_init(struct mpic *mpic)
 	WARN_ON(ppc_md.setup_msi_irqs);
 	ppc_md.setup_msi_irqs = pasemi_msi_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = pasemi_msi_teardown_msi_irqs;
-	ppc_md.msi_check_device = pasemi_msi_check_device;
 
 	return 0;
 }
diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index 9a7aa0e..623d7fb 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -105,22 +105,6 @@ static u64 find_u4_magic_addr(struct pci_dev *pdev, unsigned int hwirq)
 	return 0;
 }
 
-static int u3msi_msi_check_device(struct pci_dev *pdev, int nvec, int type)
-{
-	if (type == PCI_CAP_ID_MSIX)
-		pr_debug("u3msi: MSI-X untested, trying anyway.\n");
-
-	/* If we can't find a magic address then MSI ain't gonna work */
-	if (find_ht_magic_addr(pdev, 0) == 0 &&
-	    find_u4_magic_addr(pdev, 0) == 0) {
-		pr_debug("u3msi: no magic address found for %s\n",
-			 pci_name(pdev));
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
 static void u3msi_teardown_msi_irqs(struct pci_dev *pdev)
 {
 	struct msi_desc *entry;
@@ -146,6 +130,17 @@ static int u3msi_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	u64 addr;
 	int hwirq;
 
+	if (type == PCI_CAP_ID_MSIX)
+		pr_debug("u3msi: MSI-X untested, trying anyway.\n");
+
+	/* If we can't find a magic address then MSI ain't gonna work */
+	if (find_ht_magic_addr(pdev, 0) == 0 &&
+	    find_u4_magic_addr(pdev, 0) == 0) {
+		pr_debug("u3msi: no magic address found for %s\n",
+			 pci_name(pdev));
+		return -ENXIO;
+	}
+
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		hwirq = msi_bitmap_alloc_hwirqs(&msi_mpic->msi_bitmap, 1);
 		if (hwirq < 0) {
@@ -202,7 +197,6 @@ int mpic_u3msi_init(struct mpic *mpic)
 	WARN_ON(ppc_md.setup_msi_irqs);
 	ppc_md.setup_msi_irqs = u3msi_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = u3msi_teardown_msi_irqs;
-	ppc_md.msi_check_device = u3msi_msi_check_device;
 
 	return 0;
 }
diff --git a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
index 11c8884..a6a4dbd 100644
--- a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
@@ -44,6 +44,12 @@ static int hsta_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	int irq, hwirq;
 	u64 addr;
 
+	/* We don't support MSI-X */
+	if (type == PCI_CAP_ID_MSIX) {
+		pr_debug("%s: MSI-X not supported.\n", __func__);
+		return -EINVAL;
+	}
+
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		irq = msi_bitmap_alloc_hwirqs(&ppc4xx_hsta_msi.bmp, 1);
 		if (irq < 0) {
@@ -117,17 +123,6 @@ static void hsta_teardown_msi_irqs(struct pci_dev *dev)
 	}
 }
 
-static int hsta_msi_check_device(struct pci_dev *pdev, int nvec, int type)
-{
-	/* We don't support MSI-X */
-	if (type == PCI_CAP_ID_MSIX) {
-		pr_debug("%s: MSI-X not supported.\n", __func__);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int hsta_msi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -178,7 +173,6 @@ static int hsta_msi_probe(struct platform_device *pdev)
 
 	ppc_md.setup_msi_irqs = hsta_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = hsta_teardown_msi_irqs;
-	ppc_md.msi_check_device = hsta_msi_check_device;
 	return 0;
 
 out2:
diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
index 43948da..22b5200 100644
--- a/arch/powerpc/sysdev/ppc4xx_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_msi.c
@@ -85,8 +85,12 @@ static int ppc4xx_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_desc *entry;
 	struct ppc4xx_msi *msi_data = &ppc4xx_msi;
 
-	msi_data->msi_virqs = kmalloc((msi_irqs) * sizeof(int),
-					    GFP_KERNEL);
+	dev_dbg(&dev->dev, "PCIE-MSI:%s called. vec %x type %d\n",
+		__func__, nvec, type);
+	if (type == PCI_CAP_ID_MSIX)
+		pr_debug("ppc4xx msi: MSI-X untested, trying anyway.\n");
+
+	msi_data->msi_virqs = kmalloc((msi_irqs) * sizeof(int), GFP_KERNEL);
 	if (!msi_data->msi_virqs)
 		return -ENOMEM;
 
@@ -134,16 +138,6 @@ void ppc4xx_teardown_msi_irqs(struct pci_dev *dev)
 	}
 }
 
-static int ppc4xx_msi_check_device(struct pci_dev *pdev, int nvec, int type)
-{
-	dev_dbg(&pdev->dev, "PCIE-MSI:%s called. vec %x type %d\n",
-		__func__, nvec, type);
-	if (type == PCI_CAP_ID_MSIX)
-		pr_debug("ppc4xx msi: MSI-X untested, trying anyway.\n");
-
-	return 0;
-}
-
 static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
 				 struct resource res, struct ppc4xx_msi *msi)
 {
@@ -259,7 +253,6 @@ static int ppc4xx_msi_probe(struct platform_device *dev)
 
 	ppc_md.setup_msi_irqs = ppc4xx_setup_msi_irqs;
 	ppc_md.teardown_msi_irqs = ppc4xx_teardown_msi_irqs;
-	ppc_md.msi_check_device = ppc4xx_msi_check_device;
 	return err;
 
 error_out:
-- 
1.9.3

