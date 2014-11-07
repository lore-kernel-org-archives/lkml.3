Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKGB7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:59:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaKGB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:59:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Apply _HPX link control for all supported pcie device
Date: Thu,  6 Nov 2014 17:59:40 -0800
Message-Id: <1415325580-5974-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
and following commits, we apply _HPX for pci devices.

that is called via pci_scan_slot
			==>pci_scan_single_device
				==>pci_device_add
					==>pci_configure_device
						==>program_hpp_type2
and dev->subordinate is not allocated yet.

So that link control setup get skipped.

Acoording to ACPI spec, there is no requirement that need to be set to pcie
root port or downstream port.

We could just change to pcie_cap_has_lnkctl to cover all pcie devices with
link control cap.

Fixes: 6cd33649fa83 ("PCI: Add pci_configure_device() during enumeration")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/access.c |   13 -------------
 drivers/pci/pci.h    |   13 +++++++++++++
 drivers/pci/probe.c  |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1323,7 +1323,7 @@ static void program_hpp_type2(struct pci
 			~hpp->pci_exp_devctl_and, hpp->pci_exp_devctl_or);
 
 	/* Initialize Link Control Register */
-	if (dev->subordinate)
+	if (pcie_cap_has_lnkctl(dev))
 		pcie_capability_clear_and_set_word(dev, PCI_EXP_LNKCTL,
 			~hpp->pci_exp_lnkctl_and, hpp->pci_exp_lnkctl_or);
 
Index: linux-2.6/drivers/pci/access.c
===================================================================
--- linux-2.6.orig/drivers/pci/access.c
+++ linux-2.6/drivers/pci/access.c
@@ -444,19 +444,6 @@ static inline int pcie_cap_version(const
 	return pcie_caps_reg(dev) & PCI_EXP_FLAGS_VERS;
 }
 
-static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
-{
-	int type = pci_pcie_type(dev);
-
-	return type == PCI_EXP_TYPE_ENDPOINT ||
-	       type == PCI_EXP_TYPE_LEG_END ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
-	       type == PCI_EXP_TYPE_UPSTREAM ||
-	       type == PCI_EXP_TYPE_DOWNSTREAM ||
-	       type == PCI_EXP_TYPE_PCI_BRIDGE ||
-	       type == PCI_EXP_TYPE_PCIE_BRIDGE;
-}
-
 static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -6,6 +6,19 @@
 
 extern const unsigned char pcie_link_speed[];
 
+static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
+{
+	int type = pci_pcie_type(dev);
+
+	return type == PCI_EXP_TYPE_ENDPOINT ||
+	       type == PCI_EXP_TYPE_LEG_END ||
+	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	       type == PCI_EXP_TYPE_UPSTREAM ||
+	       type == PCI_EXP_TYPE_DOWNSTREAM ||
+	       type == PCI_EXP_TYPE_PCI_BRIDGE ||
+	       type == PCI_EXP_TYPE_PCIE_BRIDGE;
+}
+
 /* Functions internal to the PCI core code */
 
 int pci_create_sysfs_dev_files(struct pci_dev *pdev);
