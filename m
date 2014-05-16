Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355AbaEPNl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:57 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46790 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaEPNlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:53 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 34/49] media: davinci: vpif_capture: use vb2_fop_mmap/poll
Date: Fri, 16 May 2014 19:03:40 +0530
Message-Id: <1400247235-31434-37-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   53 +++----------------------
 1 file changed, 6 insertions(+), 47 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 58dddf6..a50e392 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -751,50 +751,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 }
 
 /**
- * vpif_mmap : It is used to map kernel space buffers into user spaces
- * @filep: file pointer
- * @vma: ptr to vm_area_struct
- */
-static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
-{
-	/* Get the channel object and file handle object */
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
-	int ret;
-
-	vpif_dbg(2, debug, "vpif_mmap\n");
-
-	if (mutex_lock_interruptible(&common->lock))
-		return -ERESTARTSYS;
-	ret = vb2_mmap(&common->buffer_queue, vma);
-	mutex_unlock(&common->lock);
-	return ret;
-}
-
-/**
- * vpif_poll: It is used for select/poll system call
- * @filep: file pointer
- * @wait: poll table to wait
- */
-static unsigned int vpif_poll(struct file *filep, poll_table * wait)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *channel = fh->channel;
-	struct common_obj *common = &(channel->common[VPIF_VIDEO_INDEX]);
-	unsigned int res = 0;
-
-	vpif_dbg(2, debug, "vpif_poll\n");
-
-	if (common->started) {
-		mutex_lock(&common->lock);
-		res = vb2_poll(&common->buffer_queue, filep, wait);
-		mutex_unlock(&common->lock);
-	}
-	return res;
-}
-
-/**
  * vpif_open : vpif open handler
  * @filep: file ptr
  *
@@ -1797,8 +1753,8 @@ static struct v4l2_file_operations vpif_fops = {
 	.open = vpif_open,
 	.release = vpif_release,
 	.unlocked_ioctl = video_ioctl2,
-	.mmap = vpif_mmap,
-	.poll = vpif_poll
+	.mmap = vb2_fop_mmap,
+	.poll = vb2_fop_poll
 };
 
 /* vpif video template */
@@ -1884,6 +1840,7 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 static int vpif_probe_complete(void)
 {
 	struct common_obj *common;
+	struct video_device *vdev;
 	struct channel_obj *ch;
 	struct vb2_queue *q;
 	int i, j, err, k;
@@ -1931,7 +1888,9 @@ static int vpif_probe_complete(void)
 
 		INIT_LIST_HEAD(&common->dma_queue);
 
-		err = video_register_device(ch->video_dev,
+		vdev = ch->video_dev;
+		vdev->queue = q;
+		err = video_register_device(vdev,
 					    VFL_TYPE_GRABBER, (j ? 1 : 0));
 		if (err)
 			goto probe_out;
-- 
1.7.9.5

