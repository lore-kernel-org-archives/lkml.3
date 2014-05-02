Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaEBQrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:47:10 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:62914 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbaEBQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:47:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgaAKrKY1NbsmU4/2dsb2JhbABagwarXwMBAQEBAQEEAZoBAgKBEBd0glMTHCMYgQIkE4hFAcpOhVaIJVeEQAEDjxaKGQGKe4d0gzY7gTE
Date: Fri, 2 May 2014 18:49:11 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] block/blk-core.c: convert printk to pr_foo()
Message-Id: <20140502184911.61e6207c63864476bd06570a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert all printk,print_ratelimited ...
-Define debug to have pr_debug emitted
-Fix checkpatch warning: Lu->llu

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-core.c | 60 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..5c544fa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -11,6 +11,7 @@
 /*
  * This handles all read/write requests to block devices
  */
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
@@ -139,21 +140,21 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 {
 	int bit;
 
-	printk(KERN_INFO "%s: dev %s: type=%x, flags=%llx\n", msg,
-		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
+	pr_info("%s: dev %s: type=%x, flags=%llx\n",
+		msg, rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
 		(unsigned long long) rq->cmd_flags);
 
-	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
+	pr_info("  sector %llu, nr/cnr %u/%u\n",
 	       (unsigned long long)blk_rq_pos(rq),
 	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
-	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, len %u\n",
+	pr_info("  bio %p, biotail %p, buffer %p, len %u\n",
 	       rq->bio, rq->biotail, rq->buffer, blk_rq_bytes(rq));
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		printk(KERN_INFO "  cdb: ");
+		pr_info("  cdb: ");
 		for (bit = 0; bit < BLK_MAX_CDB; bit++)
-			printk("%02x ", rq->cmd[bit]);
-		printk("\n");
+			pr_cont("%02x ", rq->cmd[bit]);
+		pr_cont("\n");
 	}
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
@@ -1023,8 +1024,8 @@ fail_elvpriv:
 	 * shouldn't stall IO.  Treat this request as !elvpriv.  This will
 	 * disturb iosched and blkcg but weird is bettern than dead.
 	 */
-	printk_ratelimited(KERN_WARNING "%s: request aux data allocation failed, iosched may be disturbed\n",
-			   dev_name(q->backing_dev_info.dev));
+	pr_warn_ratelimited("%s: request aux data allocation failed, iosched may be disturbed\n",
+			    dev_name(q->backing_dev_info.dev));
 
 	rq->cmd_flags &= ~REQ_ELVPRIV;
 	rq->elv.icq = NULL;
@@ -1624,12 +1625,12 @@ static void handle_bad_sector(struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
-			bdevname(bio->bi_bdev, b),
-			bio->bi_rw,
-			(unsigned long long)bio_end_sector(bio),
-			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
+	pr_info("attempt to access beyond end of device\n");
+	pr_info("%s: rw=%ld, want=%llu, limit=%llu\n",
+		bdevname(bio->bi_bdev, b),
+		bio->bi_rw,
+		(unsigned long long)bio_end_sector(bio),
+		(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
 
 	set_bit(BIO_EOF, &bio->bi_flags);
 }
@@ -1714,17 +1715,15 @@ generic_make_request_checks(struct bio *bio)
 
 	q = bdev_get_queue(bio->bi_bdev);
 	if (unlikely(!q)) {
-		printk(KERN_ERR
-		       "generic_make_request: Trying to access "
-			"nonexistent block-device %s (%Lu)\n",
-			bdevname(bio->bi_bdev, b),
-			(long long) bio->bi_iter.bi_sector);
+		pr_err("generic_make_request: Trying to access nonexistent block-device %s (%llu)\n",
+		       bdevname(bio->bi_bdev, b),
+		       (long long) bio->bi_iter.bi_sector);
 		goto end_io;
 	}
 
 	if (likely(bio_is_rw(bio) &&
 		   nr_sectors > queue_max_hw_sectors(q))) {
-		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
+		pr_err("bio too big device %s (%u > %u)\n",
 		       bdevname(bio->bi_bdev, b),
 		       bio_sectors(bio),
 		       queue_max_hw_sectors(q));
@@ -1899,12 +1898,11 @@ void submit_bio(int rw, struct bio *bio)
 
 		if (unlikely(block_dump)) {
 			char b[BDEVNAME_SIZE];
-			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
-			current->comm, task_pid_nr(current),
-				(rw & WRITE) ? "WRITE" : "READ",
-				(unsigned long long)bio->bi_iter.bi_sector,
-				bdevname(bio->bi_bdev, b),
-				count);
+			pr_debug("%s(%d): %s block %llu on %s (%u sectors)\n",
+				 current->comm, task_pid_nr(current),
+				 (rw & WRITE) ? "WRITE" : "READ",
+				 (unsigned long long)bio->bi_iter.bi_sector,
+				 bdevname(bio->bi_bdev, b), count);
 		}
 	}
 
@@ -1939,7 +1937,7 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 		return 0;
 
 	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
-		printk(KERN_ERR "%s: over max size limit.\n", __func__);
+		pr_err("%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
 
@@ -1951,7 +1949,7 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 	 */
 	blk_recalc_rq_segments(rq);
 	if (rq->nr_phys_segments > queue_max_segments(q)) {
-		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
+		pr_err("%s: over max segments limit.\n", __func__);
 		return -EIO;
 	}
 
@@ -2238,7 +2236,7 @@ struct request *blk_peek_request(struct request_queue *q)
 			blk_start_request(rq);
 			__blk_end_request_all(rq, -EIO);
 		} else {
-			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
+			pr_err("%s: bad return=%d\n", __func__, ret);
 			break;
 		}
 	}
@@ -2394,7 +2392,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 			error_type = "I/O";
 			break;
 		}
-		printk_ratelimited(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+		pr_err_ratelimited("end_request: %s error, dev %s, sector %llu\n",
 				   error_type, req->rq_disk ?
 				   req->rq_disk->disk_name : "?",
 				   (unsigned long long)blk_rq_pos(req));
-- 
1.8.4.5

