Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab3BLWlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:36 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18880 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab3BLWlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:31 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/9] block: xd: avoid some forward declarations
Date: Tue, 12 Feb 2013 23:40:57 +0100
Message-Id: <1360708860-23466-8-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-7-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-6-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-7-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the code around so that we can avoid a dozen
forward-declarations, then move the few remaining ones above the
table that use them. No semantic changes.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 801 +++++++++++++++++++++++++++--------------------------
 drivers/block/xd.h |  33 ---
 2 files changed, 415 insertions(+), 419 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 9e00753..ffa6e76 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -121,6 +121,20 @@ static struct xd_info xd_info[XD_MAXDRIVES];
 #define xd_dma_mem_free(addr, size) free_pages(addr, get_order(size))
 static char *xd_dma_buffer;
 
+/* card specific setup and geometry gathering code */
+static void xd_dtc_init_controller (unsigned int address);
+static void xd_dtc5150cx_init_drive (u_char drive);
+static void xd_dtc_init_drive (u_char drive);
+static void xd_wd_init_controller (unsigned int address);
+static void xd_wd_init_drive (u_char drive);
+static void xd_seagate_init_controller (unsigned int address);
+static void xd_seagate_init_drive (u_char drive);
+static void xd_omti_init_controller (unsigned int address);
+static void xd_omti_init_drive (u_char drive);
+static void xd_xebec_init_controller (unsigned int address);
+static void xd_xebec_init_drive (u_char drive);
+static void xd_override_init_drive (u_char drive);
+
 static struct xd_signature xd_sigs[] __initdata = {
 	{ 0x0000,"Override geometry handler",NULL,xd_override_init_drive,"n unknown" }, /* Pat Mackinlay, pat@it.com.au */
 	{ 0x0008,"[BXD06 (C) DTC 17-MAY-1985]",xd_dtc_init_controller,xd_dtc5150cx_init_drive," DTC 5150CX" }, /* Andrzej Krzysztofowicz, ankry@mif.pg.gda.pl */
@@ -150,13 +164,6 @@ static DEFINE_SPINLOCK(xd_lock);
 
 static struct gendisk *xd_gendisk[2];
 
-static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo);
-
-static const struct block_device_operations xd_fops = {
-	.owner	= THIS_MODULE,
-	.ioctl	= xd_ioctl,
-	.getgeo = xd_getgeo,
-};
 static DECLARE_WAIT_QUEUE_HEAD(xd_wait_int);
 static u_char xd_drives, xd_irq = 5, xd_dma = 3, xd_maxsectors;
 static u_char xd_override __initdata = 0, xd_type __initdata = 0;
@@ -171,251 +178,206 @@ static bool nodma = XD_DONT_USE_DMA;
 
 static struct request_queue *xd_queue;
 
