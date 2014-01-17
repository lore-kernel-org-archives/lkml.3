Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaAQQBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:01:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAQQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:01:06 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 7/9] vfio: Use pci_enable_msi_range() and pci_enable_msix_range()
Date: Fri, 17 Jan 2014 17:02:21 +0100
Message-Id: <c6523b6507c3aa0ab911e111f501699dce99c3f4.1389904167.git.agordeev@redhat.com>
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 641bc87..4a9db1d 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -482,15 +482,19 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 		for (i = 0; i < nvec; i++)
 			vdev->msix[i].entry = i;
 
-		ret = pci_enable_msix(pdev, vdev->msix, nvec);
-		if (ret) {
+		ret = pci_enable_msix_range(pdev, vdev->msix, 1, nvec);
+		if (ret < nvec) {
+			if (ret > 0)
+				pci_disable_msix(pdev);
 			kfree(vdev->msix);
 			kfree(vdev->ctx);
 			return ret;
 		}
 	} else {
-		ret = pci_enable_msi_block(pdev, nvec);
-		if (ret) {
+		ret = pci_enable_msi_range(pdev, 1, nvec);
+		if (ret < nvec) {
+			if (ret > 0)
+				pci_disable_msi(pdev);
 			kfree(vdev->ctx);
 			return ret;
 		}
-- 
1.7.7.6

