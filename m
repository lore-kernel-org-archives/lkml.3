Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaCaOxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:53:20 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33853 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaCaOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:53:17 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: davinci: vpif display: upgrade the driver with v4l offerings
Date: Mon, 31 Mar 2014 20:22:52 +0530
Message-Id: <1396277573-9513-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396277573-9513-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1396277573-9513-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch upgrades the vpif display driver with
v4l helpers, this patch does the following,

1: initialize the vb2 queue and context at the time of probe
and removes context at remove() callback.
2: uses vb2_ioctl_*() helpers.
3: uses vb2_fop_*() helpers.
4: uses SIMPLE_DEV_PM_OPS.
5: uses vb2_ioctl_*() helpers.
6: vidioc_g/s_priority is now handled by v4l core.
7: removed driver specific fh and now using one provided by v4l.
8: fixes checkpatch warnings.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |  788 +++++++------------------
 drivers/media/platform/davinci/vpif_display.h |   31 +-
 2 files changed, 217 insertions(+), 602 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index aed41ed..bfbe73e 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -2,7 +2,7 @@
  * vpif-display - VPIF display driver
  * Display driver for TI DaVinci VPIF
  *
- * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ * Copyright (C) 2009-2014 Texas Instruments Incorporated - http://www.ti.com/
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -12,6 +12,9 @@
  * kind, whether express or implied; without even the implied warranty
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
+ *
+ * Contributors:
+ *      Lad, Prabhakar <prabhakar.csengg@gmail.com>
  */
 
 #include <linux/interrupt.h>
@@ -34,6 +37,8 @@ MODULE_VERSION(VPIF_DISPLAY_VERSION);
 #define vpif_dbg(level, debug, fmt, arg...)	\
 		v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
 
+#define VPIF_DRIVER_NAME	"vpif_display"
+
 static int debug = 1;
 static u32 ch2_numbuffers = 3;
 static u32 ch3_numbuffers = 3;
@@ -64,9 +69,16 @@ static struct vpif_config_params config_params = {
 
 static struct vpif_device vpif_obj = { {NULL} };
 static struct device *vpif_dev;
+static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
+
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
+static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct vpif_disp_buffer, vb);
+}
+
 /*
  * buffer_prepare: This is the callback function called from vb2_qbuf()
  * function the buffer is prepared and user space virtual address is converted
@@ -74,12 +86,12 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode);
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
@@ -88,7 +100,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 			goto buf_align_exit;
 
 		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
-		if (q->streaming &&
+		if (vb2_is_streaming(q) &&
 			(V4L2_BUF_TYPE_SLICED_VBI_OUTPUT != q->type)) {
 			if (!ISALIGNED(addr + common->ytop_off) ||
 			!ISALIGNED(addr + common->ybtm_off) ||
@@ -112,12 +124,11 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				unsigned int *nbuffers, unsigned int *nplanes,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	unsigned long size;
 
-	if (V4L2_MEMORY_MMAP == common->memory) {
+	if (vq->memory == V4L2_MEMORY_MMAP) {
 		size = config_params.channel_bufsize[ch->channel_id];
 		/*
 		* Checking if the buffer size exceeds the available buffer
@@ -154,15 +165,12 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_disp_buffer *buf = container_of(vb,
-				struct vpif_disp_buffer, vb);
-	struct channel_obj *ch = fh->channel;
+	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
-
 	/* add the buffer to the DMA queue */
 	spin_lock_irqsave(&common->irqlock, flags);
 	list_add_tail(&buf->list, &common->dma_queue);
@@ -175,10 +183,8 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
  */
 static void vpif_buf_cleanup(struct vb2_buffer *vb)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
-	struct vpif_disp_buffer *buf = container_of(vb,
-					struct vpif_disp_buffer, vb);
-	struct channel_obj *ch = fh->channel;
+	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
 
