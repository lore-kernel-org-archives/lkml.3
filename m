Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab3BLWle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:34 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18877 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017Ab3BLWla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:30 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/9] block: xd: avoid using typedefs
Date: Tue, 12 Feb 2013 23:40:56 +0100
Message-Id: <1360708860-23466-7-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of the structs in the driver were using typedef, which we
avoid since ages in the kernel.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 12 ++++++------
 drivers/block/xd.h | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 18f51e9..9e00753 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -77,7 +77,7 @@ static int xd[5] = { -1,-1,-1,-1, };
  * (ST11M controller) or resetting a controller (WD) appears
  */
 
-static XD_INFO xd_info[XD_MAXDRIVES];
+static struct xd_info xd_info[XD_MAXDRIVES];
 
 /*
  * If you try this driver and find that your card is not detected by the
@@ -121,7 +121,7 @@ static XD_INFO xd_info[XD_MAXDRIVES];
 #define xd_dma_mem_free(addr, size) free_pages(addr, get_order(size))
 static char *xd_dma_buffer;
 
-static XD_SIGNATURE xd_sigs[] __initdata = {
+static struct xd_signature xd_sigs[] __initdata = {
 	{ 0x0000,"Override geometry handler",NULL,xd_override_init_drive,"n unknown" }, /* Pat Mackinlay, pat@it.com.au */
 	{ 0x0008,"[BXD06 (C) DTC 17-MAY-1985]",xd_dtc_init_controller,xd_dtc5150cx_init_drive," DTC 5150CX" }, /* Andrzej Krzysztofowicz, ankry@mif.pg.gda.pl */
 	{ 0x000B,"CRD18A   Not an IBM rom. (C) Copyright Data Technology Corp. 05/31/88",xd_dtc_init_controller,xd_dtc_init_drive," DTC 5150X" }, /* Todd Fries, tfries@umr.edu */
@@ -235,7 +235,7 @@ static int __init xd_init(void)
 		goto out3;
 
 	for (i = 0; i < xd_drives; i++) {
-		XD_INFO *p = &xd_info[i];
+		struct xd_info *p = &xd_info[i];
 		struct gendisk *disk = alloc_disk(64);
 		if (!disk)
 			goto Enomem;
@@ -339,7 +339,7 @@ static void do_xd_request(struct request_queue * q)
 	while (req) {
 		unsigned block = blk_rq_pos(req);
 		unsigned count = blk_rq_cur_sectors(req);
-		XD_INFO *disk = req->rq_disk->private_data;
+		struct xd_info *disk = req->rq_disk->private_data;
 		int res = 0;
 		int retry;
 
@@ -365,7 +365,7 @@ static void do_xd_request(struct request_queue * q)
 
 static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	XD_INFO *p = bdev->bd_disk->private_data;
+	struct xd_info *p = bdev->bd_disk->private_data;
 
 	geo->heads = p->heads;
 	geo->sectors = p->sectors;
@@ -416,7 +416,7 @@ static int xd_ioctl(struct block_device *bdev, fmode_t mode,
 }
 
 /* xd_readwrite: handle a read/write request */
-static int xd_readwrite(u_char operation, XD_INFO *p, char *buffer,
+static int xd_readwrite(u_char operation, struct xd_info *p, char *buffer,
 			u_int block, u_int count)
 {
 	int drive = p->unit;
diff --git a/drivers/block/xd.h b/drivers/block/xd.h
index 489e1ce..40630db 100644
--- a/drivers/block/xd.h
+++ b/drivers/block/xd.h
@@ -81,22 +81,22 @@
 #endif /* DEBUG */
 
 /* this structure defines the XT drives and their types */
-typedef struct {
+struct xd_info {
 	u_char heads;
 	u_short cylinders;
 	u_char sectors;
 	u_char control;
 	int unit;
-} XD_INFO;
+};
 
 /* this structure defines a ROM BIOS signature */
-typedef struct {
+struct xd_signature {
 	unsigned int offset;
 	const char *string;
 	void (*init_controller)(unsigned int address);
 	void (*init_drive)(u_char drive);
 	const char *name;
-} XD_SIGNATURE;
+};
 
 #ifndef MODULE
 static int xd_manual_geo_init (char *command);
@@ -106,7 +106,7 @@ static u_char xd_initdrives (void (*init_drive)(u_char drive));
 
 static void do_xd_request (struct request_queue * q);
 static int xd_ioctl (struct block_device *bdev,fmode_t mode,unsigned int cmd,unsigned long arg);
-static int xd_readwrite (u_char operation,XD_INFO *disk,char *buffer,u_int block,u_int count);
+static int xd_readwrite (u_char operation, struct xd_info *disk,char *buffer,u_int block,u_int count);
 static void xd_recalibrate (u_char drive);
 
 static irqreturn_t xd_interrupt_handler(int irq, void *dev_id);
-- 
1.8.1.2

