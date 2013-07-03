Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab3GCTQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:16:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590Ab3GCTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:14 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=sbf8MFaj2Z8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=HAb6J9uHviEA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=UoAF1NFOBYuNlcyhXvwA:9 a=0kPLrQdw3YYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=yN2z2FX-Bw-xYyB3:21 a=VMk5PsTzsxMw3sTX:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184108.105162710@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [129/141] md/raid1,raid10: use freeze_array in place of raise_barrier in
 various places.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0129-md-raid1-raid10-use-freeze_array-in-place-of-raise_b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit e2d59925221cd562e07fee38ec8839f7209ae603 ]

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

Cc: stable@vger.kernel.org
Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/raid1.c  |   22 +++++++++++-----------
 drivers/md/raid10.c |   14 +++++++-------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cda27cb..4347a70 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -886,17 +886,17 @@ static void allow_barrier(struct r1conf *conf)
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
@@ -904,7 +904,7 @@ static void freeze_array(struct r1conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 	spin_unlock_irq(&conf->resync_lock);
@@ -1559,8 +1559,8 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -1608,11 +1608,11 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -2229,7 +2229,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * frozen
 	 */
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, r1_bio->read_disk,
 			       r1_bio->sector, r1_bio->sectors);
 		unfreeze_array(conf);
@@ -2993,7 +2993,7 @@ static int raid1_reshape(struct mddev *mddev)
 		return -ENOMEM;
 	}
 
-	raise_barrier(conf);
+	freeze_array(conf, 0);
 
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
@@ -3024,7 +3024,7 @@ static int raid1_reshape(struct mddev *mddev)
 	conf->raid_disks = mddev->raid_disks = raid_disks;
 	mddev->delta_disks = 0;
 
-	lower_barrier(conf);
+	unfreeze_array(conf);
 
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5c3fb0b..cd7394b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1021,17 +1021,17 @@ static void allow_barrier(struct r10conf *conf)
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
@@ -1039,7 +1039,7 @@ static void freeze_array(struct r10conf *conf)
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->nr_pending == conf->nr_queued+1,
+			    conf->nr_pending == conf->nr_queued+extra,
 			    conf->resync_lock,
 			    flush_pending_writes(conf));
 
@@ -1740,8 +1740,8 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -2534,7 +2534,7 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	r10_bio->devs[slot].bio = NULL;
 
 	if (mddev->ro == 0) {
-		freeze_array(conf);
+		freeze_array(conf, 1);
 		fix_read_error(conf, mddev, r10_bio);
 		unfreeze_array(conf);
 	} else
-- 
1.7.10.4


