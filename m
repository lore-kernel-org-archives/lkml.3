Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaEJPCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:02:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbaEJPCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:02:45 -0400
Subject: [PATCH v3 03/15] PCI: quirk dma_func_alias for Ricoh devices
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        linux@horizon.com
Date: Sat, 10 May 2014 09:02:41 -0600
Message-ID: <20140510150241.2997.38099.stgit@bling.home>
In-Reply-To: <20140510145619.2997.429.stgit@bling.home>
References: <20140510145619.2997.429.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing quirk for these devices doesn't really solve the problem,
re-implement it using the DMA alias iterator.  We'll come back later
and remove the existing quirk and dma_source interface.  Note that
device ID 0xe822 is typically function 0 and 0xe230 has been tested
to not need the quirk and are therefore removed versus the equivalent
dma_source quirk.  If the exist in other configurations we can re-add
them.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e729206..ea2cb9f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3333,6 +3333,20 @@ int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 	return -ENOTTY;
 }
 
+static void quirk_dma_func0_alias(struct pci_dev *dev)
+{
+	if (PCI_FUNC(dev->devfn) != 0)
+		dev->dma_func_alias |= (1 << 0);
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

