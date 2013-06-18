Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3FRLtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:49:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56284 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3FRLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 83/93] md/raid1,raid10: use freeze_array in place of raise_barrier in various places.
Date: Tue, 18 Jun 2013 12:43:31 +0100
Message-Id: <1371555821-12820-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit e2d59925221cd562e07fee38ec8839f7209ae603 upstream.

Various places in raid1 and raid10 are calling raise_barrier when they
really should call freeze_array.
The former is only intended to be called from "make_request".
The later has extra checks for 'nr_queued' and makes a call to
flush_pending_writes(), so it is safe to call it from within the
management thread.

Using raise_barrier will sometimes deadlock.  Using freeze_array
should not.

As 'freeze_array' currently expects one request to be pending (in
handle_read_error - the only previous caller), we need to pass
it the number of pending requests (extra) to ignore.

The deadlock was made particularly noticeable by commits
050b66152f87c7 (raid10) and 6b740b8d79252f13 (raid1) which
appeared in 3.4, so the fix is appropriate for any -stable
kernel since then.

This patch probably won't apply directly to some early kernels and
will need to be applied by hand.

Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid1.c  | 22 +++++++++++-----------
 drivers/md/raid10.c | 14 +++++++-------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index adba2e7..aa58c02 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -812,17 +812,17 @@ static void allow_barrier(struct r1conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void freeze_array(struct r1conf *conf)
+static void freeze_array(struct r1conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
 	 * go quite.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until nr_pending match nr_queued+1
+	 * wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
 	 * will be blocked by nr_pending, and we need to wait for
 	 * pending IO requests to complete or be queued for re-try.
-	 * Thus the number queued (nr_queued) plus this request (1)
+	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
@@ -830,7 +830,7 @@ static void freeze_array(struct r1conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 	spin_unlock_irq(&conf->resync_lock);
@@ -1429,8 +1429,8 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf);
-		lower_barrier(conf);
+		freeze_array(conf, 0);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -1478,11 +1478,11 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			 */
 			struct md_rdev *repl =
 				conf->mirrors[conf->raid_disks + number].rdev;
-			raise_barrier(conf);
+			freeze_array(conf, 0);
 			clear_bit(Replacement, &repl->flags);
 			p->rdev = repl;
 			conf->mirrors[conf->raid_disks + number].rdev = NULL;
-			lower_barrier(conf);
+			unfreeze_array(conf);
 			clear_bit(WantReplacement, &rdev->flags);
 		} else
 			clear_bit(WantReplacement, &rdev->flags);
@@ -2099,7 +2099,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * frozen
 	 */
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
@@ -2862,7 +2862,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
 
-	raise_barrier(conf);
+	freeze_array(conf, 0);
 
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
@@ -2894,7 +2894,7 @@ static int raid1_reshape(struct mddev *mddev)
 	mddev->delta_disks = 0;
 
 	conf->last_used = 0; /* just make sure it is in-range */
-	lower_barrier(conf);
+	unfreeze_array(conf);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9dd81d9..e76227e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -995,17 +995,17 @@ static void allow_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void freeze_array(struct r10conf *conf)
+static void freeze_array(struct r10conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
 	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until nr_pending match nr_queued+1
+	 * wait until nr_pending match nr_queued+extra
 	 * This is called in the context of one normal IO request
 	 * that has failed. Thus any sync request that might be pending
 	 * will be blocked by nr_pending, and we need to wait for
 	 * pending IO requests to complete or be queued for re-try.
-	 * Thus the number queued (nr_queued) plus this request (1)
+	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
@@ -1013,7 +1013,7 @@ static void freeze_array(struct r10conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 
@@ -1715,8 +1715,8 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		 * we wait for all outstanding requests to complete.
 		 */
 		synchronize_sched();
-		raise_barrier(conf, 0);
-		lower_barrier(conf);
+		freeze_array(conf, 0);
+		unfreeze_array(conf);
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
@@ -2509,7 +2509,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	r10_bio->devs[slot].bio = NULL;
 
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	} else
-- 
1.8.1.2

