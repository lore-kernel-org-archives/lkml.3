Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab3F0Wj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458Ab3F0Wj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:39:57 -0400
Subject: [PATCH v2 1/3] pci: Fix flaw in pci_acs_enabled()
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, joro@8bytes.org, andihartmann@01019freenet.de,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Jun 2013 16:39:48 -0600
Message-ID: <20130627223948.16564.6654.stgit@bling.home>
In-Reply-To: <20130627222159.16564.38166.stgit@bling.home>
References: <20130627222159.16564.38166.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multifunction ACS rules do not apply to downstream ports.  Those
should be tested regardless of whether they are single function or
multifunciton.  The PCIe spec also fully specifies which PCIe types
are subject to the multifunction rules and excludes event collectors
and PCIe-to-PCI bridges entirely.  Document each rule to the section
of the PCIe spec and provide overall documentation of the function.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   84 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a899d8b..d0c2b35 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2349,6 +2349,19 @@ void pci_enable_acs(struct pci_dev *dev)
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, ctrl);
 }
 
+static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
+{
+	int pos;
+	u16 ctrl;
+
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
+	if (!pos)
+		return false;
+
+	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+	return (ctrl & acs_flags) == acs_flags;
+}
+
 /**
  * pci_acs_enabled - test ACS against required flags for a given device
  * @pdev: device to test
@@ -2356,36 +2369,79 @@ void pci_enable_acs(struct pci_dev *dev)
  *
  * Return true if the device supports the provided flags.  Automatically
  * filters out flags that are not implemented on multifunction devices.
+ *
+ * Note that this interface checks the effective ACS capabilities of the
+ * device rather than the actual capabilities.  For instance, most single
+ * function endpoints are not required to support ACS because they have no
+ * opportunity for peer-to-peer access.  We therefore return 'true'
+ * regardless of whether the device exposes an ACS capability.  This makes
+ * it much easier for callers of this function to ignore the actual type
+ * or topology of the device when testing ACS support.
  */
 bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
 {
-	int pos, ret;
-	u16 ctrl;
+	int ret;
 
 	ret = pci_dev_specific_acs_enabled(pdev, acs_flags);
 	if (ret >= 0)
 		return ret > 0;
 
+	/*
+	 * Conventional PCI and PCI-X devices never support ACS, either
+	 * effectively or actually.  The shared bus topology implies that
+	 * any device on the bus can receive or snoop DMA.
+	 */
 	if (!pci_is_pcie(pdev))
 		return false;
 
-	/* Filter out flags not applicable to multifunction */
-	if (pdev->multifunction)
+	switch (pci_pcie_type(pdev)) {
+	/*
+	 * PCI/X-to-PCIe bridges are not specifically mentioned by the spec,
+	 * but since their primary inteface is PCI/X, we conservatively
+	 * handle them as we would a non-PCIe device.
+	 */
+	case PCI_EXP_TYPE_PCIE_BRIDGE:
+	/*
+	 * PCIe 3.0, 6.12.1 excludes ACS on these devices.  "ACS is never
+	 * applicable... must never implement an ACS Extended Capability...".
+	 * This seems arbitrary, but we take a conservative interpretation
+	 * of this statement.
+	 */
+	case PCI_EXP_TYPE_PCI_BRIDGE:
+	case PCI_EXP_TYPE_RC_EC:
+		return false;
+	/*
+	 * PCIe 3.0, 6.12.1.1 specifies that downstream and root ports should
+	 * implement ACS in order to indicate their peer-to-peer capabilities,
+	 * regardless of whether they are single- or multi-function devices.
+	 */
+	case PCI_EXP_TYPE_DOWNSTREAM:
+	case PCI_EXP_TYPE_ROOT_PORT:
+		return pci_acs_flags_enabled(pdev, acs_flags);
+	/*
+	 * PCIe 3.0, 6.12.1.2 specifies ACS capabilities that should be
+	 * implemented by the remaining PCIe types to indicate peer-to-peer
+	 * capabilities, but only when they are part of a multifunciton
+	 * device.  The footnote for section 6.12 indicates the specific
+	 * PCIe types included here.
+	 */
+	case PCI_EXP_TYPE_ENDPOINT:
+	case PCI_EXP_TYPE_UPSTREAM:
+	case PCI_EXP_TYPE_LEG_END:
+	case PCI_EXP_TYPE_RC_END:
+		if (!pdev->multifunction)
+			break;
+
 		acs_flags &= (PCI_ACS_RR | PCI_ACS_CR |
 			      PCI_ACS_EC | PCI_ACS_DT);
 
-	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM ||
-	    pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT ||
-	    pdev->multifunction) {
-		pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ACS);
-		if (!pos)
-			return false;
-
-		pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
-		if ((ctrl & acs_flags) != acs_flags)
-			return false;
+		return pci_acs_flags_enabled(pdev, acs_flags);
 	}
 
+	/*
+	 * PCIe 3.0, 6.12.1.3 specifies no ACS capabilties are applicable
+	 * to single function devices with the exception of downstream ports.
+	 */
 	return true;
 }
 

