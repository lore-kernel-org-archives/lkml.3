Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968Ab3BTA1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:27:33 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:35587 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934889Ab3BTAXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:06 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 15/27] raid1: use bio_reset()
Date: Tue, 19 Feb 2013 16:22:29 -0800
Message-Id: <1361319761-23873-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3dbdb3d..e3f98d2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1859,7 +1859,7 @@ static int process_checks(struct r1bio *r1_bio)
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
 
-		if (r1_bio->bios[i]->bi_end_io != end_sync_read)
+		if (sbio->bi_end_io != end_sync_read)
 			continue;
 
 		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
@@ -1884,16 +1884,15 @@ static int process_checks(struct r1bio *r1_bio)
 			continue;
 		}
 		/* fixup the bio for reuse */
+		bio_reset(sbio);
 		sbio->bi_vcnt = vcnt;
 		sbio->bi_size = r1_bio->sectors << 9;
-		sbio->bi_idx = 0;
-		sbio->bi_phys_segments = 0;
-		sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		sbio->bi_flags |= 1 << BIO_UPTODATE;
-		sbio->bi_next = NULL;
 		sbio->bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		sbio->bi_end_io = end_sync_read;
+		sbio->bi_private = r1_bio;
+
 		size = sbio->bi_size;
 		for (j = 0; j < vcnt ; j++) {
 			struct bio_vec *bi;
@@ -2436,18 +2435,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
 		bio = r1_bio->bios[i];
-
-		/* take from bio_init */
-		bio->bi_next = NULL;
-		bio->bi_flags &= ~(BIO_POOL_MASK-1);
-		bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_rw = READ;
-		bio->bi_vcnt = 0;
-		bio->bi_idx = 0;
-		bio->bi_phys_segments = 0;
-		bio->bi_size = 0;
-		bio->bi_end_io = NULL;
-		bio->bi_private = NULL;
+		bio_reset(bio);
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
-- 
1.7.12

