Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaJLUnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:43:53 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40551 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaJLUlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:01 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 06/15] media: davinci: vpbe: use vb2_fop_mmap/poll
Date: Sun, 12 Oct 2014 21:40:36 +0100
Message-Id: <1413146445-7304-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch teaches vpbe driver to use vb2_fop_mmap/poll helpers.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 44 ++-------------------------
 1 file changed, 3 insertions(+), 41 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 524e1fd..fc3bdb6 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1341,45 +1341,6 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 }
 
 /*
- * vpbe_display_mmap()
- * It is used to map kernel space buffers into user spaces
- */
-static int vpbe_display_mmap(struct file *filep, struct vm_area_struct *vma)
-{
-	/* Get the layer object and file handle object */
-	struct vpbe_fh *fh = filep->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-	int ret;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_mmap\n");
-
-	if (mutex_lock_interruptible(&layer->opslock))
-		return -ERESTARTSYS;
-	ret = vb2_mmap(&layer->buffer_queue, vma);
-	mutex_unlock(&layer->opslock);
-	return ret;
-}
-
-/* vpbe_display_poll(): It is used for select/poll system call
- */
-static unsigned int vpbe_display_poll(struct file *filep, poll_table *wait)
-{
-	struct vpbe_fh *fh = filep->private_data;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-	unsigned int err = 0;
-
-	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_poll\n");
-	if (layer->started) {
-		mutex_lock(&layer->opslock);
-		err = vb2_poll(&layer->buffer_queue, filep, wait);
-		mutex_unlock(&layer->opslock);
-	}
-	return err;
-}
-
-/*
  * vpbe_display_open()
  * It creates object of file handle structure and stores it in private_data
  * member of filepointer
@@ -1527,8 +1488,8 @@ static struct v4l2_file_operations vpbe_fops = {
 	.open = vpbe_display_open,
 	.release = vpbe_display_release,
 	.unlocked_ioctl = video_ioctl2,
-	.mmap = vpbe_display_mmap,
-	.poll = vpbe_display_poll
+	.mmap = vb2_fop_mmap,
+	.poll =  vb2_fop_poll,
 };
 
 static int vpbe_device_get(struct device *dev, void *data)
@@ -1608,6 +1569,7 @@ static int register_device(struct vpbe_layer *vpbe_display_layer,
 		  (int)vpbe_display_layer,
 		  (int)&vpbe_display_layer->video_dev);
 
+	vpbe_display_layer->video_dev.queue = &vpbe_display_layer->buffer_queue;
 	err = video_register_device(&vpbe_display_layer->video_dev,
 				    VFL_TYPE_GRABBER,
 				    -1);
-- 
1.9.1

