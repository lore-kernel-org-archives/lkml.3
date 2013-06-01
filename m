Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3FAEMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:12:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45274 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754656Ab3FAEMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:12:14 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 5/8] pktcdvd: Add struct pktcdvd_device.name to pr_err logging where possible
Date: Fri, 31 May 2013 21:11:26 -0700
Message-Id: <f070c3ea7567dda29b9c3ca6bf4c13b9dd0d8819.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722> <cover.1370048648.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new pkt_err macro to prefix the name to the logging output.
Convert pr_err where there is a non-null struct pktcdvd_device.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 954a34b..07ff878 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -80,6 +80,9 @@ do {									\
 		pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__);		\
 } while (0)
 
+#define pkt_err(pd, fmt, ...)						\
+	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
+
 #define MAX_SPEED 0xffff
 
 static DEFINE_MUTEX(pktcdvd_mutex);
@@ -939,7 +942,7 @@ static int pkt_set_segment_merging(struct pktcdvd_device *pd, struct request_que
 		set_bit(PACKET_MERGE_SEGS, &pd->flags);
 		return 0;
 	} else {
-		pr_err("cdrom max_phys_segments too small\n");
+		pkt_err(pd, "cdrom max_phys_segments too small\n");
 		return -EIO;
 	}
 }
@@ -1746,7 +1749,7 @@ static noinline_for_stack int pkt_set_write_settings(struct pktcdvd_device *pd)
 		/*
 		 * paranoia
 		 */
-		pr_err("write mode wrong %d\n", wp->data_block_type);
+		pkt_err(pd, "write mode wrong %d\n", wp->data_block_type);
 		return 1;
 	}
 	wp->packet_size = cpu_to_be32(pd->settings.size >> 2);
@@ -1790,7 +1793,7 @@ static int pkt_writable_track(struct pktcdvd_device *pd, track_information *ti)
 	if (ti->rt == 1 && ti->blank == 0)
 		return 1;
 
-	pr_err("bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
+	pkt_err(pd, "bad state %d-%d-%d\n", ti->rt, ti->blank, ti->packet);
 	return 0;
 }
 
@@ -1823,7 +1826,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	}
 
 	if (di->disc_type != 0x20 && di->disc_type != 0) {
-		pr_err("wrong disc type (%x)\n", di->disc_type);
+		pkt_err(pd, "wrong disc type (%x)\n", di->disc_type);
 		return 0;
 	}
 
@@ -1833,7 +1836,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	}
 
 	if (di->border_status == PACKET_SESSION_RESERVED) {
-		pr_err("can't write to last track (reserved)\n");
+		pkt_err(pd, "can't write to last track (reserved)\n");
 		return 0;
 	}
 
@@ -1858,7 +1861,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 	memset(&ti, 0, sizeof(track_information));
 
 	if ((ret = pkt_get_disc_info(pd, &di))) {
-		pr_err("failed get_disc\n");
+		pkt_err(pd, "failed get_disc\n");
 		return ret;
 	}
 
@@ -1869,12 +1872,12 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 
 	track = 1; /* (di.last_track_msb << 8) | di.last_track_lsb; */
 	if ((ret = pkt_get_track_info(pd, track, 1, &ti))) {
-		pr_err("failed get_track\n");
+		pkt_err(pd, "failed get_track\n");
 		return ret;
 	}
 
 	if (!pkt_writable_track(pd, &ti)) {
-		pr_err("can't write to this track\n");
+		pkt_err(pd, "can't write to this track\n");
 		return -EROFS;
 	}
 
@@ -1888,7 +1891,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
-		pr_err("packet size is too big\n");
+		pkt_err(pd, "packet size is too big\n");
 		return -EROFS;
 	}
 	pd->settings.fp = ti.fp;
@@ -1930,7 +1933,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 			pd->settings.block_mode = PACKET_BLOCK_MODE2;
 			break;
 		default:
-			pr_err("unknown data mode\n");
+			pkt_err(pd, "unknown data mode\n");
 			return -EROFS;
 	}
 	return 0;
@@ -1964,7 +1967,7 @@ static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
 	cgc.buflen = cgc.cmd[8] = 2 + ((buf[0] << 8) | (buf[1] & 0xff));
 	ret = pkt_mode_select(pd, &cgc);
 	if (ret) {
-		pr_err("write caching control failed\n");
+		pkt_err(pd, "write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
 		pr_notice("enabled write caching on %s\n", pd->name);
@@ -2203,7 +2206,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 		goto out;
 
 	if ((ret = pkt_get_last_written(pd, &lba))) {
-		pr_err("pkt_get_last_written failed\n");
+		pkt_err(pd, "pkt_get_last_written failed\n");
 		goto out_putdev;
 	}
 
@@ -2233,7 +2236,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 
 	if (write) {
 		if (!pkt_grow_pktlist(pd, CONFIG_CDROM_PKTCDVD_BUFFERS)) {
-			pr_err("not enough memory for buffers\n");
+			pkt_err(pd, "not enough memory for buffers\n");
 			ret = -ENOMEM;
 			goto out_putdev;
 		}
@@ -2356,8 +2359,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 
 	pd = q->queuedata;
 	if (!pd) {
-		pr_err("%s incorrect request queue\n",
-		       bdevname(bio->bi_bdev, b));
+		pkt_err(pd, "%s incorrect request queue\n",
+			bdevname(bio->bi_bdev, b));
 		goto end_io;
 	}
 
@@ -2385,7 +2388,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	if (!bio->bi_size || (bio->bi_size % CD_FRAMESIZE)) {
-		pr_err("wrong bio size\n");
+		pkt_err(pd, "wrong bio size\n");
 		goto end_io;
 	}
 
@@ -2606,7 +2609,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	struct block_device *bdev;
 
 	if (pd->pkt_dev == dev) {
-		pr_err("recursive setup not allowed\n");
+		pkt_err(pd, "recursive setup not allowed\n");
 		return -EBUSY;
 	}
 	for (i = 0; i < MAX_WRITERS; i++) {
@@ -2614,11 +2617,12 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 		if (!pd2)
 			continue;
 		if (pd2->bdev->bd_dev == dev) {
-			pr_err("%s already setup\n", bdevname(pd2->bdev, b));
+			pkt_err(pd, "%s already setup\n",
+				bdevname(pd2->bdev, b));
 			return -EBUSY;
 		}
 		if (pd2->pkt_dev == dev) {
-			pr_err("can't chain pktcdvd devices\n");
+			pkt_err(pd, "can't chain pktcdvd devices\n");
 			return -EBUSY;
 		}
 	}
@@ -2641,7 +2645,7 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
 	atomic_set(&pd->cdrw.pending_bios, 0);
 	pd->cdrw.thread = kthread_run(kcdrwd, pd, "%s", pd->name);
 	if (IS_ERR(pd->cdrw.thread)) {
-		pr_err("can't start kernel thread\n");
+		pkt_err(pd, "can't start kernel thread\n");
 		ret = -ENOMEM;
 		goto out_mem;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

