Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbbA2Jm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:42:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44839 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932277AbbA2JFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wei Yang <weiyang@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 100/176] vfio-pci: Fix the check on pci device type in vfio_pci_probe()
Date: Wed, 28 Jan 2015 15:28:50 +0100
Message-Id: <da5c0ae9a3434ad6d27c8010116ef05195862355.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yang <weiyang@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7c2e211f3c95b91912a92a8c6736343690042e2e upstream.

Current vfio-pci just supports normal pci device, so vfio_pci_probe() will
return if the pci device is not a normal device. While current code makes a
mistake. PCI_HEADER_TYPE is the offset in configuration space of the device
type, but we use this value to mask the type value.

This patch fixs this by do the check directly on the pci_dev->hdr_type.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vfio/pci/vfio_pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6ab71b9fcf8d..275aa3fc4087 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -821,13 +821,11 @@ static const struct vfio_device_ops vfio_pci_ops = {
 
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
2.2.2

