Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaEIP3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbaEIP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:28:59 -0400
Subject: [PATCH v2 05/15] PCI: Quirk pci_for_each_dma_alias() for bridges
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 09 May 2014 09:28:55 -0600
Message-ID: <20140509152855.8321.78358.stgit@bling.home>
In-Reply-To: <20140509151735.8321.22017.stgit@bling.home>
References: <20140509151735.8321.22017.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several PCIe-to-PCI bridges fail to provide a PCIe capability, causing
us to handle them as conventional PCI devices.  In some cases, this
may be correct, in others it's not.  Add a dev_flag bit to identify
devices to be handled as standard PCIe-to-PCI bridges.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/search.c |   10 ++++++++--
 include/linux/pci.h  |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ad698b2..dab4561 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -98,8 +98,14 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
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
index b4c97d2..31d9a90 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -171,6 +171,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_ASSIGNED = (__force pci_dev_flags_t) 4,
 	/* Flag for quirk use to store if quirk-specific ACS is enabled */
 	PCI_DEV_FLAGS_ACS_ENABLED_QUIRK = (__force pci_dev_flags_t) 8,
+	/* DMA alias the device as if it was a PCIe-to-PCI bridge */
+	PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS = (__force pci_dev_flags_t) 16,
 };
 
 enum pci_irq_reroute_variant {

