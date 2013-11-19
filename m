Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3KSF0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:26:06 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:36700
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab3KSFXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:23:45 -0500
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
Subject: [PATCH 4/9 v2] powerpc: msi: Extend the msi region interface to get info from fsl_msi
Date: Tue, 19 Nov 2013 10:47:08 +0530
Message-ID: <1384838233-24847-5-git-send-email-Bharat.Bhushan@freescale.com>
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

The FSL MSI will provide the interface to get:
  - Number of MSI regions (which is number of MSI banks for powerpc)
  - Get the region address range: Physical page which have the
    address/addresses used for generating MSI interrupt
    and size of the page.

These are required to create IOMMU (Freescale PAMU) mapping for
devices which are directly assigned using VFIO.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
v1->v2
 - Atomic increment of bank index for parallel probe of msi node 

 arch/powerpc/sysdev/fsl_msi.c |   42 +++++++++++++++++++++++++++++++++++-----
 arch/powerpc/sysdev/fsl_msi.h |   11 ++++++++-
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 77efbae..eeebbf0 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -109,6 +109,34 @@ static int fsl_msi_init_allocator(struct fsl_msi *msi_data)
 	return 0;
 }
 
+static int fsl_msi_get_region_count(void)
+{
+	int count = 0;
+	struct fsl_msi *msi_data;
+
+	list_for_each_entry(msi_data, &msi_head, list)
+		count++;
+
+	return count;
+}
+
+static int fsl_msi_get_region(int region_num, struct msi_region *region)
+{
+	struct fsl_msi *msi_data;
+
+	list_for_each_entry(msi_data, &msi_head, list) {
+		if (msi_data->bank_index == region_num) {
+			region->region_num = msi_data->bank_index;
+			/* Setting PAGE_SIZE as MSIIR is a 4 byte register */
+			region->size = PAGE_SIZE;
+			region->addr = msi_data->msiir & ~(region->size - 1);
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
 static int fsl_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 {
 	if (type == PCI_CAP_ID_MSIX)
@@ -150,7 +178,8 @@ static void fsl_compose_msi_msg(struct pci_dev *pdev, int hwirq,
 	if (reg && (len == sizeof(u64)))
 		address = be64_to_cpup(reg);
 	else
-		address = fsl_pci_immrbar_base(hose) + msi_data->msiir_offset;
+		address = fsl_pci_immrbar_base(hose) +
+			   (msi_data->msiir & 0xfffff);
 
 	msg->address_lo = lower_32_bits(address);
 	msg->address_hi = upper_32_bits(address);
@@ -393,6 +422,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 	const struct fsl_msi_feature *features;
 	int len;
 	u32 offset;
+	static atomic_t bank_index = ATOMIC_INIT(-1);
 
 	match = of_match_device(fsl_of_msi_ids, &dev->dev);
 	if (!match)
@@ -436,18 +466,15 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 				dev->dev.of_node->full_name);
 			goto error_out;
 		}
-		msi->msiir_offset =
-			features->msiir_offset + (res.start & 0xfffff);
 
 		/*
 		 * First read the MSIIR/MSIIR1 offset from dts
 		 * On failure use the hardcode MSIIR offset
 		 */
 		if (of_address_to_resource(dev->dev.of_node, 1, &msiir))
-			msi->msiir_offset = features->msiir_offset +
-					    (res.start & MSIIR_OFFSET_MASK);
+			msi->msiir = res.start + features->msiir_offset;
 		else
-			msi->msiir_offset = msiir.start & MSIIR_OFFSET_MASK;
+			msi->msiir = msiir.start;
 	}
 
 	msi->feature = features->fsl_pic_ip;
@@ -521,6 +548,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		}
 	}
 
+	msi->bank_index = atomic_inc_return(&bank_index);
 	list_add_tail(&msi->list, &msi_head);
 
 	/* The multiple setting ppc_md.setup_msi_irqs will not harm things */
@@ -528,6 +556,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
 		ppc_md.setup_msi_irqs = fsl_setup_msi_irqs;
 		ppc_md.teardown_msi_irqs = fsl_teardown_msi_irqs;
 		ppc_md.msi_check_device = fsl_msi_check_device;
+		ppc_md.msi_get_region_count = fsl_msi_get_region_count;
+		ppc_md.msi_get_region = fsl_msi_get_region;
 	} else if (ppc_md.setup_msi_irqs != fsl_setup_msi_irqs) {
 		dev_err(&dev->dev, "Different MSI driver already installed!\n");
 		err = -ENODEV;
diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
index df9aa9f..a2cc5a2 100644
--- a/arch/powerpc/sysdev/fsl_msi.h
+++ b/arch/powerpc/sysdev/fsl_msi.h
@@ -31,14 +31,21 @@ struct fsl_msi {
 	struct irq_domain *irqhost;
 
 	unsigned long cascade_irq;
-
-	u32 msiir_offset; /* Offset of MSIIR, relative to start of CCSR */
+	phys_addr_t msiir; /* MSIIR Address in CCSR */
 	u32 ibs_shift; /* Shift of interrupt bit select */
 	u32 srs_shift; /* Shift of the shared interrupt register select */
 	void __iomem *msi_regs;
 	u32 feature;
 	int msi_virqs[NR_MSI_REG_MAX];
 
+	/*
+	 * During probe each bank is assigned a index number.
+	 * index number start from 0.
+	 * Example  MSI bank 1 = 0
+	 * MSI bank 2 = 1, and so on.
+	 */
+	int bank_index;
+
 	struct msi_bitmap bitmap;
 
 	struct list_head list;          /* support multiple MSI banks */
-- 
1.7.0.4


