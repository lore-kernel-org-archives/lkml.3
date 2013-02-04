Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3BDQst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:48:49 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40645 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3BDQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:48:48 -0500
Date: Mon, 4 Feb 2013 08:48:42 -0800
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH v2 50/62] vfio: convert to idr_alloc()
Message-ID: <20130204164842.GE27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-51-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-51-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 drivers/vfio/vfio.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -139,23 +139,8 @@ EXPORT_SYMBOL_GPL(vfio_unregister_iommu_
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
