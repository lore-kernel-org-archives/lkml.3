Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3C0NMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:12:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44330 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3C0NJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 11/17] drbd: validate resync_after dependency on attach already
Date: Wed, 27 Mar 2013 14:08:43 +0100
Message-Id: <1364389729-17559-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We validated resync_after dependencies, if changed via disk-options.
But we did not validate them when first created via attach.
We also did not check or cleanup dependencies that used to be correct,
but now point to meanwhile removed minor devices.

If the drbd_resync_after_valid() validation in disk-options tried to
follow a dependency chain in this way, this could lead to NULL pointer
dereference.

Validate resync_after settings in drbd_adm_attach() already, as well as
in drbd_adm_disk_opts(), and and only reject dependency loops.
Depending on non-existing disks is allowed and equivalent to no dependency.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c     |    6 ++++++
 drivers/block/drbd/drbd_worker.c |   15 ++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 39e9a91..9e3f441 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1381,6 +1381,12 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
+	write_lock_irq(&global_state_lock);
+	retcode = drbd_resync_after_valid(mdev, new_disk_conf->resync_after);
+	write_unlock_irq(&global_state_lock);
+	if (retcode != NO_ERROR)
+		goto fail;
+
 	rcu_read_lock();
 	nc = rcu_dereference(mdev->tconn->net_conf);
 	if (nc) {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 7f51f88..891c0ec 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1426,7 +1426,7 @@ static int _drbd_may_sync_now(struct drbd_conf *mdev)
 	int resync_after;
 
 	while (1) {
-		if (!odev->ldev)
+		if (!odev->ldev || odev->state.disk == D_DISKLESS)
 			return 1;
 		rcu_read_lock();
 		resync_after = rcu_dereference(odev->ldev->disk_conf)->resync_after;
@@ -1434,7 +1434,7 @@ static int _drbd_may_sync_now(struct drbd_conf *mdev)
 		if (resync_after == -1)
 			return 1;
 		odev = minor_to_mdev(resync_after);
-		if (!expect(odev))
+		if (!odev)
 			return 1;
 		if ((odev->state.conn >= C_SYNC_SOURCE &&
 		     odev->state.conn <= C_PAUSED_SYNC_T) ||
@@ -1516,7 +1516,7 @@ enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor)
 
 	if (o_minor == -1)
 		return NO_ERROR;
-	if (o_minor < -1 || minor_to_mdev(o_minor) == NULL)
+	if (o_minor < -1 || o_minor > MINORMASK)
 		return ERR_RESYNC_AFTER;
 
 	/* check for loops */
@@ -1525,6 +1525,15 @@ enum drbd_ret_code drbd_resync_after_valid(struct drbd_conf *mdev, int o_minor)
 		if (odev == mdev)
 			return ERR_RESYNC_AFTER_CYCLE;
 
+		/* You are free to depend on diskless, non-existing,
+		 * or not yet/no longer existing minors.
+		 * We only reject dependency loops.
+		 * We cannot follow the dependency chain beyond a detached or
+		 * missing minor.
+		 */
+		if (!odev || !odev->ldev || odev->state.disk == D_DISKLESS)
+			return NO_ERROR;
+
 		rcu_read_lock();
 		resync_after = rcu_dereference(odev->ldev->disk_conf)->resync_after;
 		rcu_read_unlock();
-- 
1.7.9.5

