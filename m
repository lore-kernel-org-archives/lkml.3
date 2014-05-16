Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaEPNlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:12 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58091 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566AbaEPNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:08 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 26/49] media: davinci: vpif_capture: initalize vb2 queue and DMA context during probe
Date: Fri, 16 May 2014 19:03:31 +0530
Message-Id: <1400247235-31434-28-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |  110 ++++++++++++-------------
 1 file changed, 51 insertions(+), 59 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d09a27a..b035c88 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -71,6 +71,13 @@ static struct device *vpif_dev;
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
+static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
+
+static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct vpif_cap_buffer, vb);
+}
+
 /**
  * buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
@@ -81,10 +88,8 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode);
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *q = vb->vb2_queue;
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(q);
 	struct common_obj *common;
 	unsigned long addr;
 
@@ -131,9 +136,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long size;
 
@@ -183,11 +186,8 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct channel_obj *ch = fh->channel;
-	struct vpif_cap_buffer *buf = container_of(vb,
-				struct vpif_cap_buffer, vb);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -210,11 +210,8 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
  */
 static void vpif_buf_cleanup(struct vb2_buffer *vb)
 {
-	/* Get the file handle object and channel object */
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_cap_buffer *buf = container_of(vb,
-					struct vpif_cap_buffer, vb);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -229,8 +226,7 @@ static void vpif_buf_cleanup(struct vb2_buffer *vb)
 
 static void vpif_wait_prepare(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
@@ -239,8 +235,7 @@ static void vpif_wait_prepare(struct vb2_queue *vq)
 
 static void vpif_wait_finish(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
@@ -249,23 +244,18 @@ static void vpif_wait_finish(struct vb2_queue *vq)
 
 static int vpif_buffer_init(struct vb2_buffer *vb)
 {
-	struct vpif_cap_buffer *buf = container_of(vb,
-					struct vpif_cap_buffer, vb);
+	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
 
 	INIT_LIST_HEAD(&buf->list);
 
 	return 0;
 }
 
-static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] =
-	{ {1, 1} };
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_capture_config *vpif_config_data =
 					vpif_dev->platform_data;
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
 	unsigned long addr = 0;
@@ -348,8 +338,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 /* abort streaming and wait for last buffer */
 static void vpif_stop_streaming(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -951,13 +940,9 @@ static int vpif_release(struct file *filep)
 
 	mutex_lock(&common->lock);
 	/* if this instance is doing IO */
-	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
+	if (fh->io_allowed[VPIF_VIDEO_INDEX])
 		/* Reset io_usrs member of channel object */
 		common->io_usrs = 0;
-		/* Free buffers allocated */
-		vb2_queue_release(&common->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-	}
 
 	/* Decrement channel usrs counter */
 	ch->usrs--;
@@ -987,8 +972,6 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common;
 	u8 index = 0;
-	struct vb2_queue *q;
-	int ret;
 
 	vpif_dbg(2, debug, "vpif_reqbufs\n");
 
@@ -1014,35 +997,12 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	if (0 != common->io_usrs)
 		return -EBUSY;
 
-	/* Initialize videobuf2 queue as per the buffer type */
-	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-	if (IS_ERR(common->alloc_ctx)) {
-		vpif_err("Failed to get the context\n");
-		return PTR_ERR(common->alloc_ctx);
-	}
-	q = &common->buffer_queue;
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
-	q->drv_priv = fh;
-	q->ops = &video_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
-	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 1;
-
-	ret = vb2_queue_init(q);
-	if (ret) {
-		vpif_err("vpif_capture: vb2_queue_init() failed\n");
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
@@ -1998,6 +1958,7 @@ static int vpif_probe_complete(void)
 {
 	struct common_obj *common;
 	struct channel_obj *ch;
+	struct vb2_queue *q;
 	int i, j, err, k;
 
 	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
@@ -2016,6 +1977,32 @@ static int vpif_probe_complete(void)
 		if (err)
 			goto probe_out;
 
+		/* Initialize vb2 queue */
+		q = &common->buffer_queue;
+		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+		q->drv_priv = ch;
+		q->ops = &video_qops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		q->buf_struct_size = sizeof(struct vpif_cap_buffer);
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 1;
+
+		err = vb2_queue_init(q);
+		if (err) {
+			vpif_err("vpif_capture: vb2_queue_init() failed\n");
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
 		err = video_register_device(ch->video_dev,
 					    VFL_TYPE_GRABBER, (j ? 1 : 0));
 		if (err)
@@ -2029,6 +2016,8 @@ probe_out:
 	for (k = 0; k < j; k++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[k];
+		common = &ch->common[k];
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 	}
@@ -2207,6 +2196,7 @@ vpif_unregister:
  */
 static int vpif_remove(struct platform_device *device)
 {
+	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -2217,6 +2207,8 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
+		common = &ch->common[i];
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 		kfree(vpif_obj.dev[i]);
-- 
1.7.9.5

