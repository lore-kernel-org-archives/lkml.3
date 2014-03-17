Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbaCQPA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:00:59 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56510 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933220AbaCQPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:00:37 -0400
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: i4passt@lists.cs.fau.de, neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: [PATCH 2/2] md: Add support for RAID-1 consistency check feature
Date: Mon, 17 Mar 2014 16:00:05 +0100
Message-Id: <1395068405-13860-3-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
References: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a consistency check feature for level-1 RAID
arrays that have been created with the md driver.
When enabled, every read request is duplicated and initiated for each
member of the RAID array. All read blocks are compared with their
corresponding blocks on the other array members. If the check fails for
a block, the block is not handed over, but an error code is returned
instead.
As mentioned in the cover letter, the implementation still has some 
unresolved issues.

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

---
 drivers/md/raid1.c | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 250 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a6ca1c..8c64f9a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
+#include <linux/gfp.h>
 #include "md.h"
 #include "raid1.h"
 #include "bitmap.h"
@@ -257,6 +258,109 @@ static void call_bio_endio(struct r1bio *r1_bio)
 	}
 }
 
+/* The safe_read version of the raid_end_bio_io() function */
+/* On a read request, we issue requests to all available disks.
+ * Data is returned only if all discs contain the same data
+ */
+static void safe_read_call_bio_endio(struct r1bio *r1_bio)
+{
+	struct bio *bio = r1_bio->master_bio;
+	int done;
+	struct r1conf *conf = r1_bio->mddev->private;
+	sector_t start_next_window = r1_bio->start_next_window;
+	sector_t bi_sector = bio->bi_iter.bi_sector;
+	int disk;
+	struct md_rdev *rdev;
+	int i;
+	struct page *dragptr = NULL;
+	int already_copied = 0;	/* we want to copy the data only once */
+
+	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
+		struct bio *p = NULL;
+		struct bio *s = NULL;
+		
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		rcu_read_unlock();
+
+		if (r1_bio->bios[disk] == IO_BLOCKED
+			|| rdev == NULL
+			|| test_bit(Unmerged, &rdev->flags)
+			|| test_bit(Faulty, &rdev->flags)) {
+			continue;
+		}
+
+		/* bio_for_each_segment is broken. at least here.. */
+		/* iterate over linked bios */
+		for (p = r1_bio->master_bio, s = r1_bio->bios[disk];
+		     (p != NULL) && (s != NULL);
+		     p = p->bi_next, s = s->bi_next) {
+			/* compare the pages read */
+			for (i = 0; i < r1_bio->bios[disk]->bi_vcnt; i++) {
+				if (dragptr) { /* dragptr points to the previous page */
+					if(memcmp(page_address(r1_bio->bios[disk]->bi_io_vec[0].bv_page),
+						page_address(dragptr),
+						(r1_bio->bios[disk]->bi_io_vec[0].bv_len))) {
+						set_bit(R1BIO_ReadError, &r1_bio->state);
+						clear_bit(R1BIO_Uptodate, &r1_bio->state);
+					}
+				}
+				dragptr = r1_bio->bios[disk]->bi_io_vec[0].bv_page;
+			}
+		}
+	}
+
+	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		rcu_read_unlock();
+		if (r1_bio->bios[disk] == IO_BLOCKED	//stolen from read_balance - documentation? HA! Look there!
+			|| rdev == NULL
+			|| test_bit(Unmerged, &rdev->flags)
+			|| test_bit(Faulty, &rdev->flags)) {
+			continue;
+		}
+
+ 		for (i = 0; i < r1_bio->bios[disk]->bi_vcnt; i++) {
+			if(!already_copied) {
+				if (r1_bio->bios[disk]->bi_io_vec[i].bv_page) {
+					memcpy(page_address(r1_bio->master_bio->bi_io_vec[i].bv_page),
+					       page_address(r1_bio->bios[disk]->bi_io_vec[i].bv_page),
+					       (r1_bio->bios[disk]->bi_io_vec[i].bv_len));
+				}
+			}
+
+			put_page(r1_bio->bios[disk]->bi_io_vec[i].bv_page);
+		}
+		already_copied = 1;
+	}
+
+	if (bio->bi_phys_segments) {
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		bio->bi_phys_segments--;
+		done = (bio->bi_phys_segments == 0);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+		/*
+		 * make_request() might be waiting for
+		 * bi_phys_segments to decrease
+		 */
+		wake_up(&conf->wait_barrier);
+	} else
+		done = 1;
+
+	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	if (done) {
+		bio_endio(bio, 0);
+		/*
+		 * Wake up any possible resync thread that waits for the device
+		 * to go idle.
+		 */
+		allow_barrier(conf, start_next_window, bi_sector);
+	}
+}
+
 static void raid_end_bio_io(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
@@ -268,8 +372,12 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 			 (unsigned long long) bio->bi_iter.bi_sector,
 			 (unsigned long long) bio_end_sector(bio) - 1);
 
-		call_bio_endio(r1_bio);
+		if (r1_bio->mddev->safe_read && bio_data_dir(bio) == READ)
+			safe_read_call_bio_endio(r1_bio);
+		else
+			call_bio_endio(r1_bio);
 	}
+
 	free_r1bio(r1_bio);
 }
 
@@ -303,6 +411,14 @@ static int find_bio_disk(struct r1bio *r1_bio, struct bio *bio)
 	return mirror;
 }
 
