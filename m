Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaEVXJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:09:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaEVXJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:09:05 -0400
Subject: [PATCH v4 15/16] PCI: Remove pci_find_upstream_pcie_bridge()
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        eddy0596@gmail.com, linux@horizon.com
Date: Thu, 22 May 2014 17:08:58 -0600
Message-ID: <20140522230857.2856.60347.stgit@bling.home>
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
References: <20140522230230.2856.40017.stgit@bling.home>
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
index df38f73..b8e65c2 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -104,41 +104,6 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 	return ret;
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
index 85ab35e..903c7d6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1804,15 +1804,4 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 			   int (*fn)(struct pci_dev *pdev,
 				     u16 alias, void *data), void *data);
 
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

