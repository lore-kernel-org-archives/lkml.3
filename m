Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaEAQ2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbaEAQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:28:22 -0400
Subject: [PATCH 12/13] PCI: Remove pci_find_upstream_pcie_bridge()
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:28:18 -0600
Message-ID: <20140501162818.17512.49335.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's broken and has no users.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/search.c |   35 -----------------------------------
 include/linux/pci.h  |   11 -----------
 2 files changed, 46 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 1eab231..6d3b9be 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -238,41 +238,6 @@ struct pci_dev *pci_find_dma_isolation_root(struct pci_dev *pdev)
 	return pdev;
 }
 
-/*
- * find the upstream PCIe-to-PCI bridge of a PCI device
- * if the device is PCIE, return NULL
- * if the device isn't connected to a PCIe bridge (that is its parent is a
- * legacy PCI bridge and the bridge is directly connected to bus 0), return its
- * parent
- */
-struct pci_dev *
-pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
-{
-	struct pci_dev *tmp = NULL;
-
-	if (pci_is_pcie(pdev))
-		return NULL;
-	while (1) {
-		if (pci_is_root_bus(pdev->bus))
-			break;
-		pdev = pdev->bus->self;
-		/* a p2p bridge */
-		if (!pci_is_pcie(pdev)) {
-			tmp = pdev;
-			continue;
-		}
-		/* PCI device should connect to a PCIe bridge */
-		if (pci_pcie_type(pdev) != PCI_EXP_TYPE_PCI_BRIDGE) {
-			/* Busted hardware? */
-			WARN_ON_ONCE(1);
-			return NULL;
-		}
-		return pdev;
-	}
-
-	return tmp;
-}
-
 static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
 {
 	struct pci_bus *child;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0d50064..bf4b0e9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1802,15 +1802,4 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 				     u16 alias, void *data), void *data);
 struct pci_dev *pci_find_dma_isolation_root(struct pci_dev *pdev);
 
-/**
- * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device
- * @pdev: the PCI device
- *
- * if the device is PCIE, return NULL
- * if the device isn't connected to a PCIe bridge (that is its parent is a
- * legacy PCI bridge and the bridge is directly connected to bus 0), return its
- * parent
- */
-struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
-
 #endif /* LINUX_PCI_H */

