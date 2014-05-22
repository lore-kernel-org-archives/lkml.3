Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaEVXIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaEVXIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:08:11 -0400
Subject: [PATCH v4 07/16] PCI: Add quirks for ASMedia and Tundra bridges
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        eddy0596@gmail.com, linux@horizon.com
Date: Thu, 22 May 2014 17:08:07 -0600
Message-ID: <20140522230807.2856.76394.stgit@bling.home>
In-Reply-To: <20140522230230.2856.40017.stgit@bling.home>
References: <20140522230230.2856.40017.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The quirk is intended to be extremely generic, but we only apply it
to known offending devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 923689f..ab620ac 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3385,6 +3385,29 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_JMICRON,
 			 PCI_DEVICE_ID_JMICRON_JMB388_ESD,
 			 quirk_dma_func1_alias);
 
+/*
+ * A few PCIe-to-PCI bridges fail to expose a PCIe capability, resulting in
+ * using the wrong DMA alias for the device.  Some of these devices can be
+ * used as either forward or reverse bridges, so we need to test whether the
+ * device is operating in the correct mode.  We could probably apply this
+ * quirk to PCI_ANY_ID, but for now we'll just use known offenders.  The test
+ * is for a non-root, non-PCIe bridge where the upstream device is PCIe and
+ * is not a PCIe-to-PCI bridge, then @pdev is actually a PCIe-to-PCI bridge.
+ */
+static void quirk_use_pcie_bridge_dma_alias(struct pci_dev *pdev)
+{
+	if (!pci_is_root_bus(pdev->bus) &&
+	    pdev->hdr_type == PCI_HEADER_TYPE_BRIDGE &&
+	    !pci_is_pcie(pdev) && pci_is_pcie(pdev->bus->self) &&
+	    pci_pcie_type(pdev->bus->self) != PCI_EXP_TYPE_PCI_BRIDGE)
+		pdev->dev_flags |= PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS;
+}
+/* ASM1083/1085, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c46 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1080,
+			 quirk_use_pcie_bridge_dma_alias);
+/* Tundra 8113, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c43 */
+DECLARE_PCI_FIXUP_HEADER(0x10e3, 0x8113, quirk_use_pcie_bridge_dma_alias);
+
 static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
 {
 	if (!PCI_FUNC(dev->devfn))