@@ -190,66 +196,30 @@ static void vpif_buf_cleanup(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-static void vpif_wait_prepare(struct vb2_queue *vq)
-{
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-	mutex_unlock(&common->lock);
-}
-
-static void vpif_wait_finish(struct vb2_queue *vq)
-{
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-
-	common = &ch->common[VPIF_VIDEO_INDEX];
-	mutex_lock(&common->lock);
-}
-
 static int vpif_buffer_init(struct vb2_buffer *vb)
 {
-	struct vpif_disp_buffer *buf = container_of(vb,
-					struct vpif_disp_buffer, vb);
+	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
 
 	INIT_LIST_HEAD(&buf->list);
 
 	return 0;
 }
 
-static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
-
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct vpif_display_config *vpif_config_data =
-					vpif_dev->platform_data;
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct vpif_display_config *vpif_config_data;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
-	unsigned long addr = 0;
-	unsigned long flags;
+	struct vpif_disp_buffer *buf, *tmp;
+	unsigned long addr, flags;
 	int ret;
 
 	spin_lock_irqsave(&common->irqlock, flags);
 
-	/* Get the next frame from the buffer queue */
-	common->next_frm = common->cur_frm =
-			    list_entry(common->dma_queue.next,
-				       struct vpif_disp_buffer, list);
-
-	list_del(&common->cur_frm->list);
-	spin_unlock_irqrestore(&common->irqlock, flags);
-	/* Mark state of the current frame to active */
-	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
-
-	/* Initialize field_id and started member */
+	/* Initialize field_id */
 	ch->field_id = 0;
-	common->started = 1;
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+
 	/* Calculate the offset for Y and C data  in the buffer */
 	vpif_calculate_offsets(ch);
 
@@ -259,33 +229,49 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		|| (!ch->vpifparams.std_info.frm_fmt
 		&& (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
 		vpif_err("conflict in field format and std format\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
+	vpif_config_data = vpif_dev->platform_data;
 	/* clock settings */
 	if (vpif_config_data->set_clock) {
 		ret = vpif_config_data->set_clock(ch->vpifparams.std_info.
 		ycmux_mode, ch->vpifparams.std_info.hd_sd);
 		if (ret < 0) {
 			vpif_err("can't set clock\n");
-			return ret;
+			goto err;
 		}
 	}
 
 	/* set the parameters and addresses */
 	ret = vpif_set_video_params(vpif, ch->channel_id + 2);
 	if (ret < 0)
-		return ret;
+		goto err;
 
-	common->started = ret;
 	vpif_config_addr(ch, ret);
+
+	/* Get the next frame from the buffer queue */
+	common->next_frm = common->cur_frm =
+			    list_entry(common->dma_queue.next,
+				       struct vpif_disp_buffer, list);
+
+	list_del(&common->cur_frm->list);
+	spin_unlock_irqrestore(&common->irqlock, flags);
+	/* Mark state of the current frame to active */
+	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+
 	common->set_addr((addr + common->ytop_off),
 			    (addr + common->ybtm_off),
 			    (addr + common->ctop_off),
 			    (addr + common->cbtm_off));
 
-	/* Set interrupt for both the fields in VPIF
-	    Register enable channel in VPIF register */
+	/*
+	 * Set interrupt for both the fields in VPIF
+	 * Register enable channel in VPIF register
+	 */
 	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
 	if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
 		channel2_intr_assert();
@@ -295,8 +281,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 			channel2_clipping_enable(1);
 	}
 
-	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id)
-		|| (common->started == 2)) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id) {
 		channel3_intr_assert();
 		channel3_intr_enable(1);
 		enable_channel3(1);
@@ -305,19 +290,23 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	return 0;
+
+err:
+	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+
+	return ret;
 }
 
 /* abort streaming and wait for last buffer */
 static int vpif_stop_streaming(struct vb2_queue *vq)
 {
-	struct vpif_fh *fh = vb2_get_drv_priv(vq);
-	struct channel_obj *ch = fh->channel;
+	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long flags;
 
-	if (!vb2_is_streaming(vq))
-		return 0;
-
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Disable channel */
@@ -325,12 +314,10 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 		enable_channel2(0);
 		channel2_intr_enable(0);
 	}
-	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-		(2 == common->started)) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id) {
 		enable_channel3(0);
 		channel3_intr_enable(0);
 	}
