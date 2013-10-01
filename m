Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3JASdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:33:14 -0400
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:46597 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262Ab3JASdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:33:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:69:355:379:541:599:960:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2559:2562:2828:2898:2899:2901:2904:2911:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4384:4385:4395:4419:4425:4605:5007:7652:7903:8603:8957:9010:9592:10848:11026:11232:11233:11914:12043:12291:12294:12296:12438:12517:12519:12555:12660:12663:12683:12740:13161:13229:13868:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: park46_38211b1886334
X-Filterd-Recvd-Size: 77150
Message-ID: <1380652383.1924.5.camel@joe-AO722>
Subject: Re: [PATCH 1/2] skd: Replaced custom debug PRINTKs with pr_debug
From: Joe Perches <joe@perches.com>
To: OS Engineering <osengineering@stec-inc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Date: Tue, 01 Oct 2013 11:33:03 -0700
In-Reply-To: <26D762E250385C4D8E9D6EC3C8E47DC11E70587F@sambx4.stec-inc.ad>
References: <26D762E250385C4D8E9D6EC3C8E47DC11E70587F@sambx4.stec-inc.ad>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 12:25 +0000, OS Engineering wrote:
> Hi Jens,
> 
> I'm sending a patch to replace custom debug macros with pr_debug(). Kindly please review the patch.
> Thanking you.

I think that this doesn't differentiate between
the 2 debugging levels currently implemented.

I'd do something like this:

Add pr_fmt to prefix pr_<level> uses with "skd: "
Add skd_<level> convenience logging macros
Convert VPRINTK/DPRINTK to skd_dbg(level, skdev, fmt, ...)
Convert pr_<level>("(%s): ...", skd_name(skdev), ...) uses to
	skd_<level>(skdev, ...)
Use kcalloc not kzalloc with multiply
Remove a couple unnecessary pr_err function logging uses
Add missing newline to logging

---

 drivers/block/skd_main.c | 677 ++++++++++++++++++++++-------------------------
 1 file changed, 313 insertions(+), 364 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3110f68..6a4461c 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -16,6 +16,8 @@
  * Added support for DISCARD / FLUSH and FUA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -68,13 +70,15 @@ enum {
 	SKD_FLUSH_DATA_SECOND,
 };
 
