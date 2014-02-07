Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaBGNUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:20:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaBGLsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrei Warkentin <andreiw@vmware.com>, NeilBrown <neilb@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 027/233] md: fix problem when adding device to read-only array with bitmap.
Date: Fri,  7 Feb 2014 11:44:06 +0000
Message-Id: <1391773652-25214-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97 upstream.

If an array is started degraded, and then the missing device
is found it can be re-added and a minimal bitmap-based recovery
will bring it fully up-to-date.

If the array is read-only a recovery would not be allowed.
But also if the array is read-only and the missing device was
present very recently, then there could be no need for any
recovery at all, so we simply include the device in the read-only
array without any recovery.

However... if the missing device was removed a little longer ago
it could be missing some updates, but if a bitmap is present it will
be conditionally accepted pending a bitmap-based update.  We don't
currently detect this case properly and will include that old
device into the read-only array with no recovery even though it really
needs a recovery.

This patch keeps track of whether a bitmap-based-recovery is really
needed or not in the new Bitmap_sync rdev flag.  If that is set,
then the device will not be added to a read-only array.

Cc: Andrei Warkentin <andreiw@vmware.com>
Fixes: d70ed2e4fafdbef0800e73942482bb075c21578b
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/md.c | 18 +++++++++++++++---
 drivers/md/md.h |  3 +++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a7e8d32..c4b3364 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1119,6 +1119,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 	rdev->raid_disk = -1;
 	clear_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
+	clear_bit(Bitmap_sync, &rdev->flags);
 	clear_bit(WriteMostly, &rdev->flags);
 
 	if (mddev->raid_disks == 0) {
@@ -1197,6 +1198,8 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 		 */
 		if (ev1 < mddev->bitmap->events_cleared)
 			return 0;
+		if (ev1 < mddev->events)
+			set_bit(Bitmap_sync, &rdev->flags);
 	} else {
 		if (ev1 < mddev->events)
 			/* just a hot-add of a new device, leave raid_disk at -1 */
@@ -1605,6 +1608,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 	rdev->raid_disk = -1;
 	clear_bit(Faulty, &rdev->flags);
 	clear_bit(In_sync, &rdev->flags);
+	clear_bit(Bitmap_sync, &rdev->flags);
 	clear_bit(WriteMostly, &rdev->flags);
 
 	if (mddev->raid_disks == 0) {
@@ -1687,6 +1691,8 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
 		 */
 		if (ev1 < mddev->bitmap->events_cleared)
 			return 0;
+		if (ev1 < mddev->events)
+			set_bit(Bitmap_sync, &rdev->flags);
 	} else {
 		if (ev1 < mddev->events)
 			/* just a hot-add of a new device, leave raid_disk at -1 */
@@ -2830,6 +2836,7 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		else
 			rdev->saved_raid_disk = -1;
 		clear_bit(In_sync, &rdev->flags);
+		clear_bit(Bitmap_sync, &rdev->flags);
 		err = rdev->mddev->pers->
 			hot_add_disk(rdev->mddev, rdev);
 		if (err) {
@@ -5770,6 +5777,7 @@ static int add_new_disk(struct mddev * mddev, mdu_disk_info_t *info)
 			    info->raid_disk < mddev->raid_disks) {
 				rdev->raid_disk = info->raid_disk;
 				set_bit(In_sync, &rdev->flags);
+				clear_bit(Bitmap_sync, &rdev->flags);
 			} else
 				rdev->raid_disk = -1;
 		} else
@@ -7713,7 +7721,8 @@ static int remove_and_add_spares(struct mddev *mddev,
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		if (mddev->ro &&
-		    rdev->saved_raid_disk < 0)
+		    ! (rdev->saved_raid_disk >= 0 &&
+		       !test_bit(Bitmap_sync, &rdev->flags)))
 			continue;
 
 		rdev->recovery_offset = 0;
@@ -7794,9 +7803,12 @@ void md_check_recovery(struct mddev *mddev)
 			 * As we only add devices that are already in-sync,
 			 * we can activate the spares immediately.
 			 */
-			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			remove_and_add_spares(mddev, NULL);
-			mddev->pers->spare_active(mddev);
+			/* There is no thread, but we need to call
+			 * ->spare_active and clear saved_raid_disk
+			 */
+			md_reap_sync_thread(mddev);
+			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			goto unlock;
 		}
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 20f02c0..fcac995 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -129,6 +129,9 @@ struct md_rdev {
 enum flag_bits {
 	Faulty,			/* device is known to have a fault */
 	In_sync,		/* device is in_sync with rest of array */
+	Bitmap_sync,		/* ..actually, not quite In_sync.  Need a
+				 * bitmap-based recovery to get fully in sync
+				 */
 	Unmerged,		/* device is being added to array and should
 				 * be considerred for bvec_merge_fn but not
 				 * yet for actual IO
-- 
1.8.3.2

