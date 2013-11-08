Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab3KHCVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:21:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab3KHCVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 61/91] raid5: set bio bi_vcnt 0 for discard request
Date: Thu,  7 Nov 2013 18:15:16 -0800
Message-Id: <1383876946-2396-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit 37c61ff31e9b5e3fcf3cc6579f5c68f6ad40c4b1 upstream.

SCSI layer will add new payload for discard request. If two bios are merged
to one, the second bio has bi_vcnt 1 which is set in raid5. This will confuse
SCSI and cause oops.

Suitable for backport to 3.7+

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid5.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5b022b1..7ace380 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -672,6 +672,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
+			/*
+			 * If this is discard request, set bi_vcnt 0. We don't
+			 * want to confuse SCSI because SCSI will replace payload
+			 */
+			if (rw & REQ_DISCARD)
+				bi->bi_vcnt = 0;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 
@@ -706,6 +712,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_size = STRIPE_SIZE;
 			rbi->bi_next = NULL;
+			/*
+			 * If this is discard request, set bi_vcnt 0. We don't
+			 * want to confuse SCSI because SCSI will replace payload
+			 */
+			if (rw & REQ_DISCARD)
+				rbi->bi_vcnt = 0;
 			if (conf->mddev->gendisk)
 				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 						      rbi, disk_devt(conf->mddev->gendisk),
-- 
1.8.1.2

