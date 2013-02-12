Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3BLWlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:42 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18886 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068Ab3BLWle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:34 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 8/9] block: xd: remove custom DEBUG print system
Date: Tue, 12 Feb 2013 23:40:59 +0100
Message-Id: <1360708860-23466-10-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-9-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-7-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-8-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-9-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver used a variant of debug levels, convert this over to
using the kernel pr_debug() macro for all instances. Instead
of hard-coding function names in debug messages, pass __func__.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 46 +++++++++++++++-------------------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 1875590..7ecebd4 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -113,16 +113,6 @@
 #define XD_TIMEOUT	(HZ * 30)	/* 30 second timeout */
 #define XD_RETRIES	4	/* maximum 4 retries */
 
-#undef DEBUG			/* define for debugging output */
-
-#ifdef DEBUG
-	#define DEBUG_STARTUP	/* debug driver initialisation */
-	#define DEBUG_OVERRIDE	/* debug override geometry detection */
-	#define DEBUG_READWRITE	/* debug each read/write command */
-	#define DEBUG_OTHER	/* debug misc. interrupt/DMA stuff */
-	#define DEBUG_COMMAND	/* debug each controller command */
-#endif /* DEBUG */
-
 /* this structure defines the XT drives and their types */
 struct xd_info {
 	u_char heads;
@@ -270,9 +260,8 @@ static u_char xd_setup_dma(u_char mode, u_char *buffer, u_int count)
 	if (nodma)
 		return (PIO_MODE);
 	if (((unsigned long) buffer & 0xFFFF0000) != (((unsigned long) buffer + count) & 0xFFFF0000)) {
-#ifdef DEBUG_OTHER
-		printk("xd_setup_dma: using PIO, transfer overlaps 64k boundary\n");
-#endif /* DEBUG_OTHER */
+		pr_debug("%s: using PIO, transfer overlaps 64k boundary\n",
+			 __func__);
 		return (PIO_MODE);
 	}
 
@@ -357,10 +346,8 @@ static u_int xd_command(u_char *command, u_char mode, u_char *indata,
 {
 	u_char cmdblk[6], csb, complete = 0;
 
-#ifdef DEBUG_COMMAND
-	printk("xd_command: command = 0x%X, mode = 0x%X, indata = 0x%X, outdata = 0x%X, sense = 0x%X\n",command,mode,indata,outdata,sense);
-#endif /* DEBUG_COMMAND */
-
+	pr_debug("%s: command = 0x%p, mode = 0x%X, indata = 0x%p, outdata = 0x%p, sense = 0x%p\n",
+		 __func__, command, mode, indata, outdata, sense);
 	outb(0,XD_SELECT);
 	udelay(OUTB_DELAY);
 	outb(mode,XD_CONTROL);
@@ -413,9 +400,7 @@ static u_int xd_command(u_char *command, u_char mode, u_char *indata,
 			printk("xd: warning! sense command failed!\n");
 	}
 
-#ifdef DEBUG_COMMAND
-	printk("xd_command: completed with csb = 0x%X\n",csb);
-#endif /* DEBUG_COMMAND */
+	pr_debug("%s: completed with csb = 0x%X\n", __func__, csb);
 
 	return (csb & CSB_ERROR);
 }
@@ -470,9 +455,9 @@ static int xd_readwrite(u_char operation, struct xd_info *p, char *buffer,
 	char **real_buffer;
 	register int i;
 
-#ifdef DEBUG_READWRITE
-	printk("xd_readwrite: operation = %s, drive = %d, buffer = 0x%X, block = %d, count = %d\n",operation == READ ? "read" : "write",drive,buffer,block,count);
-#endif /* DEBUG_READWRITE */
+	pr_debug("%s: operation = %s, drive = %d, buffer = 0x%p, block = %d, count = %d\n",
+		 __func__, operation == READ ? "read" : "write",
+		 drive, buffer, block, count);
 
 	spin_unlock_irq(&xd_lock);
 
@@ -487,9 +472,8 @@ static int xd_readwrite(u_char operation, struct xd_info *p, char *buffer,
 		cylinder = track / p->heads;
 		sector = block % p->sectors;
 
-#ifdef DEBUG_READWRITE
-		printk("xd_readwrite: drive = %d, head = %d, cylinder = %d, sector = %d, count = %d\n",drive,head,cylinder,sector,temp);
-#endif /* DEBUG_READWRITE */
+		pr_debug("%s: drive = %d, head = %d, cylinder = %d, sector = %d, count = %d\n",
+			 __func__, drive, head, cylinder, sector, temp);
 
 		if (xd_dma_buffer) {
 			mode = xd_setup_dma(operation == READ ? DMA_MODE_READ : DMA_MODE_WRITE,(u_char *)(xd_dma_buffer),temp * 0x200);
@@ -588,12 +572,14 @@ static void do_xd_request(struct request_queue * q)
 		int retry;
 
 		if (req->cmd_type != REQ_TYPE_FS) {
-			pr_err("unsupported request: %d\n", req->cmd_type);
+			pr_err("%s: unsupported request: %d\n",
+			       __func__, req->cmd_type);
 			res = -EIO;
 			goto done;
 		}
 		if (block + count > get_capacity(req->rq_disk)) {
-			pr_err("request beyond device capacity\n");
+			pr_err("%s: request beyond device capacity\n",
+			       __func__);
 			res = -EIO;
 			goto done;
 		}
@@ -671,9 +657,7 @@ static const struct block_device_operations xd_fops = {
 static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
 {
 	if (inb(XD_STATUS) & STAT_INTERRUPT) {							/* check if it was our device */
-#ifdef DEBUG_OTHER
-		printk("xd_interrupt_handler: interrupt detected\n");
-#endif /* DEBUG_OTHER */
+		pr_debug("%s: interrupt detected\n", __func__);
 		outb(0,XD_CONTROL); /* acknowledge interrupt */
 		udelay(OUTB_DELAY);
 		wake_up(&xd_wait_int);	/* and wake up sleeping processes */
-- 
1.8.1.2

