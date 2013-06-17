Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3FQRgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:36:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3FQRgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 84/84] md/raid1,5,10: Disable WRITE SAME until a recovery strategy is in place
Date: Mon, 17 Jun 2013 10:31:28 -0700
Message-Id: <1371490288-23167-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 5026d7a9b2f3eb1f9bda66c18ac6bc3036ec9020 upstream.

There are cases where the kernel will believe that the WRITE SAME
command is supported by a block device which does not, in fact,
support WRITE SAME.  This currently happens for SATA drivers behind a
SAS controller, but there are probably a hundred other ways that can
happen, including drive firmware bugs.

After receiving an error for WRITE SAME the block layer will retry the
request as a plain write of zeroes, but mdraid will consider the
failure as fatal and consider the drive failed.  This has the effect
that all the mirrors containing a specific set of data are each
offlined in very rapid succession resulting in data loss.

However, just bouncing the request back up to the block layer isn't
ideal either, because the whole initial request-retry sequence should
be inside the write bitmap fence, which probably means that md needs
to do its own conversion of WRITE SAME to write zero.

Until the failure scenario has been sorted out, disable WRITE SAME for
raid1, raid5, and raid10.

[neilb: added raid5]

This patch is appropriate for any -stable since 3.7 when write_same
support was added.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c  | 4 ++--
 drivers/md/raid10.c | 3 +--
 drivers/md/raid5.c  | 4 +++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3dab5bb..7116798 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2837,8 +2837,8 @@ static int run(struct mddev *mddev)
 		return PTR_ERR(conf);
 
 	if (mddev->queue)
-		blk_queue_max_write_same_sectors(mddev->queue,
-						 mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue, 0);
+
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fa1e11c..2f4be3c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3588,8 +3588,7 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
-		blk_queue_max_write_same_sectors(mddev->queue,
-						 mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, chunk_size);
 		if (conf->geo.raid_disks % conf->geo.near_copies)
 			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 94ce78e..9a6ff72 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5494,7 +5494,7 @@ static int run(struct mddev *mddev)
 		if (mddev->major_version == 0 &&
 		    mddev->minor_version > 90)
 			rdev->recovery_offset = reshape_offset;
-			
+
 		if (rdev->recovery_offset < reshape_offset) {
 			/* We need to check old and new layout */
 			if (!only_parity(rdev->raid_disk,
@@ -5617,6 +5617,8 @@ static int run(struct mddev *mddev)
 		 */
 		mddev->queue->limits.discard_zeroes_data = 0;
 
+		blk_queue_max_write_same_sectors(mddev->queue, 0);
+
 		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
-- 
1.8.1.2

