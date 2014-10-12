Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaJLUpN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:45:13 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33313 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbaJLUky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:54 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 01/15] media: davinci: vpbe: initialize vb2 queue and DMA context in probe
Date: Sun, 12 Oct 2014 21:40:31 +0100
Message-Id: <1413146445-7304-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch moves the initialization of vb2 queue and the DMA
context to probe() and clean up in remove() callback respectively.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 128 ++++++++++++--------------
 1 file changed, 60 insertions(+), 68 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 73496d9..ff9eac4 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -207,10 +207,9 @@ static irqreturn_t venc_isr(int irq, void *arg)
  */
 static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct vpbe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *q = vb->vb2_queue;
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = vb2_get_drv_priv(q);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	unsigned long addr;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -247,9 +246,8 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_buffer_setup\n");
 
@@ -271,12 +269,11 @@ vpbe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 static void vpbe_buffer_queue(struct vb2_buffer *vb)
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
 	struct vpbe_disp_buffer *buf = container_of(vb,
 				struct vpbe_disp_buffer, vb);
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_display *disp = fh->disp_dev;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpbe_display *disp = layer->disp_dev;
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	unsigned long flags;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
@@ -296,9 +293,8 @@ static void vpbe_buffer_queue(struct vb2_buffer *vb)
 static void vpbe_buf_cleanup(struct vb2_buffer *vb)
 {
 	/* Get the file handle object and layer object */
-	struct vpbe_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
+	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
 	struct vpbe_disp_buffer *buf = container_of(vb,
 					struct vpbe_disp_buffer, vb);
 	unsigned long flags;
@@ -314,16 +310,14 @@ static void vpbe_buf_cleanup(struct vb2_buffer *vb)
 
 static void vpbe_wait_prepare(struct vb2_queue *vq)
 {
-	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
-	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
 
 	mutex_unlock(&layer->opslock);
 }
 
 static void vpbe_wait_finish(struct vb2_queue *vq)
 {
-	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
-	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
 
 	mutex_lock(&layer->opslock);
 }
@@ -339,8 +333,7 @@ static int vpbe_buffer_init(struct vb2_buffer *vb)
 
 static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
-	struct vpbe_layer *layer = fh->layer;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
 	int ret;
 
 	/* Get the next frame from the buffer queue */
@@ -354,7 +347,7 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	layer->field_id = 0;
 
 	/* Set parameters in OSD and VENC */
-	ret = vpbe_set_osd_display_params(fh->disp_dev, layer);
+	ret = vpbe_set_osd_display_params(layer->disp_dev, layer);
 	if (ret < 0) {
 		struct vpbe_disp_buffer *buf, *tmp;
 
@@ -379,9 +372,8 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 static void vpbe_stop_streaming(struct vb2_queue *vq)
 {
-	struct vpbe_fh *fh = vb2_get_drv_priv(vq);
-	struct vpbe_layer *layer = fh->layer;
-	struct vpbe_display *disp = fh->disp_dev;
+	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
+	struct vpbe_display *disp = layer->disp_dev;
 	unsigned long flags;
 
 	if (!vb2_is_streaming(vq))
@@ -1380,8 +1372,7 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 	struct vpbe_fh *fh = file->private_data;
 	struct vpbe_layer *layer = fh->layer;
 	struct vpbe_device *vpbe_dev = fh->disp_dev->vpbe_dev;
-	struct vb2_queue *q;
-	int ret;
+
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_reqbufs\n");
 
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != req_buf->type) {
@@ -1394,39 +1385,14 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 		v4l2_err(&vpbe_dev->v4l2_dev, "not IO user\n");
 		return -EBUSY;
 	}
-	/* Initialize videobuf queue as per the buffer type */
-	layer->alloc_ctx = vb2_dma_contig_init_ctx(vpbe_dev->pdev);
-	if (IS_ERR(layer->alloc_ctx)) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to get the context\n");
-		return PTR_ERR(layer->alloc_ctx);
-	}
-	q = &layer->buffer_queue;
-	memset(q, 0, sizeof(*q));
-	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
-	q->drv_priv = fh;
-	q->ops = &video_qops;
-	q->mem_ops = &vb2_dma_contig_memops;
-	q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
-	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 1;
-
-	ret = vb2_queue_init(q);
-	if (ret) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "vb2_queue_init() failed\n");
-		vb2_dma_contig_cleanup_ctx(layer->alloc_ctx);
-		return ret;
-	}
 	/* Set io allowed member of file handle to TRUE */
 	fh->io_allowed = 1;
 	/* Increment io usrs member of layer object to 1 */
 	layer->io_usrs = 1;
 	/* Store type of memory requested in layer object */
 	layer->memory = req_buf->memory;
-	/* Initialize buffer queue */
-	INIT_LIST_HEAD(&layer->dma_queue);
 	/* Allocate buffers */