-	common->started = 0;
 
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
@@ -358,8 +345,8 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
-	.wait_prepare		= vpif_wait_prepare,
-	.wait_finish		= vpif_wait_finish,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 	.buf_init		= vpif_buffer_init,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
@@ -370,7 +357,7 @@ static struct vb2_ops video_qops = {
 
 static void process_progressive_mode(struct common_obj *common)
 {
-	unsigned long addr = 0;
+	unsigned long addr;
 
 	spin_lock(&common->irqlock);
 	/* Get the next buffer from buffer queue */
@@ -445,10 +432,11 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	field = ch->common[VPIF_VIDEO_INDEX].fmt.fmt.pix.field;
 	for (i = 0; i < VPIF_NUMOBJECTS; i++) {
 		common = &ch->common[i];
-		/* If streaming is started in this channel */
-		if (0 == common->started)
+
+		if (!vb2_is_streaming(&common->buffer_queue))
 			continue;
 
+		/* If streaming is started in this channel */
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
 			spin_lock(&common->irqlock);
 			if (list_empty(&common->dma_queue)) {
@@ -626,11 +614,6 @@ static void vpif_config_format(struct channel_obj *ch)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
-	if (config_params.numbuffers[ch->channel_id] == 0)
-		common->memory = V4L2_MEMORY_USERPTR;
-	else
-		common->memory = V4L2_MEMORY_MMAP;
-
 	common->fmt.fmt.pix.sizeimage =
 			config_params.channel_bufsize[ch->channel_id];
 	common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
@@ -699,127 +682,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
 	}
 }
 
-/*
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
- * vpif_open: It creates object of file handle structure and stores it in
- * private_data member of filepointer
- */
-static int vpif_open(struct file *filep)
-{
-	struct video_device *vdev = video_devdata(filep);
-	struct channel_obj *ch = video_get_drvdata(vdev);
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_fh *fh;
-
-	/* Allocate memory for the file handle object */
-	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
-	if (fh == NULL) {
-		vpif_err("unable to allocate memory for file handle object\n");
-		return -ENOMEM;
-	}
-
-	if (mutex_lock_interruptible(&common->lock)) {
-		kfree(fh);
-		return -ERESTARTSYS;
-	}
-	/* store pointer to fh in private_data member of filep */
-	filep->private_data = fh;
-	fh->channel = ch;
-	fh->initialized = 0;
-	if (!ch->initialized) {
-		fh->initialized = 1;
-		ch->initialized = 1;
-		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
-	}
-
-	/* Increment channel usrs counter */
-	atomic_inc(&ch->usrs);
-	/* Set io_allowed[VPIF_VIDEO_INDEX] member to false */
-	fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&ch->prio, &fh->prio);
-	mutex_unlock(&common->lock);
-
-	return 0;
-}
-
-/*
- * vpif_release: This function deletes buffer queue, frees the buffers and
- * the vpif file handle
- */
-static int vpif_release(struct file *filep)
-{
-	struct vpif_fh *fh = filep->private_data;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	mutex_lock(&common->lock);
-	/* if this instance is doing IO */
-	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		/* Reset io_usrs member of channel object */
-		common->io_usrs = 0;
-		/* Free buffers allocated */
-		vb2_queue_release(&common->buffer_queue);
-		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
-
-		common->numbuffers =
-		    config_params.numbuffers[ch->channel_id];
-	}
-
-	/* Decrement channel usrs counter */
-	atomic_dec(&ch->usrs);
-	/* If this file handle has initialize encoder device, reset it */
-	if (fh->initialized)
-		ch->initialized = 0;
-
-	/* Close the priority */
-	v4l2_prio_close(&ch->prio, fh->prio);
-	filep->private_data = NULL;
-	fh->initialized = 0;
-	mutex_unlock(&common->lock);
-	kfree(fh);
-
-	return 0;
-}
-
 /* functions implementing ioctls */
 /**
  * vpif_querycap() - QUERYCAP handler
@@ -834,7 +696,7 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
+	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpif_dev));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
@@ -861,8 +723,8 @@ static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
 static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Check the validity of the buffer type */