-/* xd_init: register the block device number and set up pointer tables */
-static int __init xd_init(void)
+/**
+ * xd_setup_dma() - set up the DMA controller for a data transfer
+ */
+static u_char xd_setup_dma(u_char mode, u_char *buffer, u_int count)
 {
-	u_char i,controller;
-	unsigned int address;
-	int err;
+	unsigned long f;
 
-#ifdef MODULE
-	{
-		u_char count = 0;
-		for (i = 4; i > 0; i--)
-			if (((xd[i] = xd[i-1]) >= 0) && !count)
-				count = i;
-		if ((xd[0] = count))
-			do_xd_setup(xd);
+	if (nodma)
+		return (PIO_MODE);
+	if (((unsigned long) buffer & 0xFFFF0000) != (((unsigned long) buffer + count) & 0xFFFF0000)) {
+#ifdef DEBUG_OTHER
+		printk("xd_setup_dma: using PIO, transfer overlaps 64k boundary\n");
+#endif /* DEBUG_OTHER */
+		return (PIO_MODE);
 	}
-#endif
 
-	init_timer (&xd_watchdog_int); xd_watchdog_int.function = xd_watchdog;
-
-	err = -EBUSY;
-	if (register_blkdev(XT_DISK_MAJOR, "xd"))
-		goto out1;
+	f=claim_dma_lock();
+	disable_dma(xd_dma);
+	clear_dma_ff(xd_dma);
+	set_dma_mode(xd_dma,mode);
+	set_dma_addr(xd_dma, (unsigned long) buffer);
+	set_dma_count(xd_dma,count);
 
-	err = -ENOMEM;
-	xd_queue = blk_init_queue(do_xd_request, &xd_lock);
-	if (!xd_queue)
-		goto out1a;
+	release_dma_lock(f);
 
-	if (xd_detect(&controller,&address)) {
+	return (DMA_MODE); /* use DMA and INT */
+}
 
-		printk("Detected a%s controller (type %d) at address %06x\n",
-			xd_sigs[controller].name,controller,address);
-		if (!request_region(xd_iobase,4,"xd")) {
-			printk("xd: Ports at 0x%x are not available\n",
-				xd_iobase);
-			goto out2;
-		}
-		if (controller)
-			xd_sigs[controller].init_controller(address);
-		xd_drives = xd_initdrives(xd_sigs[controller].init_drive);
+/**
+ * xd_build() - put stuff into an array in a format suitable for
+ * the controller
+ */
+static u_char *xd_build(u_char *cmdblk, u_char command, u_char drive,
+			u_char head, u_short cylinder, u_char sector,
+			u_char count, u_char control)
+{
+	cmdblk[0] = command;
+	cmdblk[1] = ((drive & 0x07) << 5) | (head & 0x1F);
+	cmdblk[2] = ((cylinder & 0x300) >> 2) | (sector & 0x3F);
+	cmdblk[3] = cylinder & 0xFF;
+	cmdblk[4] = count;
+	cmdblk[5] = control;
 
-		printk("Detected %d hard drive%s (using IRQ%d & DMA%d)\n",
-			xd_drives,xd_drives == 1 ? "" : "s",xd_irq,xd_dma);
-	}
+	return (cmdblk);
+}
 
-	/*
-	 * With the drive detected, xd_maxsectors should now be known.
-	 * If xd_maxsectors is 0, nothing was detected and we fall through
-	 * to return -ENODEV
-	 */
-	if (!xd_dma_buffer && xd_maxsectors) {
-		xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
-		if (!xd_dma_buffer) {
-			printk(KERN_ERR "xd: Out of memory.\n");
-			goto out3;
-		}
-	}
+/**
+ * xd_waitport() - waits until port & mask == flags or a timeout occurs.
+ * return 1 for a timeout
+ */
+static inline u_char xd_waitport(u_short port, u_char flags,
+				 u_char mask, u_long timeout)
+{
+	u_long expiry = jiffies + timeout;
+	int success;
 
-	err = -ENODEV;
-	if (!xd_drives)
-		goto out3;
+	xdc_busy = 1;
+	while ((success = ((inb(port) & mask) != flags)) && time_before(jiffies, expiry))
+		schedule_timeout_uninterruptible(1);
+	xdc_busy = 0;
+	return (success);
+}
 
-	for (i = 0; i < xd_drives; i++) {
-		struct xd_info *p = &xd_info[i];
-		struct gendisk *disk = alloc_disk(64);
-		if (!disk)
-			goto Enomem;
-		p->unit = i;
-		disk->major = XT_DISK_MAJOR;
-		disk->first_minor = i<<6;
-		sprintf(disk->disk_name, "xd%c", i+'a');
-		disk->fops = &xd_fops;
-		disk->private_data = p;
-		disk->queue = xd_queue;
-		set_capacity(disk, p->heads * p->cylinders * p->sectors);
-		printk(" %s: CHS=%d/%d/%d\n", disk->disk_name,
-			p->cylinders, p->heads, p->sectors);
-		xd_gendisk[i] = disk;
-	}
+static inline u_int xd_wait_for_IRQ(void)
+{
+	unsigned long flags;
+	xd_watchdog_int.expires = jiffies + 30 * HZ;
+	add_timer(&xd_watchdog_int);
 
-	err = -EBUSY;
-	if (request_irq(xd_irq,xd_interrupt_handler, 0, "XT hard disk", NULL)) {
-		printk("xd: unable to get IRQ%d\n",xd_irq);
-		goto out4;
-	}
+	flags = claim_dma_lock();
+	enable_dma(xd_dma);
+	release_dma_lock(flags);
 
-	if (request_dma(xd_dma,"xd")) {
-		printk("xd: unable to get DMA%d\n",xd_dma);
-		goto out5;
-	}
+	sleep_on(&xd_wait_int);
+	del_timer(&xd_watchdog_int);
+	xdc_busy = 0;
 
-	/* xd_maxsectors depends on controller - so set after detection */
-	blk_queue_max_hw_sectors(xd_queue, xd_maxsectors);
+	flags = claim_dma_lock();
+	disable_dma(xd_dma);
+	release_dma_lock(flags);
 
-	for (i = 0; i < xd_drives; i++)
-		add_disk(xd_gendisk[i]);
+	if (xd_error) {
+		printk("xd: missed IRQ - command aborted\n");
+		xd_error = 0;
+		return (1);
+	}
+	return (0);
+}
 
-	return 0;
+/**
+ * xd_command() - handle all data transfers necessary for a single command
+ */
+static u_int xd_command(u_char *command, u_char mode, u_char *indata,
+			u_char *outdata, u_char *sense, u_long timeout)
+{
+	u_char cmdblk[6], csb, complete = 0;
 
-out5:
-	free_irq(xd_irq, NULL);
-out4:
-	for (i = 0; i < xd_drives; i++)
-		put_disk(xd_gendisk[i]);
-out3:
-	if (xd_maxsectors)
-		release_region(xd_iobase,4);
+#ifdef DEBUG_COMMAND
+	printk("xd_command: command = 0x%X, mode = 0x%X, indata = 0x%X, outdata = 0x%X, sense = 0x%X\n",command,mode,indata,outdata,sense);
+#endif /* DEBUG_COMMAND */
 
-	if (xd_dma_buffer)
-		xd_dma_mem_free((unsigned long)xd_dma_buffer,
-				xd_maxsectors * 0x200);
-out2:
-	blk_cleanup_queue(xd_queue);
-out1a:
-	unregister_blkdev(XT_DISK_MAJOR, "xd");
-out1:
-	return err;
-Enomem:
-	err = -ENOMEM;
-	while (i--)
-		put_disk(xd_gendisk[i]);
-	goto out3;
-}
+	outb(0,XD_SELECT);
+	udelay(OUTB_DELAY);
+	outb(mode,XD_CONTROL);
+	udelay(OUTB_DELAY);
 
-/* xd_detect: scan the possible BIOS ROM locations for the signature strings */
-static u_char __init xd_detect(u_char *controller, unsigned int *address)
-{
-	int i, j;
+	if (xd_waitport(XD_STATUS,STAT_SELECT,STAT_SELECT,timeout))
+		return (1);
 
-	if (xd_override)
-	{
-		*controller = xd_type;
-		*address = 0;
-		return(1);
-	}
+	while (!complete) {
+		if (xd_waitport(XD_STATUS,STAT_READY,STAT_READY,timeout))
+			return (1);
 
-	for (i = 0; i < ARRAY_SIZE(xd_bases); i++) {
-		void __iomem *p = ioremap(xd_bases[i], 0x2000);
-		if (!p)
-			continue;
-		for (j = 1; j < ARRAY_SIZE(xd_sigs); j++) {
-			const char *s = xd_sigs[j].string;
-			if (check_signature(p + xd_sigs[j].offset, s, strlen(s))) {
-				*controller = j;
-				xd_type = j;
-				*address = xd_bases[i];
-				iounmap(p);
-				return 1;
-			}
+		switch (inb(XD_STATUS) & (STAT_COMMAND | STAT_INPUT)) {
+			case 0:
+				if (mode == DMA_MODE) {
+					if (xd_wait_for_IRQ())
+						return (1);
+				} else {
+					outb(outdata ? *outdata++ : 0,XD_DATA);
+					udelay(OUTB_DELAY);
+				}
+				break;
+			case STAT_INPUT:
+				if (mode == DMA_MODE) {
+					if (xd_wait_for_IRQ())
+						return (1);
+				} else
+					if (indata)
+						*indata++ = inb(XD_DATA);
+					else
+						inb(XD_DATA);
+				break;
+			case STAT_COMMAND:
+				outb(command ? *command++ : 0,XD_DATA);
+				udelay(OUTB_DELAY);
+				break;
+			case STAT_COMMAND | STAT_INPUT:
+				complete = 1;
+				break;
 		}
-		iounmap(p);
 	}
-	return 0;
-}
+	csb = inb(XD_DATA);
 
-/* do_xd_request: handle an incoming request */
-static void do_xd_request(struct request_queue * q)
-{
-	struct request *req;
+	if (xd_waitport(XD_STATUS,0,STAT_SELECT,timeout))					/* wait until deselected */
+		return (1);
 
-	if (xdc_busy)
-		return;
+	if (csb & CSB_ERROR) {									/* read sense data if error */
+		xd_build(cmdblk,CMD_SENSE,(csb & CSB_LUN) >> 5,0,0,0,0,0);
+		if (xd_command(cmdblk,0,sense,NULL,NULL,XD_TIMEOUT))
+			printk("xd: warning! sense command failed!\n");
+	}
 
-	req = blk_fetch_request(q);
-	while (req) {
-		unsigned block = blk_rq_pos(req);
-		unsigned count = blk_rq_cur_sectors(req);
-		struct xd_info *disk = req->rq_disk->private_data;
-		int res = 0;
-		int retry;
+#ifdef DEBUG_COMMAND
+	printk("xd_command: completed with csb = 0x%X\n",csb);
+#endif /* DEBUG_COMMAND */
 
-		if (req->cmd_type != REQ_TYPE_FS) {
-			pr_err("unsupported request: %d\n", req->cmd_type);
-			res = -EIO;
-			goto done;
-		}
-		if (block + count > get_capacity(req->rq_disk)) {
-			pr_err("request beyond device capacity\n");
-			res = -EIO;
-			goto done;
-		}
-		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
-			res = xd_readwrite(rq_data_dir(req), disk, req->buffer,
-					   block, count);
-	done:
-		/* wrap up, 0 = success, -errno = fail */
-		if (!__blk_end_request_cur(req, res))
-			req = blk_fetch_request(q);
-	}
+	return (csb & CSB_ERROR);
 }
 
-static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+/**
+ * xd_setparam() - set the drive characteristics
+ */
+static void __init xd_setparam (u_char command, u_char drive, u_char heads,
+				u_short cylinders, u_short rwrite,
+				u_short wprecomp, u_char ecc)
 {
-	struct xd_info *p = bdev->bd_disk->private_data;
+	u_char cmdblk[14];
 
-	geo->heads = p->heads;
-	geo->sectors = p->sectors;
-	geo->cylinders = p->cylinders;
-	return 0;
-}
+	xd_build(cmdblk,command,drive,0,0,0,0,0);
+	cmdblk[6] = (u_char) (cylinders >> 8) & 0x03;
+	cmdblk[7] = (u_char) (cylinders & 0xFF);
+	cmdblk[8] = heads & 0x1F;
+	cmdblk[9] = (u_char) (rwrite >> 8) & 0x03;
+	cmdblk[10] = (u_char) (rwrite & 0xFF);
+	cmdblk[11] = (u_char) (wprecomp >> 8) & 0x03;
+	cmdblk[12] = (u_char) (wprecomp & 0xFF);
+	cmdblk[13] = ecc;
 
-/* xd_ioctl: handle device ioctl's */
-static int xd_locked_ioctl(struct block_device *bdev, fmode_t mode,
-			   u_int cmd, u_long arg)
-{
-	switch (cmd) {
-		case HDIO_SET_DMA:
-			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
-			if (xdc_busy) return -EBUSY;
-			nodma = !arg;
-			if (nodma && xd_dma_buffer) {
-				xd_dma_mem_free((unsigned long)xd_dma_buffer,
-						xd_maxsectors * 0x200);
-				xd_dma_buffer = NULL;
-			} else if (!nodma && !xd_dma_buffer) {
-				xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
-				if (!xd_dma_buffer) {
-					nodma = XD_DONT_USE_DMA;
-					return -ENOMEM;
-				}
-			}
-			return 0;
-		case HDIO_GET_DMA:
-			return put_user(!nodma, (long __user *) arg);
-		case HDIO_GET_MULTCOUNT:
-			return put_user(xd_maxsectors, (long __user *) arg);
-		default:
-			return -EINVAL;
-	}
+	/* Some controllers require geometry info as data, not command */
+	if (xd_command(cmdblk,PIO_MODE,NULL,&cmdblk[6],NULL,XD_TIMEOUT * 2))
+		printk("xd: error setting characteristics for xd%c\n", 'a'+drive);
 }
 
-static int xd_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned int cmd, unsigned long param)
+/**
+ * xd_recalibrate() - recalibrate a given drive and reset controller if
+ * necessary
+ */
+static void xd_recalibrate(u_char drive)
 {
-	int ret;
-
-	mutex_lock(&xd_mutex);
-	ret = xd_locked_ioctl(bdev, mode, cmd, param);
-	mutex_unlock(&xd_mutex);
+	u_char cmdblk[6];
 
-	return ret;
+	xd_build(cmdblk,CMD_RECALIBRATE,drive,0,0,0,0,0);
+	if (xd_command(cmdblk,PIO_MODE,NULL,NULL,NULL,XD_TIMEOUT * 8))
+		printk("xd%c: warning! error recalibrating, controller may be unstable\n", 'a'+drive);
 }
 
-/* xd_readwrite: handle a read/write request */
+/**
+ * xd_readwrite() - handle a read/write request
+ */
 static int xd_readwrite(u_char operation, struct xd_info *p, char *buffer,
 			u_int block, u_int count)
 {
@@ -496,187 +458,154 @@ static int xd_readwrite(u_char operation, struct xd_info *p, char *buffer,
 	return 0;
 }
 
-/* xd_recalibrate: recalibrate a given drive and reset controller if necessary */
-static void xd_recalibrate(u_char drive)
+/* xd_detect: scan the possible BIOS ROM locations for the signature strings */
+static u_char __init xd_detect(u_char *controller, unsigned int *address)
 {
-	u_char cmdblk[6];
+	int i, j;
 
-	xd_build(cmdblk,CMD_RECALIBRATE,drive,0,0,0,0,0);
-	if (xd_command(cmdblk,PIO_MODE,NULL,NULL,NULL,XD_TIMEOUT * 8))
-		printk("xd%c: warning! error recalibrating, controller may be unstable\n", 'a'+drive);
-}
+	if (xd_override)
+	{
+		*controller = xd_type;
+		*address = 0;
+		return(1);
+	}
 
-/* xd_interrupt_handler: interrupt service routine */
-static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
-{
-	if (inb(XD_STATUS) & STAT_INTERRUPT) {							/* check if it was our device */
-#ifdef DEBUG_OTHER
-		printk("xd_interrupt_handler: interrupt detected\n");
-#endif /* DEBUG_OTHER */
-		outb(0,XD_CONTROL); /* acknowledge interrupt */
-		udelay(OUTB_DELAY);
-		wake_up(&xd_wait_int);	/* and wake up sleeping processes */
-		return IRQ_HANDLED;
+	for (i = 0; i < ARRAY_SIZE(xd_bases); i++) {
+		void __iomem *p = ioremap(xd_bases[i], 0x2000);
+		if (!p)
+			continue;
+		for (j = 1; j < ARRAY_SIZE(xd_sigs); j++) {
+			const char *s = xd_sigs[j].string;
+			if (check_signature(p + xd_sigs[j].offset, s, strlen(s))) {
+				*controller = j;
+				xd_type = j;
+				*address = xd_bases[i];
+				iounmap(p);
+				return 1;
+			}
+		}
+		iounmap(p);
 	}
-	else
-		printk("xd: unexpected interrupt\n");
-	return IRQ_NONE;
+	return 0;
 }
 
-/* xd_setup_dma: set up the DMA controller for a data transfer */
-static u_char xd_setup_dma(u_char mode, u_char *buffer, u_int count)
+/* do_xd_request: handle an incoming request */
+static void do_xd_request(struct request_queue * q)
 {
-	unsigned long f;
-
-	if (nodma)
-		return (PIO_MODE);
-	if (((unsigned long) buffer & 0xFFFF0000) != (((unsigned long) buffer + count) & 0xFFFF0000)) {
-#ifdef DEBUG_OTHER
-		printk("xd_setup_dma: using PIO, transfer overlaps 64k boundary\n");
-#endif /* DEBUG_OTHER */
-		return (PIO_MODE);
-	}
+	struct request *req;
 
-	f=claim_dma_lock();
-	disable_dma(xd_dma);
-	clear_dma_ff(xd_dma);
-	set_dma_mode(xd_dma,mode);
-	set_dma_addr(xd_dma, (unsigned long) buffer);
-	set_dma_count(xd_dma,count);
+	if (xdc_busy)
+		return;
 
-	release_dma_lock(f);
+	req = blk_fetch_request(q);
+	while (req) {
+		unsigned block = blk_rq_pos(req);
+		unsigned count = blk_rq_cur_sectors(req);
+		struct xd_info *disk = req->rq_disk->private_data;
+		int res = 0;
+		int retry;
 
-	return (DMA_MODE); /* use DMA and INT */
+		if (req->cmd_type != REQ_TYPE_FS) {
+			pr_err("unsupported request: %d\n", req->cmd_type);
+			res = -EIO;
+			goto done;
+		}
+		if (block + count > get_capacity(req->rq_disk)) {
+			pr_err("request beyond device capacity\n");
+			res = -EIO;
+			goto done;
+		}
+		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
+			res = xd_readwrite(rq_data_dir(req), disk, req->buffer,
+					   block, count);
+	done:
+		/* wrap up, 0 = success, -errno = fail */
+		if (!__blk_end_request_cur(req, res))
+			req = blk_fetch_request(q);
+	}
 }
 
-/* xd_build: put stuff into an array in a format suitable for the controller */
-static u_char *xd_build(u_char *cmdblk, u_char command, u_char drive,
-			u_char head, u_short cylinder, u_char sector,
-			u_char count, u_char control)
+static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
-	cmdblk[0] = command;
-	cmdblk[1] = ((drive & 0x07) << 5) | (head & 0x1F);
-	cmdblk[2] = ((cylinder & 0x300) >> 2) | (sector & 0x3F);
-	cmdblk[3] = cylinder & 0xFF;
-	cmdblk[4] = count;
-	cmdblk[5] = control;
-
-	return (cmdblk);
-}
+	struct xd_info *p = bdev->bd_disk->private_data;
 
-static void xd_watchdog(unsigned long unused)
-{
-	xd_error = 1;
-	wake_up(&xd_wait_int);
+	geo->heads = p->heads;
+	geo->sectors = p->sectors;
+	geo->cylinders = p->cylinders;
+	return 0;
 }
 
-/* xd_waitport: waits until port & mask == flags or a timeout occurs. return 1 for a timeout */
-static inline u_char xd_waitport(u_short port, u_char flags,
-				 u_char mask, u_long timeout)
+static int xd_locked_ioctl(struct block_device *bdev, fmode_t mode,
+			   u_int cmd, u_long arg)
 {
-	u_long expiry = jiffies + timeout;
-	int success;
-
-	xdc_busy = 1;
-	while ((success = ((inb(port) & mask) != flags)) && time_before(jiffies, expiry))
-		schedule_timeout_uninterruptible(1);
-	xdc_busy = 0;
-	return (success);
+	switch (cmd) {
+		case HDIO_SET_DMA:
+			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
+			if (xdc_busy) return -EBUSY;
+			nodma = !arg;
+			if (nodma && xd_dma_buffer) {
+				xd_dma_mem_free((unsigned long)xd_dma_buffer,
+						xd_maxsectors * 0x200);
+				xd_dma_buffer = NULL;
+			} else if (!nodma && !xd_dma_buffer) {
+				xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
+				if (!xd_dma_buffer) {
+					nodma = XD_DONT_USE_DMA;
+					return -ENOMEM;
+				}
+			}
+			return 0;
+		case HDIO_GET_DMA:
+			return put_user(!nodma, (long __user *) arg);
+		case HDIO_GET_MULTCOUNT:
+			return put_user(xd_maxsectors, (long __user *) arg);
+		default:
+			return -EINVAL;
+	}
 }
 
-static inline u_int xd_wait_for_IRQ(void)
+/**
+ * xd_ioctl() - handle device ioctl's
+ */
+static int xd_ioctl(struct block_device *bdev, fmode_t mode,
+		    unsigned int cmd, unsigned long param)
 {
-	unsigned long flags;
-	xd_watchdog_int.expires = jiffies + 30 * HZ;
-	add_timer(&xd_watchdog_int);
+	int ret;
 
-	flags=claim_dma_lock();
-	enable_dma(xd_dma);
-	release_dma_lock(flags);
+	mutex_lock(&xd_mutex);
+	ret = xd_locked_ioctl(bdev, mode, cmd, param);
+	mutex_unlock(&xd_mutex);
 
-	sleep_on(&xd_wait_int);
-	del_timer(&xd_watchdog_int);
-	xdc_busy = 0;
+	return ret;
+}
 
-	flags=claim_dma_lock();
-	disable_dma(xd_dma);
-	release_dma_lock(flags);
+static const struct block_device_operations xd_fops = {
+	.owner	= THIS_MODULE,
+	.ioctl	= xd_ioctl,
+	.getgeo = xd_getgeo,
+};
 
-	if (xd_error) {
-		printk("xd: missed IRQ - command aborted\n");
-		xd_error = 0;
-		return (1);
+/* xd_interrupt_handler: interrupt service routine */
+static irqreturn_t xd_interrupt_handler(int irq, void *dev_id)
+{
+	if (inb(XD_STATUS) & STAT_INTERRUPT) {							/* check if it was our device */
+#ifdef DEBUG_OTHER
+		printk("xd_interrupt_handler: interrupt detected\n");
+#endif /* DEBUG_OTHER */
+		outb(0,XD_CONTROL); /* acknowledge interrupt */
+		udelay(OUTB_DELAY);
+		wake_up(&xd_wait_int);	/* and wake up sleeping processes */
+		return IRQ_HANDLED;
 	}
-	return (0);
+	else
+		printk("xd: unexpected interrupt\n");
+	return IRQ_NONE;
 }
 
-/* xd_command: handle all data transfers necessary for a single command */
-static u_int xd_command(u_char *command, u_char mode, u_char *indata,
-			u_char *outdata, u_char *sense, u_long timeout)
+static void xd_watchdog(unsigned long unused)
 {
-	u_char cmdblk[6], csb, complete = 0;
-
-#ifdef DEBUG_COMMAND
-	printk("xd_command: command = 0x%X, mode = 0x%X, indata = 0x%X, outdata = 0x%X, sense = 0x%X\n",command,mode,indata,outdata,sense);
-#endif /* DEBUG_COMMAND */
-
-	outb(0,XD_SELECT);
-	udelay(OUTB_DELAY);
-	outb(mode,XD_CONTROL);
-	udelay(OUTB_DELAY);
-
-	if (xd_waitport(XD_STATUS,STAT_SELECT,STAT_SELECT,timeout))
-		return (1);
-
-	while (!complete) {
-		if (xd_waitport(XD_STATUS,STAT_READY,STAT_READY,timeout))
-			return (1);
-
-		switch (inb(XD_STATUS) & (STAT_COMMAND | STAT_INPUT)) {
-			case 0:
-				if (mode == DMA_MODE) {
-					if (xd_wait_for_IRQ())
-						return (1);
-				} else {
-					outb(outdata ? *outdata++ : 0,XD_DATA);
-					udelay(OUTB_DELAY);
-				}
-				break;
-			case STAT_INPUT:
-				if (mode == DMA_MODE) {
-					if (xd_wait_for_IRQ())
-						return (1);
-				} else
-					if (indata)
-						*indata++ = inb(XD_DATA);
-					else
-						inb(XD_DATA);
-				break;
-			case STAT_COMMAND:
-				outb(command ? *command++ : 0,XD_DATA);
-				udelay(OUTB_DELAY);
-				break;
-			case STAT_COMMAND | STAT_INPUT:
-				complete = 1;
-				break;
-		}
-	}
-	csb = inb(XD_DATA);
-
-	if (xd_waitport(XD_STATUS,0,STAT_SELECT,timeout))					/* wait until deselected */
-		return (1);
-
-	if (csb & CSB_ERROR) {									/* read sense data if error */
-		xd_build(cmdblk,CMD_SENSE,(csb & CSB_LUN) >> 5,0,0,0,0,0);
-		if (xd_command(cmdblk,0,sense,NULL,NULL,XD_TIMEOUT))
-			printk("xd: warning! sense command failed!\n");
-	}
-
-#ifdef DEBUG_COMMAND
-	printk("xd_command: completed with csb = 0x%X\n",csb);
-#endif /* DEBUG_COMMAND */
-
-	return (csb & CSB_ERROR);
+	xd_error = 1;
+	wake_up(&xd_wait_int);
 }
 
 static u_char __init xd_initdrives(void (*init_drive)(u_char drive))
@@ -1083,29 +1012,129 @@ static void __init do_xd_setup(int *integers)
 	xd_maxsectors = 0x01;
 }
 
-/**
- * xd_setparam() - set the drive characteristics
- */
-static void __init xd_setparam (u_char command, u_char drive, u_char heads,
-				u_short cylinders, u_short rwrite,
-				u_short wprecomp, u_char ecc)
+/* xd_init: register the block device number and set up pointer tables */
+static int __init xd_init(void)
 {
-	u_char cmdblk[14];
+	u_char i,controller;
+	unsigned int address;
+	int err;
 
-	xd_build(cmdblk,command,drive,0,0,0,0,0);
-	cmdblk[6] = (u_char) (cylinders >> 8) & 0x03;
-	cmdblk[7] = (u_char) (cylinders & 0xFF);
-	cmdblk[8] = heads & 0x1F;
-	cmdblk[9] = (u_char) (rwrite >> 8) & 0x03;
-	cmdblk[10] = (u_char) (rwrite & 0xFF);
-	cmdblk[11] = (u_char) (wprecomp >> 8) & 0x03;
-	cmdblk[12] = (u_char) (wprecomp & 0xFF);
-	cmdblk[13] = ecc;
+#ifdef MODULE
+	{
+		u_char count = 0;
+		for (i = 4; i > 0; i--)
+			if (((xd[i] = xd[i-1]) >= 0) && !count)
+				count = i;
+		if ((xd[0] = count))
+			do_xd_setup(xd);
+	}
+#endif
 
-	/* Some controllers require geometry info as data, not command */
+	init_timer (&xd_watchdog_int); xd_watchdog_int.function = xd_watchdog;
 
-	if (xd_command(cmdblk,PIO_MODE,NULL,&cmdblk[6],NULL,XD_TIMEOUT * 2))
-		printk("xd: error setting characteristics for xd%c\n", 'a'+drive);
+	err = -EBUSY;
+	if (register_blkdev(XT_DISK_MAJOR, "xd"))
+		goto out1;
+
+	err = -ENOMEM;
+	xd_queue = blk_init_queue(do_xd_request, &xd_lock);
+	if (!xd_queue)
+		goto out1a;
+
+	if (xd_detect(&controller,&address)) {
+
+		printk("Detected a%s controller (type %d) at address %06x\n",
+			xd_sigs[controller].name,controller,address);
+		if (!request_region(xd_iobase,4,"xd")) {
+			printk("xd: Ports at 0x%x are not available\n",
+				xd_iobase);
+			goto out2;
+		}
+		if (controller)
+			xd_sigs[controller].init_controller(address);
+		xd_drives = xd_initdrives(xd_sigs[controller].init_drive);
+
+		printk("Detected %d hard drive%s (using IRQ%d & DMA%d)\n",
+			xd_drives,xd_drives == 1 ? "" : "s",xd_irq,xd_dma);
+	}
+
+	/*
+	 * With the drive detected, xd_maxsectors should now be known.
+	 * If xd_maxsectors is 0, nothing was detected and we fall through
+	 * to return -ENODEV
+	 */
+	if (!xd_dma_buffer && xd_maxsectors) {
+		xd_dma_buffer = (char *)xd_dma_mem_alloc(xd_maxsectors * 0x200);
+		if (!xd_dma_buffer) {
+			printk(KERN_ERR "xd: Out of memory.\n");
+			goto out3;
+		}
+	}
+
+	err = -ENODEV;
+	if (!xd_drives)
+		goto out3;
+
+	for (i = 0; i < xd_drives; i++) {
+		struct xd_info *p = &xd_info[i];
+		struct gendisk *disk = alloc_disk(64);
+		if (!disk)
+			goto Enomem;
+		p->unit = i;
+		disk->major = XT_DISK_MAJOR;
+		disk->first_minor = i<<6;
+		sprintf(disk->disk_name, "xd%c", i+'a');
+		disk->fops = &xd_fops;
+		disk->private_data = p;
+		disk->queue = xd_queue;
+		set_capacity(disk, p->heads * p->cylinders * p->sectors);
+		printk(" %s: CHS=%d/%d/%d\n", disk->disk_name,
+			p->cylinders, p->heads, p->sectors);
+		xd_gendisk[i] = disk;
+	}
+
+	err = -EBUSY;
+	if (request_irq(xd_irq,xd_interrupt_handler, 0, "XT hard disk", NULL)) {
+		printk("xd: unable to get IRQ%d\n",xd_irq);
+		goto out4;
+	}
+
+	if (request_dma(xd_dma,"xd")) {
+		printk("xd: unable to get DMA%d\n",xd_dma);
+		goto out5;
+	}
+
+	/* xd_maxsectors depends on controller - so set after detection */
+	blk_queue_max_hw_sectors(xd_queue, xd_maxsectors);
+
+	for (i = 0; i < xd_drives; i++)
+		add_disk(xd_gendisk[i]);
+
+	return 0;
+
+out5:
+	free_irq(xd_irq, NULL);
+out4:
+	for (i = 0; i < xd_drives; i++)
+		put_disk(xd_gendisk[i]);
+out3:
+	if (xd_maxsectors)
+		release_region(xd_iobase,4);
+
+	if (xd_dma_buffer)
+		xd_dma_mem_free((unsigned long)xd_dma_buffer,
+				xd_maxsectors * 0x200);
+out2:
+	blk_cleanup_queue(xd_queue);
+out1a:
+	unregister_blkdev(XT_DISK_MAJOR, "xd");
+out1:
+	return err;
+Enomem:
+	err = -ENOMEM;
+	while (i--)
+		put_disk(xd_gendisk[i]);
+	goto out3;
 }
 
 #ifdef MODULE
diff --git a/drivers/block/xd.h b/drivers/block/xd.h
index 40630db..f09a33d 100644
--- a/drivers/block/xd.h
+++ b/drivers/block/xd.h
@@ -98,37 +98,4 @@ struct xd_signature {
 	const char *name;
 };
 
-#ifndef MODULE
-static int xd_manual_geo_init (char *command);
-#endif /* MODULE */
-static u_char xd_detect (u_char *controller, unsigned int *address);
-static u_char xd_initdrives (void (*init_drive)(u_char drive));
-
-static void do_xd_request (struct request_queue * q);
-static int xd_ioctl (struct block_device *bdev,fmode_t mode,unsigned int cmd,unsigned long arg);
-static int xd_readwrite (u_char operation, struct xd_info *disk,char *buffer,u_int block,u_int count);
-static void xd_recalibrate (u_char drive);
-
-static irqreturn_t xd_interrupt_handler(int irq, void *dev_id);
-static u_char xd_setup_dma (u_char opcode,u_char *buffer,u_int count);
-static u_char *xd_build (u_char *cmdblk,u_char command,u_char drive,u_char head,u_short cylinder,u_char sector,u_char count,u_char control);
-static void xd_watchdog (unsigned long unused);
-static inline u_char xd_waitport (u_short port,u_char flags,u_char mask,u_long timeout);
-static u_int xd_command (u_char *command,u_char mode,u_char *indata,u_char *outdata,u_char *sense,u_long timeout);
-
-/* card specific setup and geometry gathering code */
-static void xd_dtc_init_controller (unsigned int address);
-static void xd_dtc5150cx_init_drive (u_char drive);
-static void xd_dtc_init_drive (u_char drive);
-static void xd_wd_init_controller (unsigned int address);
-static void xd_wd_init_drive (u_char drive);
-static void xd_seagate_init_controller (unsigned int address);
-static void xd_seagate_init_drive (u_char drive);
-static void xd_omti_init_controller (unsigned int address);
-static void xd_omti_init_drive (u_char drive);
-static void xd_xebec_init_controller (unsigned int address);
-static void xd_xebec_init_drive (u_char drive);
-static void xd_setparam (u_char command,u_char drive,u_char heads,u_short cylinders,u_short rwrite,u_short wprecomp,u_char ecc);
-static void xd_override_init_drive (u_char drive);
-
 #endif /* _LINUX_XD_H */
-- 
1.8.1.2

