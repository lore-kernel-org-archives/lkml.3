Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3BCBfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:35:48 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:49793 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3BCBVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:37 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>, drbd-dev@lists.linbit.com,
        drbd-user@lists.linbit.com
Subject: [PATCH 10/62] drbd: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:11 -0800
Message-Id: <1359854463-2538-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: drbd-dev@lists.linbit.com
Cc: drbd-user@lists.linbit.com
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/block/drbd/drbd_main.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8c13eeb..e98da67 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2660,25 +2660,24 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	mdev->read_requests = RB_ROOT;
 	mdev->write_requests = RB_ROOT;
 
-	if (!idr_pre_get(&minors, GFP_KERNEL))
-		goto out_no_minor_idr;
-	if (idr_get_new_above(&minors, mdev, minor, &minor_got))
+	minor_got = idr_alloc(&minors, mdev, minor, minor + 1, GFP_KERNEL);
+	if (minor_got < 0) {
+		if (minor_got == -ENOSPC) {
+			err = ERR_MINOR_EXISTS;
+			drbd_msg_put_info("requested minor exists already");
+		}
 		goto out_no_minor_idr;
-	if (minor_got != minor) {
-		err = ERR_MINOR_EXISTS;
-		drbd_msg_put_info("requested minor exists already");
-		goto out_idr_remove_minor;
 	}
 
-	if (!idr_pre_get(&tconn->volumes, GFP_KERNEL))
-		goto out_idr_remove_minor;
-	if (idr_get_new_above(&tconn->volumes, mdev, vnr, &vnr_got))
+	vnr_got = idr_alloc(&tconn->volumes, mdev, vnr, vnr + 1, GFP_KERNEL);
+	if (vnr_got < 0) {
+		if (vnr_got == -ENOSPC) {
+			err = ERR_INVALID_REQUEST;
+			drbd_msg_put_info("requested volume exists already");
+		}
 		goto out_idr_remove_minor;
-	if (vnr_got != vnr) {
-		err = ERR_INVALID_REQUEST;
-		drbd_msg_put_info("requested volume exists already");
-		goto out_idr_remove_vol;
 	}
+
 	add_disk(disk);
 	kref_init(&mdev->kref); /* one ref for both idrs and the the add_disk */
 
@@ -2689,8 +2688,6 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 
 	return NO_ERROR;
 
-out_idr_remove_vol:
-	idr_remove(&tconn->volumes, vnr_got);
 out_idr_remove_minor:
 	idr_remove(&minors, minor_got);
 	synchronize_rcu();
-- 
1.8.1

