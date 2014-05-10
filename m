Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbaEJPDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbaEJPDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:03:04 -0400
Subject: [PATCH v3 06/15] PCI: Add quirks for ASMedia and Tundra bridges
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: bhelgaas@google.com, acooks@gmail.com, linux-kernel@vger.kernel.org,
        linux@horizon.com
Date: Sat, 10 May 2014 09:02:59 -0600
Message-ID: <20140510150259.2997.67187.stgit@bling.home>
In-Reply-To: <20140510145619.2997.429.stgit@bling.home>
References: <20140510145619.2997.429.stgit@bling.home>
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
index c6ae46f..652b49e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3354,6 +3354,29 @@ static void quirk_dma_func1_alias(struct pci_dev *dev)
 }
 
 /*
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
+/*
  * Marvell 88SE9123 uses function 1 as the requester ID for DMA.  In some
  * SKUs function 1 is present and is a legacy IDE controller, in other
  * SKUs this function is not present, making this a ghost requester.