@@ -878,28 +740,14 @@ static int vpif_g_fmt_vid_out(struct file *file, void *priv,
 static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct v4l2_pix_format *pixfmt;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	int ret = 0;
-
-	if ((VPIF_CHANNEL2_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL3_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_dbg(1, debug, "Channel Busy\n");
-			return -EBUSY;
-		}
-
-		/* Check for the priority */
-		ret = v4l2_prio_check(&ch->prio, fh->prio);
-		if (0 != ret)
-			return ret;
-		fh->initialized = 1;
-	}
+	struct v4l2_pix_format *pixfmt;
+	int ret;
 
-	if (common->started) {
-		vpif_dbg(1, debug, "Streaming in progress\n");
+	if (vb2_is_streaming(&common->buffer_queue)) {
+		vpif_err("Streaming in progress\n");
 		return -EBUSY;
 	}
 
@@ -919,8 +767,8 @@ static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *fmt)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 	int ret = 0;
@@ -934,131 +782,18 @@ static int vpif_try_fmt_vid_out(struct file *file, void *priv,
 	return ret;
 }
 
-static int vpif_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *reqbuf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common;
-	enum v4l2_field field;
-	struct vb2_queue *q;
-	u8 index = 0;
-	int ret;
-
-	/* This file handle has not initialized the channel,
-	   It is not allowed to do settings */
-	if ((VPIF_CHANNEL2_VIDEO == ch->channel_id)
-	    || (VPIF_CHANNEL3_VIDEO == ch->channel_id)) {
-		if (!fh->initialized) {
-			vpif_err("Channel Busy\n");
-			return -EBUSY;
-		}
-	}
-
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != reqbuf->type)
-		return -EINVAL;
-
-	index = VPIF_VIDEO_INDEX;
-
-	common = &ch->common[index];
-
-	if (common->fmt.type != reqbuf->type || !vpif_dev)
-		return -EINVAL;
-	if (0 != common->io_usrs)
-		return -EBUSY;
-
-	if (reqbuf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (common->fmt.fmt.pix.field == V4L2_FIELD_ANY)
-			field = V4L2_FIELD_INTERLACED;
-		else
-			field = common->fmt.fmt.pix.field;
-	} else {
-		field = V4L2_VBI_INTERLACED;
-	}
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
-	/* Set io allowed member of file handle to TRUE */
-	fh->io_allowed[index] = 1;
-	/* Increment io usrs member of channel object to 1 */
-	common->io_usrs = 1;
-	/* Store type of memory requested in channel object */
-	common->memory = reqbuf->memory;
-	INIT_LIST_HEAD(&common->dma_queue);
-	/* Allocate buffers */
-	return vb2_reqbufs(&common->buffer_queue, reqbuf);
-}
-
-static int vpif_querybuf(struct file *file, void *priv,
-				struct v4l2_buffer *tbuf)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	if (common->fmt.type != tbuf->type)
-		return -EINVAL;
-
-	return vb2_querybuf(&common->buffer_queue, tbuf);
-}
-
-static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct vpif_fh *fh = NULL;
-	struct channel_obj *ch = NULL;
-	struct common_obj *common = NULL;
-
-	if (!buf || !priv)
-		return -EINVAL;
-
-	fh = priv;
-	ch = fh->channel;
-	if (!ch)
-		return -EINVAL;
-
-	common = &(ch->common[VPIF_VIDEO_INDEX]);
-	if (common->fmt.type != buf->type)
-		return -EINVAL;
-
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
-	return vb2_qbuf(&common->buffer_queue, buf);
-}
-
 static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
 	if (!(std_id & VPIF_V4L2_STD))
 		return -EINVAL;
 
-	if (common->started) {
-		vpif_err("streaming in progress\n");
+	if (vb2_is_streaming(&common->buffer_queue)) {
+		vpif_err("Streaming in progress\n");
 		return -EBUSY;
 	}
 
@@ -1096,123 +831,18 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*std = ch->video.stdid;
 	return 0;
 }
 
