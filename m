Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab3BRNBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:01:34 -0500
Received: from [216.32.180.30] ([216.32.180.30]:8312 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab3BRNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:01:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <joro@8bytes.org>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 2/6] powerpc/fsl_pci: Store the platform device information corresponding to the pci controller.
Date: Mon, 18 Feb 2013 18:22:15 +0530
Message-ID: <1361191939-21260-3-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci controller structure has a provision to store the device strcuture
pointer of the corresponding platform device. Currently this information is
not stored during fsl pci controller initialization. This information is
required while dealing with iommu groups for pci devices connected to the fsl
pci controller. For the case where the pci devices can't be paritioned, they
would fall under the same device group as the pci controller.

This patch stores the platform device information in the pci controller
structure during initialization.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 arch/powerpc/sysdev/fsl_pci.c |    9 +++++++--
 arch/powerpc/sysdev/fsl_pci.h |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 92a5915..b393ae7 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -421,13 +421,16 @@ void fsl_pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-int __init fsl_add_bridge(struct device_node *dev, int is_primary)
+int __init fsl_add_bridge(struct platform_device *pdev, int is_primary)
 {
 	int len;
 	struct pci_controller *hose;
 	struct resource rsrc;
 	const int *bus_range;
 	u8 hdr_type, progif;
+	struct device_node *dev;
+
+	dev = pdev->dev.of_node;
 
 	if (!of_device_is_available(dev)) {
 		pr_warning("%s: disabled\n", dev->full_name);
@@ -453,6 +456,8 @@ int __init fsl_add_bridge(struct device_node *dev, int is_primary)
 	if (!hose)
 		return -ENOMEM;
 
+	/* set platform device as the parent */
+	hose->parent = &pdev->dev;
 	hose->first_busno = bus_range ? bus_range[0] : 0x0;
 	hose->last_busno = bus_range ? bus_range[1] : 0xff;
 
@@ -880,7 +885,7 @@ static int fsl_pci_probe(struct platform_device *pdev)
 #endif
 
 	node = pdev->dev.of_node;
-	ret = fsl_add_bridge(node, fsl_pci_primary == node);
+	ret = fsl_add_bridge(pdev, fsl_pci_primary == node);
 
 #ifdef CONFIG_SWIOTLB
 	if (ret == 0) {
diff --git a/arch/powerpc/sysdev/fsl_pci.h b/arch/powerpc/sysdev/fsl_pci.h
index d078537..c495c00 100644
--- a/arch/powerpc/sysdev/fsl_pci.h
+++ b/arch/powerpc/sysdev/fsl_pci.h
@@ -91,7 +91,7 @@ struct ccsr_pci {
 	__be32	pex_err_cap_r3;		/* 0x.e34 - PCIE error capture register 0 */
 };
 
-extern int fsl_add_bridge(struct device_node *dev, int is_primary);
+extern int fsl_add_bridge(struct platform_device *pdev, int is_primary);
 extern void fsl_pcibios_fixup_bus(struct pci_bus *bus);
 extern int mpc83xx_add_bridge(struct device_node *dev);
 u64 fsl_pci_immrbar_base(struct pci_controller *hose);
-- 
1.7.4.1


