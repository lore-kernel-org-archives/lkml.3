Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaEVXOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbaEVXHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:07:53 -0400
Subject: [PATCH v4 04/16] PCI: quirk dma_alias_devfn for Ricoh devices
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        eddy0596@gmail.com, linux@horizon.com
Date: Thu, 22 May 2014 17:07:49 -0600
Message-ID: <20140522230749.2856.5415.stgit@bling.home>
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
References: <20140522230230.2856.40017.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing quirk for these devices doesn't really solve the problem;
re-implement it using the DMA alias iterator.  We'll come back later
and remove the existing quirk and dma_source interface.  Note that
device ID 0xe822 is typically function 0 and 0xe230 has been tested to
not need the quirk and are therefore removed versus the equivalent
dma_source quirk.  If there exist in other configurations we can
re-add them.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e729206..bc8ebd9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3333,6 +3333,22 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 	return -ENOTTY;
 }
 
+static void quirk_dma_func0_alias(struct pci_dev *dev)
+{
+	if (PCI_FUNC(dev->devfn) != 0) {
+		dev->dma_alias_devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
+		dev->dev_flags |= PCI_DEV_FLAGS_DMA_ALIAS_DEVFN;
+	}
+}
+
+/*
+ * https://bugzilla.redhat.com/show_bug.cgi?id=605888
+ *
+ * Some Ricoh devices use function 0 as the PCIe requester ID for DMA.
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe476, quirk_dma_func0_alias);
+
 static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
 {
 	if (!PCI_FUNC(dev->devfn))

