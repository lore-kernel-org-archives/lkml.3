Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaBZLC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:02:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:54782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaBZLCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 07/16] [media] radio-cadet: avoid interruptible_sleep_on race
Date: Wed, 26 Feb 2014 12:01:47 +0100
Message-Id: <1393412516-3762435-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1TBVnu7Ro34STCxwy7j8q1UgGEJZaysIfyuwdIhotto
 d1HUItnPnF0x7Kim4/O6I2a/DQmnPO7nxgZtlVc9gRDu2d2ltA
 XtLPqqKtcfP1Q3e0GF3DI9oNNnog3Vj+N2NZG338YbhNXdGpvV
 KHU3sCkrzThgAxYOV6Wr3a9uTUhGVA2WMkD6Iypf44LPGmX5et
 2PwkHFa4jzjWkZ0L0gVEfCyDBbcuIym8bAzeh7k2C7PWlcuec8
 lPx2yVE1ZRNZzUQ17jvSBSEG6wRBawm3bvN2TmCP/j2thFMzZL
 ybSjyPo3HxwHluC6DJRMBVBXvP1rSMPsDf47f8093jSexRtq/I
 MHEZwZNpsmGYx0v65UFrpujw3kTecUivq0OwbXSh1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. This replaces
one use in the radio-cadet driver with an wait_event_interruptible
call that lets us check the condition under the mutex
but sleep without it.

The first version of this patch was done by Arnd, but Hans
came up with a nicer solution.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/radio/radio-cadet.c | 46 +++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 545c04c..d27e8b2 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -270,6 +270,16 @@ reset_rds:
 	outb(inb(dev->io + 1) & 0x7f, dev->io + 1);
 }
 
+static bool cadet_has_rds_data(struct cadet *dev)
+{
+	bool result;
+	
+	mutex_lock(&dev->lock);
+	result = dev->rdsin != dev->rdsout;
+	mutex_unlock(&dev->lock);
+	return result;
+}
+
 
 static void cadet_handler(unsigned long data)
 {
@@ -279,13 +289,12 @@ static void cadet_handler(unsigned long data)
 	if (mutex_trylock(&dev->lock)) {
 		outb(0x3, dev->io);       /* Select RDS Decoder Control */
 		if ((inb(dev->io + 1) & 0x20) != 0)
-			printk(KERN_CRIT "cadet: RDS fifo overflow\n");
+			pr_err("cadet: RDS fifo overflow\n");
 		outb(0x80, dev->io);      /* Select RDS fifo */
+
 		while ((inb(dev->io) & 0x80) != 0) {
 			dev->rdsbuf[dev->rdsin] = inb(dev->io + 1);
-			if (dev->rdsin + 1 == dev->rdsout)
-				printk(KERN_WARNING "cadet: RDS buffer overflow\n");
-			else
+			if (dev->rdsin + 1 != dev->rdsout)
 				dev->rdsin++;
 		}
 		mutex_unlock(&dev->lock);
@@ -294,7 +303,7 @@ static void cadet_handler(unsigned long data)
 	/*
 	 * Service pending read
 	 */
-	if (dev->rdsin != dev->rdsout)
+	if (cadet_has_rds_data(dev))
 		wake_up_interruptible(&dev->read_queue);
 
 	/*
@@ -327,22 +336,21 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	mutex_lock(&dev->lock);
 	if (dev->rdsstat == 0)
 		cadet_start_rds(dev);
-	if (dev->rdsin == dev->rdsout) {
-		if (file->f_flags & O_NONBLOCK) {
-			i = -EWOULDBLOCK;
-			goto unlock;
-		}
-		mutex_unlock(&dev->lock);
-		interruptible_sleep_on(&dev->read_queue);
-		mutex_lock(&dev->lock);
-	}
+	mutex_unlock(&dev->lock);
+
+	if (!cadet_has_rds_data(dev) && (file->f_flags & O_NONBLOCK))
+		return -EWOULDBLOCK;
+	i = wait_event_interruptible(dev->read_queue, cadet_has_rds_data(dev));
+	if (i)
+		return i;
+
+	mutex_lock(&dev->lock);
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
+	mutex_unlock(&dev->lock);
 
 	if (i && copy_to_user(data, readbuf, i))
-		i = -EFAULT;
-unlock:
-	mutex_unlock(&dev->lock);
+		return -EFAULT;
 	return i;
 }
 
@@ -352,7 +360,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strlcpy(v->driver, "ADS Cadet", sizeof(v->driver));
 	strlcpy(v->card, "ADS Cadet", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
+	strlcpy(v->bus_info, "ISA:radio-cadet", sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
 			  V4L2_CAP_READWRITE | V4L2_CAP_RDS_CAPTURE;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -491,7 +499,7 @@ static unsigned int cadet_poll(struct file *file, struct poll_table_struct *wait
 			cadet_start_rds(dev);
 		mutex_unlock(&dev->lock);
 	}
-	if (dev->rdsin != dev->rdsout)
+	if (cadet_has_rds_data(dev))
 		res |= POLLIN | POLLRDNORM;
 	return res;
 }
-- 
1.8.3.2

