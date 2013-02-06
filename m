Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab3BFTvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:51:25 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39999 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab3BFTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:10 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        kvm@vger.kernel.org
Subject: [PATCH 66/77] vfio: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:38 -0800
Message-Id: <1360179649-22465-67-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

v2: Restore accidentally dropped "index 0" comment as suggested by
    Alex.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
---
 drivers/vfio/vfio.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 12c264d..7f61abf 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -139,23 +139,8 @@ EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
  */
 static int vfio_alloc_group_minor(struct vfio_group *group)
 {
-	int ret, minor;
-
-again:
-	if (unlikely(idr_pre_get(&vfio.group_idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
-
 	/* index 0 is used by /dev/vfio/vfio */
-	ret = idr_get_new_above(&vfio.group_idr, group, 1, &minor);
-	if (ret == -EAGAIN)
-		goto again;
-	if (ret || minor > MINORMASK) {
-		if (minor > MINORMASK)
-			idr_remove(&vfio.group_idr, minor);
-		return -ENOSPC;
-	}
-
-	return minor;
+	return idr_alloc(&vfio.group_idr, group, 1, MINORMASK + 1, GFP_KERNEL);
 }
 
 static void vfio_free_group_minor(int minor)
-- 
1.8.1

