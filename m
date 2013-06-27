Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3F0WlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:41:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab3F0WlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:41:01 -0400
Subject: [PATCH v2 3/3] pci: ACS quirk for AMD southbridge
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, joro@8bytes.org, andihartmann@01019freenet.de,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 16:40:00 -0600
Message-ID: <20130627224000.16564.47084.stgit@bling.home>
In-Reply-To: <20130627222159.16564.38166.stgit@bling.home>
References: <20130627222159.16564.38166.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD confirmed that peer-to-peer between these devices is
not possible.  We can therefore claim that they support a
subset of ACS.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7d68aee..02855dd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3270,11 +3270,61 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
 	return pci_dev_get(dev);
 }
 
+/*
+ * AMD has indicated that the devices below do not support peer-to-peer
+ * in any system where they are found in the southbridge with an AMD
+ * IOMMU in the system.  Multifunction devices that do not support
+ * peer-to-peer between functions can claim to support a subset of ACS.
+ * Such devices effectively enable request redirect (RR) and completion
+ * redirect (CR) since all transactions are redirected to the upstream
+ * root complex.
+ * 
+ * http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/94086
+ * http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/94102
+ * http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/99402
+ *
+ * 1002:4385 SBx00 SMBus Controller
+ * 1002:439c SB7x0/SB8x0/SB9x0 IDE Controller
+ * 1002:4383 SBx00 Azalia (Intel HDA)
+ * 1002:439d SB7x0/SB8x0/SB9x0 LPC host controller
+ * 1002:4384 SBx00 PCI to PCI Bridge
+ * 1002:4399 SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
+ */
+static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
+{
+#ifdef CONFIG_ACPI
+	struct acpi_table_header *header = NULL;
+	acpi_status status;
+
+	/* Targeting multifunction devices on the SB (appears on root bus) */
+	if (!dev->multifunction || !pci_is_root_bus(dev->bus))
+		return -ENODEV;
+
+	/* The IVRS table describes the AMD IOMMU */
+	status = acpi_get_table("IVRS", 0, &header);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	/* Filter out flags not applicable to multifunction */
+	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
+
+	return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
+#else
+	return -ENODEV;
+#endif
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
 	int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
 } pci_dev_acs_enabled[] = {
+	{ PCI_VENDOR_ID_ATI, 0x4385, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_ATI, 0x439c, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_ATI, 0x4383, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_ATI, 0x439d, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_ATI, 0x4384, pci_quirk_amd_sb_acs },
+	{ PCI_VENDOR_ID_ATI, 0x4399, pci_quirk_amd_sb_acs },
 	{ 0 }
 };
 

