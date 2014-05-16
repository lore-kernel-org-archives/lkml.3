Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbaEPNiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:17 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58814 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaEPNiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:13 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 09/49] media: davinci: vpif_display: use vb2_fop_mmap/poll
Date: Fri, 16 May 2014 19:03:14 +0530
Message-Id: <1400247235-31434-11-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   49 ++++---------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 933d28f..cea526b 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -646,44 +646,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 }
 
 /*
- * vpif_mmap: It is used to map kernel space buffers into user spaces
- */
-static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
-{
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
-/*
- * vpif_poll: It is used for select/poll system call
- */
-static unsigned int vpif_poll(struct file *filep, poll_table *wait)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	unsigned int res = 0;
-
-	if (common->started) {
-		mutex_lock(&common->lock);
-		res = vb2_poll(&common->buffer_queue, filep, wait);
-		mutex_unlock(&common->lock);
-	}
-
-	return res;
-}
-
-/*
  * vpif_open: It creates object of file handle structure and stores it in
  * private_data member of filepointer
  */
@@ -1463,8 +1425,8 @@ static const struct v4l2_file_operations vpif_fops = {
 	.open		= vpif_open,
 	.release	= vpif_release,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= vpif_mmap,
-	.poll		= vpif_poll
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll
 };
 
 static struct video_device vpif_video_template = {
@@ -1555,6 +1517,7 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 static int vpif_probe_complete(void)
 {
 	struct common_obj *common;
+	struct video_device *vdev;
 	struct channel_obj *ch;
 	struct vb2_queue *q;
 	int j, err, k;
@@ -1636,8 +1599,10 @@ static int vpif_probe_complete(void)
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
 			 (int)ch, (int)&ch->video_dev);
 
-		err = video_register_device(ch->video_dev,
-					  VFL_TYPE_GRABBER, (j ? 3 : 2));
+		vdev = ch->video_dev;
+		vdev->queue = q;
+		err = video_register_device(vdev, VFL_TYPE_GRABBER,
+					    (j ? 3 : 2));
 		if (err < 0)
 			goto probe_out;
 	}
-- 
1.7.9.5

