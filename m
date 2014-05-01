Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaEAQ1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaEAQ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:27:34 -0400
Subject: [PATCH 04/13] PCI: quirk dma_func_alias for Marvell devices
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 10:27:30 -0600
Message-ID: <20140501162729.17512.34992.stgit@bling.home>
In-Reply-To: <20140501160128.17512.23609.stgit@bling.home>
References: <20140501160128.17512.23609.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several Marvell devices and a JMicron device have a similar DMA
requester ID problem to Ricoh, except they use function 1 as the
PCIe requester ID.  Add a quirk for these to populate the DMA
function alias bitmap.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a458c6b..82b2733 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3349,6 +3349,28 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe230, quirk_dma_func0_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
 
+static void quirk_dma_func1_alias(struct pci_dev *dev)
+{
+	if (PCI_SLOT(dev->devfn) != 1)
+		dev->dma_func_alias |= (1 << 1);
+}
+
+/*
+ * Marvell 88SE9123 uses function 1 as the requester ID for DMA.  In some
+ * SKUs function 1 is present and is a legacy IDE controller, in other
+ * SKUs this function is not present, making this a ghost requester.
+ * https://bugzilla.kernel.org/show_bug.cgi?id=42679
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9123,
+			 quirk_dma_func1_alias);
+/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c14 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9130,
+			 quirk_dma_func1_alias);
+/* https://bugs.gentoo.org/show_bug.cgi?id=497630 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_JMICRON,
+			 PCI_DEVICE_ID_JMICRON_JMB388_ESD,
+			 quirk_dma_func1_alias);
+
 static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
 {
 	if (!PCI_FUNC(dev->devfn))

