Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201Ab3JPLg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:36:26 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:41586
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933654Ab3JPLgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:36:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <scottwood@freescale.com>,
        <alex.williamson@redhat.com>, <r65777@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 2/3 v2] iommu/fsl: Enable default DMA window for PCIe devices
Date: Wed, 16 Oct 2013 16:53:01 +0530
Message-ID: <1381922582-28724-3-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
References: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once the PCIe device assigned to a guest VM (via VFIO) gets detached from the iommu domain
(when guest terminates), its PAMU table entry is disabled. So, this would prevent the device
from being used once it's assigned back to the host.

This patch allows for creation of a default DMA window corresponding to the device
and subsequently enabling the PAMU table entry. Before we enable the entry, we ensure that
the device's bus master capability is disabled (device quiesced).

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 drivers/iommu/fsl_pamu.c        |   43 ++++++++++++++++++++++++++++--------
 drivers/iommu/fsl_pamu.h        |    1 +
 drivers/iommu/fsl_pamu_domain.c |   46 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 78 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index cba0498..fb4a031 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -225,6 +225,21 @@ static struct paace *pamu_get_spaace(struct paace *paace, u32 wnum)
 	return spaace;
 }
 
+/*
+ * Defaul PPAACE settings for an LIODN.
+ */
+static void setup_default_ppaace(struct paace *ppaace)
+{
+	pamu_init_ppaace(ppaace);
+	/* window size is 2^(WSE+1) bytes */
+	set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
+	ppaace->wbah = 0;
+	set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
+	set_bf(ppaace->impl_attr, PAACE_IA_ATM,
+		PAACE_ATM_NO_XLATE);
+	set_bf(ppaace->addr_bitfields, PAACE_AF_AP,
+		PAACE_AP_PERMS_ALL);
+}
 /**
  * pamu_get_fspi_and_allocate() - Allocates fspi index and reserves subwindows
  *                                required for primary PAACE in the secondary
@@ -253,6 +268,24 @@ static unsigned long pamu_get_fspi_and_allocate(u32 subwin_cnt)
 	return (spaace_addr - (unsigned long)spaact) / (sizeof(struct paace));
 }
 
+/* Reset the PAACE entry to the default state */
+void enable_default_dma_window(int liodn)
+{
+	struct paace *ppaace;
+
+	ppaace = pamu_get_ppaace(liodn);
+	if (!ppaace) {
+		pr_debug("Invalid liodn entry\n");
+		return;
+	}
+
+	memset(ppaace, 0, sizeof(struct paace));
+
+	setup_default_ppaace(ppaace);
+	mb();
+	pamu_enable_liodn(liodn);
+}
+
 /* Release the subwindows reserved for a particular LIODN */
 void pamu_free_subwins(int liodn)
 {
@@ -752,15 +785,7 @@ static void __init setup_liodns(void)
 				continue;
 			}
 			ppaace = pamu_get_ppaace(liodn);
-			pamu_init_ppaace(ppaace);
-			/* window size is 2^(WSE+1) bytes */
-			set_bf(ppaace->addr_bitfields, PPAACE_AF_WSE, 35);
-			ppaace->wbah = 0;
-			set_bf(ppaace->addr_bitfields, PPAACE_AF_WBAL, 0);
-			set_bf(ppaace->impl_attr, PAACE_IA_ATM,
-				PAACE_ATM_NO_XLATE);
-			set_bf(ppaace->addr_bitfields, PAACE_AF_AP,
-				PAACE_AP_PERMS_ALL);
+			setup_default_ppaace(ppaace);
 			if (of_device_is_compatible(node, "fsl,qman-portal"))
 				setup_qbman_paace(ppaace, QMAN_PORTAL_PAACE);
 			if (of_device_is_compatible(node, "fsl,qman"))
diff --git a/drivers/iommu/fsl_pamu.h b/drivers/iommu/fsl_pamu.h
index 8fc1a12..0edcbbbb 100644
--- a/drivers/iommu/fsl_pamu.h
+++ b/drivers/iommu/fsl_pamu.h
@@ -406,5 +406,6 @@ void get_ome_index(u32 *omi_index, struct device *dev);
 int  pamu_update_paace_stash(int liodn, u32 subwin, u32 value);
 int pamu_disable_spaace(int liodn, u32 subwin);
 u32 pamu_get_max_subwin_cnt(void);
+void enable_default_dma_window(int liodn);
 
 #endif  /* __FSL_PAMU_H */
diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 966ae70..dd6cafc 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -340,17 +340,57 @@ static inline struct device_domain_info *find_domain(struct device *dev)
 	return dev->archdata.iommu_domain;
 }
 
+/* Disable device DMA capability and enable default DMA window */
+static void disable_device_dma(struct device_domain_info *info,
+				int enable_dma_window)
+{
+#ifdef CONFIG_PCI
+	if (info->dev->bus == &pci_bus_type) {
+		struct pci_dev *pdev = NULL;
+		pdev = to_pci_dev(info->dev);
+		if (pci_is_enabled(pdev))
+			pci_disable_device(pdev);
+	}
+#endif
+
+	if (enable_dma_window)
+		enable_default_dma_window(info->liodn);
+}
+
+static int check_for_shared_liodn(struct device_domain_info *info)
+{
+	struct device_domain_info *tmp;
+
+	/*
+	 * Sanity check, to ensure that this is not a
+	 * shared LIODN. In case of a PCIe controller
+	 * it's possible that all PCIe devices share
+	 * the same LIODN.
+	 */
+	list_for_each_entry(tmp, &info->domain->devices, link) {
+		if (info->liodn == tmp->liodn)
+			return 1;
+	}
+
+	return 0;
+}
+
 static void remove_device_ref(struct device_domain_info *info, u32 win_cnt)
 {
 	unsigned long flags;
+	int enable_dma_window = 0;
 
 	list_del(&info->link);
 	spin_lock_irqsave(&iommu_lock, flags);
-	if (win_cnt > 1)
-		pamu_free_subwins(info->liodn);
-	pamu_disable_liodn(info->liodn);
+	if (!check_for_shared_liodn(info)) {
+		if (win_cnt > 1)
+			pamu_free_subwins(info->liodn);
+		pamu_disable_liodn(info->liodn);
+		enable_dma_window = 1;
+	}
 	spin_unlock_irqrestore(&iommu_lock, flags);
 	spin_lock_irqsave(&device_domain_lock, flags);
+	disable_device_dma(info, enable_dma_window);
 	info->dev->archdata.iommu_domain = NULL;
 	kmem_cache_free(iommu_devinfo_cache, info);
 	spin_unlock_irqrestore(&device_domain_lock, flags);
-- 
1.7.9.5


