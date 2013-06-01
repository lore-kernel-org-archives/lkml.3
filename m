Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3FAEMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:12:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45519 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753872Ab3FAEMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:12:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/8] pktcdvd: Add struct pktcdvd_device * to pkt_dbg
Date: Fri, 31 May 2013 21:11:25 -0700
Message-Id: <d262c3b2feede5342456a1f8089d427bf33b25dc.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722> <cover.1370048648.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pd->name to output for these debugging messages.

Remove normally compiled out pkt_dbg(2, ...) function entry
tracing equivalents as it's better done via the function tracer.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 90 +++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 48 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b546d97..954a34b 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -71,12 +71,13 @@
 
 #define DRIVER_NAME	"pktcdvd"
 
-#define pkt_dbg(level, fmt, ...)				\
-do {								\
-	if (level == 2 && PACKET_DEBUG >= 2)			\
-		pr_notice("%s: " fmt, __func__, ##__VA_ARGS__);	\
-	else if (level == 1 && PACKET_DEBUG >= 1)		\
-		pr_notice(fmt, ##__VA_ARGS__);			\
+#define pkt_dbg(level, pd, fmt, ...)					\
+do {									\
+	if (level == 2 && PACKET_DEBUG >= 2)				\
+		pr_notice("%s: %s():" fmt,				\
+			  pd->name, __func__, ##__VA_ARGS__);		\
+	else if (level == 1 && PACKET_DEBUG >= 1)			\
+		pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__);		\
 } while (0)
 
 #define MAX_SPEED 0xffff
@@ -515,7 +516,7 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
 {
 	BUG_ON(atomic_read(&pd->cdrw.pending_bios) <= 0);
 	if (atomic_dec_and_test(&pd->cdrw.pending_bios)) {
-		pkt_dbg(2, "queue empty\n");
+		pkt_dbg(2, pd, "queue empty\n");
 		atomic_set(&pd->iosched.attention, 1);
 		wake_up(&pd->wqueue);
 	}
@@ -867,7 +868,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 				need_write_seek = 0;
 			if (need_write_seek && reads_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					pkt_dbg(2, "write, waiting\n");
+					pkt_dbg(2, pd, "write, waiting\n");
 					break;
 				}
 				pkt_flush_cache(pd);
@@ -876,7 +877,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 		} else {
 			if (!reads_queued && writes_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					pkt_dbg(2, "read, waiting\n");
+					pkt_dbg(2, pd, "read, waiting\n");
 					break;
 				}
 				pd->iosched.writing = 1;
@@ -983,7 +984,7 @@ static void pkt_end_io_read(struct bio *bio, int err,
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	pkt_dbg(2, "bio=%p sec0=%llx sec=%llx err=%d\n",
+	pkt_dbg(2, pd, "bio=%p sec0=%llx sec=%llx err=%d\n",
 		bio, (unsigned long long)pkt->sector,
 		(unsigned long long)bio->bi_sector, err);
 
@@ -1003,7 +1004,7 @@ static void pkt_end_io_packet_write(struct bio *bio, int err,
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	pkt_dbg(2, "id=%d, err=%d\n", pkt->id, err);
+	pkt_dbg(2, pd, "id=%d, err=%d\n", pkt->id, err);
 
 	pd->stats.pkt_ended++;
 
@@ -1045,7 +1046,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	spin_unlock(&pkt->lock);
 
 	if (pkt->cache_valid) {
-		pkt_dbg(2, "zone %llx cached\n",
+		pkt_dbg(2, pd, "zone %llx cached\n",
 			(unsigned long long)pkt->sector);
 		goto out_account;
 	}
@@ -1068,7 +1069,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
-		pkt_dbg(2, "Adding frame %d, page:%p offs:%d\n",
+		pkt_dbg(2, pd, "Adding frame %d, page:%p offs:%d\n",
 			f, pkt->pages[p], offset);
 		if (!bio_add_page(bio, pkt->pages[p], CD_FRAMESIZE, offset))
 			BUG();
@@ -1080,7 +1081,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	}
 
 out_account:
-	pkt_dbg(2, "need %d frames for zone %llx\n",
+	pkt_dbg(2, pd, "need %d frames for zone %llx\n",
 		frames_read, (unsigned long long)pkt->sector);
 	pd->stats.pkt_started++;
 	pd->stats.secs_rg += frames_read * (CD_FRAMESIZE >> 9);
@@ -1181,7 +1182,7 @@ static inline void pkt_set_state(struct packet_data *pkt, enum packet_data_state
 		"IDLE", "WAITING", "READ_WAIT", "WRITE_WAIT", "RECOVERY", "FINISHED"
 	};
 	enum packet_data_state old_state = pkt->state;
-	pkt_dbg(2, "pkt %2d : s=%6llx %s -> %s\n",
+	pkt_dbg(2, pd, "pkt %2d : s=%6llx %s -> %s\n",
 		pkt->id, (unsigned long long)pkt->sector,
 		state_name[old_state], state_name[state]);
 #endif
@@ -1201,12 +1202,10 @@ static int pkt_handle_queue(struct pktcdvd_device *pd)
 	struct rb_node *n;
 	int wakeup;
 
-	pkt_dbg(2, "\n");
-
 	atomic_set(&pd->scan_queue, 0);
 
 	if (list_empty(&pd->cdrw.pkt_free_list)) {
-		pkt_dbg(2, "no pkt\n");
+		pkt_dbg(2, pd, "no pkt\n");
 		return 0;
 	}
 
@@ -1243,7 +1242,7 @@ try_next_bio:
 	}
 	spin_unlock(&pd->lock);
 	if (!bio) {
-		pkt_dbg(2, "no bio\n");
+		pkt_dbg(2, pd, "no bio\n");
 		return 0;
 	}
 
@@ -1259,10 +1258,10 @@ try_next_bio:
 	 * to this packet.
 	 */
 	spin_lock(&pd->lock);
-	pkt_dbg(2, "looking for zone %llx\n", (unsigned long long)zone);
+	pkt_dbg(2, pd, "looking for zone %llx\n", (unsigned long long)zone);
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
-		pkt_dbg(2, "found zone=%llx\n",
+		pkt_dbg(2, pd, "found zone=%llx\n",
 			(unsigned long long)get_zone(bio->bi_sector, pd));
 		if (get_zone(bio->bi_sector, pd) != zone)
 			break;
@@ -1315,7 +1314,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
 	}
-	pkt_dbg(2, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
+	pkt_dbg(2, pd, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
 
 	/*
 	 * Fill-in bvec with data from orig_bios.
@@ -1326,7 +1325,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	pkt_set_state(pkt, PACKET_WRITE_WAIT_STATE);
 	spin_unlock(&pkt->lock);
 
-	pkt_dbg(2, "Writing %d frames for zone %llx\n",
+	pkt_dbg(2, pd, "Writing %d frames for zone %llx\n",
 		pkt->write_size, (unsigned long long)pkt->sector);
 
 	if (test_bit(PACKET_MERGE_SEGS, &pd->flags) || (pkt->write_size < pkt->frames)) {
@@ -1358,7 +1357,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 {
 	int uptodate;
 
-	pkt_dbg(2, "pkt %d\n", pkt->id);
+	pkt_dbg(2, pd, "pkt %d\n", pkt->id);
 
 	for (;;) {
 		switch (pkt->state) {
@@ -1397,7 +1396,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 			if (pkt_start_recovery(pkt)) {
 				pkt_start_write(pd, pkt);
 			} else {
-				pkt_dbg(2, "No recovery possible\n");
+				pkt_dbg(2, pd, "No recovery possible\n");
 				pkt_set_state(pkt, PACKET_FINISHED_STATE);
 			}
 			break;
@@ -1418,8 +1417,6 @@ static void pkt_handle_packets(struct pktcdvd_device *pd)
 {
 	struct packet_data *pkt, *next;
 
-	pkt_dbg(2, "\n");
-
 	/*
 	 * Run state machine for active packets
 	 */
@@ -1501,7 +1498,7 @@ static int kcdrwd(void *foobar)
 			if (PACKET_DEBUG > 1) {
 				int states[PACKET_NUM_STATES];
 				pkt_count_states(pd, states);
-				pkt_dbg(2, "i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
+				pkt_dbg(2, pd, "i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
 					states[0], states[1], states[2],
 					states[3], states[4], states[5]);
 			}
@@ -1512,9 +1509,9 @@ static int kcdrwd(void *foobar)
 					min_sleep_time = pkt->sleep_time;
 			}
 
-			pkt_dbg(2, "sleeping\n");
+			pkt_dbg(2, pd, "sleeping\n");
 			residue = schedule_timeout(min_sleep_time);
-			pkt_dbg(2, "wake up\n");
+			pkt_dbg(2, pd, "wake up\n");
 
 			/* make swsusp happy with our thread */
 			try_to_freeze();
@@ -1811,7 +1808,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 		case 0x12: /* DVD-RAM */
 			return 1;
 		default:
-			pkt_dbg(2, "Wrong disc profile (%x)\n",
+			pkt_dbg(2, pd, "Wrong disc profile (%x)\n",
 				pd->mmc3_profile);
 			return 0;
 	}
@@ -2127,7 +2124,7 @@ static noinline_for_stack int pkt_perform_opc(struct pktcdvd_device *pd)
 	struct request_sense sense;
 	int ret;
 
-	pkt_dbg(2, "Performing OPC\n");
+	pkt_dbg(2, pd, "Performing OPC\n");
 
 	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
 	cgc.sense = &sense;
@@ -2145,12 +2142,12 @@ static int pkt_open_write(struct pktcdvd_device *pd)
 	unsigned int write_speed, media_write_speed, read_speed;
 
 	if ((ret = pkt_probe_settings(pd))) {
-		pkt_dbg(2, "%s failed probe\n", pd->name);
+		pkt_dbg(2, pd, "failed probe\n");
 		return ret;
 	}
 
 	if ((ret = pkt_set_write_settings(pd))) {
-		pkt_dbg(1, "%s failed saving write settings\n", pd->name);
+		pkt_dbg(1, pd, "failed saving write settings\n");
 		return -EIO;
 	}
 
@@ -2162,26 +2159,26 @@ static int pkt_open_write(struct pktcdvd_device *pd)
 		case 0x13: /* DVD-RW */
 		case 0x1a: /* DVD+RW */
 		case 0x12: /* DVD-RAM */
-			pkt_dbg(1, "write speed %ukB/s\n", write_speed);
+			pkt_dbg(1, pd, "write speed %ukB/s\n", write_speed);
 			break;
 		default:
 			if ((ret = pkt_media_speed(pd, &media_write_speed)))
 				media_write_speed = 16;
 			write_speed = min(write_speed, media_write_speed * 177);
-			pkt_dbg(1, "write speed %ux\n", write_speed / 176);
+			pkt_dbg(1, pd, "write speed %ux\n", write_speed / 176);
 			break;
 	}
 	read_speed = write_speed;
 
 	if ((ret = pkt_set_speed(pd, write_speed, read_speed))) {
-		pkt_dbg(1, "%s couldn't set write speed\n", pd->name);
+		pkt_dbg(1, pd, "couldn't set write speed\n");
 		return -EIO;
 	}
 	pd->write_speed = write_speed;
 	pd->read_speed = read_speed;
 
 	if ((ret = pkt_perform_opc(pd))) {
-		pkt_dbg(1, "%s Optimum Power Calibration failed\n", pd->name);
+		pkt_dbg(1, pd, "Optimum Power Calibration failed\n");
 	}
 
 	return 0;
@@ -2258,7 +2255,7 @@ out:
 static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 {
 	if (flush && pkt_flush_cache(pd))
-		pkt_dbg(1, "%s not flushing cache\n", pd->name);
+		pkt_dbg(1, pd, "not flushing cache\n");
 
 	pkt_lock_door(pd, 0);
 
@@ -2280,8 +2277,6 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 	struct pktcdvd_device *pd = NULL;
 	int ret;
 
-	pkt_dbg(2, "entering\n");
-
 	mutex_lock(&pktcdvd_mutex);
 	mutex_lock(&ctl_mutex);
 	pd = pkt_find_dev_from_minor(MINOR(bdev->bd_dev));
@@ -2316,7 +2311,6 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 out_dec:
 	pd->refcnt--;
 out:
-	pkt_dbg(2, "failed (%d)\n", ret);
 	mutex_unlock(&ctl_mutex);
 	mutex_unlock(&pktcdvd_mutex);
 	return ret;
@@ -2398,7 +2392,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	blk_queue_bounce(q, &bio);
 
 	zone = get_zone(bio->bi_sector, pd);
-	pkt_dbg(2, "start = %6llx stop = %6llx\n",
+	pkt_dbg(2, pd, "start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
 		(unsigned long long)bio_end_sector(bio));
 
@@ -2653,7 +2647,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	}
 
 	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
-	pkt_dbg(1, "writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
+	pkt_dbg(1, pd, "writer mapped to %s\n", bdevname(bdev, b));
 	return 0;
 
 out_mem:
@@ -2668,7 +2662,7 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	struct pktcdvd_device *pd = bdev->bd_disk->private_data;
 	int ret;
 
-	pkt_dbg(2, "cmd %x, dev %d:%d\n",
+	pkt_dbg(2, pd, "cmd %x, dev %d:%d\n",
 		cmd, MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
 	mutex_lock(&pktcdvd_mutex);
@@ -2693,7 +2687,7 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		break;
 
 	default:
-		pkt_dbg(2, "Unknown ioctl for %s (%x)\n", pd->name, cmd);
+		pkt_dbg(2, pd, "Unknown ioctl (%x)\n", cmd);
 		ret = -ENOTTY;
 	}
 	mutex_unlock(&pktcdvd_mutex);
@@ -2842,7 +2836,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 			break;
 	}
 	if (idx == MAX_WRITERS) {
-		pkt_dbg(1, "dev not setup\n");
+		pkt_dbg(1, pd, "dev not setup\n");
 		ret = -ENXIO;
 		goto out;
 	}
@@ -2862,7 +2856,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 	blkdev_put(pd->bdev, FMODE_READ | FMODE_NDELAY);
 
 	remove_proc_entry(pd->name, pkt_proc);
-	pkt_dbg(1, "writer %s unmapped\n", pd->name);
+	pkt_dbg(1, pd, "writer unmapped\n");
 
 	del_gendisk(pd->disk);
 	blk_cleanup_queue(pd->disk->queue);
-- 
1.8.1.2.459.gbcd45b4.dirty