+static void r1_bio_read_done(struct r1bio *r1_bio)
+{
+	if(r1_bio->mddev->safe_read)
+		if (!atomic_dec_and_test(&r1_bio->remaining))
+			return;
+	raid_end_bio_io(r1_bio);
+}
+
 static void raid1_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -333,7 +449,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 	}
 
 	if (uptodate) {
-		raid_end_bio_io(r1_bio);
+		r1_bio_read_done(r1_bio);
 		rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 	} else {
 		/*
@@ -1073,6 +1189,133 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
+/* This function creates a "deep copy" of a bio (own pages, own bvecs) */
+static struct bio *copy_bio(struct bio *source, struct mddev *mddev) {
+	struct bio *temp;
+
+	temp = bio_clone_mddev(source, GFP_NOIO, mddev);
+	BUG_ON(!temp);
+
+	bio_alloc_pages(temp, GFP_NOIO | __GFP_HIGHMEM);
+	temp->bi_flags = source->bi_flags;
+	temp->bi_flags = (temp->bi_flags | BIO_OWNS_VEC);
+
+	temp->bi_rw = source->bi_rw;
+	temp->bi_iter.bi_sector = source->bi_iter.bi_sector;
+	temp->bi_iter.bi_size = source->bi_iter.bi_size;
+	temp->bi_phys_segments = source->bi_phys_segments;
+	temp->bi_end_io = source->bi_end_io;
+	temp->bi_private = source->bi_private;
+
+	return temp;
+}
+
+/* Duplicate the read command in order to read from every available disk */
+static void do_safe_read(struct mddev *mddev, struct bio * bio, struct r1bio *r1_bio) {
+	struct r1conf *conf = mddev->private;
+	struct raid1_info *mirror;
+	struct bitmap *bitmap;
+	struct bio *read_bio;
+	struct md_rdev *rdev;
+
+	int rdisk;
+	int max_sectors = r1_bio->sectors;
+	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
+	int sectors_handled;
+
+	int disk;
+	bitmap = mddev->bitmap;
+
+	/* set the atomic counter */
+	atomic_set(&r1_bio->remaining, 1);
+
+	/* iterate over the disks */
+	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
+d_s_read_again:
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->mirrors[disk].rdev);
+		rcu_read_unlock();
+
+		/* check if disk is valid */
+		if (r1_bio->bios[disk] == IO_BLOCKED
+			|| rdev == NULL
+			|| test_bit(Unmerged, &rdev->flags)
+			|| test_bit(Faulty, &rdev->flags)) {
+			continue;
+		}
+
+		rdisk = disk;
+
+		mirror = conf->mirrors + rdisk;
+
+		if (test_bit(WriteMostly, &mirror->rdev->flags) &&
+			bitmap) {
+			/* Reading from a write-mostly device must
+				* take care not to over-take any writes
+				* that are 'behind'
+				*/
+			wait_event(bitmap->behind_wait,
+					atomic_read(&bitmap->behind_writes) == 0);
+		}
+		r1_bio->read_disk = rdisk;
+
+		/* try to copy the bio */
+		read_bio = copy_bio(bio, mddev);
+		if(!read_bio)
+			return;
+		bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
+				max_sectors);
+
+		r1_bio->bios[rdisk] = read_bio;
+
+		read_bio->bi_iter.bi_sector = r1_bio->sector +
+			mirror->rdev->data_offset;
+		read_bio->bi_bdev = mirror->rdev->bdev;
+		read_bio->bi_end_io = raid1_end_read_request;
+		read_bio->bi_rw = READ | do_sync;
+		read_bio->bi_private = r1_bio;
+
+		if (max_sectors < r1_bio->sectors) {
+			/* could not read all from this device, so we will
+				* need another r1_bio.
+				*/
+
+			sectors_handled = (r1_bio->sector + max_sectors
+						- bio->bi_iter.bi_sector);
+			r1_bio->sectors = max_sectors;
+			spin_lock_irq(&conf->device_lock);
+			if (bio->bi_phys_segments == 0)
+				bio->bi_phys_segments = 2;
+			else
+				bio->bi_phys_segments++;
+			spin_unlock_irq(&conf->device_lock);
+			/* Cannot call generic_make_request directly
+				* as that will be queued in __make_request
+				* and subsequent mempool_alloc might block waiting
+				* for it.  So hand bio over to raid1d.
+				*/
+			reschedule_retry(r1_bio);
+
+			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
+
+			r1_bio->master_bio = bio;
+			r1_bio->sectors = bio_sectors(bio) - sectors_handled;
+			r1_bio->state = 0;
+			r1_bio->mddev = mddev;
+			r1_bio->sector = bio->bi_iter.bi_sector +
+				sectors_handled;
+			goto d_s_read_again;
+		} else {
+			
+			atomic_inc(&r1_bio->remaining);
+			generic_make_request(read_bio);
+		}
+		
+	}
+	r1_bio_read_done(r1_bio);	/* decrement atomic counter */
+	return;
+}
+
 static void make_request(struct mddev *mddev, struct bio * bio)
 {
 	struct r1conf *conf = mddev->private;
@@ -1157,6 +1400,11 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		 */
 		int rdisk;
 
+		if(mddev->safe_read) {
+			do_safe_read(mddev, bio, r1_bio);
+			return;
+		}
+
 read_again:
 		rdisk = read_balance(conf, r1_bio, &max_sectors);
 
-- 
1.8.3.2