-static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-
-	return vb2_dqbuf(&common->buffer_queue, p,
-					(file->f_flags & O_NONBLOCK));
-}
-
-static int vpif_streamon(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
-	int ret = 0;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		vpif_err("buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
-	/* If Streaming is already started, return error */
-	if (common->started) {
-		vpif_err("channel->started\n");
-		return -EBUSY;
-	}
-
-	if ((ch->channel_id == VPIF_CHANNEL2_VIDEO
-		&& oth_ch->common[VPIF_VIDEO_INDEX].started &&
-		ch->vpifparams.std_info.ycmux_mode == 0)
-		|| ((ch->channel_id == VPIF_CHANNEL3_VIDEO)
-		&& (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
-		vpif_err("other channel is using\n");
-		return -EBUSY;
-	}
-
-	ret = vpif_check_format(ch, &common->fmt.fmt.pix);
-	if (ret < 0)
-		return ret;
-
-	/* Call vb2_streamon to start streaming in videobuf2 */
-	ret = vb2_streamon(&common->buffer_queue, buftype);
-	if (ret < 0) {
-		vpif_err("vb2_streamon\n");
-		return ret;
-	}
-
-	return ret;
-}
-
-static int vpif_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buftype)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_display_config *vpif_config_data =
-					vpif_dev->platform_data;
-
-	if (buftype != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		vpif_err("buffer type not supported\n");
-		return -EINVAL;
-	}
-
-	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
-		vpif_err("fh->io_allowed\n");
-		return -EACCES;
-	}
-
-	if (!common->started) {
-		vpif_err("channel->started\n");
-		return -EINVAL;
-	}
-
-	if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		/* disable channel */
-		if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
-			if (vpif_config_data->
-				chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
-				channel2_clipping_enable(0);
-			enable_channel2(0);
-			channel2_intr_enable(0);
-		}
-		if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-					(2 == common->started)) {
-			if (vpif_config_data->
-				chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
-				channel3_clipping_enable(0);
-			enable_channel3(0);
-			channel3_intr_enable(0);
-		}
-	}
-
-	common->started = 0;
-	return vb2_streamoff(&common->buffer_queue, buftype);
-}
-
 static int vpif_cropcap(struct file *file, void *priv,
 			struct v4l2_cropcap *crop)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != crop->type)
 		return -EINVAL;
