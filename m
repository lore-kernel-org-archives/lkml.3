Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3FAEMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:12:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49563 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753321Ab3FAEL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:11:57 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/8] pktcdvd: Consolidate DPRINTK and VPRINTK macros
Date: Fri, 31 May 2013 21:11:24 -0700
Message-Id: <2d9e8533e243cdbbedb8475e61b970a8ba485103.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722> <cover.1370048648.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pkt_dbg(level, fmt, ...) form.

These messages are emitted at KERN_NOTICE.

Always emit function name with pkt_dbg(2, ...) uses and
remove the sometimes abbreviated embedded function name.

This form always verifies the format and arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 107 ++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 12bdce4..b546d97 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -71,17 +71,13 @@
 
 #define DRIVER_NAME	"pktcdvd"
 
-#if PACKET_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_NOTICE fmt, ##args)
-#else
-#define DPRINTK(fmt, args...)
-#endif
-
-#if PACKET_DEBUG > 1
-#define VPRINTK(fmt, args...) printk(KERN_NOTICE fmt, ##args)
-#else
-#define VPRINTK(fmt, args...)
-#endif
+#define pkt_dbg(level, fmt, ...)				\
+do {								\
+	if (level == 2 && PACKET_DEBUG >= 2)			\
+		pr_notice("%s: " fmt, __func__, ##__VA_ARGS__);	\
+	else if (level == 1 && PACKET_DEBUG >= 1)		\
+		pr_notice(fmt, ##__VA_ARGS__);			\
+} while (0)
 
 #define MAX_SPEED 0xffff
 
@@ -519,7 +515,7 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
 {
 	BUG_ON(atomic_read(&pd->cdrw.pending_bios) <= 0);
 	if (atomic_dec_and_test(&pd->cdrw.pending_bios)) {
-		VPRINTK(DRIVER_NAME": queue empty\n");
+		pkt_dbg(2, "queue empty\n");
 		atomic_set(&pd->iosched.attention, 1);
 		wake_up(&pd->wqueue);
 	}
@@ -871,7 +867,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 				need_write_seek = 0;
 			if (need_write_seek && reads_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					VPRINTK(DRIVER_NAME": write, waiting\n");
+					pkt_dbg(2, "write, waiting\n");
 					break;
 				}
 				pkt_flush_cache(pd);
@@ -880,7 +876,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 		} else {
 			if (!reads_queued && writes_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
-					VPRINTK(DRIVER_NAME": read, waiting\n");
+					pkt_dbg(2, "read, waiting\n");
 					break;
 				}
 				pd->iosched.writing = 1;
@@ -987,8 +983,9 @@ static void pkt_end_io_read(struct bio *bio, int err,
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
-		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
+	pkt_dbg(2, "bio=%p sec0=%llx sec=%llx err=%d\n",
+		bio, (unsigned long long)pkt->sector,
+		(unsigned long long)bio->bi_sector, err);
 
 	if (err)
 		atomic_inc(&pkt->io_errors);
@@ -1006,7 +1003,7 @@ static void pkt_end_io_packet_write(struct bio *bio, int err,
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	VPRINTK("pkt_end_io_packet_write: id=%d, err=%d\n", pkt->id, err);
+	pkt_dbg(2, "id=%d, err=%d\n", pkt->id, err);
 
 	pd->stats.pkt_ended++;
 
@@ -1048,7 +1045,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	spin_unlock(&pkt->lock);
 
 	if (pkt->cache_valid) {
-		VPRINTK("pkt_gather_data: zone %llx cached\n",
+		pkt_dbg(2, "zone %llx cached\n",
 			(unsigned long long)pkt->sector);
 		goto out_account;
 	}
@@ -1071,7 +1068,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
-		VPRINTK("pkt_gather_data: Adding frame %d, page:%p offs:%d\n",
+		pkt_dbg(2, "Adding frame %d, page:%p offs:%d\n",
 			f, pkt->pages[p], offset);
 		if (!bio_add_page(bio, pkt->pages[p], CD_FRAMESIZE, offset))
 			BUG();
@@ -1083,7 +1080,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	}
 
 out_account:
-	VPRINTK("pkt_gather_data: need %d frames for zone %llx\n",
+	pkt_dbg(2, "need %d frames for zone %llx\n",
 		frames_read, (unsigned long long)pkt->sector);
 	pd->stats.pkt_started++;
 	pd->stats.secs_rg += frames_read * (CD_FRAMESIZE >> 9);
@@ -1184,7 +1181,8 @@ static inline void pkt_set_state(struct packet_data *pkt, enum packet_data_state
 		"IDLE", "WAITING", "READ_WAIT", "WRITE_WAIT", "RECOVERY", "FINISHED"
 	};
 	enum packet_data_state old_state = pkt->state;
-	VPRINTK("pkt %2d : s=%6llx %s -> %s\n", pkt->id, (unsigned long long)pkt->sector,
+	pkt_dbg(2, "pkt %2d : s=%6llx %s -> %s\n",
+		pkt->id, (unsigned long long)pkt->sector,
 		state_name[old_state], state_name[state]);
 #endif
 	pkt->state = state;
@@ -1203,12 +1201,12 @@ static int pkt_handle_queue(struct pktcdvd_device *pd)
 	struct rb_node *n;
 	int wakeup;
 
-	VPRINTK("handle_queue\n");
+	pkt_dbg(2, "\n");
 
 	atomic_set(&pd->scan_queue, 0);
 
 	if (list_empty(&pd->cdrw.pkt_free_list)) {
-		VPRINTK("handle_queue: no pkt\n");
+		pkt_dbg(2, "no pkt\n");
 		return 0;
 	}
 
@@ -1245,7 +1243,7 @@ try_next_bio:
 	}
 	spin_unlock(&pd->lock);
 	if (!bio) {
-		VPRINTK("handle_queue: no bio\n");
+		pkt_dbg(2, "no bio\n");
 		return 0;
 	}
 
@@ -1261,10 +1259,10 @@ try_next_bio:
 	 * to this packet.
 	 */
 	spin_lock(&pd->lock);
-	VPRINTK("pkt_handle_queue: looking for zone %llx\n", (unsigned long long)zone);
+	pkt_dbg(2, "looking for zone %llx\n", (unsigned long long)zone);
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
-		VPRINTK("pkt_handle_queue: found zone=%llx\n",
+		pkt_dbg(2, "found zone=%llx\n",
 			(unsigned long long)get_zone(bio->bi_sector, pd));
 		if (get_zone(bio->bi_sector, pd) != zone)
 			break;
@@ -1317,7 +1315,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
 	}
-	VPRINTK(DRIVER_NAME": vcnt=%d\n", pkt->w_bio->bi_vcnt);
+	pkt_dbg(2, "vcnt=%d\n", pkt->w_bio->bi_vcnt);
 
 	/*
 	 * Fill-in bvec with data from orig_bios.
@@ -1328,7 +1326,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	pkt_set_state(pkt, PACKET_WRITE_WAIT_STATE);
 	spin_unlock(&pkt->lock);
 
-	VPRINTK("pkt_start_write: Writing %d frames for zone %llx\n",
+	pkt_dbg(2, "Writing %d frames for zone %llx\n",
 		pkt->write_size, (unsigned long long)pkt->sector);
 
 	if (test_bit(PACKET_MERGE_SEGS, &pd->flags) || (pkt->write_size < pkt->frames)) {
@@ -1360,7 +1358,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 {
 	int uptodate;
 
-	VPRINTK("run_state_machine: pkt %d\n", pkt->id);
+	pkt_dbg(2, "pkt %d\n", pkt->id);
 
 	for (;;) {
 		switch (pkt->state) {
@@ -1399,7 +1397,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 			if (pkt_start_recovery(pkt)) {
 				pkt_start_write(pd, pkt);
 			} else {
-				VPRINTK("No recovery possible\n");
+				pkt_dbg(2, "No recovery possible\n");
 				pkt_set_state(pkt, PACKET_FINISHED_STATE);
 			}
 			break;
@@ -1420,7 +1418,7 @@ static void pkt_handle_packets(struct pktcdvd_device *pd)
 {
 	struct packet_data *pkt, *next;
 
-	VPRINTK("pkt_handle_packets\n");
+	pkt_dbg(2, "\n");
 
 	/*
 	 * Run state machine for active packets
@@ -1503,9 +1501,9 @@ static int kcdrwd(void *foobar)
 			if (PACKET_DEBUG > 1) {
 				int states[PACKET_NUM_STATES];
 				pkt_count_states(pd, states);
-				VPRINTK("kcdrwd: i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
-					states[0], states[1], states[2], states[3],
-					states[4], states[5]);
+				pkt_dbg(2, "i:%d ow:%d rw:%d ww:%d rec:%d fin:%d\n",
+					states[0], states[1], states[2],
+					states[3], states[4], states[5]);
 			}
 
 			min_sleep_time = MAX_SCHEDULE_TIMEOUT;
@@ -1514,9 +1512,9 @@ static int kcdrwd(void *foobar)
 					min_sleep_time = pkt->sleep_time;
 			}
 
-			VPRINTK("kcdrwd: sleeping\n");
+			pkt_dbg(2, "sleeping\n");
 			residue = schedule_timeout(min_sleep_time);
-			VPRINTK("kcdrwd: wake up\n");
+			pkt_dbg(2, "wake up\n");
 
 			/* make swsusp happy with our thread */
 			try_to_freeze();
@@ -1813,7 +1811,8 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 		case 0x12: /* DVD-RAM */
 			return 1;
 		default:
-			VPRINTK(DRIVER_NAME": Wrong disc profile (%x)\n", pd->mmc3_profile);
+			pkt_dbg(2, "Wrong disc profile (%x)\n",
+				pd->mmc3_profile);
 			return 0;
 	}
 
@@ -2128,7 +2127,7 @@ static noinline_for_stack int pkt_perform_opc(struct pktcdvd_device *pd)
 	struct request_sense sense;
 	int ret;
 
-	VPRINTK(DRIVER_NAME": Performing OPC\n");
+	pkt_dbg(2, "Performing OPC\n");
 
 	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
 	cgc.sense = &sense;
@@ -2146,12 +2145,12 @@ static int pkt_open_write(struct pktcdvd_device *pd)
 	unsigned int write_speed, media_write_speed, read_speed;
 
 	if ((ret = pkt_probe_settings(pd))) {
-		VPRINTK(DRIVER_NAME": %s failed probe\n", pd->name);
+		pkt_dbg(2, "%s failed probe\n", pd->name);
 		return ret;
 	}
 
 	if ((ret = pkt_set_write_settings(pd))) {
-		DPRINTK(DRIVER_NAME": %s failed saving write settings\n", pd->name);
+		pkt_dbg(1, "%s failed saving write settings\n", pd->name);
 		return -EIO;
 	}
 
@@ -2163,26 +2162,26 @@ static int pkt_open_write(struct pktcdvd_device *pd)
 		case 0x13: /* DVD-RW */
 		case 0x1a: /* DVD+RW */
 		case 0x12: /* DVD-RAM */
-			DPRINTK(DRIVER_NAME": write speed %ukB/s\n", write_speed);
+			pkt_dbg(1, "write speed %ukB/s\n", write_speed);
 			break;
 		default:
 			if ((ret = pkt_media_speed(pd, &media_write_speed)))
 				media_write_speed = 16;
 			write_speed = min(write_speed, media_write_speed * 177);
-			DPRINTK(DRIVER_NAME": write speed %ux\n", write_speed / 176);
+			pkt_dbg(1, "write speed %ux\n", write_speed / 176);
 			break;
 	}
 	read_speed = write_speed;
 
 	if ((ret = pkt_set_speed(pd, write_speed, read_speed))) {
-		DPRINTK(DRIVER_NAME": %s couldn't set write speed\n", pd->name);
+		pkt_dbg(1, "%s couldn't set write speed\n", pd->name);
 		return -EIO;
 	}
 	pd->write_speed = write_speed;
 	pd->read_speed = read_speed;
 
 	if ((ret = pkt_perform_opc(pd))) {
-		DPRINTK(DRIVER_NAME": %s Optimum Power Calibration failed\n", pd->name);
+		pkt_dbg(1, "%s Optimum Power Calibration failed\n", pd->name);
 	}
 
 	return 0;
@@ -2259,7 +2258,7 @@ out:
 static void pkt_release_dev(struct pktcdvd_device *pd, int flush)
 {
 	if (flush && pkt_flush_cache(pd))
-		DPRINTK(DRIVER_NAME": %s not flushing cache\n", pd->name);
+		pkt_dbg(1, "%s not flushing cache\n", pd->name);
 
 	pkt_lock_door(pd, 0);
 
@@ -2281,7 +2280,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 	struct pktcdvd_device *pd = NULL;
 	int ret;
 
-	VPRINTK(DRIVER_NAME": entering open\n");
+	pkt_dbg(2, "entering\n");
 
 	mutex_lock(&pktcdvd_mutex);
 	mutex_lock(&ctl_mutex);
@@ -2317,7 +2316,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 out_dec:
 	pd->refcnt--;
 out:
-	VPRINTK(DRIVER_NAME": failed open (%d)\n", ret);
+	pkt_dbg(2, "failed (%d)\n", ret);
 	mutex_unlock(&ctl_mutex);
 	mutex_unlock(&pktcdvd_mutex);
 	return ret;
@@ -2399,7 +2398,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	blk_queue_bounce(q, &bio);
 
 	zone = get_zone(bio->bi_sector, pd);
-	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
+	pkt_dbg(2, "start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
 		(unsigned long long)bio_end_sector(bio));
 
@@ -2654,7 +2653,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	}
 
 	proc_create_data(pd->name, 0, pkt_proc, &pkt_proc_fops, pd);
-	DPRINTK(DRIVER_NAME": writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
+	pkt_dbg(1, "writer %s mapped to %s\n", pd->name, bdevname(bdev, b));
 	return 0;
 
 out_mem:
@@ -2669,8 +2668,8 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	struct pktcdvd_device *pd = bdev->bd_disk->private_data;
 	int ret;
 
-	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd,
-		MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+	pkt_dbg(2, "cmd %x, dev %d:%d\n",
+		cmd, MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
 	mutex_lock(&pktcdvd_mutex);
 	switch (cmd) {
@@ -2694,7 +2693,7 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		break;
 
 	default:
-		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
+		pkt_dbg(2, "Unknown ioctl for %s (%x)\n", pd->name, cmd);
 		ret = -ENOTTY;
 	}
 	mutex_unlock(&pktcdvd_mutex);
@@ -2843,7 +2842,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 			break;
 	}
 	if (idx == MAX_WRITERS) {
-		DPRINTK(DRIVER_NAME": dev not setup\n");
+		pkt_dbg(1, "dev not setup\n");
 		ret = -ENXIO;
 		goto out;
 	}
@@ -2863,7 +2862,7 @@ static int pkt_remove_dev(dev_t pkt_dev)
 	blkdev_put(pd->bdev, FMODE_READ | FMODE_NDELAY);
 
 	remove_proc_entry(pd->name, pkt_proc);
-	DPRINTK(DRIVER_NAME": writer %s unmapped\n", pd->name);
+	pkt_dbg(1, "writer %s unmapped\n", pd->name);
 
 	del_gendisk(pd->disk);
 	blk_cleanup_queue(pd->disk->queue);
-- 
1.8.1.2.459.gbcd45b4.dirty

