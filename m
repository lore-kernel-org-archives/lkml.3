Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaAaPHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:07:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657AbaAaPHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:07:40 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jon Mason <jdmason@kudzu.us>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 22/34] vxge: Use pci_enable_msix_range()
Date: Fri, 31 Jan 2014 16:08:41 +0100
Message-Id: <8eb335d8fbd229124db20e89d81a391faee2567d.1391172839.git.agordeev@redhat.com>
In-Reply-To: <cover.1391172839.git.agordeev@redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 1ded50ca..d6682ed 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2352,12 +2352,18 @@ start:
 	vdev->vxge_entries[j].entry = VXGE_ALARM_MSIX_ID;
 	vdev->vxge_entries[j].in_use = 0;
 
-	ret = pci_enable_msix(vdev->pdev, vdev->entries, vdev->intr_cnt);
-	if (ret > 0) {
+	ret = pci_enable_msix_range(vdev->pdev,
+				    vdev->entries, 3, vdev->intr_cnt);
+	if (ret < 0) {
+		ret = -ENODEV;
+		goto enable_msix_failed;
+	} else if (ret < vdev->intr_cnt) {
+		pci_disable_msix(vdev->pdev);
+
 		vxge_debug_init(VXGE_ERR,
 			"%s: MSI-X enable failed for %d vectors, ret: %d",
 			VXGE_DRIVER_NAME, vdev->intr_cnt, ret);
-		if ((max_config_vpath != VXGE_USE_DEFAULT) || (ret < 3)) {
+		if (max_config_vpath != VXGE_USE_DEFAULT) {
 			ret = -ENODEV;
 			goto enable_msix_failed;
 		}
@@ -2371,9 +2377,6 @@ start:
 		vxge_close_vpaths(vdev, temp);
 		vdev->no_of_vpath = temp;
 		goto start;
-	} else if (ret < 0) {
-		ret = -ENODEV;
-		goto enable_msix_failed;
 	}
 	return 0;
 
-- 
1.7.7.6

