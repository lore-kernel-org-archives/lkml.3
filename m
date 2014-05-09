Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaEIP2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007AbaEIP2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:28:48 -0400
Subject: [PATCH v2 03/15] PCI: quirk dma_func_alias for Ricoh devices
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 09 May 2014 09:28:43 -0600
Message-ID: <20140509152843.8321.81165.stgit@bling.home>
In-Reply-To: <20140509151735.8321.22017.stgit@bling.home>
References: <20140509151735.8321.22017.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing quirk for these devices doesn't really solve the problem,
re-implement it using the DMA alias iterator.  We'll come back later
and remove the existing quirk and dma_source interface.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e729206..fa70476 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3333,6 +3333,22 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 	return -ENOTTY;
 }
 
+static void quirk_dma_func0_alias(struct pci_dev *dev)
+{
+	if (PCI_SLOT(dev->devfn) != 0)
+		dev->dma_func_alias |= (1 << 0);
+}
+
+/*
+ * https://bugzilla.redhat.com/show_bug.cgi?id=605888
+ *
+ * Some Ricoh devices use function 0 as the PCIe requester ID for DMA.
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe822, quirk_dma_func0_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe230, quirk_dma_func0_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe476, quirk_dma_func0_alias);
+
 static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
 {
 	if (!PCI_FUNC(dev->devfn))

