Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbaEPNf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:57 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49423 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbaEPNfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:35:55 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 01/49] media: davinci: vpif_display: initalize vb2 queue and DMA context during probe
Date: Fri, 16 May 2014 19:03:05 +0530
Message-Id: <1400247235-31434-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch moves the initalization of vb2 queue and
the DMA context to probe() and clean up in remove()
callback respectively.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   86 ++++++++++++-------------
 1 file changed, 41 insertions(+), 45 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d03487f..dbd4f0f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -74,12 +74,12 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode);
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *q = vb->vb2_queue;
+	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
 	unsigned long addr;
 
-	common = &fh->channel->common[VPIF_VIDEO_INDEX];
+	common = &ch->common[VPIF_VIDEO_INDEX];
 	if (vb->state != VB2_BUF_STATE_ACTIVE &&
 		vb->state != VB2_BUF_STATE_PREPARED) {
 		vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
@@ -112,8 +112,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	unsigned long size;
 
@@ -154,10 +153,9 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpif_disp_buffer *buf = container_of(vb,
 				struct vpif_disp_buffer, vb);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -175,10 +173,9 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
  */
 static void vpif_buf_cleanup(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpif_disp_buffer *buf = container_of(vb,
 					struct vpif_disp_buffer, vb);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -192,8 +189,7 @@ static void vpif_buf_cleanup(struct vb2_buffer *vb)
 
 static void vpif_wait_prepare(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
@@ -202,8 +198,7 @@ static void vpif_wait_prepare(struct vb2_queue *vq)
 
 static void vpif_wait_finish(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
@@ -226,8 +221,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_display_config *vpif_config_data =
 					vpif_dev->platform_data;
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
 	unsigned long addr = 0;
@@ -310,8 +304,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 /* abort streaming and wait for last buffer */
 static void vpif_stop_streaming(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -794,10 +787,6 @@ static int vpif_release(struct file *filep)
 	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
 		/* Reset io_usrs member of channel object */
 		common->io_usrs = 0;
-		/* Free buffers allocated */
-		vb2_queue_release(&common->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-
 		common->numbuffers =
 		    config_params.numbuffers[ch->channel_id];
 	}
@@ -939,9 +928,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common;
 	enum v4l2_field field;
-	struct vb2_queue *q;
 	u8 index = 0;
-	int ret;
 
 	/* This file handle has not initialized the channel,
 	   It is not allowed to do settings */
@@ -973,35 +960,12 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	} else {
 		field = V4L2_VBI_INTERLACED;
 	}
-	/* Initialize videobuf2 queue as per the buffer type */
-	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-	if (IS_ERR(common->alloc_ctx)) {
-		vpif_err("Failed to get the context\n");
-		return PTR_ERR(common->alloc_ctx);
-	}
-	q = &common->buffer_queue;
-	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
-	q->drv_priv = fh;
-	q->ops = &video_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct vpif_disp_buffer);
-	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 1;
-
-	ret = vb2_queue_init(q);
-	if (ret) {
-		vpif_err("vpif_display: vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-		return ret;
-	}
 	/* Set io allowed member of file handle to TRUE */
 	fh->io_allowed[index] = 1;
 	/* Increment io usrs member of channel object to 1 */
 	common->io_usrs = 1;
 	/* Store type of memory requested in channel object */
 	common->memory = reqbuf->memory;
-	INIT_LIST_HEAD(&common->dma_queue);
 	/* Allocate buffers */
 	return vb2_reqbufs(&common->buffer_queue, reqbuf);
 }
@@ -1637,6 +1601,7 @@ static int vpif_probe_complete(void)
 {
 	struct common_obj *common;
 	struct channel_obj *ch;
+	struct vb2_queue *q;
 	int j, err, k;
 
 	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
@@ -1685,6 +1650,32 @@ static int vpif_probe_complete(void)
 		if (err)
 			goto probe_out;
 
+		/* Initialize vb2 queue */
+		q = &common->buffer_queue;
+		q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+		q->drv_priv = ch;
+		q->ops = &video_qops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		q->buf_struct_size = sizeof(struct vpif_disp_buffer);
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 1;
+
+		err = vb2_queue_init(q);
+		if (err) {
+			vpif_err("vpif_display: vb2_queue_init() failed\n");
+			goto probe_out;
+		}
+
+		common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
+		if (IS_ERR(common->alloc_ctx)) {
+			vpif_err("Failed to get the context\n");
+			err = PTR_ERR(common->alloc_ctx);
+			goto probe_out;
+		}
+
+		INIT_LIST_HEAD(&common->dma_queue);
+
 		/* register video device */
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
 			 (int)ch, (int)&ch->video_dev);
@@ -1700,6 +1691,8 @@ static int vpif_probe_complete(void)
 probe_out:
 	for (k = 0; k < j; k++) {
 		ch = vpif_obj.dev[k];
+		common = &ch->common[k];
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		video_unregister_device(ch->video_dev);
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
@@ -1865,6 +1858,7 @@ vpif_unregister:
  */
 static int vpif_remove(struct platform_device *device)
 {
+	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -1875,6 +1869,8 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
+		common = &ch->common[i];
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 
-- 
1.7.9.5

