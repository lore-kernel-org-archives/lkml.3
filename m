Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3BCBXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:23:01 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46084 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3BCBWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:55 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 50/62] vfio: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:51 -0800
Message-Id: <1359854463-2538-51-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/vfio/vfio.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 12c264d..0132846 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -139,23 +139,7 @@ EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
  */
 static int vfio_alloc_group_minor(struct vfio_group *group)
 {
-	int ret, minor;
-
-again:
-	if (unlikely(idr_pre_get(&vfio.group_idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
-
-	/* index 0 is used by /dev/vfio/vfio */
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

