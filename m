Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbbA0Msy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:48:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34896 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309AbbA0MRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 021/126] vfio-pci: Fix the check on pci device type in vfio_pci_probe()
Date: Tue, 27 Jan 2015 12:15:26 +0000
Message-Id: <1422361031-19364-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <weiyang@linux.vnet.ibm.com>

commit 7c2e211f3c95b91912a92a8c6736343690042e2e upstream.

Current vfio-pci just supports normal pci device, so vfio_pci_probe() will
return if the pci device is not a normal device. While current code makes a
mistake. PCI_HEADER_TYPE is the offset in configuration space of the device
type, but we use this value to mask the type value.

This patch fixs this by do the check directly on the pci_dev->hdr_type.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vfio/pci/vfio_pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 010e0f8b8e4f..652ab678160e 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -810,13 +810,11 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	u8 type;
 	struct vfio_pci_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
-	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &type);
-	if ((type & PCI_HEADER_TYPE) != PCI_HEADER_TYPE_NORMAL)
+	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
 		return -EINVAL;
 
 	group = iommu_group_get(&pdev->dev);
-- 
2.1.4

