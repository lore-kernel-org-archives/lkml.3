Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbaJVVmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:42:12 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46824 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbaJVVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:42:09 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS
Date: Wed, 22 Oct 2014 22:42:01 +0100
Message-Id: <1414014121-29908-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support for vidioc_create_bufs. Along side
remove unneeded member numbuffers.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Changes for v2:
 a: return -EINVAL in queue_setup() callback if sizeimage is
    less then current format size.
 b: removed unneeded member numbuffers.
 
 drivers/media/platform/davinci/vpbe_display.c | 10 +++++++---
 include/media/davinci/vpbe_display.h          |  2 --
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 3b60749..78b9ffe 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -244,12 +244,15 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_buffer_setup\n");
 
+	if (fmt && fmt->fmt.pix.sizeimage < layer->pix_fmt.sizeimage)
+		return -EINVAL;
+
 	/* Store number of buffers allocated in numbuffer member */
-	if (*nbuffers < VPBE_DEFAULT_NUM_BUFS)
-		*nbuffers = layer->numbuffers = VPBE_DEFAULT_NUM_BUFS;
+	if (vq->num_buffers + *nbuffers < VPBE_DEFAULT_NUM_BUFS)
+		*nbuffers = VPBE_DEFAULT_NUM_BUFS - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = layer->pix_fmt.sizeimage;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : layer->pix_fmt.sizeimage;
 	alloc_ctxs[0] = layer->alloc_ctx;
 
 	return 0;
@@ -1241,6 +1244,7 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
 	.vidioc_try_fmt_vid_out  = vpbe_display_try_fmt,
 
 	.vidioc_reqbufs		 = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs	 = vb2_ioctl_create_bufs,
 	.vidioc_querybuf	 = vb2_ioctl_querybuf,
 	.vidioc_qbuf		 = vb2_ioctl_qbuf,
 	.vidioc_dqbuf		 = vb2_ioctl_dqbuf,
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index 163a02b..fa0247a 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -70,8 +70,6 @@ struct vpbe_disp_buffer {
 
 /* vpbe display object structure */
 struct vpbe_layer {
-	/* number of buffers in fbuffers */
-	unsigned int numbuffers;
 	/* Pointer to the vpbe_display */
 	struct vpbe_display *disp_dev;
 	/* Pointer pointing to current v4l2_buffer */
-- 
1.9.1

