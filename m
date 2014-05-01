Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaEAQ1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaEAQ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:27:39 -0400
Subject: [PATCH 05/13] PCI: Consolidate isolation domain code
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:27:35 -0600
Message-ID: <20140501162735.17512.80501.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each of the IOMMU drivers supporting IOMMU groups has their own
implementation of an algorithm to find the base device for an IOMMU
group.  This N:1 function takes into account visibility of a PCI
device on the bus using DMA aliases, as well as the isolation of
devices using ACS.  Since these are all generic PCI properties,
provide this helper in PCI code to create a single, standard
implementation.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/search.c |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    1 
 2 files changed, 131 insertions(+)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ad698b2..1eab231 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -109,6 +109,136 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
 }
 
 /*
+ * last_dma_alias_dev - Isolation root helper to record the last DMA alias pdev
+ */
+static int last_dma_alias_dev(struct pci_dev *pdev, u16 alias, void *data)
+{
+	*(struct pci_dev **)data = pdev;
+	return 0;
+}
+
+/*
+ * To consider a device isolated, we require ACS to support Source Validation,
+ * Request Redirection, Completer Redirection, and Upstream Forwarding.  This
+ * effectively means that devices cannot spoof their requester ID, requests
+ * and commpletions cannot be redirected, and all transactions are forwarded
+ * upstream, even as it passes through a bridge where the target device is
+ * downstream.
+ */
+#define REQ_ACS_FLAGS   (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
+/*
+ * pci_find_dma_isolation_root - Given a PCI device, find the root device for
+ *				 an isolation domain.
+ * @pdev: target device
+ *
+ * This function takes DMA alias quirks, bus topology, and PCI ACS into
+ * account to find the root device for an isolation domain.  The root device
+ * is a consistent and representative device within the isolation domain.
+ * Passing any device within a given isolation domain results in the same
+ * returned root device, allowing this root device to be used for lookup
+ * for structures like IOMMU groups.  Note that the root device is not
+ * necessarily a bridge, in the case of a multifunction device without
+ * DMA isolation between functions, the root device is the lowest function
+ * without isolation.
+ */
+struct pci_dev *pci_find_dma_isolation_root(struct pci_dev *pdev)
+{
+	struct pci_bus *bus;
+
+	/*
+	 * Step 1: Find the upstream DMA alias device
+	 *
+	 * A device can be aliased by bridges or DMA alias quirks.  Being able
+	 * to differentiate devices is a minimum requirement for isolation.
+	 */
+	pci_for_each_dma_alias(pdev, &last_dma_alias_dev, &pdev);
+
+	/*
+	 * Step 2: Find the upstream ACS device
+	 *
+	 * Beyond differentiation, ACS prevents uncontrolled peer-to-peer
+	 * transactions.  Therefore the next step is to find the upstream
+	 * ACS device.
+	 */
+	for (bus = pdev->bus; !pci_is_root_bus(bus); bus = bus->parent) {
+		if (!bus->self)
+			continue;
+
+		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
+			break;
+
+		pdev = bus->self;
+	}
+
+	/*
+	 * Step 3: Handle DMA function aliases
+	 *
+	 * PCI functions are sometimes broken and use the wrong requester
+	 * ID for DMA transactions.  The requester ID for this device may
+	 * actually be used by another function in this slot.  If such a
+	 * function exists, use it.
+	 */
+	if (pdev->multifunction) {
+		u8 func, func_mask = 1 << PCI_FUNC(pdev->devfn);
+
+		for (func = 0; func < 8; func++) {
+			struct pci_dev *tmp;
+
+			if (func == PCI_FUNC(pdev->devfn))
+				continue;
+
+			tmp = pci_get_slot(pdev->bus,
+					   PCI_DEVFN(PCI_SLOT(pdev->devfn),
+						     func));
+			if (!tmp)
+				continue;
+
+			pci_dev_put(tmp);
+			/*
+			 * If this device has a DMA alias to us, it becomes
+			 * the base device regardless of ACS.
+			 */
+			if (tmp->dma_func_alias & func_mask) {
+				pdev = tmp;
+				break;
+			}
+		}
+	}
+
+	/*
+	 * Step 4: Handle multifunction ACS
+	 *
+	 * If the resulting device is multifunction and does not itself
+	 * support ACS then we cannot assume isolation between functions.
+	 * The root device needs to be consistent, therefore we return the
+	 * lowest numbered function that also lacks ACS support.
+	 */
+	if (pdev->multifunction && !pci_acs_enabled(pdev, REQ_ACS_FLAGS)) {
+		u8 func;
+
+		for (func = 0; func < PCI_FUNC(pdev->devfn); func++) {
+			struct pci_dev *tmp;
+
+			tmp = pci_get_slot(pdev->bus,
+					   PCI_DEVFN(PCI_SLOT(pdev->devfn),
+						     func));
+			if (!tmp)
+				continue;
+
+			pci_dev_put(tmp);
+
+			if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
+				pdev = tmp;
+				break;
+			}
+		}
+	}
+
+	return pdev;
+}
+
+/*
  * find the upstream PCIe-to-PCI bridge of a PCI device
  * if the device is PCIE, return NULL
  * if the device isn't connected to a PCIe bridge (that is its parent is a
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b4c97d2..0d50064 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1800,6 +1800,7 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
 int pci_for_each_dma_alias(struct pci_dev *pdev,
 			   int (*fn)(struct pci_dev *pdev,
 				     u16 alias, void *data), void *data);
+struct pci_dev *pci_find_dma_isolation_root(struct pci_dev *pdev);
 
 /**
  * pci_find_upstream_pcie_bridge - find upstream PCIe-to-PCI bridge of a device

