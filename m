Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935060Ab3BNW3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:29:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3BNW1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6/9] drm/pci: move drm_pcie_get_speed_cap_mask inside #ifdef CONFIG_PCI
Date: Thu, 14 Feb 2013 23:26:55 +0100
Message-Id: <1360880818-4071454-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TnFBuvQGFahsGVBCYxjHhNc8sr7Ht9zUxInpNYiuHFa
 uzl/t9yWan2hWHJ0GneCqDGQ51EXJJWH9lgmMnLcl8wJ0Wq//L
 4rY/JPpNQbZoID9sYdODLrXCO8XIPIAhslf4DvB3px1hZ5LXxm
 hJ4lV/4Jn26INQnm2LFM0Xb8e29Fbo1yDuJnBeo8wySpgR04B+
 9syl4m5oHUa39JW3WwS/ti9rnwtYtpalCGdMAU1KuIusJ3glEy
 FPPEFIo6/6248MdghXpfloCIzhU1L4AROYpfCfOouAi+jPTYVG
 Xs7Rnu237Kjay7A7VZum6bExEOpXb4PHRmaVjPq9L4Ky9Nr5Kc
 ZDJUezrrhpFDcmG42JcTaIV2Sqi5uFBo012RJ//Gu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dd66cc2e1  "drm/pci: Use PCI Express Capability accessors"
introduced the use of the pcie_capability_read_dword function
in the drm_pci code, which is only defined when PCI is enabled.
While most of the file is already hidden away behind an #ifdef
CONFIG_PCI, this function is not, and that now causes a link
error in the ARM imx_v6_v7_defconfig configuration.

Moving the function into the #ifdef section makes this work
again on IMX, which does not have PCI support, and should
have no impact on platforms that do.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/drm_pci.c | 75 +++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 86102a0..9c408e0 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -388,6 +388,43 @@ err_g1:
 }
 EXPORT_SYMBOL(drm_get_pci_dev);
 
+int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
+{
+	struct pci_dev *root;
+	u32 lnkcap, lnkcap2;
+
+	*mask = 0;
+	if (!dev->pdev)
+		return -EINVAL;
+
+	root = dev->pdev->bus->self;
+
+	/* we've been informed via and serverworks don't make the cut */
+	if (root->vendor == PCI_VENDOR_ID_VIA ||
+	    root->vendor == PCI_VENDOR_ID_SERVERWORKS)
+		return -EINVAL;
+
+	pcie_capability_read_dword(root, PCI_EXP_LNKCAP, &lnkcap);
+	pcie_capability_read_dword(root, PCI_EXP_LNKCAP2, &lnkcap2);
+
+	if (lnkcap2) {	/* PCIe r3.0-compliant */
+		if (lnkcap2 & PCI_EXP_LNKCAP2_SLS_2_5GB)
+			*mask |= DRM_PCIE_SPEED_25;
+		if (lnkcap2 & PCI_EXP_LNKCAP2_SLS_5_0GB)
+			*mask |= DRM_PCIE_SPEED_50;
+		if (lnkcap2 & PCI_EXP_LNKCAP2_SLS_8_0GB)
+			*mask |= DRM_PCIE_SPEED_80;
+	} else {	/* pre-r3.0 */
+		if (lnkcap & PCI_EXP_LNKCAP_SLS_2_5GB)
+			*mask |= DRM_PCIE_SPEED_25;
+		if (lnkcap & PCI_EXP_LNKCAP_SLS_5_0GB)
+			*mask |= (DRM_PCIE_SPEED_25 | DRM_PCIE_SPEED_50);
+	}
+
+	DRM_INFO("probing gen 2 caps for device %x:%x = %x/%x\n", root->vendor, root->device, lnkcap, lnkcap2);
+	return 0;
+}
+EXPORT_SYMBOL(drm_pcie_get_speed_cap_mask);
 /**
  * PCI device initialization. Called direct from modules at load time.
  *
@@ -465,41 +502,3 @@ void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
 	DRM_INFO("Module unloaded\n");
 }
 EXPORT_SYMBOL(drm_pci_exit);
-
-int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
-{
-	struct pci_dev *root;
-	u32 lnkcap, lnkcap2;
-
-	*mask = 0;
-	if (!dev->pdev)
-		return -EINVAL;
-
-	root = dev->pdev->bus->self;
-
-	/* we've been informed via and serverworks don't make the cut */
-	if (root->vendor == PCI_VENDOR_ID_VIA ||
-	    root->vendor == PCI_VENDOR_ID_SERVERWORKS)
-		return -EINVAL;
-
-	pcie_capability_read_dword(root, PCI_EXP_LNKCAP, &lnkcap);
-	pcie_capability_read_dword(root, PCI_EXP_LNKCAP2, &lnkcap2);
-
-	if (lnkcap2) {	/* PCIe r3.0-compliant */
-		if (lnkcap2 & PCI_EXP_LNKCAP2_SLS_2_5GB)
-			*mask |= DRM_PCIE_SPEED_25;
-		if (lnkcap2 & PCI_EXP_LNKCAP2_SLS_5_0GB)
-			*mask |= DRM_PCIE_SPEED_50;
-		if (lnkcap2 & PCI_EXP_LNKCAP2_SLS_8_0GB)
-			*mask |= DRM_PCIE_SPEED_80;
-	} else {	/* pre-r3.0 */
-		if (lnkcap & PCI_EXP_LNKCAP_SLS_2_5GB)
-			*mask |= DRM_PCIE_SPEED_25;
-		if (lnkcap & PCI_EXP_LNKCAP_SLS_5_0GB)
-			*mask |= (DRM_PCIE_SPEED_25 | DRM_PCIE_SPEED_50);
-	}
-
-	DRM_INFO("probing gen 2 caps for device %x:%x = %x/%x\n", root->vendor, root->device, lnkcap, lnkcap2);
-	return 0;
-}
-EXPORT_SYMBOL(drm_pcie_get_speed_cap_mask);
-- 
1.8.1.2

