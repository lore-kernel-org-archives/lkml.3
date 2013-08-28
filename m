Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3H1Osz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:48:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3H1Osx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:48:53 -0400
Subject: [PATCH] vfio-pci: Test for extended config space
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Wed, 28 Aug 2013 08:48:52 -0600
Message-ID: <20130828144813.9104.39850.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having PCIe/PCI-X capability isn't enough to assume that there are
extended capabilities.  Both specs define that the first capability
header is all zero if there are no extended capabilities.  Testing
for this avoids an erroneous message about hiding capability 0x0 at
offset 0x100.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8477963..bcf3624 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1069,6 +1069,7 @@ static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
 static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	u32 dword;
 	u16 word;
 	u8 byte;
 	int ret;
@@ -1082,7 +1083,9 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 			return pcibios_err_to_errno(ret);
 
 		if (PCI_X_CMD_VERSION(word)) {
-			vdev->extended_caps = true;
+			/* Test for extended capabilities */
+			pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
+			vdev->extended_caps = (dword != 0);
 			return PCI_CAP_PCIX_SIZEOF_V2;
 		} else
 			return PCI_CAP_PCIX_SIZEOF_V0;
@@ -1094,9 +1097,11 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 
 		return byte;
 	case PCI_CAP_ID_EXP:
-		/* length based on version */
-		vdev->extended_caps = true;
+		/* Test for extended capabilities */
+		pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
+		vdev->extended_caps = (dword != 0);
 
+		/* length based on version */
 		if ((pcie_caps_reg(pdev) & PCI_EXP_FLAGS_VERS) == 1)
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
 		else