-#define DPRINTK(skdev, fmt, args ...) \
-	do { \
-		if (unlikely((skdev)->dbg_level > 0)) {	\
-			pr_err("%s:%s:%d " fmt, (skdev)->name,	\
-			       __func__, __LINE__, ## args); \
-		} \
-	} while (0)
+#define skd_err(skdev, fmt, ...)					\
+	pr_err("(%s): " fmt, (skdev)->name, ##__VA_ARGS__)
+#define skd_info(skdev, fmt, ...)					\
+	pr_info("(%s): " fmt, (skdev)->name, ##__VA_ARGS__)
+#define skd_dbg(level, skdev, fmt, ...)					\
+do {									\
+	if (unlikely((skdev)->dbg_level >= (level)))			\
+		pr_debug("%s" fmt, (skdev)->name, ##__VA_ARGS__);	\
+} while (0)
 
 #define SKD_ASSERT(expr) \
 	do { \
@@ -84,19 +88,9 @@ enum {
 		} \
 	} while (0)
 
-#define VPRINTK(skdev, fmt, args ...) \
-	do { \
-		if (unlikely((skdev)->dbg_level > 1)) {	\
-			pr_err("%s:%s:%d " fmt, (skdev)->name,	\
-			       __func__, __LINE__, ## args); \
-		} \
-	} while (0)
-
-
 #define DRV_NAME "skd"
 #define DRV_VERSION "2.2.1"
 #define DRV_BUILD_ID "0260"
-#define PFX DRV_NAME ": "
 #define DRV_BIN_VERSION 0x100
 #define DRV_VER_COMPL   "2.2.1." DRV_BUILD_ID
 
@@ -408,7 +402,7 @@ static inline u32 skd_reg_read32(struct skd_device *skdev, u32 offset)
 		barrier();
 		val = readl(skdev->mem_map[1] + offset);
 		barrier();
-		VPRINTK(skdev, "offset %x = %x\n", offset, val);
+		skd_dbg(2, skdev, "offset %x = %x\n", offset, val);
 		return val;
 	}
 
@@ -428,7 +422,7 @@ static inline void skd_reg_write32(struct skd_device *skdev, u32 val,
 		barrier();
 		readl(skdev->mem_map[1] + offset);
 		barrier();
-		VPRINTK(skdev, "offset %x = %x\n", offset, val);
+		skd_dbg(2, skdev, "offset %x = %x\n", offset, val);
 	}
 }
 
@@ -446,7 +440,7 @@ static inline void skd_reg_write64(struct skd_device *skdev, u64 val,
 		barrier();
 		readq(skdev->mem_map[1] + offset);
 		barrier();
-		VPRINTK(skdev, "offset %x = %016llx\n", offset, val);
+		skd_dbg(2, skdev, "offset %x = %016llx\n", offset, val);
 	}
 }
 
@@ -565,7 +559,7 @@ static void skd_start_queue(struct skd_device *skdev)
 	if (!skd_bio) {
 		blk_start_queue(skdev->queue);
 	} else {
-		pr_err("(%s): Starting queue\n", skd_name(skdev));
+		skd_err(skdev, "Starting queue\n");
 		skdev->queue_stopped = 0;
 		skd_request_fn(skdev->queue);
 	}
@@ -772,7 +766,7 @@ static void skd_request_fn(struct request_queue *q)
 			if (io_flags & REQ_FUA)
 				fua++;
 
-			VPRINTK(skdev,
+			skd_dbg(2, skdev,
 				"new req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
 				req, lba, lba, count, count, data_dir);
 		} else {
@@ -780,7 +774,7 @@ static void skd_request_fn(struct request_queue *q)
 				/* Process data part of FLUSH request. */
 				bio = (struct bio *)skd_flush_cmd_dequeue(skdev);
 				flush++;
-				VPRINTK(skdev, "processing FLUSH request with data.\n");
+				skd_dbg(2, skdev, "processing FLUSH request with data.\n");
 			} else {
 				/* peek at our bio queue */
 				bio = bio_list_peek(&skdev->bio_queue);
@@ -795,7 +789,7 @@ static void skd_request_fn(struct request_queue *q)
 			data_dir = bio_data_dir(bio);
 			io_flags = bio->bi_rw;
 
-			VPRINTK(skdev,
+			skd_dbg(2, skdev,
 				"new bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
 				bio, lba, lba, count, count, data_dir);
 
@@ -813,7 +807,7 @@ static void skd_request_fn(struct request_queue *q)
 
 		/* Are too many requets already in progress? */
 		if (skdev->in_flight >= skdev->cur_max_queue_depth) {
-			VPRINTK(skdev, "qdepth %d, limit %d\n",
+			skd_dbg(2, skdev, "qdepth %d, limit %d\n",
 				skdev->in_flight, skdev->cur_max_queue_depth);
 			break;
 		}
@@ -821,7 +815,7 @@ static void skd_request_fn(struct request_queue *q)
 		/* Is a skd_request_context available? */
 		skreq = skdev->skreq_free_list;
 		if (skreq == NULL) {
-			VPRINTK(skdev, "Out of req=%p\n", q);
+			skd_dbg(2, skdev, "Out of req=%p\n", q);
 			break;
 		}
 		SKD_ASSERT(skreq->state == SKD_REQ_STATE_IDLE);
@@ -830,7 +824,7 @@ static void skd_request_fn(struct request_queue *q)
 		/* Now we check to see if we can get a fit msg */
 		if (skmsg == NULL) {
 			if (skdev->skmsg_free_list == NULL) {
-				VPRINTK(skdev, "Out of msg\n");
+				skd_dbg(2, skdev, "Out of msg\n");
 				break;
 			}
 		}
@@ -870,7 +864,8 @@ static void skd_request_fn(struct request_queue *q)
 			/* Are there any FIT msg buffers available? */
 			skmsg = skdev->skmsg_free_list;
 			if (skmsg == NULL) {
-				VPRINTK(skdev, "Out of msg skdev=%p\n", skdev);
+				skd_dbg(2, skdev, "Out of msg skdev=%p\n",
+					skdev);
 				break;
 			}
 			SKD_ASSERT(skmsg->state == SKD_MSG_STATE_IDLE);
@@ -919,7 +914,8 @@ static void skd_request_fn(struct request_queue *q)
 		if (io_flags & REQ_DISCARD) {
 			page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
 			if (!page) {
-				pr_err("request_fn:Page allocation failed.\n");
+				pr_err("%s: Page allocation failed\n",
+				       __func__);
 				skd_end_request(skdev, skreq, -ENOMEM);
 				break;
 			}
@@ -953,7 +949,7 @@ static void skd_request_fn(struct request_queue *q)
 			 * only resource that has been allocated but might
 			 * not be used is that the FIT msg could be empty.
 			 */
-			DPRINTK(skdev, "error Out\n");
+			skd_dbg(1, skdev, "error Out\n");
 			skd_end_request(skdev, skreq, error);
 			continue;
 		}
@@ -978,7 +974,7 @@ skip_sg:
 		timo_slot = skreq->timeout_stamp & SKD_TIMEOUT_SLOT_MASK;
 		skdev->timeout_slot[timo_slot]++;
 		skdev->in_flight++;
-		VPRINTK(skdev, "req=0x%x busy=%d\n",
+		skd_dbg(2, skdev, "req=0x%x busy=%d\n",
 			skreq->id, skdev->in_flight);
 
 		/*
@@ -1001,7 +997,7 @@ skip_sg:
 	if (skmsg != NULL) {
 		/* Bigger than just a FIT msg header? */
 		if (skmsg->length > sizeof(struct fit_msg_hdr)) {
-			VPRINTK(skdev, "sending msg=%p, len %d\n",
+			skd_dbg(2, skdev, "sending msg=%p, len %d\n",
 				skmsg, skmsg->length);
 			skd_send_fitmsg(skdev, skmsg);
 		} else {
@@ -1035,7 +1031,7 @@ static void skd_end_request_blk(struct skd_device *skdev,
 
 	if ((io_flags & REQ_DISCARD) &&
 		(skreq->discard_page == 1)) {
-		VPRINTK(skdev, "skd_end_request_blk, free the page!");
+		skd_dbg(2, skdev, "skd_end_request_blk, free the page!");
 		free_page((unsigned long)req->buffer);
 		req->buffer = NULL;
 	}
@@ -1046,10 +1042,10 @@ static void skd_end_request_blk(struct skd_device *skdev,
 		u32 lba = (u32)blk_rq_pos(req);
 		u32 count = blk_rq_sectors(req);
 
-		pr_err("(%s): Error cmd=%s sect=%u count=%u id=0x%x\n",
-		       skd_name(skdev), cmd, lba, count, skreq->id);
+		skd_err(skdev, "Error cmd=%s sect=%u count=%u id=0x%x\n",
+			cmd, lba, count, skreq->id);
 	} else
-		VPRINTK(skdev, "id=0x%x error=%d\n", skreq->id, error);
+		skd_dbg(2, skdev, "id=0x%x error=%d\n", skreq->id, error);
 
 	__blk_end_request_all(skreq->req, error);
 }
@@ -1101,11 +1097,11 @@ static int skd_preop_sg_list_blk(struct skd_device *skdev,
 	skreq->sksg_list[n_sg - 1].control = FIT_SGD_CONTROL_LAST;
 
 	if (unlikely(skdev->dbg_level > 1)) {
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
+		skd_dbg(2, skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
 			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
 		for (i = 0; i < n_sg; i++) {
 			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
+			skd_dbg(2, skdev, "  sg[%d] count=%u ctrl=0x%x "
 				"addr=0x%llx next=0x%llx\n",
 				i, sgd->byte_count, sgd->control,
 				sgd->host_side_addr, sgd->next_desc_ptr);
@@ -1140,7 +1136,7 @@ static void skd_end_request_bio(struct skd_device *skdev,
 
 	if ((io_flags & REQ_DISCARD) &&
 		(skreq->discard_page == 1)) {
-		VPRINTK(skdev, "biomode: skd_end_request: freeing DISCARD page.\n");
+		skd_dbg(2, skdev, "biomode: skd_end_request: freeing DISCARD page.\n");
 		free_page((unsigned long)page_address(bio->bi_io_vec->bv_page));
 	}
 
@@ -1148,8 +1144,8 @@ static void skd_end_request_bio(struct skd_device *skdev,
 		u32 lba = (u32)skreq->bio->bi_sector;
 		u32 count = bio_sectors(skreq->bio);
 		char *cmd = (rw == WRITE) ? "write" : "read";
-		pr_err("(%s): Error cmd=%s sect=%u count=%u id=0x%x\n",
-		       skd_name(skdev), cmd, lba, count, skreq->id);
+		skd_err(skdev, "Error cmd=%s sect=%u count=%u id=0x%x\n",
+			cmd, lba, count, skreq->id);
 	}
 	{
 		int cpu = part_stat_lock();
@@ -1165,7 +1161,7 @@ static void skd_end_request_bio(struct skd_device *skdev,
 		part_stat_unlock();
 	}
 
-	VPRINTK(skdev, "id=0x%x error=%d\n", skreq->id, error);
+	skd_dbg(2, skdev, "id=0x%x error=%d\n", skreq->id, error);
 
 	bio_endio(skreq->bio, error);
 }
@@ -1193,8 +1189,7 @@ static int skd_preop_sg_list_bio(struct skd_device *skdev,
 		return -EINVAL;
 
 	if (n_sg > skdev->sgs_per_request) {
-		pr_err("(%s): sg overflow n=%d\n",
-		       skd_name(skdev), n_sg);
+		skd_err(skdev, "sg overflow n=%d\n", n_sg);
 		skreq->n_sg = 0;
 		return -EIO;
 	}
@@ -1208,9 +1203,8 @@ static int skd_preop_sg_list_bio(struct skd_device *skdev,
 
 		if (count == 0 || count > 64u * 1024u || (count & 3) != 0
 		    || (dma_addr & 3) != 0) {
-			pr_err(
-			       "(%s): Bad sg ix=%d count=%d addr=0x%llx\n",
-			       skd_name(skdev), i, count, dma_addr);
+			skd_err(skdev, "Bad sg ix=%d count=%d addr=0x%llx\n",
+				i, count, dma_addr);
 			errs++;
 		}
 
@@ -1230,18 +1224,18 @@ static int skd_preop_sg_list_bio(struct skd_device *skdev,
 	 if (!(io_flags & REQ_DISCARD)) {
 		count = bio_sectors(bio) << 9u;
 		if (count != skreq->sg_byte_count) {
-			pr_err("(%s): mismatch count sg=%d req=%d\n",
-			       skd_name(skdev), skreq->sg_byte_count, count);
+			skd_err(skdev, "mismatch count sg=%d req=%d\n",
+				skreq->sg_byte_count, count);
 			errs++;
 		}
 	}
 
 	if (unlikely(skdev->dbg_level > 1)) {
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
+		skd_dbg(2, skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
 			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
 		for (i = 0; i < n_sg; i++) {
 			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
+			skd_dbg(2, skdev, "  sg[%d] count=%u ctrl=0x%x "
 				"addr=0x%llx next=0x%llx\n",
 				i, sgd->byte_count, sgd->control,
 				sgd->host_side_addr, sgd->next_desc_ptr);
@@ -1399,10 +1393,10 @@ static void skd_timer_tick(ulong arg)
 	/* Something is overdue */
 	overdue_timestamp = skdev->timeout_stamp - SKD_N_TIMEOUT_SLOT;
 
-	DPRINTK(skdev, "found %d timeouts, draining busy=%d\n",
+	skd_dbg(1, skdev, "found %d timeouts, draining busy=%d\n",
 		skdev->timeout_slot[timo_slot], skdev->in_flight);
-	pr_err("(%s): Overdue IOs (%d), busy %d\n",
-	       skd_name(skdev), skdev->timeout_slot[timo_slot],
+	skd_err(skdev, "Overdue IOs (%d), busy %d\n",
+		skdev->timeout_slot[timo_slot],
 	       skdev->in_flight);
 
 	skdev->timer_countdown = SKD_DRAINING_TIMO;
@@ -1423,7 +1417,7 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 	case SKD_DRVR_STATE_LOAD:
 		break;
 	case SKD_DRVR_STATE_BUSY_SANITIZE:
-		VPRINTK(skdev, "drive busy sanitize[%x], driver[%x]\n",
+		skd_dbg(2, skdev, "drive busy sanitize[%x], driver[%x]\n",
 			skdev->drive_state, skdev->state);
 		/* If we've been in sanitize for 3 seconds, we figure we're not
 		 * going to get anymore completions, so recover requests now
@@ -1438,13 +1432,13 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 	case SKD_DRVR_STATE_BUSY:
 	case SKD_DRVR_STATE_BUSY_IMMINENT:
 	case SKD_DRVR_STATE_BUSY_ERASE:
-		VPRINTK(skdev, "busy[%x], countdown=%d\n",
+		skd_dbg(2, skdev, "busy[%x], countdown=%d\n",
 			skdev->state, skdev->timer_countdown);
 		if (skdev->timer_countdown > 0) {
 			skdev->timer_countdown--;
 			return;
 		}
-		DPRINTK(skdev, "busy[%x], timedout=%d, restarting device.",
+		skd_dbg(1, skdev, "busy[%x], timedout=%d, restarting device.",
 			skdev->state, skdev->timer_countdown);
 		skd_restart_device(skdev);
 		break;
@@ -1459,8 +1453,8 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 		 * revcover at some point. */
 		skdev->state = SKD_DRVR_STATE_FAULT;
 
-		pr_err("(%s): DriveFault Connect Timeout (%x)\n",
-		       skd_name(skdev), skdev->drive_state);
+		skd_err(skdev, "DriveFault Connect Timeout (%x)\n",
+			skdev->drive_state);
 
 		/*start the queue so we can respond with error to requests */
 		/* wakeup anyone waiting for startup complete */
@@ -1478,7 +1472,7 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 		break;
 
 	case SKD_DRVR_STATE_DRAINING_TIMEOUT:
-		DPRINTK(skdev,
+		skd_dbg(1, skdev,
 			"draining busy [%d] tick[%d] qdb[%d] tmls[%d]\n",
 			skdev->timo_slot,
 			skdev->timer_countdown,
@@ -1486,7 +1480,7 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 			skdev->timeout_slot[skdev->timo_slot]);
 		/* if the slot has cleared we can let the I/O continue */
 		if (skdev->timeout_slot[skdev->timo_slot] == 0) {
-			DPRINTK(skdev, "Slot drained, starting queue.\n");
+			skd_dbg(1, skdev, "Slot drained, starting queue.\n");
 			skdev->state = SKD_DRVR_STATE_ONLINE;
 			skd_start_queue(skdev);
 			return;
@@ -1506,8 +1500,8 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 		/* For now, we fault the drive. Could attempt resets to
 		 * revcover at some point. */
 		skdev->state = SKD_DRVR_STATE_FAULT;
-		pr_err("(%s): DriveFault Reconnect Timeout (%x)\n",
-		       skd_name(skdev), skdev->drive_state);
+		skd_err(skdev, "DriveFault Reconnect Timeout (%x)\n",
+			skdev->drive_state);
 
 		/*
 		 * Recovering does two things:
@@ -1529,8 +1523,8 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 			 * fail. This is to mitigate hung processes. */
 			skd_recover_requests(skdev, 0);
 		else {
-			pr_err("(%s): Disable BusMaster (%x)\n",
-			       skd_name(skdev), skdev->drive_state);
+			skd_err(skdev, "Disable BusMaster (%x)\n",
+				skdev->drive_state);
 			pci_disable_device(skdev->pdev);
 			skd_disable_interrupts(skdev);
 			skd_recover_requests(skdev, 0);
@@ -1562,8 +1556,7 @@ static int skd_start_timer(struct skd_device *skdev)
 
 	rc = mod_timer(&skdev->timer, (jiffies + HZ));
 	if (rc)
-		pr_err("%s: failed to start timer %d\n",
-		       __func__, rc);
+		pr_err("%s: failed to start timer %d\n", __func__, rc);
 	return rc;
 }
 
@@ -1609,7 +1602,7 @@ static int skd_bdev_ioctl(struct block_device *bdev, fmode_t mode,
 	struct skd_device *skdev = disk->private_data;
 	void __user *p = (void *)arg;
 
-	DPRINTK(skdev, "%s: CMD[%s] ioctl  mode 0x%x, cmd 0x%x arg %0lx\n",
+	skd_dbg(1, skdev, "%s: CMD[%s] ioctl  mode 0x%x, cmd 0x%x arg %0lx\n",
 		disk->disk_name, current->comm, mode, cmd_in, arg);
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1630,7 +1623,7 @@ static int skd_bdev_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	}
 
-	DPRINTK(skdev, "%s:  completion rc %d\n", disk->disk_name, rc);
+	skd_dbg(1, skdev, "%s:  completion rc %d\n", disk->disk_name, rc);
 	return rc;
 }
 
@@ -1651,7 +1644,7 @@ static int skd_ioctl_sg_io(struct skd_device *skdev, fmode_t mode,
 		break;
 
 	default:
-		DPRINTK(skdev, "drive not online\n");
+		skd_dbg(1, skdev, "drive not online\n");
 		rc = -ENXIO;
 		goto out;
 	}
@@ -1687,33 +1680,34 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 	int i, acc;
 
 	if (!access_ok(VERIFY_WRITE, sksgio->argp, sizeof(sg_io_hdr_t))) {
-		DPRINTK(skdev, "access sg failed %p\n", sksgio->argp);
+		skd_dbg(1, skdev, "access sg failed %p\n", sksgio->argp);
 		return -EFAULT;
 	}
 
 	if (__copy_from_user(sgp, sksgio->argp, sizeof(sg_io_hdr_t))) {
-		DPRINTK(skdev, "copy_from_user sg failed %p\n", sksgio->argp);
+		skd_dbg(1, skdev, "copy_from_user sg failed %p\n",
+			sksgio->argp);
 		return -EFAULT;
 	}
 
 	if (sgp->interface_id != SG_INTERFACE_ID_ORIG) {
-		DPRINTK(skdev, "interface_id invalid 0x%x\n",
+		skd_dbg(1, skdev, "interface_id invalid 0x%x\n",
 			sgp->interface_id);
 		return -EINVAL;
 	}
 
 	if (sgp->cmd_len > sizeof(sksgio->cdb)) {
-		DPRINTK(skdev, "cmd_len invalid %d\n", sgp->cmd_len);
+		skd_dbg(1, skdev, "cmd_len invalid %d\n", sgp->cmd_len);
 		return -EINVAL;
 	}
 
 	if (sgp->iovec_count > 256) {
-		DPRINTK(skdev, "iovec_count invalid %d\n", sgp->iovec_count);
+		skd_dbg(1, skdev, "iovec_count invalid %d\n", sgp->iovec_count);
 		return -EINVAL;
 	}
 
 	if (sgp->dxfer_len > (PAGE_SIZE * SKD_N_SG_PER_SPECIAL)) {
-		DPRINTK(skdev, "dxfer_len invalid %d\n", sgp->dxfer_len);
+		skd_dbg(1, skdev, "dxfer_len invalid %d\n", sgp->dxfer_len);
 		return -EINVAL;
 	}
 
@@ -1732,18 +1726,19 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		break;
 
 	default:
-		DPRINTK(skdev, "dxfer_dir invalid %d\n", sgp->dxfer_direction);
+		skd_dbg(1, skdev, "dxfer_dir invalid %d\n",
+			sgp->dxfer_direction);
 		return -EINVAL;
 	}
 
 	if (copy_from_user(sksgio->cdb, sgp->cmdp, sgp->cmd_len)) {
-		DPRINTK(skdev, "copy_from_user cmdp failed %p\n", sgp->cmdp);
+		skd_dbg(1, skdev, "copy_from_user cmdp failed %p\n", sgp->cmdp);
 		return -EFAULT;
 	}
 
 	if (sgp->mx_sb_len != 0) {
 		if (!access_ok(VERIFY_WRITE, sgp->sbp, sgp->mx_sb_len)) {
-			DPRINTK(skdev, "access sbp failed %p\n", sgp->sbp);
+			skd_dbg(1, skdev, "access sbp failed %p\n", sgp->sbp);
 			return -EFAULT;
 		}
 	}
@@ -1760,7 +1755,7 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 
 		iov = kmalloc(nbytes, GFP_KERNEL);
 		if (iov == NULL) {
-			DPRINTK(skdev, "alloc iovec failed %d\n",
+			skd_dbg(1, skdev, "alloc iovec failed %d\n",
 				sgp->iovec_count);
 			return -ENOMEM;
 		}
@@ -1768,7 +1763,7 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		sksgio->iovcnt = sgp->iovec_count;
 
 		if (copy_from_user(iov, sgp->dxferp, nbytes)) {
-			DPRINTK(skdev, "copy_from_user iovec failed %p\n",
+			skd_dbg(1, skdev, "copy_from_user iovec failed %p\n",
 				sgp->dxferp);
 			return -EFAULT;
 		}
@@ -1797,7 +1792,7 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		struct sg_iovec *iov = sksgio->iov;
 		for (i = 0; i < sksgio->iovcnt; i++, iov++) {
 			if (!access_ok(acc, iov->iov_base, iov->iov_len)) {
-				DPRINTK(skdev, "access data failed %p/%d\n",
+				skd_dbg(1, skdev, "access data failed %p/%d\n",
 					iov->iov_base, (int)iov->iov_len);
 				return -EFAULT;
 			}
@@ -1833,14 +1828,14 @@ static int skd_sg_io_obtain_skspcl(struct skd_device *skdev,
 			break;
 		}
 
-		DPRINTK(skdev, "blocking\n");
+		skd_dbg(1, skdev, "blocking\n");
 
 		rc = wait_event_interruptible_timeout(
 				skdev->waitq,
 				(skdev->skspcl_free_list != NULL),
 				msecs_to_jiffies(sksgio->sg.timeout));
 
-		DPRINTK(skdev, "unblocking, rc=%d\n", rc);
+		skd_dbg(1, skdev, "unblocking, rc=%d\n", rc);
 
 		if (rc <= 0) {
 			if (rc == 0)
@@ -1917,12 +1912,12 @@ static int skd_skreq_prep_buffering(struct skd_device *skdev,
 	if (unlikely(skdev->dbg_level > 1)) {
 		u32 i;
 
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
+		skd_dbg(2, skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
 			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
 		for (i = 0; i < skreq->n_sg; i++) {
 			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
 
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
+			skd_dbg(2, skdev, "  sg[%d] count=%u ctrl=0x%x "
 				"addr=0x%llx next=0x%llx\n",
 				i, sgd->byte_count, sgd->control,
 				sgd->host_side_addr, sgd->next_desc_ptr);
@@ -2047,7 +2042,7 @@ static int skd_sg_io_await(struct skd_device *skdev, struct skd_sg_io *sksgio)
 	spin_lock_irqsave(&skdev->lock, flags);
 
 	if (sksgio->skspcl->req.state == SKD_REQ_STATE_ABORTED) {
-		DPRINTK(skdev, "skspcl %p aborted\n", sksgio->skspcl);
+		skd_dbg(1, skdev, "skspcl %p aborted\n", sksgio->skspcl);
 
 		/* Build check cond, sense and let command finish. */
 		/* For a timeout, we must fabricate completion and sense
@@ -2072,11 +2067,11 @@ static int skd_sg_io_await(struct skd_device *skdev, struct skd_sg_io *sksgio)
 		sksgio->skspcl->orphaned = 1;
 		sksgio->skspcl = NULL;
 		if (rc == 0) {
-			DPRINTK(skdev, "timed out %p (%u ms)\n", sksgio,
+			skd_dbg(1, skdev, "timed out %p (%u ms)\n", sksgio,
 				sksgio->sg.timeout);
 			rc = -ETIMEDOUT;
 		} else {
-			DPRINTK(skdev, "cntlc %p\n", sksgio);
+			skd_dbg(1, skdev, "cntlc %p\n", sksgio);
 			rc = -EINTR;
 		}
 	}
@@ -2106,7 +2101,7 @@ static int skd_sg_io_put_status(struct skd_device *skdev,
 	if (sgp->masked_status || sgp->host_status || sgp->driver_status)
 		sgp->info |= SG_INFO_CHECK;
 
-	DPRINTK(skdev, "status %x masked %x resid 0x%x\n", sgp->status,
+	skd_dbg(1, skdev, "status %x masked %x resid 0x%x\n", sgp->status,
 		sgp->masked_status, sgp->resid);
 
 	if (sgp->masked_status == SAM_STAT_CHECK_CONDITION) {
@@ -2119,7 +2114,7 @@ static int skd_sg_io_put_status(struct skd_device *skdev,
 			sgp->sb_len_wr = nbytes;
 
 			if (__copy_to_user(sgp->sbp, ei, nbytes)) {
-				DPRINTK(skdev, "copy_to_user sense failed %p\n",
+				skd_dbg(1, skdev, "copy_to_user sense failed %p\n",
 					sgp->sbp);
 				return -EFAULT;
 			}
@@ -2127,7 +2122,7 @@ static int skd_sg_io_put_status(struct skd_device *skdev,
 	}
 
 	if (__copy_to_user(sksgio->argp, sgp, sizeof(sg_io_hdr_t))) {
-		DPRINTK(skdev, "copy_to_user sg failed %p\n", sksgio->argp);
+		skd_dbg(1, skdev, "copy_to_user sg failed %p\n", sksgio->argp);
 		return -EFAULT;
 	}
 
@@ -2295,9 +2290,8 @@ static void skd_log_check_status(struct skd_device *skdev, u8 status, u8 key,
 	/* If the check condition is of special interest, log a message */
 	if ((status == SAM_STAT_CHECK_CONDITION) && (key == 0x02)
 	    && (code == 0x04) && (qual == 0x06)) {
-		pr_err("(%s): *** LOST_WRITE_DATA ERROR *** key/asc/"
-		       "ascq/fruc %02x/%02x/%02x/%02x\n",
-		       skd_name(skdev), key, code, qual, fruc);
+		skd_err(skdev, "*** LOST_WRITE_DATA ERROR *** key/asc/ascq/fruc %02x/%02x/%02x/%02x\n",
+			key, code, qual, fruc);
 	}
 }
 
@@ -2315,7 +2309,7 @@ static void skd_complete_internal(struct skd_device *skdev,
 
 	SKD_ASSERT(skspcl == &skdev->internal_skspcl);
 
-	DPRINTK(skdev, "complete internal %x\n", scsi->cdb[0]);
+	skd_dbg(1, skdev, "complete internal %x\n", scsi->cdb[0]);
 
 	skspcl->req.completion = *skcomp;
 	skspcl->req.state = SKD_REQ_STATE_IDLE;
@@ -2335,11 +2329,11 @@ static void skd_complete_internal(struct skd_device *skdev,
 			skd_send_internal_skspcl(skdev, skspcl, WRITE_BUFFER);
 		else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				VPRINTK(skdev, "TUR failed, don't send anymore"
+				skd_dbg(2, skdev, "TUR failed, don't send anymore"
 					"state 0x%x\n", skdev->state);
 				return;
 			}
-			DPRINTK(skdev, "**** TUR failed, retry skerr\n");
+			skd_dbg(1, skdev, "**** TUR failed, retry skerr\n");
 			skd_send_internal_skspcl(skdev, skspcl, 0x00);
 		}
 		break;
@@ -2349,11 +2343,11 @@ static void skd_complete_internal(struct skd_device *skdev,
 			skd_send_internal_skspcl(skdev, skspcl, READ_BUFFER);
 		else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				VPRINTK(skdev, "write buffer failed, don't send"
+				skd_dbg(2, skdev, "write buffer failed, don't send"
 					" anymore state 0x%x\n", skdev->state);
 				return;
 			}
-			DPRINTK(skdev,
+			skd_dbg(1, skdev,
 				"**** write buffer failed, retry skerr\n");
 			skd_send_internal_skspcl(skdev, skspcl, 0x00);
 		}
@@ -2365,29 +2359,26 @@ static void skd_complete_internal(struct skd_device *skdev,
 				skd_send_internal_skspcl(skdev, skspcl,
 							 READ_CAPACITY);
 			else {
-				pr_err(
-				       "(%s):*** W/R Buffer mismatch %d ***\n",
-				       skd_name(skdev), skdev->connect_retries);
+				skd_err(skdev, "*** W/R Buffer mismatch %d ***\n",
+					skdev->connect_retries);
 				if (skdev->connect_retries <
 				    SKD_MAX_CONNECT_RETRIES) {
 					skdev->connect_retries++;
 					skd_soft_reset(skdev);
 				} else {
-					pr_err(
-					       "(%s): W/R Buffer Connect Error\n",
-					       skd_name(skdev));
+					skd_err(skdev, "W/R Buffer Connect Error\n");
 					return;
 				}
 			}
 
 		} else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				VPRINTK(skdev,
+				skd_dbg(2, skdev,
 					"read buffer failed, don't send anymore"
 					"state 0x%x\n", skdev->state);
 				return;
 			}
-			DPRINTK(skdev,
+			skd_dbg(1, skdev,
 				"**** read buffer failed, retry skerr\n");
 			skd_send_internal_skspcl(skdev, skspcl, 0x00);
 		}
@@ -2403,7 +2394,7 @@ static void skd_complete_internal(struct skd_device *skdev,
 				(buf[4] << 24) | (buf[5] << 16) |
 				(buf[6] << 8) | buf[7];
 
-			DPRINTK(skdev, "last lba %d, bs %d\n",
+			skd_dbg(1, skdev, "last lba %d, bs %d\n",
 				skdev->read_cap_last_lba,
 				skdev->read_cap_blocksize);
 
@@ -2416,11 +2407,11 @@ static void skd_complete_internal(struct skd_device *skdev,
 			   (skerr->key == MEDIUM_ERROR)) {
 			skdev->read_cap_last_lba = ~0;
 			set_capacity(skdev->disk, skdev->read_cap_last_lba + 1);
-			DPRINTK(skdev,
+			skd_dbg(1, skdev,
 				"**** MEDIUM ERROR caused READCAP to fail, ignore failure and continue to inquiry\n");
 			skd_send_internal_skspcl(skdev, skspcl, INQUIRY);
 		} else {
-			DPRINTK(skdev, "**** READCAP failed, retry TUR\n");
+			skd_dbg(1, skdev, "**** READCAP failed, retry TUR\n");
 			skd_send_internal_skspcl(skdev, skspcl,
 						 TEST_UNIT_READY);
 		}
@@ -2437,7 +2428,7 @@ static void skd_complete_internal(struct skd_device *skdev,
 		}
 
 		if (skd_unquiesce_dev(skdev) < 0)
-			DPRINTK(skdev, "**** failed, to ONLINE device\n");
+			skd_dbg(1, skdev, "**** failed, to ONLINE device\n");
 		 /* connection is complete */
 		skdev->connect_retries = 0;
 		break;
@@ -2467,9 +2458,9 @@ static void skd_send_fitmsg(struct skd_device *skdev,
 	u64 qcmd;
 	struct fit_msg_hdr *fmh;
 
-	VPRINTK(skdev, "dma address 0x%llx, busy=%d\n",
+	skd_dbg(2, skdev, "dma address 0x%llx, busy=%d\n",
 		skmsg->mb_dma_address, skdev->in_flight);
-	VPRINTK(skdev, "msg_buf 0x%p, offset %x\n",
+	skd_dbg(2, skdev, "msg_buf 0x%p, offset %x\n",
 		skmsg->msg_buf, skmsg->offset);
 
 	qcmd = skmsg->mb_dma_address;
@@ -2482,7 +2473,7 @@ static void skd_send_fitmsg(struct skd_device *skdev,
 		u8 *bp = (u8 *)skmsg->msg_buf;
 		int i;
 		for (i = 0; i < skmsg->length; i += 8) {
-			VPRINTK(skdev, "  msg[%2d] %02x %02x %02x %02x "
+			skd_dbg(2, skdev, "  msg[%2d] %02x %02x %02x %02x "
 				"%02x %02x %02x %02x\n",
 				i, bp[i + 0], bp[i + 1], bp[i + 2],
 				bp[i + 3], bp[i + 4], bp[i + 5],
@@ -2520,7 +2511,7 @@ static void skd_send_special_fitmsg(struct skd_device *skdev,
 		int i;
 
 		for (i = 0; i < SKD_N_SPECIAL_FITMSG_BYTES; i += 8) {
-			VPRINTK(skdev,
+			skd_dbg(2, skdev,
 				"  spcl[%2d] %02x %02x %02x %02x  "
 				"%02x %02x %02x %02x\n", i,
 				bp[i + 0], bp[i + 1], bp[i + 2], bp[i + 3],
@@ -2529,14 +2520,14 @@ static void skd_send_special_fitmsg(struct skd_device *skdev,
 				i = 64 - 8;
 		}
 
-		VPRINTK(skdev, "skspcl=%p id=%04x sksg_list=%p sksg_dma=%llx\n",
+		skd_dbg(2, skdev, "skspcl=%p id=%04x sksg_list=%p sksg_dma=%llx\n",
 			skspcl, skspcl->req.id, skspcl->req.sksg_list,
 			skspcl->req.sksg_dma_address);
 		for (i = 0; i < skspcl->req.n_sg; i++) {
 			struct fit_sg_descriptor *sgd =
 				&skspcl->req.sksg_list[i];
 
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
+			skd_dbg(2, skdev, "  sg[%d] count=%u ctrl=0x%x "
 				"addr=0x%llx next=0x%llx\n",
 				i, sgd->byte_count, sgd->control,
 				sgd->host_side_addr, sgd->next_desc_ptr);
@@ -2618,11 +2609,10 @@ static enum skd_check_status_action skd_check_status(struct skd_device *skdev,
 {
 	int i, n;
 
-	pr_err("(%s): key/asc/ascq/fruc %02x/%02x/%02x/%02x\n",
-	       skd_name(skdev), skerr->key, skerr->code, skerr->qual,
-	       skerr->fruc);
+	skd_err(skdev, "key/asc/ascq/fruc %02x/%02x/%02x/%02x\n",
+		skerr->key, skerr->code, skerr->qual, skerr->fruc);
 
-	VPRINTK(skdev, "stat: t=%02x stat=%02x k=%02x c=%02x q=%02x "
+	skd_dbg(2, skdev, "stat: t=%02x stat=%02x k=%02x c=%02x q=%02x "
 		"fruc=%02x\n", skerr->type, cmp_status, skerr->key,
 		skerr->code, skerr->qual, skerr->fruc);
 
@@ -2652,10 +2642,8 @@ static enum skd_check_status_action skd_check_status(struct skd_device *skdev,
 				continue;
 
 		if (sns->action == SKD_CHECK_STATUS_REPORT_SMART_ALERT) {
-			pr_err("(%s): SMART Alert: sense key/asc/ascq "
-			       "%02x/%02x/%02x\n",
-			       skd_name(skdev), skerr->key,
-			       skerr->code, skerr->qual);
+			skd_err(skdev, "SMART Alert: sense key/asc/ascq %02x/%02x/%02x\n",
+				skerr->key, skerr->code, skerr->qual);
 		}
 		return sns->action;
 	}
@@ -2664,11 +2652,11 @@ static enum skd_check_status_action skd_check_status(struct skd_device *skdev,
 	 * zero status means good
 	 */
 	if (cmp_status) {
-		DPRINTK(skdev, "status check: error\n");
+		skd_dbg(1, skdev, "status check: error\n");
 		return SKD_CHECK_STATUS_REPORT_ERROR;
 	}
 
-	DPRINTK(skdev, "status check good default\n");
+	skd_dbg(1, skdev, "status check good default\n");
 	return SKD_CHECK_STATUS_REPORT_GOOD;
 }
 
@@ -2686,7 +2674,7 @@ static void skd_resolve_req_exception(struct skd_device *skdev,
 	case SKD_CHECK_STATUS_BUSY_IMMINENT:
 		skd_log_skreq(skdev, skreq, "retry(busy)");
 		skd_requeue_request(skdev, skreq);
-		pr_info("(%s) drive BUSY imminent\n", skd_name(skdev));
+		skd_info(skdev, "drive BUSY imminent\n");
 		skdev->state = SKD_DRVR_STATE_BUSY_IMMINENT;
 		skdev->timer_countdown = SKD_TIMER_MINUTES(20);
 		skd_quiesce_dev(skdev);
@@ -2806,7 +2794,7 @@ static void skd_do_inq_page_00(struct skd_device *skdev,
 	/* Caller requested "supported pages".  The driver needs to insert
 	 * its page.
 	 */
-	VPRINTK(skdev, "skd_do_driver_inquiry: modify supported pages.\n");
+	skd_dbg(2, skdev, "skd_do_driver_inquiry: modify supported pages.\n");
 
 	/* If the device rejected the request because the CDB was
 	 * improperly formed, then just leave.
@@ -2903,7 +2891,7 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 	struct driver_inquiry_data inq;
 	u16 val;
 
-	VPRINTK(skdev, "skd_do_driver_inquiry: return driver page\n");
+	skd_dbg(2, skdev, "skd_do_driver_inquiry: return driver page\n");
 
 	memset(&inq, 0, sizeof(inq));
 
@@ -3035,14 +3023,14 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 
 		skerr = &skdev->skerr_table[skdev->skcomp_ix];
 
-		VPRINTK(skdev,
+		skd_dbg(2, skdev,
 			"cycle=%d ix=%d got cycle=%d cmdctxt=0x%x stat=%d "
 			"busy=%d rbytes=0x%x proto=%d\n", skdev->skcomp_cycle,
 			skdev->skcomp_ix, cmp_cycle, cmp_cntxt, cmp_status,
 			skdev->in_flight, cmp_bytes, skdev->proto_ver);
 
 		if (cmp_cycle != skdev->skcomp_cycle) {
-			VPRINTK(skdev, "end of completions\n");
+			skd_dbg(2, skdev, "end of completions\n");
 			break;
 		}
 		/*
@@ -3078,14 +3066,12 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 		 * Make sure the request ID for the slot matches.
 		 */
 		if (skreq->id != req_id) {
-			DPRINTK(skdev, "mismatch comp_id=0x%x req_id=0x%x\n",
+			skd_dbg(1, skdev, "mismatch comp_id=0x%x req_id=0x%x\n",
 				req_id, skreq->id);
 			{
 				u16 new_id = cmp_cntxt;
-				pr_err("(%s): Completion mismatch "
-				       "comp_id=0x%04x skreq=0x%04x new=0x%04x\n",
-				       skd_name(skdev), req_id,
-				       skreq->id, new_id);
+				skd_err(skdev, "Completion mismatch comp_id=0x%04x skreq=0x%04x new=0x%04x\n",
+					req_id, skreq->id, new_id);
 
 				continue;
 			}
@@ -3094,7 +3080,7 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 		SKD_ASSERT(skreq->state == SKD_REQ_STATE_BUSY);
 
 		if (skreq->state == SKD_REQ_STATE_ABORTED) {
-			DPRINTK(skdev, "reclaim req %p id=%04x\n",
+			skd_dbg(1, skdev, "reclaim req %p id=%04x\n",
 				skreq, skreq->id);
 			/* a previously timed out command can
 			 * now be cleaned up */
@@ -3115,7 +3101,7 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 
 		if (((!skd_bio) && !skreq->req) ||
 		    ((skd_bio) && !skreq->bio)) {
-			DPRINTK(skdev, "NULL backptr skdreq %p, "
+			skd_dbg(1, skdev, "NULL backptr skdreq %p, "
 				"req=0x%x req_id=0x%x\n",
 				skreq, skreq->id, req_id);
 		} else {
@@ -3132,7 +3118,8 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 						} else {
 							ret = skd_flush_cmd_enqueue(skdev, (void *)skreq->bio);
 							if (ret != 0) {
-								pr_err("Failed to enqueue flush bio with Data. Err=%d.\n", ret);
+								pr_err("Failed to enqueue flush bio with Data. Err=%d\n",
+								       ret);
 								skd_end_request(skdev, skreq, ret);
 							} else {
 								((*enqueued)++);
@@ -3186,7 +3173,7 @@ static void skd_complete_other(struct skd_device *skdev,
 	req_table = req_id & SKD_ID_TABLE_MASK;
 	req_slot = req_id & SKD_ID_SLOT_MASK;
 
-	DPRINTK(skdev, "table=0x%x id=0x%x slot=%d\n", req_table, req_id,
+	skd_dbg(1, skdev, "table=0x%x id=0x%x slot=%d\n", req_table, req_id,
 		req_slot);
 
 	/*
@@ -3255,12 +3242,12 @@ static void skd_complete_special(struct skd_device *skdev,
 				 volatile struct fit_comp_error_info *skerr,
 				 struct skd_special_context *skspcl)
 {
-	DPRINTK(skdev, " completing special request %p\n", skspcl);
+	skd_dbg(1, skdev, " completing special request %p\n", skspcl);
 	if (skspcl->orphaned) {
 		/* Discard orphaned request */
 		/* ?: Can this release directly or does it need
 		 * to use a worker? */
-		DPRINTK(skdev, "release orphaned %p\n", skspcl);
+		skd_dbg(1, skdev, "release orphaned %p\n", skspcl);
 		skd_release_special(skdev, skspcl);
 		return;
 	}
@@ -3298,7 +3285,7 @@ static void skd_release_special(struct skd_device *skdev,
 	skdev->skspcl_free_list = (struct skd_special_context *)skspcl;
 
 	if (was_depleted) {
-		DPRINTK(skdev, "skspcl was depleted\n");
+		skd_dbg(1, skdev, "skspcl was depleted\n");
 		/* Free list was depleted. Their might be waiters. */
 		wake_up_interruptible(&skdev->waitq);
 	}
@@ -3363,7 +3350,7 @@ static skd_isr(int irq, void *ptr)
 		ack = FIT_INT_DEF_MASK;
 		ack &= intstat;
 
-		VPRINTK(skdev, "intstat=0x%x ack=0x%x\n", intstat, ack);
+		skd_dbg(2, skdev, "intstat=0x%x ack=0x%x\n", intstat, ack);
 
 		/* As long as there is an int pending on device, keep
 		 * running loop.  When none, get out, but if we've never
@@ -3429,13 +3416,13 @@ static skd_isr(int irq, void *ptr)
 static void skd_drive_fault(struct skd_device *skdev)
 {
 	skdev->state = SKD_DRVR_STATE_FAULT;
-	pr_err("(%s): Drive FAULT\n", skd_name(skdev));
+	skd_err(skdev, "Drive FAULT\n");
 }
 
 static void skd_drive_disappeared(struct skd_device *skdev)
 {
 	skdev->state = SKD_DRVR_STATE_DISAPPEARED;
-	pr_err("(%s): Drive DISAPPEARED\n", skd_name(skdev));
+	skd_err(skdev, "Drive DISAPPEARED\n");
 }
 
 static void skd_isr_fwstate(struct skd_device *skdev)
@@ -3448,10 +3435,9 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 	sense = SKD_READL(skdev, FIT_STATUS);
 	state = sense & FIT_SR_DRIVE_STATE_MASK;
 
-	pr_err("(%s): s1120 state %s(%d)=>%s(%d)\n",
-	       skd_name(skdev),
-	       skd_drive_state_to_str(skdev->drive_state), skdev->drive_state,
-	       skd_drive_state_to_str(state), state);
+	skd_err(skdev, "s1120 state %s(%d)=>%s(%d)\n",
+		skd_drive_state_to_str(skdev->drive_state), skdev->drive_state,
+		skd_drive_state_to_str(state), state);
 
 	skdev->drive_state = state;
 
@@ -3483,11 +3469,10 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 			skdev->cur_max_queue_depth * 2 / 3 + 1;
 		if (skdev->queue_low_water_mark < 1)
 			skdev->queue_low_water_mark = 1;
-		pr_info(
-		       "(%s): Queue depth limit=%d dev=%d lowat=%d\n",
-		       skd_name(skdev),
-		       skdev->cur_max_queue_depth,
-		       skdev->dev_max_queue_depth, skdev->queue_low_water_mark);
+		skd_info(skdev, "Queue depth limit=%d dev=%d lowat=%d\n",
+			 skdev->cur_max_queue_depth,
+			 skdev->dev_max_queue_depth,
+			 skdev->queue_low_water_mark);
 
 		skd_refresh_device_data(skdev);
 		break;
@@ -3524,7 +3509,8 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 		}
 		break;
 	case FIT_SR_DRIVE_FW_BOOTING:
-		VPRINTK(skdev, "ISR FIT_SR_DRIVE_FW_BOOTING %s\n", skdev->name);
+		skd_dbg(2, skdev, "ISR FIT_SR_DRIVE_FW_BOOTING %s\n",
+			skdev->name);
 		skdev->state = SKD_DRVR_STATE_WAIT_BOOT;
 		skdev->timer_countdown = SKD_WAIT_BOOT_TIMO;
 		break;
@@ -3542,8 +3528,7 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 
 	/* PCIe bus returned all Fs? */
 	case 0xFF:
-		pr_info("(%s): state=0x%x sense=0x%x\n",
-		       skd_name(skdev), state, sense);
+		skd_info(skdev, "state=0x%x sense=0x%x\n", state, sense);
 		skd_drive_disappeared(skdev);
 		skd_recover_requests(skdev, 0);
 		skd_start_queue(skdev);
@@ -3554,10 +3539,9 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 		 */
 		break;
 	}
-	pr_err("(%s): Driver state %s(%d)=>%s(%d)\n",
-	       skd_name(skdev),
-	       skd_skdev_state_to_str(prev_driver_state), prev_driver_state,
-	       skd_skdev_state_to_str(skdev->state), skdev->state);
+	skd_err(skdev, "Driver state %s(%d)=>%s(%d)\n",
+		skd_skdev_state_to_str(prev_driver_state), prev_driver_state,
+		skd_skdev_state_to_str(skdev->state), skdev->state);
 }
 
 static void skd_recover_requests(struct skd_device *skdev, int requeue)
@@ -3633,10 +3617,10 @@ static void skd_recover_requests(struct skd_device *skdev, int requeue)
 		 */
 		if (skspcl->req.state == SKD_REQ_STATE_BUSY) {
 			if (skspcl->orphaned) {
-				DPRINTK(skdev, "orphaned %p\n", skspcl);
+				skd_dbg(1, skdev, "orphaned %p\n", skspcl);
 				skd_release_special(skdev, skspcl);
 			} else {
-				DPRINTK(skdev, "not orphaned %p\n", skspcl);
+				skd_dbg(1, skdev, "not orphaned %p\n", skspcl);
 				skspcl->req.state = SKD_REQ_STATE_ABORTED;
 			}
 		}
@@ -3657,7 +3641,7 @@ static void skd_isr_msg_from_dev(struct skd_device *skdev)
 
 	mfd = SKD_READL(skdev, FIT_MSG_FROM_DEVICE);
 
-	DPRINTK(skdev, "mfd=0x%x last_mtd=0x%x\n", mfd, skdev->last_mtd);
+	skd_dbg(1, skdev, "mfd=0x%x last_mtd=0x%x\n", mfd, skdev->last_mtd);
 
 	/* ignore any mtd that is an ack for something we didn't send */
 	if (FIT_MXD_TYPE(mfd) != FIT_MXD_TYPE(skdev->last_mtd))
@@ -3668,13 +3652,10 @@ static void skd_isr_msg_from_dev(struct skd_device *skdev)
 		skdev->proto_ver = FIT_PROTOCOL_MAJOR_VER(mfd);
 
 		if (skdev->proto_ver != FIT_PROTOCOL_VERSION_1) {
-			pr_err("(%s): protocol mismatch\n",
-			       skdev->name);
-			pr_err("(%s):   got=%d support=%d\n",
-			       skdev->name, skdev->proto_ver,
-			       FIT_PROTOCOL_VERSION_1);
-			pr_err("(%s):   please upgrade driver\n",
-			       skdev->name);
+			skd_err(skdev, "protocol mismatch\n");
+			skd_err(skdev, "  got=%d support=%d\n",
+				skdev->proto_ver, FIT_PROTOCOL_VERSION_1);
+			skd_err(skdev, "  please upgrade driver\n");
 			skdev->state = SKD_DRVR_STATE_PROTOCOL_MISMATCH;
 			skd_soft_reset(skdev);
 			break;
@@ -3728,9 +3709,8 @@ static void skd_isr_msg_from_dev(struct skd_device *skdev)
 		SKD_WRITEL(skdev, mtd, FIT_MSG_TO_DEVICE);
 		skdev->last_mtd = mtd;
 
-		pr_err("(%s): Time sync driver=0x%x device=0x%x\n",
-		       skd_name(skdev),
-		       skdev->connect_time_stamp, skdev->drive_jiffies);
+		skd_err(skdev, "Time sync driver=0x%x device=0x%x\n",
+			skdev->connect_time_stamp, skdev->drive_jiffies);
 		break;
 
 	case FIT_MTD_ARM_QUEUE:
@@ -3752,7 +3732,7 @@ static void skd_disable_interrupts(struct skd_device *skdev)
 	sense = SKD_READL(skdev, FIT_CONTROL);
 	sense &= ~FIT_CR_ENABLE_INTERRUPTS;
 	SKD_WRITEL(skdev, sense, FIT_CONTROL);
-	DPRINTK(skdev, "sense 0x%x\n", sense);
+	skd_dbg(1, skdev, "sense 0x%x\n", sense);
 
 	/* Note that the 1s is written. A 1-bit means
 	 * disable, a 0 means enable.
@@ -3771,11 +3751,11 @@ static void skd_enable_interrupts(struct skd_device *skdev)
 	/* Note that the compliment of mask is written. A 1-bit means
 	 * disable, a 0 means enable. */
 	SKD_WRITEL(skdev, ~val, FIT_INT_MASK_HOST);
-	DPRINTK(skdev, "interrupt mask=0x%x\n", ~val);
+	skd_dbg(1, skdev, "interrupt mask=0x%x\n", ~val);
 
 	val = SKD_READL(skdev, FIT_CONTROL);
 	val |= FIT_CR_ENABLE_INTERRUPTS;
-	DPRINTK(skdev, "control=0x%x\n", val);
+	skd_dbg(1, skdev, "control=0x%x\n", val);
 	SKD_WRITEL(skdev, val, FIT_CONTROL);
 }
 
@@ -3791,7 +3771,7 @@ static void skd_soft_reset(struct skd_device *skdev)
 
 	val = SKD_READL(skdev, FIT_CONTROL);
 	val |= (FIT_CR_SOFT_RESET);
-	DPRINTK(skdev, "control=0x%x\n", val);
+	skd_dbg(1, skdev, "control=0x%x\n", val);
 	SKD_WRITEL(skdev, val, FIT_CONTROL);
 }
 
@@ -3808,7 +3788,7 @@ static void skd_start_device(struct skd_device *skdev)
 
 	sense = SKD_READL(skdev, FIT_STATUS);
 
-	DPRINTK(skdev, "initial status=0x%x\n", sense);
+	skd_dbg(1, skdev, "initial status=0x%x\n", sense);
 
 	state = sense & FIT_SR_DRIVE_STATE_MASK;
 	skdev->drive_state = state;
@@ -3821,24 +3801,23 @@ static void skd_start_device(struct skd_device *skdev)
 
 	switch (skdev->drive_state) {
 	case FIT_SR_DRIVE_OFFLINE:
-		pr_err("(%s): Drive offline...\n", skd_name(skdev));
+		skd_err(skdev, "Drive offline...\n");
 		break;
 
 	case FIT_SR_DRIVE_FW_BOOTING:
-		VPRINTK(skdev, "FIT_SR_DRIVE_FW_BOOTING %s\n", skdev->name);
+		skd_dbg(2, skdev, "FIT_SR_DRIVE_FW_BOOTING %s\n", skdev->name);
 		skdev->state = SKD_DRVR_STATE_WAIT_BOOT;
 		skdev->timer_countdown = SKD_WAIT_BOOT_TIMO;
 		break;
 
 	case FIT_SR_DRIVE_BUSY_SANITIZE:
-		pr_info("(%s): Start: BUSY_SANITIZE\n",
-		       skd_name(skdev));
+		skd_info(skdev, "Start: BUSY_SANITIZE\n");
 		skdev->state = SKD_DRVR_STATE_BUSY_SANITIZE;
 		skdev->timer_countdown = SKD_STARTED_BUSY_TIMO;
 		break;
 
 	case FIT_SR_DRIVE_BUSY_ERASE:
-		pr_info("(%s): Start: BUSY_ERASE\n", skd_name(skdev));
+		skd_info(skdev, "Start: BUSY_ERASE\n");
 		skdev->state = SKD_DRVR_STATE_BUSY_ERASE;
 		skdev->timer_countdown = SKD_STARTED_BUSY_TIMO;
 		break;
@@ -3849,14 +3828,13 @@ static void skd_start_device(struct skd_device *skdev)
 		break;
 
 	case FIT_SR_DRIVE_BUSY:
-		pr_err("(%s): Drive Busy...\n", skd_name(skdev));
+		skd_err(skdev, "Drive Busy...\n");
 		skdev->state = SKD_DRVR_STATE_BUSY;
 		skdev->timer_countdown = SKD_STARTED_BUSY_TIMO;
 		break;
 
 	case FIT_SR_DRIVE_SOFT_RESET:
-		pr_err("(%s) drive soft reset in prog\n",
-		       skd_name(skdev));
+		skd_err(skdev, "drive soft reset in prog\n");
 		break;
 
 	case FIT_SR_DRIVE_FAULT:
@@ -3866,7 +3844,7 @@ static void skd_start_device(struct skd_device *skdev)
 		 */
 		skd_drive_fault(skdev);
 		/*start the queue so we can respond with error to requests */
-		VPRINTK(skdev, "starting %s queue\n", skdev->name);
+		skd_dbg(2, skdev, "starting %s queue\n", skdev->name);
 		skd_start_queue(skdev);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
@@ -3877,7 +3855,7 @@ static void skd_start_device(struct skd_device *skdev)
 		 * to the BAR1 addresses. */
 		skd_drive_disappeared(skdev);
 		/*start the queue so we can respond with error to requests */
-		VPRINTK(skdev, "starting %s queue to error-out reqs\n",
+		skd_dbg(2, skdev, "starting %s queue to error-out reqs\n",
 			skdev->name);
 		skd_start_queue(skdev);
 		skdev->gendisk_on = -1;
@@ -3885,25 +3863,24 @@ static void skd_start_device(struct skd_device *skdev)
 		break;
 
 	default:
-		pr_err("(%s) Start: unknown state %x\n",
-		       skd_name(skdev), skdev->drive_state);
+		skd_err(skdev, "Start: unknown state %x\n", skdev->drive_state);
 		break;
 	}
 
 	state = SKD_READL(skdev, FIT_CONTROL);
-	DPRINTK(skdev, "FIT Control Status=0x%x\n", state);
+	skd_dbg(1, skdev, "FIT Control Status=0x%x\n", state);
 
 	state = SKD_READL(skdev, FIT_INT_STATUS_HOST);
-	DPRINTK(skdev, "Intr Status=0x%x\n", state);
+	skd_dbg(1, skdev, "Intr Status=0x%x\n", state);
 
 	state = SKD_READL(skdev, FIT_INT_MASK_HOST);
-	DPRINTK(skdev, "Intr Mask=0x%x\n", state);
+	skd_dbg(1, skdev, "Intr Mask=0x%x\n", state);
 
 	state = SKD_READL(skdev, FIT_MSG_FROM_DEVICE);
-	DPRINTK(skdev, "Msg from Dev=0x%x\n", state);
+	skd_dbg(1, skdev, "Msg from Dev=0x%x\n", state);
 
 	state = SKD_READL(skdev, FIT_HW_VERSION);
-	DPRINTK(skdev, "HW version=0x%x\n", state);
+	skd_dbg(1, skdev, "HW version=0x%x\n", state);
 
 	spin_unlock_irqrestore(&skdev->lock, flags);
 }
@@ -3918,14 +3895,12 @@ static void skd_stop_device(struct skd_device *skdev)
 	spin_lock_irqsave(&skdev->lock, flags);
 
 	if (skdev->state != SKD_DRVR_STATE_ONLINE) {
-		pr_err("(%s): skd_stop_device not online no sync\n",
-		       skd_name(skdev));
+		skd_err(skdev, "skd_stop_device not online no sync\n");
 		goto stop_out;
 	}
 
 	if (skspcl->req.state != SKD_REQ_STATE_IDLE) {
-		pr_err("(%s): skd_stop_device no special\n",
-		       skd_name(skdev));
+		skd_err(skdev, "skd_stop_device no special\n");
 		goto stop_out;
 	}
 
@@ -3943,16 +3918,13 @@ static void skd_stop_device(struct skd_device *skdev)
 
 	switch (skdev->sync_done) {
 	case 0:
-		pr_err("(%s): skd_stop_device no sync\n",
-		       skd_name(skdev));
+		skd_err(skdev, "skd_stop_device no sync\n");
 		break;
 	case 1:
-		pr_err("(%s): skd_stop_device sync done\n",
-		       skd_name(skdev));
+		skd_err(skdev, "skd_stop_device sync done\n");
 		break;
 	default:
-		pr_err("(%s): skd_stop_device sync error\n",
-		       skd_name(skdev));
+		skd_err(skdev, "skd_stop_device sync error\n");
 	}
 
 stop_out:
@@ -3982,8 +3954,8 @@ stop_out:
 	}
 
 	if (dev_state != FIT_SR_DRIVE_INIT)
-		pr_err("(%s): skd_stop_device state error 0x%02x\n",
-		       skd_name(skdev), dev_state);
+		skd_err(skdev, "skd_stop_device state error 0x%02x\n",
+			dev_state);
 }
 
 /* assume spinlock is held */
@@ -3996,7 +3968,7 @@ static void skd_restart_device(struct skd_device *skdev)
 
 	state = SKD_READL(skdev, FIT_STATUS);
 
-	DPRINTK(skdev, "drive status=0x%x\n", state);
+	skd_dbg(1, skdev, "drive status=0x%x\n", state);
 
 	state &= FIT_SR_DRIVE_STATE_MASK;
 	skdev->drive_state = state;
@@ -4016,7 +3988,7 @@ static int skd_quiesce_dev(struct skd_device *skdev)
 	switch (skdev->state) {
 	case SKD_DRVR_STATE_BUSY:
 	case SKD_DRVR_STATE_BUSY_IMMINENT:
-		VPRINTK(skdev, "stopping %s queue\n", skdev->name);
+		skd_dbg(2, skdev, "stopping %s queue\n", skdev->name);
 		skd_stop_queue(skdev);
 		break;
 	case SKD_DRVR_STATE_ONLINE:
@@ -4029,7 +4001,7 @@ static int skd_quiesce_dev(struct skd_device *skdev)
 	case SKD_DRVR_STATE_RESUMING:
 	default:
 		rc = -EINVAL;
-		VPRINTK(skdev, "state [%d] not implemented\n", skdev->state);
+		skd_dbg(2, skdev, "state [%d] not implemented\n", skdev->state);
 	}
 	return rc;
 }
@@ -4041,7 +4013,7 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 
 	skd_log_skdev(skdev, "unquiesce");
 	if (skdev->state == SKD_DRVR_STATE_ONLINE) {
-		DPRINTK(skdev, "**** device already ONLINE\n");
+		skd_dbg(1, skdev, "**** device already ONLINE\n");
 		return 0;
 	}
 	if (skdev->drive_state != FIT_SR_DRIVE_ONLINE) {
@@ -4054,7 +4026,7 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 		 * to become available.
 		 */
 		skdev->state = SKD_DRVR_STATE_BUSY;
-		DPRINTK(skdev, "drive BUSY state\n");
+		skd_dbg(1, skdev, "drive BUSY state\n");
 		return 0;
 	}
 
@@ -4073,14 +4045,13 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 	case SKD_DRVR_STATE_IDLE:
 	case SKD_DRVR_STATE_LOAD:
 		skdev->state = SKD_DRVR_STATE_ONLINE;
-		pr_err("(%s): Driver state %s(%d)=>%s(%d)\n",
-		       skd_name(skdev),
-		       skd_skdev_state_to_str(prev_driver_state),
-		       prev_driver_state, skd_skdev_state_to_str(skdev->state),
-		       skdev->state);
-		DPRINTK(skdev, "**** device ONLINE...starting block queue\n");
-		VPRINTK(skdev, "starting %s queue\n", skdev->name);
-		pr_info("(%s): STEC s1120 ONLINE\n", skd_name(skdev));
+		skd_err(skdev, "Driver state %s(%d)=>%s(%d)\n",
+			skd_skdev_state_to_str(prev_driver_state),
+			prev_driver_state, skd_skdev_state_to_str(skdev->state),
+			skdev->state);
+		skd_dbg(1, skdev, "**** device ONLINE...starting block queue\n");
+		skd_dbg(2, skdev, "starting %s queue\n", skdev->name);
+		skd_info(skdev, "STEC s1120 ONLINE\n");
 		skd_start_queue(skdev);
 		skdev->gendisk_on = 1;
 		wake_up_interruptible(&skdev->waitq);
@@ -4088,7 +4059,7 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 
 	case SKD_DRVR_STATE_DISAPPEARED:
 	default:
-		DPRINTK(skdev, "**** driver state %d, not implemented \n",
+		skd_dbg(1, skdev, "**** driver state %d, not implemented\n",
 			skdev->state);
 		return -EBUSY;
 	}
@@ -4107,9 +4078,10 @@ static irqreturn_t skd_reserved_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
-	pr_err("(%s): MSIX reserved irq %d = 0x%x\n", skd_name(skdev),
-	       irq, SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	skd_dbg(2, skdev, "MSIX = 0x%x\n",
+		SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	skd_info(skdev, "MSIX reserved irq %d = 0x%x\n",
+		 irq, SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_INT_RESERVED_MASK, FIT_INT_STATUS_HOST);
 	spin_unlock_irqrestore(&skdev->lock, flags);
 	return IRQ_HANDLED;
@@ -4121,7 +4093,8 @@ static irqreturn_t skd_statec_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	skd_dbg(2, skdev, "MSIX = 0x%x\n",
+		SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_ISH_FW_STATE_CHANGE, FIT_INT_STATUS_HOST);
 	skd_isr_fwstate(skdev);
 	spin_unlock_irqrestore(&skdev->lock, flags);
@@ -4136,7 +4109,8 @@ static irqreturn_t skd_comp_q(int irq, void *skd_host_data)
 	int deferred;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	skd_dbg(2, skdev, "MSIX = 0x%x\n",
+		SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_ISH_COMPLETION_POSTED, FIT_INT_STATUS_HOST);
 	deferred = skd_isr_completion_posted(skdev, skd_isr_comp_limit,
 						&flush_enqueued);
@@ -4160,7 +4134,8 @@ static irqreturn_t skd_msg_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	skd_dbg(2, skdev, "MSIX = 0x%x\n",
+		SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_ISH_MSG_FROM_DEV, FIT_INT_STATUS_HOST);
 	skd_isr_msg_from_dev(skdev);
 	spin_unlock_irqrestore(&skdev->lock, flags);
@@ -4173,7 +4148,8 @@ static irqreturn_t skd_qfull_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	skd_dbg(2, skdev, "MSIX = 0x%x\n",
+		SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_INT_QUEUE_FULL, FIT_INT_STATUS_HOST);
 	spin_unlock_irqrestore(&skdev->lock, flags);
 	return IRQ_HANDLED;
@@ -4248,7 +4224,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 
 	pdev = skdev->pdev;
 	skdev->msix_count = SKD_MAX_MSIX_COUNT;
-	entries = kzalloc(sizeof(struct msix_entry) * SKD_MAX_MSIX_COUNT,
+	entries = kcalloc(SKD_MAX_MSIX_COUNT, sizeof(struct msix_entry),
 			  GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
@@ -4261,29 +4237,26 @@ static int skd_acquire_msix(struct skd_device *skdev)
 		goto msix_out;
 	if (rc) {
 		if (rc < SKD_MIN_MSIX_COUNT) {
-			pr_err("(%s): failed to enable MSI-X %d\n",
-			       skd_name(skdev), rc);
+			skd_err(skdev, "failed to enable MSI-X %d\n", rc);
 			goto msix_out;
 		}
-		DPRINTK(skdev, "%s: <%s> allocated %d MSI-X vectors\n",
+		skd_dbg(1, skdev, "%s: <%s> allocated %d MSI-X vectors\n",
 			pci_name(pdev), skdev->name, rc);
 
 		skdev->msix_count = rc;
 		rc = pci_enable_msix(pdev, entries, skdev->msix_count);
 		if (rc) {
-			pr_err("(%s): failed to enable MSI-X "
-			       "support (%d) %d\n",
-			       skd_name(skdev), skdev->msix_count, rc);
+			skd_err(skdev, "failed to enable MSI-X support (%d) %d\n",
+				skdev->msix_count, rc);
 			goto msix_out;
 		}
 	}
-	skdev->msix_entries = kzalloc(sizeof(struct skd_msix_entry) *
-				      skdev->msix_count, GFP_KERNEL);
+	skdev->msix_entries = kcalloc(skdev->msix_count,
+				      sizeof(struct skd_msix_entry),
+				      GFP_KERNEL);
 	if (!skdev->msix_entries) {
 		rc = -ENOMEM;
 		skdev->msix_count = 0;
-		pr_err("(%s): msix table allocation error\n",
-		       skd_name(skdev));
 		goto msix_out;
 	}
 
@@ -4293,7 +4266,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 		qentry->entry = entries[i].entry;
 		qentry->rsp = NULL;
 		qentry->have_irq = 0;
-		DPRINTK(skdev, "%s: <%s> msix (%d) vec %d, entry %x\n",
+		skd_dbg(1, skdev, "%s: <%s> msix (%d) vec %d, entry %x\n",
 			pci_name(pdev), skdev->name,
 			i, qentry->vector, qentry->entry);
 		qentry++;
@@ -4309,16 +4282,15 @@ static int skd_acquire_msix(struct skd_device *skdev)
 				      msix_entries[i].handler, 0,
 				      qentry->isr_name, skdev);
 		if (rc) {
-			pr_err("(%s): Unable to register(%d) MSI-X "
-			       "handler %d: %s\n",
-			       skd_name(skdev), rc, i, qentry->isr_name);
+			skd_err(skdev, "Unable to register(%d) MSI-X handler %d: %s\n",
+				rc, i, qentry->isr_name);
 			goto msix_out;
 		} else {
 			qentry->have_irq = 1;
 			qentry->rsp = skdev;
 		}
 	}
-	DPRINTK(skdev, "%s: <%s> msix %d irq(s) enabled\n",
+	skd_dbg(1, skdev, "%s: <%s> msix %d irq(s) enabled\n",
 		pci_name(pdev), skdev->name, skdev->msix_count);
 	return 0;
 
@@ -4342,12 +4314,11 @@ RETRY_IRQ_TYPE:
 	case SKD_IRQ_MSIX:
 		rc = skd_acquire_msix(skdev);
 		if (!rc)
-			pr_info("(%s): MSI-X %d irqs enabled\n",
-			       skd_name(skdev), skdev->msix_count);
+			skd_info(skdev, "MSI-X %d irqs enabled\n",
+				 skdev->msix_count);
 		else {
-			pr_err(
-			       "(%s): failed to enable MSI-X, re-trying with MSI %d\n",
-			       skd_name(skdev), rc);
+			skd_err(skdev, "failed to enable MSI-X, re-trying with MSI %d\n",
+				rc);
 			skdev->irq_type = SKD_IRQ_MSI;
 			goto RETRY_IRQ_TYPE;
 		}
@@ -4361,18 +4332,15 @@ RETRY_IRQ_TYPE:
 					      skdev->isr_name, skdev);
 			if (rc) {
 				pci_disable_msi(pdev);
-				pr_err(
-				       "(%s): failed to allocate the MSI interrupt %d\n",
-				       skd_name(skdev), rc);
+				skd_err(skdev, "failed to allocate the MSI interrupt %d\n",
+					rc);
 				goto RETRY_IRQ_LEGACY;
 			}
-			pr_info("(%s): MSI irq %d enabled\n",
-			       skd_name(skdev), pdev->irq);
+			skd_info(skdev, "MSI irq %d enabled\n", pdev->irq);
 		} else {
 RETRY_IRQ_LEGACY:
-			pr_err(
-			       "(%s): failed to enable MSI, re-trying with LEGACY %d\n",
-			       skd_name(skdev), rc);
+			skd_err(skdev, "failed to enable MSI, re-trying with LEGACY %d\n",
+				rc);
 			skdev->irq_type = SKD_IRQ_LEGACY;
 			goto RETRY_IRQ_TYPE;
 		}
@@ -4383,15 +4351,13 @@ RETRY_IRQ_LEGACY:
 		rc = devm_request_irq(&pdev->dev, pdev->irq, skd_isr,
 				      IRQF_SHARED, skdev->isr_name, skdev);
 		if (!rc)
-			pr_info("(%s): LEGACY irq %d enabled\n",
-			       skd_name(skdev), pdev->irq);
+			skd_info(skdev, "LEGACY irq %d enabled\n", pdev->irq);
 		else
-			pr_err("(%s): request LEGACY irq error %d\n",
-			       skd_name(skdev), rc);
+			skd_err(skdev, "request LEGACY irq error %d\n", rc);
 		break;
 	default:
-		pr_info("(%s): irq_type %d invalid, re-set to %d\n",
-		       skd_name(skdev), skdev->irq_type, SKD_IRQ_DEFAULT);
+		skd_info(skdev, "irq_type %d invalid, re-set to %d\n",
+			 skdev->irq_type, SKD_IRQ_DEFAULT);
 		skdev->irq_type = SKD_IRQ_LEGACY;
 		goto RETRY_IRQ_TYPE;
 	}
@@ -4412,8 +4378,7 @@ static void skd_release_irq(struct skd_device *skdev)
 		devm_free_irq(&skdev->pdev->dev, skdev->pdev->irq, skdev);
 		break;
 	default:
-		pr_err("(%s): wrong irq type %d!",
-		       skd_name(skdev), skdev->irq_type);
+		skd_err(skdev, "wrong irq type %d!\n", skdev->irq_type);
 		break;
 	}
 }
@@ -4444,12 +4409,8 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	int rc;
 
 	skdev = kzalloc(sizeof(*skdev), GFP_KERNEL);
-
-	if (!skdev) {
-		pr_err(PFX "(%s): memory alloc failure\n",
-		       pci_name(pdev));
+	if (!skdev)
 		return NULL;
-	}
 
 	skdev->state = SKD_DRVR_STATE_LOAD;
 	skdev->pdev = pdev;
@@ -4479,43 +4440,43 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
 	INIT_LIST_HEAD(&skdev->flush_list);
 
-	VPRINTK(skdev, "skcomp\n");
+	skd_dbg(2, skdev, "skcomp\n");
 	rc = skd_cons_skcomp(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "skmsg\n");
+	skd_dbg(2, skdev, "skmsg\n");
 	rc = skd_cons_skmsg(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "skreq\n");
+	skd_dbg(2, skdev, "skreq\n");
 	rc = skd_cons_skreq(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "skspcl\n");
+	skd_dbg(2, skdev, "skspcl\n");
 	rc = skd_cons_skspcl(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "sksb\n");
+	skd_dbg(2, skdev, "sksb\n");
 	rc = skd_cons_sksb(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "disk\n");
+	skd_dbg(2, skdev, "disk\n");
 	rc = skd_cons_disk(skdev);
 	if (rc < 0)
 		goto err_out;
 
 
 
-	DPRINTK(skdev, "VICTORY\n");
+	skd_dbg(1, skdev, "VICTORY\n");
 	return skdev;
 
 err_out:
-	DPRINTK(skdev, "construct failed\n");
+	skd_dbg(1, skdev, "construct failed\n");
 	skd_destruct(skdev);
 	return NULL;
 }
@@ -4529,7 +4490,7 @@ static int skd_cons_skcomp(struct skd_device *skdev)
 	nbytes = sizeof(*skcomp) * SKD_N_COMPLETION_ENTRY;
 	nbytes += sizeof(struct fit_comp_error_info) * SKD_N_COMPLETION_ENTRY;
 
-	VPRINTK(skdev, "comp pci_alloc, total bytes %d entries %d\n", nbytes,
+	skd_dbg(2, skdev, "comp pci_alloc, total bytes %d entries %d\n", nbytes,
 		SKD_N_COMPLETION_ENTRY);
 
 	skcomp = pci_alloc_consistent(skdev->pdev, nbytes,
@@ -4556,14 +4517,15 @@ static int skd_cons_skmsg(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
+	skd_dbg(2, skdev, "skmsg_table kzalloc, struct %zu, count %u total %lu\n",
 		sizeof(struct skd_fitmsg_context),
 		skdev->num_fitmsg_context,
 		(unsigned long) sizeof(struct skd_fitmsg_context) *
 					skdev->num_fitmsg_context);
 
-	skdev->skmsg_table = kzalloc(sizeof(struct skd_fitmsg_context)
-				     *skdev->num_fitmsg_context, GFP_KERNEL);
+	skdev->skmsg_table = kcalloc(skdev->num_fitmsg_context,
+				     sizeof(struct skd_fitmsg_context),
+				     GFP_KERNEL);
 	if (skdev->skmsg_table == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
@@ -4611,19 +4573,20 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
+	skd_dbg(2, skdev, "skreq_table kzalloc, struct %zu, count %u total %lu\n",
 		sizeof(struct skd_request_context),
 		skdev->num_req_context,
 		sizeof(struct skd_request_context) * skdev->num_req_context);
 
-	skdev->skreq_table = kzalloc(sizeof(struct skd_request_context)
-				     * skdev->num_req_context, GFP_KERNEL);
+	skdev->skreq_table = kcalloc(skdev->num_req_context,
+				     sizeof(struct skd_request_context),
+				     GFP_KERNEL);
 	if (skdev->skreq_table == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
+	skd_dbg(2, skdev, "alloc sg_table sg_per_req %u scatlist %zu total %lu\n",
 		skdev->sgs_per_request, sizeof(struct scatterlist),
 		skdev->sgs_per_request * sizeof(struct scatterlist));
 
@@ -4635,8 +4598,8 @@ static int skd_cons_skreq(struct skd_device *skdev)
 		skreq->id = i + SKD_ID_RW_REQUEST;
 		skreq->state = SKD_REQ_STATE_IDLE;
 
-		skreq->sg = kzalloc(sizeof(struct scatterlist) *
-				    skdev->sgs_per_request, GFP_KERNEL);
+		skreq->sg = kcalloc(skdev->sgs_per_request,
+				    sizeof(struct scatterlist), GFP_KERNEL);
 		if (skreq->sg == NULL) {
 			rc = -ENOMEM;
 			goto err_out;
@@ -4668,13 +4631,14 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
+	skd_dbg(2, skdev, "skspcl_table kzalloc, struct %zu, count %u total %zu\n",
 		sizeof(struct skd_special_context),
 		skdev->n_special,
 		sizeof(struct skd_special_context) * skdev->n_special);
 
-	skdev->skspcl_table = kzalloc(sizeof(struct skd_special_context)
-				      * skdev->n_special, GFP_KERNEL);
+	skdev->skspcl_table = kcalloc(skdev->n_special,
+				      sizeof(struct skd_special_context),
+				      GFP_KERNEL);
 	if (skdev->skspcl_table == NULL) {
 		rc = -ENOMEM;
 		goto err_out;
@@ -4701,8 +4665,9 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 
 		memset(skspcl->msg_buf, 0, nbytes);
 
-		skspcl->req.sg = kzalloc(sizeof(struct scatterlist) *
-					 SKD_N_SG_PER_SPECIAL, GFP_KERNEL);
+		skspcl->req.sg = kcalloc(SKD_N_SG_PER_SPECIAL,
+					 sizeof(struct scatterlist),
+					 GFP_KERNEL);
 		if (skspcl->req.sg == NULL) {
 			rc = -ENOMEM;
 			goto err_out;
@@ -4863,7 +4828,7 @@ static int skd_cons_disk(struct skd_device *skdev)
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "stopping %s queue\n", skdev->name);
+	skd_dbg(2, skdev, "stopping %s queue\n", skdev->name);
 	skd_stop_queue(skdev);
 	spin_unlock_irqrestore(&skdev->lock, flags);
 
@@ -4893,25 +4858,25 @@ static void skd_destruct(struct skd_device *skdev)
 		return;
 
 
-	VPRINTK(skdev, "disk\n");
+	skd_dbg(2, skdev, "disk\n");
 	skd_free_disk(skdev);
 
-	VPRINTK(skdev, "sksb\n");
+	skd_dbg(2, skdev, "sksb\n");
 	skd_free_sksb(skdev);
 
-	VPRINTK(skdev, "skspcl\n");
+	skd_dbg(2, skdev, "skspcl\n");
 	skd_free_skspcl(skdev);
 
-	VPRINTK(skdev, "skreq\n");
+	skd_dbg(2, skdev, "skreq\n");
 	skd_free_skreq(skdev);
 
-	VPRINTK(skdev, "skmsg\n");
+	skd_dbg(2, skdev, "skmsg\n");
 	skd_free_skmsg(skdev);
 
-	VPRINTK(skdev, "skcomp\n");
+	skd_dbg(2, skdev, "skcomp\n");
 	skd_free_skcomp(skdev);
 
-	VPRINTK(skdev, "skdev\n");
+	skd_dbg(2, skdev, "skdev\n");
 	kfree(skdev);
 }
 
@@ -5097,7 +5062,7 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 	skdev = bdev->bd_disk->private_data;
 
-	DPRINTK(skdev, "%s: CMD[%s] getgeo device\n",
+	skd_dbg(1, skdev, "%s: CMD[%s] getgeo device\n",
 		bdev->bd_disk->disk_name, current->comm);
 
 	if (skdev->read_cap_is_valid) {
@@ -5113,7 +5078,7 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 static int skd_bdev_attach(struct skd_device *skdev)
 {
-	DPRINTK(skdev, "add_disk\n");
+	skd_dbg(1, skdev, "add_disk\n");
 	add_disk(skdev->disk);
 	return 0;
 }
@@ -5176,9 +5141,9 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct skd_device *skdev;
 
 	pr_info("STEC s1120 Driver(%s) version %s-b%s\n",
-	       DRV_NAME, DRV_VERSION, DRV_BUILD_ID);
+		DRV_NAME, DRV_VERSION, DRV_BUILD_ID);
 	pr_info("(skd?:??:[%s]): vendor=%04X device=%04x\n",
-	       pci_name(pdev), pdev->vendor, pdev->device);
+		pci_name(pdev), pdev->vendor, pdev->device);
 
 	rc = pci_enable_device(pdev);
 	if (rc)
@@ -5196,7 +5161,6 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else {
 		(rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)));
 		if (rc) {
-
 			pr_err("(%s): DMA mask error %d\n",
 			       pci_name(pdev), rc);
 			goto err_out_regions;
@@ -5208,14 +5172,13 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_regions;
 
 	skd_pci_info(skdev, pci_str);
-	pr_info("(%s): %s 64bit\n", skd_name(skdev), pci_str);
+	skd_info(skdev, "%s 64bit\n", pci_str);
 
 	pci_set_master(pdev);
 	rc = pci_enable_pcie_error_reporting(pdev);
 	if (rc) {
-		pr_err(
-		       "(%s): bad enable of PCIe error reporting rc=%d\n",
-		       skd_name(skdev), rc);
+		skd_err(skdev, "bad enable of PCIe error reporting rc=%d\n",
+			rc);
 		skdev->pcie_error_reporting_is_enabled = 0;
 	} else
 		skdev->pcie_error_reporting_is_enabled = 1;
@@ -5231,20 +5194,18 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		skdev->mem_map[i] = ioremap(skdev->mem_phys[i],
 					    skdev->mem_size[i]);
 		if (!skdev->mem_map[i]) {
-			pr_err("(%s): Unable to map adapter memory!\n",
-			       skd_name(skdev));
+			skd_err(skdev, "Unable to map adapter memory!\n");
 			rc = -ENODEV;
 			goto err_out_iounmap;
 		}
-		DPRINTK(skdev, "mem_map=%p, phyd=%016llx, size=%d\n",
+		skd_dbg(1, skdev, "mem_map=%p, phyd=%016llx, size=%d\n",
 			skdev->mem_map[i],
 			(uint64_t)skdev->mem_phys[i], skdev->mem_size[i]);
 	}
 
 	rc = skd_acquire_irq(skdev);
 	if (rc) {
-		pr_err("(%s): interrupt resource error %d\n",
-		       skd_name(skdev), rc);
+		skd_err(skdev, "interrupt resource error %d\n", rc);
 		goto err_out_iounmap;
 	}
 
@@ -5266,9 +5227,7 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else {
 		/* we timed out, something is wrong with the device,
 		   don't add the disk structure */
-		pr_err(
-		       "(%s): error: waiting for s1120 timed out %d!\n",
-		       skd_name(skdev), rc);
+		skd_err(skdev, "error: waiting for s1120 timed out %d!\n", rc);
 		/* in case of no error; we timeout with ENXIO */
 		if (!rc)
 			rc = -ENXIO;
@@ -5397,7 +5356,6 @@ static int skd_pci_resume(struct pci_dev *pdev)
 	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!rc) {
 		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
-
 			pr_err("(%s): consistent DMA mask error %d\n",
 			       pci_name(pdev), rc);
 		}
@@ -5405,8 +5363,7 @@ static int skd_pci_resume(struct pci_dev *pdev)
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc) {
 
-			pr_err("(%s): DMA mask error %d\n",
-			       pci_name(pdev), rc);
+			pr_err("(%s): DMA mask error %d\n", pci_name(pdev), rc);
 			goto err_out_regions;
 		}
 	}
@@ -5414,8 +5371,8 @@ static int skd_pci_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	rc = pci_enable_pcie_error_reporting(pdev);
 	if (rc) {
-		pr_err("(%s): bad enable of PCIe error reporting rc=%d\n",
-		       skdev->name, rc);
+		skd_err(skdev, "bad enable of PCIe error reporting rc=%d\n",
+			rc);
 		skdev->pcie_error_reporting_is_enabled = 0;
 	} else
 		skdev->pcie_error_reporting_is_enabled = 1;
@@ -5427,18 +5384,16 @@ static int skd_pci_resume(struct pci_dev *pdev)
 		skdev->mem_map[i] = ioremap(skdev->mem_phys[i],
 					    skdev->mem_size[i]);
 		if (!skdev->mem_map[i]) {
-			pr_err("(%s): Unable to map adapter memory!\n",
-			       skd_name(skdev));
+			skd_err(skdev, "Unable to map adapter memory!\n");
 			rc = -ENODEV;
 			goto err_out_iounmap;
 		}
-		DPRINTK(skdev, "mem_map=%p, phyd=%016llx, size=%d\n",
+		skd_dbg(1, skdev, "mem_map=%p, phyd=%016llx, size=%d\n",
 			skdev->mem_map[i],
 			(uint64_t)skdev->mem_phys[i], skdev->mem_size[i]);
 	}
 	rc = skd_acquire_irq(skdev);
 	if (rc) {
-
 		pr_err("(%s): interrupt resource error %d\n",
 		       pci_name(pdev), rc);
 		goto err_out_iounmap;
@@ -5478,15 +5433,12 @@ static void skd_pci_shutdown(struct pci_dev *pdev)
 {
 	struct skd_device *skdev;
 
-	pr_err("skd_pci_shutdown called\n");
-
 	skdev = pci_get_drvdata(pdev);
 	if (!skdev) {
 		pr_err("%s: no device data for PCI\n", pci_name(pdev));
 		return;
 	}
 
-	pr_err("%s: calling stop\n", skd_name(skdev));
 	skd_stop_device(skdev);
 }
 
@@ -5634,22 +5586,22 @@ const char *skd_skreq_state_to_str(enum skd_req_state state)
 
 static void skd_log_skdev(struct skd_device *skdev, const char *event)
 {
-	DPRINTK(skdev, "(%s) skdev=%p event='%s'\n", skdev->name, skdev, event);
-	DPRINTK(skdev, "  drive_state=%s(%d) driver_state=%s(%d)\n",
+	skd_dbg(1, skdev, "skdev=%p event='%s'\n", skdev, event);
+	skd_dbg(1, skdev, "  drive_state=%s(%d) driver_state=%s(%d)\n",
 		skd_drive_state_to_str(skdev->drive_state), skdev->drive_state,
 		skd_skdev_state_to_str(skdev->state), skdev->state);
-	DPRINTK(skdev, "  busy=%d limit=%d dev=%d lowat=%d\n",
+	skd_dbg(1, skdev, "  busy=%d limit=%d dev=%d lowat=%d\n",
 		skdev->in_flight, skdev->cur_max_queue_depth,
 		skdev->dev_max_queue_depth, skdev->queue_low_water_mark);
-	DPRINTK(skdev, "  timestamp=0x%x cycle=%d cycle_ix=%d\n",
+	skd_dbg(1, skdev, "  timestamp=0x%x cycle=%d cycle_ix=%d\n",
 		skdev->timeout_stamp, skdev->skcomp_cycle, skdev->skcomp_ix);
 }
 
 static void skd_log_skmsg(struct skd_device *skdev,
 			  struct skd_fitmsg_context *skmsg, const char *event)
 {
-	DPRINTK(skdev, "(%s) skmsg=%p event='%s'\n", skdev->name, skmsg, event);
-	DPRINTK(skdev, "  state=%s(%d) id=0x%04x length=%d\n",
+	skd_dbg(1, skdev, "skmsg=%p event='%s'\n", skmsg, event);
+	skd_dbg(1, skdev, "  state=%s(%d) id=0x%04x length=%d\n",
 		skd_skmsg_state_to_str(skmsg->state), skmsg->state,
 		skmsg->id, skmsg->length);
 }
@@ -5657,11 +5609,11 @@ static void skd_log_skmsg(struct skd_device *skdev,
 static void skd_log_skreq(struct skd_device *skdev,
 			  struct skd_request_context *skreq, const char *event)
 {
-	DPRINTK(skdev, "(%s) skreq=%p event='%s'\n", skdev->name, skreq, event);
-	DPRINTK(skdev, "  state=%s(%d) id=0x%04x fitmsg=0x%04x\n",
+	skd_dbg(1, skdev, "skreq=%p event='%s'\n", skreq, event);
+	skd_dbg(1, skdev, "  state=%s(%d) id=0x%04x fitmsg=0x%04x\n",
 		skd_skreq_state_to_str(skreq->state), skreq->state,
 		skreq->id, skreq->fitmsg_id);
-	DPRINTK(skdev, "  timo=0x%x sg_dir=%d n_sg=%d\n",
+	skd_dbg(1, skdev, "  timo=0x%x sg_dir=%d n_sg=%d\n",
 		skreq->timeout_stamp, skreq->sg_data_dir, skreq->n_sg);
 
 	if (!skd_bio) {
@@ -5670,24 +5622,24 @@ static void skd_log_skreq(struct skd_device *skdev,
 			u32 lba = (u32)blk_rq_pos(req);
 			u32 count = blk_rq_sectors(req);
 
-			DPRINTK(skdev,
+			skd_dbg(1, skdev,
 				"  req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
 				req, lba, lba, count, count,
 				(int)rq_data_dir(req));
 		} else
-			DPRINTK(skdev, "  req=NULL\n");
+			skd_dbg(1, skdev, "  req=NULL\n");
 	} else {
 		if (skreq->bio != NULL) {
 			struct bio *bio = skreq->bio;
 			u32 lba = (u32)bio->bi_sector;
 			u32 count = bio_sectors(bio);
 
-			DPRINTK(skdev,
+			skd_dbg(1, skdev,
 				"  bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
 				bio, lba, lba, count, count,
 				(int)bio_data_dir(bio));
 		} else
-			DPRINTK(skdev, "  req=NULL\n");
+			skd_dbg(1, skdev, "  req=NULL\n");
 	}
 }
 
@@ -5701,7 +5653,7 @@ static int __init skd_init(void)
 {
 	int rc = 0;
 
-	pr_info(PFX " v%s-b%s loaded\n", DRV_VERSION, DRV_BUILD_ID);
+	pr_info(" v%s-b%s loaded\n", DRV_VERSION, DRV_BUILD_ID);
 
 	switch (skd_isr_type) {
 	case SKD_IRQ_LEGACY:
@@ -5710,7 +5662,7 @@ static int __init skd_init(void)
 		break;
 	default:
 		pr_info("skd_isr_type %d invalid, re-set to %d\n",
-		       skd_isr_type, SKD_IRQ_DEFAULT);
+			skd_isr_type, SKD_IRQ_DEFAULT);
 		skd_isr_type = SKD_IRQ_DEFAULT;
 	}
 
@@ -5719,47 +5671,44 @@ static int __init skd_init(void)
 						0, 0, NULL);
 
 	if (!skd_flush_slab) {
-		pr_err("failed to allocated flush slab.\n");
+		pr_err("failed to allocated flush slab\n");
 		return -ENOMEM;
 	}
 
 	if (skd_max_queue_depth < 1
 	    || skd_max_queue_depth > SKD_MAX_QUEUE_DEPTH) {
-		pr_info(
-		       "skd_max_queue_depth %d invalid, re-set to %d\n",
-		       skd_max_queue_depth, SKD_MAX_QUEUE_DEPTH_DEFAULT);
+		pr_info("skd_max_queue_depth %d invalid, re-set to %d\n",
+			skd_max_queue_depth, SKD_MAX_QUEUE_DEPTH_DEFAULT);
 		skd_max_queue_depth = SKD_MAX_QUEUE_DEPTH_DEFAULT;
 	}
 
 	if (skd_max_req_per_msg < 1 || skd_max_req_per_msg > 14) {
-		pr_info(
-		       "skd_max_req_per_msg %d invalid, re-set to %d\n",
-		       skd_max_req_per_msg, SKD_MAX_REQ_PER_MSG_DEFAULT);
+		pr_info("skd_max_req_per_msg %d invalid, re-set to %d\n",
+			skd_max_req_per_msg, SKD_MAX_REQ_PER_MSG_DEFAULT);
 		skd_max_req_per_msg = SKD_MAX_REQ_PER_MSG_DEFAULT;
 	}
 
 	if (skd_sgs_per_request < 1 || skd_sgs_per_request > 4096) {
-		pr_info(
-		       "skd_sg_per_request %d invalid, re-set to %d\n",
-		       skd_sgs_per_request, SKD_N_SG_PER_REQ_DEFAULT);
+		pr_info("skd_sg_per_request %d invalid, re-set to %d\n",
+			skd_sgs_per_request, SKD_N_SG_PER_REQ_DEFAULT);
 		skd_sgs_per_request = SKD_N_SG_PER_REQ_DEFAULT;
 	}
 
 	if (skd_dbg_level < 0 || skd_dbg_level > 2) {
 		pr_info("skd_dbg_level %d invalid, re-set to %d\n",
-		       skd_dbg_level, 0);
+			skd_dbg_level, 0);
 		skd_dbg_level = 0;
 	}
 
 	if (skd_isr_comp_limit < 0) {
 		pr_info("skd_isr_comp_limit %d invalid, set to %d\n",
-		       skd_isr_comp_limit, 0);
+			skd_isr_comp_limit, 0);
 		skd_isr_comp_limit = 0;
 	}
 
 	if (skd_max_pass_thru < 1 || skd_max_pass_thru > 50) {
 		pr_info("skd_max_pass_thru %d invalid, re-set to %d\n",
-		       skd_max_pass_thru, SKD_N_SPECIAL_CONTEXT);
+			skd_max_pass_thru, SKD_N_SPECIAL_CONTEXT);
 		skd_max_pass_thru = SKD_N_SPECIAL_CONTEXT;
 	}
 
@@ -5776,7 +5725,7 @@ static int __init skd_init(void)
 
 static void __exit skd_exit(void)
 {
-	pr_info(PFX " v%s-b%s unloading\n", DRV_VERSION, DRV_BUILD_ID);
+	pr_info(" v%s-b%s unloading\n", DRV_VERSION, DRV_BUILD_ID);
 
 	unregister_blkdev(skd_major, DRV_NAME);
 	pci_unregister_driver(&skd_driver);
@@ -5791,7 +5740,7 @@ skd_flush_cmd_enqueue(struct skd_device *skdev, void *cmd)
 
 	item = kmem_cache_zalloc(skd_flush_slab, GFP_ATOMIC);
 	if (!item) {
-		pr_err("skd_flush_cmd_enqueue: Failed to allocated item.\n");
+		pr_err("%s: Failed to allocated item\n", __func__);
 		return -ENOMEM;
 	}
 