@@ -1231,8 +861,8 @@ static int vpif_enum_output(struct file *file, void *fh,
 
 	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct vpif_display_chan_config *chan_cfg;
-	struct vpif_fh *vpif_handler = fh;
-	struct channel_obj *ch = vpif_handler->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 	if (output->index >= chan_cfg->output_count) {
@@ -1327,8 +957,8 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 {
 	struct vpif_display_config *config = vpif_dev->platform_data;
 	struct vpif_display_chan_config *chan_cfg;
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
 	chan_cfg = &config->chan_config[ch->channel_id];
@@ -1336,7 +966,7 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	if (i >= chan_cfg->output_count)
 		return -EINVAL;
 
-	if (common->started) {
+	if (vb2_is_streaming(&common->buffer_queue)) {
 		vpif_err("Streaming in progress\n");
 		return -EBUSY;
 	}
@@ -1346,32 +976,14 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 
 static int vpif_g_output(struct file *file, void *priv, unsigned int *i)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 
 	*i = ch->output_idx;
 
 	return 0;
 }
 
-static int vpif_g_priority(struct file *file, void *priv, enum v4l2_priority *p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	*p = v4l2_prio_max(&ch->prio);
-
-	return 0;
-}
-
-static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
-{
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
-
-	return v4l2_prio_change(&ch->prio, &fh->prio, p);
-}
-
 /**
  * vpif_enum_dv_timings() - ENUM_DV_TIMINGS handler
  * @file: file ptr
@@ -1382,8 +994,8 @@ static int
 vpif_enum_dv_timings(struct file *file, void *priv,
 		     struct v4l2_enum_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	int ret;
 
 	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
@@ -1401,14 +1013,18 @@ vpif_enum_dv_timings(struct file *file, void *priv,
 static int vpif_s_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
+	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpifparams = &ch->vpifparams;
 	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
 	struct video_obj *vid_ch = &ch->video;
 	struct v4l2_bt_timings *bt = &vid_ch->dv_timings.bt;
 	int ret;
 
+	if (vb2_is_streaming(&common->buffer_queue))
+		return -EBUSY;
+
 	if (timings->type != V4L2_DV_BT_656_1120) {
 		vpif_dbg(2, debug, "Timing type not defined\n");
 		return -EINVAL;
@@ -1490,8 +1106,8 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 static int vpif_g_dv_timings(struct file *file, void *priv,
 		struct v4l2_dv_timings *timings)
 {
-	struct vpif_fh *fh = priv;
-	struct channel_obj *ch = fh->channel;
+	struct video_device *vdev = video_devdata(file);
+	struct channel_obj *ch = video_get_drvdata(vdev);
 	struct video_obj *vid_ch = &ch->video;
 
 	*timings = vid_ch->dv_timings;
@@ -1516,47 +1132,45 @@ static int vpif_log_status(struct file *filep, void *priv)
 
 /* vpif display ioctl operations */
 static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
-	.vidioc_querycap        	= vpif_querycap,
-	.vidioc_g_priority		= vpif_g_priority,
-	.vidioc_s_priority		= vpif_s_priority,
+	.vidioc_querycap		= vpif_querycap,
 	.vidioc_enum_fmt_vid_out	= vpif_enum_fmt_vid_out,
-	.vidioc_g_fmt_vid_out  		= vpif_g_fmt_vid_out,
-	.vidioc_s_fmt_vid_out   	= vpif_s_fmt_vid_out,
-	.vidioc_try_fmt_vid_out 	= vpif_try_fmt_vid_out,
-	.vidioc_reqbufs         	= vpif_reqbufs,
-	.vidioc_querybuf        	= vpif_querybuf,
-	.vidioc_qbuf            	= vpif_qbuf,
-	.vidioc_dqbuf           	= vpif_dqbuf,
-	.vidioc_streamon        	= vpif_streamon,
-	.vidioc_streamoff       	= vpif_streamoff,
-	.vidioc_s_std           	= vpif_s_std,
+	.vidioc_g_fmt_vid_out		= vpif_g_fmt_vid_out,
+	.vidioc_s_fmt_vid_out		= vpif_s_fmt_vid_out,
+	.vidioc_try_fmt_vid_out		= vpif_try_fmt_vid_out,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_s_std			= vpif_s_std,
 	.vidioc_g_std			= vpif_g_std,
+
 	.vidioc_enum_output		= vpif_enum_output,
 	.vidioc_s_output		= vpif_s_output,
 	.vidioc_g_output		= vpif_g_output,
-	.vidioc_cropcap         	= vpif_cropcap,
-	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
-	.vidioc_s_dv_timings            = vpif_s_dv_timings,
-	.vidioc_g_dv_timings            = vpif_g_dv_timings,
+	.vidioc_cropcap			= vpif_cropcap,
+
+	.vidioc_enum_dv_timings		= vpif_enum_dv_timings,
+	.vidioc_s_dv_timings		= vpif_s_dv_timings,
+	.vidioc_g_dv_timings		= vpif_g_dv_timings,
+
 	.vidioc_log_status		= vpif_log_status,
 };
 
 static const struct v4l2_file_operations vpif_fops = {
 	.owner		= THIS_MODULE,
-	.open		= vpif_open,
-	.release	= vpif_release,
+	.open		= v4l2_fh_open,
+	.release	= vb2_fop_release,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= vpif_mmap,
-	.poll		= vpif_poll
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll,
 };
 
-static struct video_device vpif_video_template = {
-	.name		= "vpif",
-	.fops		= &vpif_fops,
-	.ioctl_ops	= &vpif_ioctl_ops,
-};
-
-/*Configure the channels, buffer sizei, request irq */
+/* Configure the channels, buffer size */
 static int initialize_vpif(void)
 {
 	int free_channel_objects_index;
@@ -1638,18 +1252,17 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 static int vpif_probe_complete(void)
 {
 	struct common_obj *common;
+	struct video_device *vdev;
 	struct channel_obj *ch;
+	struct vb2_queue *q;
 	int j, err, k;
 
 	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
 		/* Initialize field of the channel objects */
-		atomic_set(&ch->usrs, 0);
 		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
 			ch->common[k].numbuffers = 0;
 			common = &ch->common[k];
-			common->io_usrs = 0;
-			common->started = 0;
 			spin_lock_init(&common->irqlock);
 			mutex_init(&common->lock);
 			common->numbuffers = 0;
@@ -1663,9 +1276,10 @@ static int vpif_probe_complete(void)
 			memset(&common->fmt, 0, sizeof(common->fmt));
 			common->numbuffers = config_params.numbuffers[k];
 		}
-		ch->initialized = 0;
+
 		if (vpif_obj.config->subdev_count)
 			ch->sd = vpif_obj.sd[0];
+
 		ch->channel_id = j;
 		if (j < 2)
 			ch->common[VPIF_VIDEO_INDEX].numbuffers =
@@ -1675,26 +1289,64 @@ static int vpif_probe_complete(void)
 
 		memset(&ch->vpifparams, 0, sizeof(ch->vpifparams));
 
-		/* Initialize prio member of channel object */
-		v4l2_prio_init(&ch->prio);
 		ch->common[VPIF_VIDEO_INDEX].fmt.type =
 						V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		ch->video_dev->lock = &common->lock;
-		video_set_drvdata(ch->video_dev, ch);
 
 		/* select output 0 */
 		err = vpif_set_output(vpif_obj.config, ch, 0);
 		if (err)
 			goto probe_out;
 
+		/* Initialize vb2 queue */
+		q = &common->buffer_queue;
+		q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		q->io_modes = VB2_MMAP | VB2_USERPTR;
+		q->drv_priv = ch;
+		q->ops = &video_qops;
+		q->mem_ops = &vb2_dma_contig_memops;
+		q->buf_struct_size = sizeof(struct vpif_disp_buffer);
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 3;
+		q->lock = &common->lock;
+		q->gfp_flags = GFP_DMA32;
+
+		err = vb2_queue_init(q);
+		if (err) {
+			vpif_err("vpif_display: vb2_queue_init() failed\n");
+			vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
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
+		/* Initialize the video_device structure */
+		vdev = ch->video_dev;
+		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
+		vdev->release = video_device_release;
+		vdev->fops = &vpif_fops;
+		vdev->ioctl_ops = &vpif_ioctl_ops;
+		vdev->lock = &common->lock;
+		vdev->queue = q;
+		vdev->v4l2_dev = &vpif_obj.v4l2_dev;
+		vdev->vfl_dir = VFL_DIR_TX;
+		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
+		video_set_drvdata(vdev, ch);
+
 		/* register video device */
+		err = video_register_device(vdev,
+					    VFL_TYPE_GRABBER, (j ? 3 : 2));
+		if (err < 0)
+			goto probe_out;
 		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
 			 (int)ch, (int)&ch->video_dev);
 
-		err = video_register_device(ch->video_dev,
-					  VFL_TYPE_GRABBER, (j ? 3 : 2));
-		if (err < 0)
-			goto probe_out;
 	}
 
 	return 0;
@@ -1702,6 +1354,9 @@ static int vpif_probe_complete(void)
 probe_out:
 	for (k = 0; k < j; k++) {
 		ch = vpif_obj.dev[k];
+		common = &ch->common[k];
+
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		video_unregister_device(ch->video_dev);
 		video_device_release(ch->video_dev);
 		ch->video_dev = NULL;
@@ -1746,7 +1401,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
-					IRQF_SHARED, "VPIF_Display",
+					IRQF_SHARED, VPIF_DRIVER_NAME,
 					(void *)(&vpif_obj.dev[res_idx]->
 					channel_id));
 		if (err) {
@@ -1772,15 +1427,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 			goto vpif_unregister;
 		}
 
-		/* Initialize field of video device */
-		*vfd = vpif_video_template;
-		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
-		vfd->release = video_device_release;
-		vfd->vfl_dir = VFL_DIR_TX;
-		snprintf(vfd->name, sizeof(vfd->name),
-			 "VPIF_Display_DRIVER_V%s",
-			 VPIF_DISPLAY_VERSION);
-
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
 	}
@@ -1867,6 +1513,7 @@ vpif_unregister:
  */
 static int vpif_remove(struct platform_device *device)
 {
+	struct common_obj *common;
 	struct channel_obj *ch;
 	int i;
 
@@ -1877,9 +1524,11 @@ static int vpif_remove(struct platform_device *device)
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
+		common = &ch->common[i];
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
 
+		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
 		ch->video_dev = NULL;
 		kfree(vpif_obj.dev[i]);
 	}
@@ -1887,7 +1536,7 @@ static int vpif_remove(struct platform_device *device)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int vpif_suspend(struct device *dev)
 {
 	struct common_obj *common;
@@ -1898,18 +1547,19 @@ static int vpif_suspend(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (atomic_read(&ch->usrs) && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
-				enable_channel2(0);
-				channel2_intr_enable(0);
-			}
-			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					common->started == 2) {
-				enable_channel3(0);
-				channel3_intr_enable(0);
-			}
+		/* Disable channel */
+		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
+			enable_channel2(0);
+			channel2_intr_enable(0);
+		}
+		if (ch->channel_id == VPIF_CHANNEL3_VIDEO) {
+			enable_channel3(0);
+			channel3_intr_enable(0);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -1928,40 +1578,34 @@ static int vpif_resume(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (atomic_read(&ch->usrs) && common->io_usrs) {
-			/* Enable channel */
-			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
-				enable_channel2(1);
-				channel2_intr_enable(1);
-			}
-			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					common->started == 2) {
-				enable_channel3(1);
-				channel3_intr_enable(1);
-			}
+		/* Enable channel */
+		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
+			enable_channel2(1);
+			channel2_intr_enable(1);
+		}
+		if (ch->channel_id == VPIF_CHANNEL3_VIDEO) {
+			enable_channel3(1);
+			channel3_intr_enable(1);
 		}
 		mutex_unlock(&common->lock);
 	}
 
 	return 0;
 }
