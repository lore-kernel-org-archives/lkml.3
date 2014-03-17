Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbaCQNco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:32:44 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:55916 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932471AbaCQNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:32:40 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 09:32:40 EDT
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: i4passt@lists.cs.fau.de, neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: [PATCH] md: Fixed issue in raid1 that may lead to data corruption
Date: Mon, 17 Mar 2014 14:22:24 +0100
Message-Id: <1395062544-11321-1-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If data gets damaged on a disk that is part of a RAID-1 array, it is
possible that the damaged data is mirrored to the other disks of the
array.
In the case of a two-disk array this behavior cannot be avoided as there
is no reference which disk contains the intact data.
However, in a configuration with three or more disks it is possible to
compare the data of all array members to find out which version is
probably the right one to clone on all members.
The patch adds this functionality by adding a mechanism that chooses the
disk with the fewest mismatches.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/md/raid1.c | 109 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a6ca1c..645a6e1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1947,6 +1947,12 @@ static int process_checks(struct r1bio *r1_bio)
 	int primary;
 	int i;
 	int vcnt;
+	/* Each time a read block from a device differs from its
+	 * pendant on the other device, its mismatch counter is incremented.
+	 */
+	int mismatch_counter[conf->raid_disks * 2];
+	/* "pointer" to the disk with fewest mismatches */
+	int min_mismatch_disk = -1;
 
 	/* Fix variable parts of all bios */
 	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
@@ -1982,49 +1988,80 @@ static int process_checks(struct r1bio *r1_bio)
 			size -= PAGE_SIZE;
 		}
 	}
-	for (primary = 0; primary < conf->raid_disks * 2; primary++)
-		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
-		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
-			r1_bio->bios[primary]->bi_end_io = NULL;
-			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
-			break;
-		}
-	r1_bio->read_disk = primary;
-	for (i = 0; i < conf->raid_disks * 2; i++) {
-		int j;
-		struct bio *pbio = r1_bio->bios[primary];
-		struct bio *sbio = r1_bio->bios[i];
-		int uptodate = test_bit(BIO_UPTODATE, &sbio->bi_flags);
 
-		if (sbio->bi_end_io != end_sync_read)
+	for (primary = 0; primary < conf->raid_disks * 2; primary++) {
+		if (r1_bio->bios[primary]->bi_end_io != end_sync_read ||
+		    !test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
+			/* ignore this disk for comparison */
+			mismatch_counter[primary] = -1;
 			continue;
-		/* Now we can 'fixup' the BIO_UPTODATE flag */
-		set_bit(BIO_UPTODATE, &sbio->bi_flags);
-
-		if (uptodate) {
-			for (j = vcnt; j-- ; ) {
-				struct page *p, *s;
-				p = pbio->bi_io_vec[j].bv_page;
-				s = sbio->bi_io_vec[j].bv_page;
-				if (memcmp(page_address(p),
-					   page_address(s),
-					   sbio->bi_io_vec[j].bv_len))
-					break;
+		}
+		mismatch_counter[primary] = 0;
+		for (i = 0; i < conf->raid_disks * 2; i++) {
+			int j;
+			struct bio *pbio = r1_bio->bios[primary];
+			struct bio *sbio = r1_bio->bios[i];
+			int uptodate = test_bit(BIO_UPTODATE, &sbio->bi_flags);
+
+			if (sbio->bi_end_io != end_sync_read)
+				continue;
+			/* Now we can 'fixup' the BIO_UPTODATE flag */
+			set_bit(BIO_UPTODATE, &sbio->bi_flags);
+
+			if (uptodate) {
+				for (j = vcnt; j-- ; ) {
+					struct page *p, *s;
+					p = pbio->bi_io_vec[j].bv_page;
+					s = sbio->bi_io_vec[j].bv_page;
+					if (memcmp(page_address(p),
+						  page_address(s),
+						  sbio->bi_io_vec[j].bv_len))
+						++mismatch_counter[primary];
+				}
 			}
-		} else
-			j = 0;
-		if (j >= 0)
-			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
-		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-			      && uptodate)) {
+			if (mismatch_counter[primary] > 0)
+				atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
+			if (!mismatch_counter[primary]
+			    || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+				&& uptodate)) {
+				mismatch_counter[primary] = 0;
+			}
+		}
+
+		if (min_mismatch_disk == -1) {
+			min_mismatch_disk = primary;
+		} else {
+			if (mismatch_counter[primary] < mismatch_counter[min_mismatch_disk])
+				min_mismatch_disk = primary;
+		}
+	}
+	r1_bio->read_disk = min_mismatch_disk;
+	/* We have compared everything now. */
+
+	/* If mismatches occured, we try to fix them now */
+	for (primary = 0; primary < conf->raid_disks * 2; primary++) {
+		int uptodate = test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags);
+		struct bio *destination = r1_bio->bios[primary];
+		struct bio *source = r1_bio->bios[min_mismatch_disk];
+		/* take only valid disks */
+		if (mismatch_counter[primary] == -1
+		    || primary == min_mismatch_disk)
+			continue;
+
+		if (mismatch_counter[primary] == 0
+		    || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
+			&& uptodate)) {
 			/* No need to write to this device. */
-			sbio->bi_end_io = NULL;
-			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
+			r1_bio->bios[primary]->bi_end_io = NULL;
+			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 			continue;
 		}
-
-		bio_copy_data(sbio, pbio);
+		/* Write the data from min_mismatch_disk to primary,
+		 * as the data in primary is probably corrupted
+		 */
+		bio_copy_data(destination, source);
 	}
+
 	return 0;
 }
 
-- 
1.8.3.2

