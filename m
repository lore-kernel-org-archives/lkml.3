Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FEGDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:03:32 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48834 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3FEGD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:03:29 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: fix crash on rmmod
Date: Wed,  5 Jun 2013 16:03:14 +1000
Message-Id: <1370412194-32211-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devtmpfs_delete_node() calls devnode() callback with mode==NULL but
vfio still tries to write there.

The patch fixes this.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

---

Steps to reproduce on freshly booted system with no devices given to VFIO:
modprobe vfio
rmmod vfio_iommu_spapr_tce
rmmod vfio
---
 drivers/vfio/vfio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 523c121..259ad28 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1360,7 +1360,7 @@ static const struct file_operations vfio_device_fops = {
  */
 static char *vfio_devnode(struct device *dev, umode_t *mode)
 {
-	if (MINOR(dev->devt) == 0)
+	if (mode && (MINOR(dev->devt) == 0))
 		*mode = S_IRUGO | S_IWUGO;
 
 	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
-- 
1.7.10.4