-
-static const struct dev_pm_ops vpif_pm = {
-	.suspend        = vpif_suspend,
-	.resume         = vpif_resume,
-};
-
-#define vpif_pm_ops (&vpif_pm)
-#else
-#define vpif_pm_ops NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
+
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
-			.name	= "vpif_display",
+			.name	= VPIF_DRIVER_NAME,
 			.owner	= THIS_MODULE,
-			.pm	= vpif_pm_ops,
+			.pm	= &vpif_pm_ops,
 	},
 	.probe	= vpif_probe,
 	.remove	= vpif_remove,
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 4d0485b..72f9b4f 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -67,17 +67,11 @@ struct vpif_disp_buffer {
 };
 
 struct common_obj {
-	/* Buffer specific parameters */
-	u8 *fbuffers[VIDEO_MAX_FRAME];		/* List of buffer pointers for
-						 * storing frames */
 	u32 numbuffers;				/* number of buffers */
 	struct vpif_disp_buffer *cur_frm;	/* Pointer pointing to current
 						 * vb2_buffer */
 	struct vpif_disp_buffer *next_frm;	/* Pointer pointing to next
 						 * vb2_buffer */
-	enum v4l2_memory memory;		/* This field keeps track of
-						 * type of buffer exchange
-						 * method user has selected */
 	struct v4l2_format fmt;			/* Used to store the format */
 	struct vb2_queue buffer_queue;		/* Buffer queue used in
 						 * video-buf */
@@ -90,10 +84,6 @@ struct common_obj {
 	/* channel specific parameters */
 	struct mutex lock;			/* lock used to access this
 						 * structure */
-	u32 io_usrs;				/* number of users performing
-						 * IO */
-	u8 started;				/* Indicates whether streaming
-						 * started */
 	u32 ytop_off;				/* offset of Y top from the
 						 * starting of the buffer */
 	u32 ybtm_off;				/* offset of Y bottom from the
@@ -103,7 +93,7 @@ struct common_obj {
 	u32 cbtm_off;				/* offset of C bottom from the
 						 * starting of the buffer */
 	/* Function pointer to set the addresses */
-	void (*set_addr) (unsigned long, unsigned long,
+	void (*set_addr)(unsigned long, unsigned long,
 				unsigned long, unsigned long);
 	u32 height;
 	u32 width;
@@ -113,14 +103,8 @@ struct channel_obj {
 	/* V4l2 specific parameters */
 	struct video_device *video_dev;	/* Identifies video device for
 					 * this channel */
-	struct v4l2_prio_state prio;	/* Used to keep track of state of
-					 * the priority */
-	atomic_t usrs;			/* number of open instances of
-					 * the channel */
 	u32 field_id;			/* Indicates id of the field
 					 * which is being displayed */
-	u8 initialized;			/* flag to indicate whether
-					 * encoder is initialized */
 	u32 output_idx;			/* Current output index */
 	struct v4l2_subdev *sd;		/* Current output subdev(may be NULL) */
 
@@ -130,19 +114,6 @@ struct channel_obj {
 	struct video_obj video;
 };
 
-/* File handle structure */
-struct vpif_fh {
-	struct channel_obj *channel;	/* pointer to channel object for
-					 * opened device */
-	u8 io_allowed[VPIF_NUMOBJECTS];	/* Indicates whether this file handle
-					 * is doing IO */
-	enum v4l2_priority prio;	/* Used to keep track priority of
-					 * this instance */
-	u8 initialized;			/* Used to keep track of whether this
-					 * file handle has initialized
-					 * channel or not */
-};
-
 /* vpif device structure */
 struct vpif_device {
 	struct v4l2_device v4l2_dev;
-- 
1.7.9.5

