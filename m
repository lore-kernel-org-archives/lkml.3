Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab3CSRRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:17:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44617 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab3CSRRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 18/18] drbd: adjust upper limit for activity log extents
Date: Tue, 19 Mar 2013 18:16:59 +0100
Message-Id: <1363713419-17803-19-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Now that the on-disk activity-log ring buffer size is adjustable,
the maximum active set can become larger, and is now limited by
the use of 16bit "labels".

This increases the maximum working set from 6433 to 65534 extents,
each of which covers an area of 4MiB.
Which means that if you use the maximum, you'd have to resync
more than 250 GiB after an unclean Primary shutdown.
With capable backend storage and replication links,
this is entirely feasible.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   47 ++++++++++++++++++++++++++++++++++--------
 include/linux/drbd_limits.h  |   11 +++++-----
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index bcf900b..42fda4a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1141,15 +1141,32 @@ static bool should_set_defaults(struct genl_info *info)
 	return 0 != (flags & DRBD_GENL_F_SET_DEFAULTS);
 }
 
-static void enforce_disk_conf_limits(struct disk_conf *dc)
+static unsigned int drbd_al_extents_max(struct drbd_backing_dev *bdev)
 {
-	if (dc->al_extents < DRBD_AL_EXTENTS_MIN)
-		dc->al_extents = DRBD_AL_EXTENTS_MIN;
-	if (dc->al_extents > DRBD_AL_EXTENTS_MAX)
-		dc->al_extents = DRBD_AL_EXTENTS_MAX;
+	/* This is limited by 16 bit "slot" numbers,
+	 * and by available on-disk context storage.
+	 *
+	 * Also (u16)~0 is special (denotes a "free" extent).
+	 *
+	 * One transaction occupies one 4kB on-disk block,
+	 * we have n such blocks in the on disk ring buffer,
+	 * the "current" transaction may fail (n-1),
+	 * and there is 919 slot numbers context information per transaction.
+	 *
+	 * 72 transaction blocks amounts to more than 2**16 context slots,
+	 * so cap there first.
+	 */
+	const unsigned int max_al_nr = DRBD_AL_EXTENTS_MAX;
+	const unsigned int sufficient_on_disk =
+		(max_al_nr + AL_CONTEXT_PER_TRANSACTION -1)
+		/AL_CONTEXT_PER_TRANSACTION;
 
-	if (dc->c_plan_ahead > DRBD_C_PLAN_AHEAD_MAX)
-		dc->c_plan_ahead = DRBD_C_PLAN_AHEAD_MAX;
+	unsigned int al_size_4k = bdev->md.al_size_4k;
+
+	if (al_size_4k > sufficient_on_disk)
+		return max_al_nr;
+
+	return (al_size_4k - 1) * AL_CONTEXT_PER_TRANSACTION;
 }
 
 int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
@@ -1196,7 +1213,13 @@ int drbd_adm_disk_opts(struct sk_buff *skb, struct genl_info *info)
 	if (!expect(new_disk_conf->resync_rate >= 1))
 		new_disk_conf->resync_rate = 1;
 
-	enforce_disk_conf_limits(new_disk_conf);
+	if (new_disk_conf->al_extents < DRBD_AL_EXTENTS_MIN)
+		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MIN;
+	if (new_disk_conf->al_extents > drbd_al_extents_max(mdev->ldev))
+		new_disk_conf->al_extents = drbd_al_extents_max(mdev->ldev);
+
+	if (new_disk_conf->c_plan_ahead > DRBD_C_PLAN_AHEAD_MAX)
+		new_disk_conf->c_plan_ahead = DRBD_C_PLAN_AHEAD_MAX;
 
 	fifo_size = (new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ;
 	if (fifo_size != mdev->rs_plan_s->size) {
@@ -1344,7 +1367,8 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		goto fail;
 	}
 
-	enforce_disk_conf_limits(new_disk_conf);
+	if (new_disk_conf->c_plan_ahead > DRBD_C_PLAN_AHEAD_MAX)
+		new_disk_conf->c_plan_ahead = DRBD_C_PLAN_AHEAD_MAX;
 
 	new_plan = fifo_alloc((new_disk_conf->c_plan_ahead * 10 * SLEEP_TIME) / HZ);
 	if (!new_plan) {
@@ -1419,6 +1443,11 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto fail;
 
+	if (new_disk_conf->al_extents < DRBD_AL_EXTENTS_MIN)
+		new_disk_conf->al_extents = DRBD_AL_EXTENTS_MIN;
+	if (new_disk_conf->al_extents > drbd_al_extents_max(nbc))
+		new_disk_conf->al_extents = drbd_al_extents_max(nbc);
+
 	if (drbd_get_max_capacity(nbc) < new_disk_conf->disk_size) {
 		dev_err(DEV, "max capacity %llu smaller than disk size %llu\n",
 			(unsigned long long) drbd_get_max_capacity(nbc),
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 1fa19c5..1fedf2b 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -126,13 +126,12 @@
 #define DRBD_RESYNC_RATE_DEF 250
 #define DRBD_RESYNC_RATE_SCALE 'k'  /* kilobytes */
 
-  /* less than 7 would hit performance unnecessarily.
-   * 919 slots context information per transaction,
-   * 32k activity log, 4k transaction size,
-   * one transaction in flight:
-   * 919 * 7 = 6433 */
+  /* less than 7 would hit performance unnecessarily. */
 #define DRBD_AL_EXTENTS_MIN  7
-#define DRBD_AL_EXTENTS_MAX  6433
+  /* we use u16 as "slot number", (u16)~0 is "FREE".
+   * If you use >= 292 kB on-disk ring buffer,
+   * this is the maximum you can use: */
+#define DRBD_AL_EXTENTS_MAX  0xfffe
 #define DRBD_AL_EXTENTS_DEF  1237
 #define DRBD_AL_EXTENTS_SCALE '1'
 
-- 
1.7.9.5

