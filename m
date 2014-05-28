Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaE1U5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:57:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaE1U5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:57:13 -0400
Subject: [PATCH v4.1 06/16] PCI: Quirk pci_for_each_dma_alias() for bridges
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        eddy0596@gmail.com, linux@horizon.com
Date: Wed, 28 May 2014 14:57:02 -0600
Message-ID: <20140528205517.27973.56814.stgit@bling.home>
In-Reply-To: <20140522230801.2856.18629.stgit@bling.home>
References: <20140522230801.2856.18629.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several PCIe-to-PCI bridges fail to provide a PCIe capability, causing
us to handle them as conventional PCI devices when they really use the
requester ID of the secondary bus.  We need to differentiate these
from PCIe-to-PCI bridges that actually use the conventional PCI ID
when a PCIe capability is not present, such as those found on the root
complex of may Intel chipsets.  Add a dev_flag bit to identify devices
to be handled as standard PCIe-to-PCI bridges.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v4.1: expand commitlog, no code change

 drivers/pci/search.c |   10 ++++++++--
 include/linux/pci.h  |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 2c19f3f..df38f73 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -88,8 +88,14 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 				continue;
 			}
 		} else {
-			ret = fn(tmp, PCI_DEVID(tmp->bus->number, tmp->devfn),
-				 data);
+			if (tmp->dev_flags & PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS)
+				ret = fn(tmp,
+					 PCI_DEVID(tmp->subordinate->number,
+						   PCI_DEVFN(0, 0)), data);
+			else
+				ret = fn(tmp,
+					 PCI_DEVID(tmp->bus->number,
+						   tmp->devfn), data);
 			if (ret)
 				return ret;
 		}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9d4035c..85ab35e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -173,6 +173,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_ACS_ENABLED_QUIRK = (__force pci_dev_flags_t) (1 << 3),
 	/* Flag to indicate the device uses dma_alias_devfn */
 	PCI_DEV_FLAGS_DMA_ALIAS_DEVFN = (__force pci_dev_flags_t) (1 << 4),
+	/* Use a PCIe-to-PCI bridge alias even if !pci_is_pcie */
+	PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS = (__force pci_dev_flags_t) (1 << 5),
 };
 
 enum pci_irq_reroute_variant {

