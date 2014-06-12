Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbaFLQoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:44:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbaFLQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:44:17 -0400
Subject: [PATCH] vfio/pci: Add extra test for extended capabilities
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 12 Jun 2014 10:44:17 -0600
Message-ID: <20140612164349.9739.53824.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PCI core set cfg_size isn't large enough for extended
capabilities, then they're not there.  Extended config space may be
inaccessible due to a PCI bridge, in which case cfg_size may be cut
short.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 83cd157..4a62a37 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1027,8 +1027,11 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 
 		if (PCI_X_CMD_VERSION(word)) {
 			/* Test for extended capabilities */
-			pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
-			vdev->extended_caps = (dword != 0);
+			if (pdev->cfg_size > PCI_CFG_SPACE_SIZE) {
+				pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE,
+						      &dword);
+				vdev->extended_caps = (dword != 0);
+			}
 			return PCI_CAP_PCIX_SIZEOF_V2;
 		} else
 			return PCI_CAP_PCIX_SIZEOF_V0;
@@ -1041,8 +1044,10 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 		return byte;
 	case PCI_CAP_ID_EXP:
 		/* Test for extended capabilities */
-		pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
-		vdev->extended_caps = (dword != 0);
+		if (pdev->cfg_size > PCI_CFG_SPACE_SIZE) {
+			pci_read_config_dword(pdev, PCI_CFG_SPACE_SIZE, &dword);
+			vdev->extended_caps = (dword != 0);
+		}
 
 		/* length based on version */
 		if ((pcie_caps_reg(pdev) & PCI_EXP_FLAGS_VERS) == 1)

