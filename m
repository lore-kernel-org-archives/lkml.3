Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaFRSoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:44:16 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:36950 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751231AbaFRSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:44:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2904:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3874:4051:4120:4250:4321:4605:5007:6119:7652:7807:7875:7903:7904:8603:9391:10004:10848:11026:11232:11233:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:13019:13870:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: week06_7ad4df12e856
X-Filterd-Recvd-Size: 9046
Message-ID: <1403117049.3839.21.camel@joe-AO725>
Subject: [PATCH] floppy: Neaten message logging
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 11:44:09 -0700
In-Reply-To: <alpine.LNX.2.00.1406181406401.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1406181406401.2303@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current style to prefix "floppy: " on
all messages.

Convert DPRINT to emit at KERN_DEBUG.

Other miscellaneous logging changes:

o Add missing newline
o Remove embedded "floppy" style prefixes
o Remove trailing periods to standardize style
o Consolidate two logging lines into one
o Convert args... to ... and ##__VA_ARGS__

Signed-off-by: Joe Perches <joe@perches.com>
---

On Wed, 2014-06-18 at 14:07 +0200, Jiri Kosina wrote:
>       floppy: format block0 read error message properly

This could also probably use a pr_fmt so that
all the messages are prefixed.

 drivers/block/floppy.c | 58 +++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 56d46ff..168c42d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -144,22 +144,25 @@
  * Better audit of register_blkdev.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #undef  FLOPPY_SILENT_DCL_CLEAR
 
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
 