-	return vb2_reqbufs(q, req_buf);
+	return vb2_reqbufs(&layer->buffer_queue, req_buf);
 }
 
 /*
@@ -1551,9 +1517,6 @@ static int vpbe_display_release(struct file *file)
 		osd_device->ops.disable_layer(osd_device,
 				layer->layer_info.id);
 		layer->started = 0;
-		/* Free buffers allocated */
-		vb2_queue_release(&layer->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(&layer->buffer_queue);
 	}
 
 	/* Decrement layer usrs counter */
@@ -1724,9 +1687,10 @@ static int register_device(struct vpbe_layer *vpbe_display_layer,
  */
 static int vpbe_display_probe(struct platform_device *pdev)
 {
-	struct vpbe_layer *vpbe_display_layer;
 	struct vpbe_display *disp_dev;
+	struct v4l2_device *v4l2_dev;
 	struct resource *res = NULL;
+	struct vb2_queue *q;
 	int k;
 	int i;
 	int err;
@@ -1748,13 +1712,14 @@ static int vpbe_display_probe(struct platform_device *pdev)
 			vpbe_device_get);
 	if (err < 0)
 		return err;
+
+	v4l2_dev = &disp_dev->vpbe_dev->v4l2_dev;
 	/* Initialize the vpbe display controller */
 	if (NULL != disp_dev->vpbe_dev->ops.initialize) {
 		err = disp_dev->vpbe_dev->ops.initialize(&pdev->dev,
 							 disp_dev->vpbe_dev);
 		if (err) {
-			v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
-					"Error initing vpbe\n");
+			v4l2_err(v4l2_dev, "Error initing vpbe\n");
 			err = -ENOMEM;
 			goto probe_out;
 		}
@@ -1769,8 +1734,7 @@ static int vpbe_display_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
-		v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
-			 "Unable to get VENC interrupt resource\n");
+		v4l2_err(v4l2_dev, "Unable to get VENC interrupt resource\n");
 		err = -ENODEV;
 		goto probe_out;
 	}
@@ -1779,30 +1743,57 @@ static int vpbe_display_probe(struct platform_device *pdev)
 	err = devm_request_irq(&pdev->dev, irq, venc_isr, 0,
 			       VPBE_DISPLAY_DRIVER, disp_dev);
 	if (err) {
-		v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
-				"Unable to request interrupt\n");
+		v4l2_err(v4l2_dev, "VPBE IRQ request failed\n");
 		goto probe_out;
 	}
 
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
+		/* initialize vb2 queue */
+		q = &disp_dev->dev[i]->buffer_queue;
+		memset(q, 0, sizeof(*q));
+		q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->drv_priv = disp_dev->dev[i];
+		q->ops = &video_qops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 1;
+
+		err = vb2_queue_init(q);
+		if (err) {
+			v4l2_err(v4l2_dev, "vb2_queue_init() failed\n");
+			goto probe_out;
+		}
+
+		disp_dev->dev[i]->alloc_ctx =
+			vb2_dma_contig_init_ctx(disp_dev->vpbe_dev->pdev);
+		if (IS_ERR(disp_dev->dev[i]->alloc_ctx)) {
+			v4l2_err(v4l2_dev, "Failed to get the context\n");
+			err = PTR_ERR(disp_dev->dev[i]->alloc_ctx);
+			goto probe_out;
+		}
+
+		INIT_LIST_HEAD(&disp_dev->dev[i]->dma_queue);
+
 		if (register_device(disp_dev->dev[i], disp_dev, pdev)) {
 			err = -ENODEV;
 			goto probe_out;
 		}
 	}
 
-	printk(KERN_DEBUG "Successfully completed the probing of vpbe v4l2 device\n");
+	v4l2_dbg(1, debug, v4l2_dev,
+		 "Successfully completed the probing of vpbe v4l2 device\n");
+
 	return 0;
 
 probe_out:
 	for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
-		/* Get the pointer to the layer object */
-		vpbe_display_layer = disp_dev->dev[k];
 		/* Unregister video device */
-		if (vpbe_display_layer) {
-			video_unregister_device(
-				&vpbe_display_layer->video_dev);
-				kfree(disp_dev->dev[k]);
+		if (disp_dev->dev[k] != NULL) {
+			vb2_dma_contig_cleanup_ctx(disp_dev->dev[k]->alloc_ctx);
+			video_unregister_device(&disp_dev->dev[k]->video_dev);
+			kfree(disp_dev->dev[k]);
 		}
 	}
 	return err;
@@ -1828,6 +1819,7 @@ static int vpbe_display_remove(struct platform_device *pdev)
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the layer object */
 		vpbe_display_layer = disp_dev->dev[i];
+		vb2_dma_contig_cleanup_ctx(vpbe_display_layer->alloc_ctx);
 		/* Unregister video device */
 		video_unregister_device(&vpbe_display_layer->video_dev);
 
-- 
1.9.1