-#define DPRINT(format, args...) \
-	pr_info("floppy%d: " format, current_drive, ##args)
+#define DPRINT(format, ...)					\
+	printk(KERN_DEBUG KBUILD_MODNAME "%d: " format,		\
+	       current_drive, ##__VA_ARGS__)
 
 #define DCL_DEBUG		/* debug disk change line */
 #ifdef DCL_DEBUG
-#define debug_dcl(test, fmt, args...) \
-	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##args); } while (0)
+#define debug_dcl(test, fmt, ...) \
+	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##__VA_ARGS__); } while (0)
 #else
-#define debug_dcl(test, fmt, args...) \
-	do { if (0) DPRINT(fmt, ##args); } while (0)
+#define debug_dcl(test, fmt, ...) \
+	do { if (0) DPRINT(fmt, ##__VA_ARGS__); } while (0)
 #endif
 
 /* do print messages for unexpected interrupts */
@@ -1213,7 +1216,7 @@ static void perpendicular_mode(void)
 		output_byte(perp_mode);
 		FDCS->perp_mode = perp_mode;
 	} else if (perp_mode) {
-		DPRINT("perpendicular mode not supported by this FDC.\n");
+		DPRINT("perpendicular mode not supported by this FDC\n");
 	}
 }				/* perpendicular_mode */
 
@@ -1686,7 +1689,7 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
 		pr_info("DOR0=%x\n", fdc_state[0].dor);
-		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
+		pr_info("interrupt on bizarre fdc %d\n", fdc);
 		pr_info("handler=%pf\n", handler);
 		is_alive(__func__, "bizarre fdc");
 		return IRQ_NONE;
@@ -1784,9 +1787,8 @@ static void show_floppy(void)
 {
 	int i;
 
-	pr_info("\n");
-	pr_info("floppy driver state\n");
-	pr_info("-------------------\n");
+	pr_info("driver state\n");
+	pr_info("------------\n");
 	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%pf\n",
 		jiffies, interruptjiffies, jiffies - interruptjiffies,
 		lasthandler);
@@ -1800,7 +1802,7 @@ static void show_floppy(void)
 			output_log[(i + output_log_pos) % OLOGSIZE].jiffies);
 	pr_info("last result at %lu\n", resultjiffies);
 	pr_info("last redo_fd_request at %lu\n", lastredo);
-	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1,
+	print_hex_dump(KERN_INFO, KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, 16, 1,
 		       reply_buffer, resultsize, true);
 
 	pr_info("status=%x\n", fd_inb(FD_STATUS));
@@ -1821,7 +1823,6 @@ static void show_floppy(void)
 	pr_info("cont=%p\n", cont);
 	pr_info("current_req=%p\n", current_req);
 	pr_info("command_status=%d\n", command_status);
-	pr_info("\n");
 }
 
 static void floppy_shutdown(struct work_struct *arg)
@@ -1839,7 +1840,7 @@ static void floppy_shutdown(struct work_struct *arg)
 	/* avoid dma going to a random drive after shutdown */
 
 	if (initialized)
-		DPRINT("floppy timeout called\n");
+		DPRINT("timeout called\n");
 	FDCS->reset = 1;
 	if (cont) {
 		cont->done(0);
@@ -1919,7 +1920,7 @@ static void floppy_ready(void)
 
 static void floppy_start(void)
 {
-	reschedule_timeout(current_reqD, "floppy start");
+	reschedule_timeout(current_reqD, "start");
 
 	scandrives();
 	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
@@ -2233,7 +2234,7 @@ static void request_done(int uptodate)
 	reschedule_timeout(MAXTIMEOUT, msg);
 
 	if (!req) {
-		pr_info("floppy.c: no request in request_done\n");
+		pr_info("no request in request_done\n");
 		return;
 	}
 
@@ -2680,9 +2681,8 @@ static int make_raw_rw_request(void)
 			raw_cmd->kernel_data = bio_data(current_req->bio);
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT("%s: zero dma transfer attempted\n", __func__);
-				DPRINT("indirect=%d direct=%d fsector_t=%d\n",
-				       indirect, direct, fsector_t);
+				DPRINT("%s: zero dma transfer attempted - indirect=%d direct=%d fsector_t=%d\n",
+				       __func__, indirect, direct, fsector_t);
 				return 0;
 			}
 			virtualdmabug_workaround();
@@ -3604,7 +3604,7 @@ static void __init config_types(void)
 			if (!has_drive) {
 				prepend = "";
 				has_drive = true;
-				pr_info("Floppy drive(s):");
+				pr_info("drive(s):");
 			} else {
 				prepend = ",";
 			}
@@ -3625,7 +3625,7 @@ static void floppy_release(struct gendisk *disk, fmode_t mode)
 	mutex_lock(&floppy_mutex);
 	mutex_lock(&open_lock);
 	if (!UDRS->fd_ref--) {
-		DPRINT("floppy_release with fd_ref == 0");
+		DPRINT("floppy_release with fd_ref == 0\n");
 		UDRS->fd_ref = 0;
 	}
 	if (!UDRS->fd_ref)
@@ -3777,7 +3777,7 @@ static void floppy_rb0_cb(struct bio *bio, int err)
 	int drive = cbdata->drive;
 
 	if (err) {
-		pr_info("floppy: error %d while reading block 0\n", err);
+		pr_info("error %d while reading block 0\n", err);
 		set_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
 	}
 	complete(&cbdata->complete);
@@ -3905,7 +3905,7 @@ static char __init get_fdc_version(void)
 		return FDC_8272A;	/* 8272a/765 don't know DUMPREGS */
 	}
 	if (r != 10) {
-		pr_info("FDC %d init: DUMPREGS: unexpected return of %d bytes.\n",
+		pr_info("FDC %d init: DUMPREGS: unexpected return of %d bytes\n",
 			fdc, r);
 		return FDC_UNKNOWN;
 	}
@@ -3931,14 +3931,14 @@ static char __init get_fdc_version(void)
 					 * LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
-		pr_info("FDC %d init: UNLOCK: unexpected return of %d bytes.\n",
+		pr_info("FDC %d init: UNLOCK: unexpected return of %d bytes\n",
 			fdc, r);
 		return FDC_UNKNOWN;
 	}
 	output_byte(FD_PARTID);
 	r = result();
 	if (r != 1) {
-		pr_info("FDC %d init: PARTID: unexpected return of %d bytes.\n",
+		pr_info("FDC %d init: PARTID: unexpected return of %d bytes\n",
 			fdc, r);
 		return FDC_UNKNOWN;
 	}
@@ -3949,7 +3949,7 @@ static char __init get_fdc_version(void)
 	switch (reply_buffer[0] >> 5) {
 	case 0x0:
 		/* Either a 82078-1 or a 82078SL running at 5Volt */
-		pr_info("FDC %d is an 82078.\n", fdc);
+		pr_info("FDC %d is an 82078\n", fdc);
 		return FDC_82078;
 	case 0x1:
 		pr_info("FDC %d is a 44pin 82078\n", fdc);
@@ -3961,7 +3961,7 @@ static char __init get_fdc_version(void)
 		pr_info("FDC %d is a National Semiconductor PC87306\n", fdc);
 		return FDC_87306;
 	default:
-		pr_info("FDC %d init: 82078 variant with unknown PARTID=%d.\n",
+		pr_info("FDC %d init: 82078 variant with unknown PARTID=%d\n",
 			fdc, reply_buffer[0] >> 5);
 		return FDC_82078_UNKN;
 	}
@@ -4423,7 +4423,7 @@ static int floppy_request_regions(int fdc)
 	for (p = io_regions; p < ARRAY_END(io_regions); p++) {
 		if (!request_region(FDCS->address + p->offset,
 				    p->size, "floppy")) {
-			DPRINT("Floppy io-port 0x%04lx in use\n",
+			DPRINT("io-port 0x%04lx in use\n",
 			       FDCS->address + p->offset);
 			floppy_release_allocated_regions(fdc, p);
 			return -EBUSY;
@@ -4538,7 +4538,7 @@ static void floppy_release_irq_and_dma(void)
 #endif
 
 	if (delayed_work_pending(&fd_timeout))
-		pr_info("floppy timer still active:%s\n", timeout_message);
+		pr_info("timer still active: %s\n", timeout_message);
 	if (delayed_work_pending(&fd_timer))
 		pr_info("auxiliary floppy timer still active\n");
 	if (work_pending(&floppy_work))



