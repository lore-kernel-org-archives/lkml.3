Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbaLKAgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:36:33 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:60489 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932621AbaLKAgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:36:31 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com, mkrufky@linuxtv.org,
        dheitmueller@kernellabs.com, prabhakar.csengg@gmail.com,
        ramakrmu@cisco.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 - convert to use videobuf2
Date: Wed, 10 Dec 2014 17:28:12 -0700
Message-Id: <1418257692-8030-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert au0828 to use videobuf2. Tested with NTSC.
Tested video and vbi devices with xawtv, tvtime,
and vlc. Ran v4l2-compliance to ensure there are
no new regressions in video and vbi now has 3 fewer
failures.

video before:
test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
test VIDIOC_G_FMT: FAIL 3 failures
Total: 72, Succeeded: 69, Failed: 3, Warnings: 0

Video after:
test VIDIOC_DBG_G/S_REGISTER: OK
test VIDIOC_G_FMT: FAIL 3 failures
Total: 72, Succeeded: 69, Failed: 3, Warnings: 0

vbi before:
test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
test VIDIOC_EXPBUF: FAIL
test USERPTR: FAIL
Total: 72, Succeeded: 66, Failed: 6, Warnings: 0

vbi after:
test VIDIOC_DBG_G/S_REGISTER: OK
test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
test VIDIOC_EXPBUF: OK (Not Supported)
test USERPTR: OK
Total: 72, Succeeded: 69, Failed: 3, Warnings: 0

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Note: 
Also Alsa audio is having issues on 3.18-rc7 without any vb2
conversion changes. Is that a known issue? Several ALSA PCM
underrun and overrun errors and audio stops.

 drivers/media/usb/au0828/Kconfig        |   2 +-
 drivers/media/usb/au0828/au0828-cards.c |   2 +-
 drivers/media/usb/au0828/au0828-vbi.c   | 122 ++--
 drivers/media/usb/au0828/au0828-video.c | 960 +++++++++++++-------------------
 drivers/media/usb/au0828/au0828.h       |  61 +-
 5 files changed, 462 insertions(+), 685 deletions(-)

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 1d410ac..78b797e 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_AU0828
 	depends on I2C && INPUT && DVB_CORE && USB
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
-	select VIDEOBUF_VMALLOC
+	select VIDEOBUF2_VMALLOC
 	select DVB_AU8522_DTV if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 9eb77ac..ae2e563 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -39,7 +39,7 @@ static void hvr950q_cs5340_audio(void *priv, int enable)
 struct au0828_board au0828_boards[] = {
 	[AU0828_BOARD_UNKNOWN] = {
 		.name	= "Unknown board",
-		.tuner_type = UNSET,
+		.tuner_type = -1U,
 		.tuner_addr = ADDR_UNSET,
 	},
 	[AU0828_BOARD_HAUPPAUGE_HVR850] = {
diff --git a/drivers/media/usb/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
index 932d24f..e8b4798 100644
--- a/drivers/media/usb/au0828/au0828-vbi.c
+++ b/drivers/media/usb/au0828/au0828-vbi.c
@@ -34,105 +34,71 @@ MODULE_PARM_DESC(vbibufs, "number of vbi buffers, range 2-32");
 
 /* ------------------------------------------------------------------ */
 
-static void
-free_buffer(struct videobuf_queue *vq, struct au0828_buffer *buf)
+static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+			   unsigned int *nbuffers, unsigned int *nplanes,
+			   unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct au0828_fh     *fh  = vq->priv_data;
-	struct au0828_dev    *dev = fh->dev;
-	unsigned long flags = 0;
-	if (in_interrupt())
-		BUG();
-
-	/* We used to wait for the buffer to finish here, but this didn't work
-	   because, as we were keeping the state as VIDEOBUF_QUEUED,
-	   videobuf_queue_cancel marked it as finished for us.
-	   (Also, it could wedge forever if the hardware was misconfigured.)
-
-	   This should be safe; by the time we get here, the buffer isn't
-	   queued anymore. If we ever start marking the buffers as
-	   VIDEOBUF_ACTIVE, it won't be, though.
-	*/
-	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->isoc_ctl.vbi_buf == buf)
-		dev->isoc_ctl.vbi_buf = NULL;
-	spin_unlock_irqrestore(&dev->slock, flags);
+	struct au0828_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
 
-	videobuf_vmalloc_free(&buf->vb);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
-}
+	if (fmt)
+		size = fmt->fmt.pix.sizeimage;
+	else
+		size = dev->vbi_width * dev->vbi_height * 2;
 
-static int
-vbi_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
-{
-	struct au0828_fh     *fh  = q->priv_data;
-	struct au0828_dev    *dev = fh->dev;
+	if (0 == *nbuffers)
+		*nbuffers = 32;
+	if (*nbuffers < 2)
+		*nbuffers = 2;
+	if (*nbuffers > 32)
+		*nbuffers = 32;
 
-	*size = dev->vbi_width * dev->vbi_height * 2;
+	*nplanes = 1;
+	sizes[0] = size;
 
-	if (0 == *count)
-		*count = vbibufs;
-	if (*count < 2)
-		*count = 2;
-	if (*count > 32)
-		*count = 32;
 	return 0;
 }
 
-static int
-vbi_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
-	    enum v4l2_field field)
+static int vbi_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct au0828_fh     *fh  = q->priv_data;
-	struct au0828_dev    *dev = fh->dev;
+	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
-	int                  rc = 0;
+	unsigned long size;
 
-	buf->vb.size = dev->vbi_width * dev->vbi_height * 2;
+	size = dev->vbi_width * dev->vbi_height * 2;
 
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
+	if (vb2_plane_size(vb, 0) < size) {
+		pr_err("%s data will not fit into plane (%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0), size);
 		return -EINVAL;
-
-	buf->vb.width  = dev->vbi_width;
-	buf->vb.height = dev->vbi_height;
-	buf->vb.field  = field;
-
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		rc = videobuf_iolock(q, &buf->vb, NULL);
-		if (rc < 0)
-			goto fail;
 	}
+	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	buf->vb.state = VIDEOBUF_PREPARED;
 	return 0;
-
-fail:
-	free_buffer(q, buf);
-	return rc;
 }
 
 static void
-vbi_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
-{
-	struct au0828_buffer    *buf     = container_of(vb,
-							struct au0828_buffer,
-							vb);
-	struct au0828_fh        *fh      = vq->priv_data;
-	struct au0828_dev       *dev     = fh->dev;
-	struct au0828_dmaqueue  *vbiq    = &dev->vbiq;
-
-	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vbiq->active);
-}
-
-static void vbi_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+vbi_buffer_queue(struct vb2_buffer *vb)
 {
+	struct au0828_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
-	free_buffer(q, buf);
+	struct au0828_dmaqueue *vbiq = &dev->vbiq;
+	unsigned long flags = 0;
+
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &vbiq->active);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-struct videobuf_queue_ops au0828_vbi_qops = {
-	.buf_setup    = vbi_setup,
-	.buf_prepare  = vbi_prepare,
-	.buf_queue    = vbi_queue,
-	.buf_release  = vbi_release,
+struct vb2_ops au0828_vbi_qops = {
+	.queue_setup     = vbi_queue_setup,
+	.buf_prepare     = vbi_buffer_prepare,
+	.buf_queue       = vbi_buffer_queue,
+	.start_streaming = au0828_start_analog_streaming,
+	.stop_streaming  = au0828_stop_vbi_streaming,
+	.wait_prepare    = vb2_ops_wait_prepare,
+	.wait_finish     = vb2_ops_wait_finish,
 };
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 5f337b1..04d9015 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -219,9 +219,6 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 
 	au0828_isocdbg("au0828: called au0828_prepare_isoc\n");
 
-	/* De-allocates all pending stuff */
-	au0828_uninit_isoc(dev);
-
 	dev->isoc_ctl.isoc_copy = isoc_copy;
 	dev->isoc_ctl.num_bufs = num_bufs;
 
@@ -285,8 +282,6 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
 		}
 	}
 
-	init_waitqueue_head(&dma_q->wq);
-
 	/* submit urbs and enables IRQ */
 	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
 		rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_ATOMIC);
@@ -309,16 +304,12 @@ static inline void buffer_filled(struct au0828_dev *dev,
 				  struct au0828_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
-
-	buf->vb.state = VIDEOBUF_DONE;
-	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
+	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
-	dev->isoc_ctl.buf = NULL;
-
-	list_del(&buf->vb.queue);
-	wake_up(&buf->vb.done);
+	buf->vb.v4l2_buf.sequence = dev->field_count++;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 }
 
 static inline void vbi_buffer_filled(struct au0828_dev *dev,
@@ -326,16 +317,12 @@ static inline void vbi_buffer_filled(struct au0828_dev *dev,
 				     struct au0828_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->vb.i);
-
-	buf->vb.state = VIDEOBUF_DONE;
-	buf->vb.field_count++;
-	v4l2_get_timestamp(&buf->vb.ts);
+	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
-	dev->isoc_ctl.vbi_buf = NULL;
-
-	list_del(&buf->vb.queue);
-	wake_up(&buf->vb.done);
+	buf->vb.v4l2_buf.sequence = dev->vbi_field_count++;
+	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -354,8 +341,8 @@ static void au0828_copy_video(struct au0828_dev *dev,
 	if (len == 0)
 		return;
 
-	if (dma_q->pos + len > buf->vb.size)
-		len = buf->vb.size - dma_q->pos;
+	if (dma_q->pos + len > buf->length)
+		len = buf->length - dma_q->pos;
 
 	startread = p;
 	remain = len;
@@ -373,11 +360,11 @@ static void au0828_copy_video(struct au0828_dev *dev,
 	lencopy = bytesperline - currlinedone;
 	lencopy = lencopy > remain ? remain : lencopy;
 
-	if ((char *)startwrite + lencopy > (char *)outp + buf->vb.size) {
+	if ((char *)startwrite + lencopy > (char *)outp + buf->length) {
 		au0828_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
 			       ((char *)startwrite + lencopy) -
-			       ((char *)outp + buf->vb.size));
-		remain = (char *)outp + buf->vb.size - (char *)startwrite;
+			       ((char *)outp + buf->length));
+		remain = (char *)outp + buf->length - (char *)startwrite;
 		lencopy = remain;
 	}
 	if (lencopy <= 0)
@@ -395,11 +382,11 @@ static void au0828_copy_video(struct au0828_dev *dev,
 			lencopy = bytesperline;
 
 		if ((char *)startwrite + lencopy > (char *)outp +
-		    buf->vb.size) {
+		    buf->length) {
 			au0828_isocdbg("Overflow %zi bytes past buf end (2)\n",
 				       ((char *)startwrite + lencopy) -
-				       ((char *)outp + buf->vb.size));
-			lencopy = remain = (char *)outp + buf->vb.size -
+				       ((char *)outp + buf->length));
+			lencopy = remain = (char *)outp + buf->length -
 					   (char *)startwrite;
 		}
 		if (lencopy <= 0)
@@ -435,7 +422,11 @@ static inline void get_next_buf(struct au0828_dmaqueue *dma_q,
 	}
 
 	/* Get the next buffer */
-	*buf = list_entry(dma_q->active.next, struct au0828_buffer, vb.queue);
+	*buf = list_entry(dma_q->active.next, struct au0828_buffer, list);
+	/* Cleans up buffer - Useful for testing for frame/URB loss */
+	list_del(&(*buf)->list);
+	dma_q->pos = 0;
+	(*buf)->vb_buf = (*buf)->mem;
 	dev->isoc_ctl.buf = *buf;
 
 	return;
@@ -473,8 +464,8 @@ static void au0828_copy_vbi(struct au0828_dev *dev,
 
 	bytesperline = dev->vbi_width;
 
-	if (dma_q->pos + len > buf->vb.size)
-		len = buf->vb.size - dma_q->pos;
+	if (dma_q->pos + len > buf->length)
+		len = buf->length - dma_q->pos;
 
 	startread = p;
 	startwrite = outp + (dma_q->pos / 2);
@@ -497,7 +488,6 @@ static inline void vbi_get_next_buf(struct au0828_dmaqueue *dma_q,
 				    struct au0828_buffer **buf)
 {
 	struct au0828_dev *dev = container_of(dma_q, struct au0828_dev, vbiq);
-	char *outp;
 
 	if (list_empty(&dma_q->active)) {
 		au0828_isocdbg("No active queue to serve\n");
@@ -507,13 +497,12 @@ static inline void vbi_get_next_buf(struct au0828_dmaqueue *dma_q,
 	}
 
 	/* Get the next buffer */
-	*buf = list_entry(dma_q->active.next, struct au0828_buffer, vb.queue);
+	*buf = list_entry(dma_q->active.next, struct au0828_buffer, list);
 	/* Cleans up buffer - Useful for testing for frame/URB loss */
-	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	memset(outp, 0x00, (*buf)->vb.size);
-
+	list_del(&(*buf)->list);
+	dma_q->pos = 0;
+	(*buf)->vb_buf = (*buf)->mem;
 	dev->isoc_ctl.vbi_buf = *buf;
-
 	return;
 }
 
@@ -549,11 +538,11 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 
 	buf = dev->isoc_ctl.buf;
 	if (buf != NULL)
-		outp = videobuf_to_vmalloc(&buf->vb);
+		outp = vb2_plane_vaddr(&buf->vb, 0);
 
 	vbi_buf = dev->isoc_ctl.vbi_buf;
 	if (vbi_buf != NULL)
-		vbioutp = videobuf_to_vmalloc(&vbi_buf->vb);
+		vbioutp = vb2_plane_vaddr(&vbi_buf->vb, 0);
 
 	for (i = 0; i < urb->number_of_packets; i++) {
 		int status = urb->iso_frame_desc[i].status;
@@ -593,8 +582,8 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 				if (vbi_buf == NULL)
 					vbioutp = NULL;
 				else
-					vbioutp = videobuf_to_vmalloc(
-						&vbi_buf->vb);
+					vbioutp = vb2_plane_vaddr(
+						&vbi_buf->vb, 0);
 
 				/* Video */
 				if (buf != NULL)
@@ -603,7 +592,7 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 				if (buf == NULL)
 					outp = NULL;
 				else
-					outp = videobuf_to_vmalloc(&buf->vb);
+					outp = vb2_plane_vaddr(&buf->vb, 0);
 
 				/* As long as isoc traffic is arriving, keep
 				   resetting the timer */
@@ -657,130 +646,66 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int
-buffer_setup(struct videobuf_queue *vq, unsigned int *count,
-	     unsigned int *size)
+static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct au0828_fh *fh = vq->priv_data;
-	*size = (fh->dev->width * fh->dev->height * 16 + 7) >> 3;
+	struct au0828_dev *dev = vb2_get_drv_priv(vq);
+	unsigned long size;
 
-	if (0 == *count)
-		*count = AU0828_DEF_BUF;
+	if (fmt)
+		size = fmt->fmt.pix.sizeimage;
+	else
+		size =
+		    (dev->width * dev->height * dev->bytesperline + 7) >> 3;
 
-	if (*count < AU0828_MIN_BUF)
-		*count = AU0828_MIN_BUF;
-	return 0;
-}
+	if (size == 0)
+		return -EINVAL;
 
-/* This is called *without* dev->slock held; please keep it that way */
-static void free_buffer(struct videobuf_queue *vq, struct au0828_buffer *buf)
-{
-	struct au0828_fh     *fh  = vq->priv_data;
-	struct au0828_dev    *dev = fh->dev;
-	unsigned long flags = 0;
-	if (in_interrupt())
-		BUG();
-
-	/* We used to wait for the buffer to finish here, but this didn't work
-	   because, as we were keeping the state as VIDEOBUF_QUEUED,
-	   videobuf_queue_cancel marked it as finished for us.
-	   (Also, it could wedge forever if the hardware was misconfigured.)
-
-	   This should be safe; by the time we get here, the buffer isn't
-	   queued anymore. If we ever start marking the buffers as
-	   VIDEOBUF_ACTIVE, it won't be, though.
-	*/
-	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->isoc_ctl.buf == buf)
-		dev->isoc_ctl.buf = NULL;
-	spin_unlock_irqrestore(&dev->slock, flags);
+	if (0 == *nbuffers)
+		*nbuffers = 32;
+
+	*nplanes = 1;
+	sizes[0] = size;
 
-	videobuf_vmalloc_free(&buf->vb);
-	buf->vb.state = VIDEOBUF_NEEDS_INIT;
+	return 0;
 }
 
 static int
-buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
-						enum v4l2_field field)
+buffer_prepare(struct vb2_buffer *vb)
 {
-	struct au0828_fh     *fh  = vq->priv_data;
 	struct au0828_buffer *buf = container_of(vb, struct au0828_buffer, vb);
-	struct au0828_dev    *dev = fh->dev;
-	int                  rc = 0, urb_init = 0;
+	struct au0828_dev    *dev = vb2_get_drv_priv(vb->vb2_queue);
 
-	buf->vb.size = (fh->dev->width * fh->dev->height * 16 + 7) >> 3;
+	buf->length = (dev->width * dev->height * 16 + 7) >> 3;
 
-	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
+	if (vb2_plane_size(vb, 0) < buf->length) {
+		pr_err("%s data will not fit into plane (%lu < %lu)\n",
+			__func__, vb2_plane_size(vb, 0), buf->length);
 		return -EINVAL;
-
-	buf->vb.width  = dev->width;
-	buf->vb.height = dev->height;
-	buf->vb.field  = field;
-
-	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
-		rc = videobuf_iolock(vq, &buf->vb, NULL);
-		if (rc < 0) {
-			pr_info("videobuf_iolock failed\n");
-			goto fail;
-		}
 	}
-
-	if (!dev->isoc_ctl.num_bufs)
-		urb_init = 1;
-
-	if (urb_init) {
-		rc = au0828_init_isoc(dev, AU0828_ISO_PACKETS_PER_URB,
-				      AU0828_MAX_ISO_BUFS, dev->max_pkt_size,
-				      au0828_isoc_copy);
-		if (rc < 0) {
-			pr_info("au0828_init_isoc failed\n");
-			goto fail;
-		}
-	}
-
-	buf->vb.state = VIDEOBUF_PREPARED;
+	vb2_set_plane_payload(&buf->vb, 0, buf->length);
 	return 0;
-
-fail:
-	free_buffer(vq, buf);
-	return rc;
 }
 
 static void
-buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
+buffer_queue(struct vb2_buffer *vb)
 {
 	struct au0828_buffer    *buf     = container_of(vb,
 							struct au0828_buffer,
 							vb);
-	struct au0828_fh        *fh      = vq->priv_data;
-	struct au0828_dev       *dev     = fh->dev;
+	struct au0828_dev       *dev     = vb2_get_drv_priv(vb->vb2_queue);
 	struct au0828_dmaqueue  *vidq    = &dev->vidq;
+	unsigned long flags = 0;
 
-	buf->vb.state = VIDEOBUF_QUEUED;
-	list_add_tail(&buf->vb.queue, &vidq->active);
-}
-
-static void buffer_release(struct videobuf_queue *vq,
-				struct videobuf_buffer *vb)
-{
-	struct au0828_buffer   *buf  = container_of(vb,
-						    struct au0828_buffer,
-						    vb);
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
 
-	free_buffer(vq, buf);
+	spin_lock_irqsave(&dev->slock, flags);
+	list_add_tail(&buf->list, &vidq->active);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct videobuf_queue_ops au0828_video_qops = {
-	.buf_setup      = buffer_setup,
-	.buf_prepare    = buffer_prepare,
-	.buf_queue      = buffer_queue,
-	.buf_release    = buffer_release,
-};
-
-/* ------------------------------------------------------------------
-   V4L2 interface
-   ------------------------------------------------------------------*/
-
 static int au0828_i2s_init(struct au0828_dev *dev)
 {
 	/* Enable i2s mode */
@@ -829,7 +754,7 @@ static int au0828_analog_stream_enable(struct au0828_dev *d)
 	return 0;
 }
 
-int au0828_analog_stream_disable(struct au0828_dev *d)
+static int au0828_analog_stream_disable(struct au0828_dev *d)
 {
 	dprintk(1, "au0828_analog_stream_disable called\n");
 	au0828_writereg(d, AU0828_SENSORCTRL_100, 0x0);
@@ -862,78 +787,149 @@ static int au0828_stream_interrupt(struct au0828_dev *dev)
 	return 0;
 }
 
-/*
- * au0828_release_resources
- * unregister v4l2 devices
- */
-void au0828_analog_unregister(struct au0828_dev *dev)
+int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	dprintk(1, "au0828_release_resources called\n");
-	mutex_lock(&au0828_sysfs_lock);
+	struct au0828_dev *dev = vb2_get_drv_priv(vq);
+	int rc = 0;
 
-	if (dev->vdev)
-		video_unregister_device(dev->vdev);
-	if (dev->vbi_dev)
-		video_unregister_device(dev->vbi_dev);
+	dprintk(1, "au0828_start_analog_streaming called %d\n",
+		dev->streaming_users);
 
-	mutex_unlock(&au0828_sysfs_lock);
-}
+	/* Make sure streaming is not already in progress for this type
+	   of filehandle (e.g. video, vbi) */
+	if (vb2_is_streaming(vq))
+		return -EBUSY;
+
+	if (dev->streaming_users == 0) {
+		/* If we were doing ac97 instead of i2s, it would go here...*/
+		au0828_i2s_init(dev);
+		rc = au0828_init_isoc(dev, AU0828_ISO_PACKETS_PER_URB,
+				   AU0828_MAX_ISO_BUFS, dev->max_pkt_size,
+				   au0828_isoc_copy);
+		if (rc < 0) {
+			pr_info("au0828_init_isoc failed\n");
+			return rc;
+		}
 
+		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+			v4l2_device_call_all(&dev->v4l2_dev, 0, video,
+						s_stream, 1);
+			dev->vid_timeout_running = 1;
+			mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
+		} else if (vq->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
+			dev->vbi_timeout_running = 1;
+			mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
+		}
+	}
+	dev->streaming_users++;
+	return rc;
+}
 
-/* Usage lock check functions */
-static int res_get(struct au0828_fh *fh, unsigned int bit)
+static void au0828_stop_streaming(struct vb2_queue *vq)
 {
-	struct au0828_dev    *dev = fh->dev;
+	struct au0828_dev *dev = vb2_get_drv_priv(vq);
+	struct au0828_dmaqueue *vidq = &dev->vidq;
+	unsigned long flags = 0;
+	int i;
 
-	if (fh->resources & bit)
-		/* have it already allocated */
-		return 1;
+	dprintk(1, "au0828_stop_streaming called %d\n", dev->streaming_users);
 
-	/* is it free? */
-	if (dev->resources & bit) {
-		/* no, someone else uses it */
-		return 0;
+	if (!vb2_is_streaming(vq))
+		return;
+
+	if (dev->streaming_users-- == 1)
+		au0828_uninit_isoc(dev);
+	dprintk(1, "au0828_stop_streaming %d\n", dev->streaming_users);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	if (dev->isoc_ctl.buf != NULL) {
+		vb2_buffer_done(&dev->isoc_ctl.buf->vb, VB2_BUF_STATE_ERROR);
+		dev->isoc_ctl.buf = NULL;
 	}
-	/* it's free, grab it */
-	fh->resources  |= bit;
-	dev->resources |= bit;
-	dprintk(1, "res: get %d\n", bit);
+	while (!list_empty(&vidq->active)) {
+		struct au0828_buffer *buf;
 
-	return 1;
-}
+		buf = list_entry(vidq->active.next, struct au0828_buffer, list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+		list_del(&buf->list);
+	}
 
-static int res_check(struct au0828_fh *fh, unsigned int bit)
-{
-	return fh->resources & bit;
-}
+	dev->vid_timeout_running = 0;
+	del_timer_sync(&dev->vid_timeout);
 
-static int res_locked(struct au0828_dev *dev, unsigned int bit)
-{
-	return dev->resources & bit;
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+
+	for (i = 0; i < AU0828_MAX_INPUT; i++) {
+		if (AUVI_INPUT(i).audio_setup == NULL)
+			continue;
+		(AUVI_INPUT(i).audio_setup)(dev, 0);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static void res_free(struct au0828_fh *fh, unsigned int bits)
+void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 {
-	struct au0828_dev    *dev = fh->dev;
+	struct au0828_dev *dev = vb2_get_drv_priv(vq);
+	struct au0828_dmaqueue *vbiq = &dev->vbiq;
+	unsigned long flags = 0;
+
+	dprintk(1, "au0828_stop_vbi_streaming called %d\n",
+		dev->streaming_users);
+	if (!vb2_is_streaming(vq))
+		return;
+
+	if (dev->streaming_users-- == 1)
+		au0828_uninit_isoc(dev);
+	dprintk(1, "au0828_stop_vbi_streaming %d\n", dev->streaming_users);
+
+	spin_lock_irqsave(&dev->slock, flags);
+	if (dev->isoc_ctl.vbi_buf != NULL) {
+		vb2_buffer_done(&dev->isoc_ctl.vbi_buf->vb,
+				VB2_BUF_STATE_ERROR);
+		dev->isoc_ctl.vbi_buf = NULL;
+	}
+	while (!list_empty(&vbiq->active)) {
+		struct au0828_buffer *buf;
 
-	BUG_ON((fh->resources & bits) != bits);
+		buf = list_entry(vbiq->active.next, struct au0828_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	dev->vbi_timeout_running = 0;
+	del_timer_sync(&dev->vbi_timeout);
 
-	fh->resources  &= ~bits;
-	dev->resources &= ~bits;
-	dprintk(1, "res: put %d\n", bits);
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static int get_ressource(struct au0828_fh *fh)
+static struct vb2_ops au0828_video_qops = {
+	.queue_setup     = queue_setup,
+	.buf_prepare     = buffer_prepare,
+	.buf_queue       = buffer_queue,
+	.start_streaming = au0828_start_analog_streaming,
+	.stop_streaming  = au0828_stop_streaming,
+	.wait_prepare    = vb2_ops_wait_prepare,
+	.wait_finish     = vb2_ops_wait_finish,
+};
+
+/* ------------------------------------------------------------------
+   V4L2 interface
+   ------------------------------------------------------------------*/
+/*
+ * au0828_analog_unregister
+ * unregister v4l2 devices
+ */
+void au0828_analog_unregister(struct au0828_dev *dev)
 {
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		return AU0828_RESOURCE_VIDEO;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
-		return AU0828_RESOURCE_VBI;
-	default:
-		BUG();
-		return 0;
-	}
+	dprintk(1, "au0828_analog_unregister called\n");
+	mutex_lock(&au0828_sysfs_lock);
+
+	if (dev->vdev)
+		video_unregister_device(dev->vdev);
+	if (dev->vbi_dev)
+		video_unregister_device(dev->vbi_dev);
+
+	mutex_unlock(&au0828_sysfs_lock);
 }
 
 /* This function ensures that video frames continue to be delivered even if
@@ -951,8 +947,8 @@ static void au0828_vid_buffer_timeout(unsigned long data)
 
 	buf = dev->isoc_ctl.buf;
 	if (buf != NULL) {
-		vid_data = videobuf_to_vmalloc(&buf->vb);
-		memset(vid_data, 0x00, buf->vb.size); /* Blank green frame */
+		vid_data = vb2_plane_vaddr(&buf->vb, 0);
+		memset(vid_data, 0x00, buf->length); /* Blank green frame */
 		buffer_filled(dev, dma_q, buf);
 	}
 	get_next_buf(dma_q, &buf);
@@ -975,8 +971,8 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
 
 	buf = dev->isoc_ctl.vbi_buf;
 	if (buf != NULL) {
-		vbi_data = videobuf_to_vmalloc(&buf->vb);
-		memset(vbi_data, 0x00, buf->vb.size);
+		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
+		memset(vbi_data, 0x00, buf->length);
 		vbi_buffer_filled(dev, dma_q, buf);
 	}
 	vbi_get_next_buf(dma_q, &buf);
@@ -986,14 +982,12 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-
 static int au0828_v4l2_open(struct file *filp)
 {
-	int ret = 0;
 	struct video_device *vdev = video_devdata(filp);
 	struct au0828_dev *dev = video_drvdata(filp);
-	struct au0828_fh *fh;
 	int type;
+	int ret = 0;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
@@ -1006,85 +1000,61 @@ static int au0828_v4l2_open(struct file *filp)
 		return -EINVAL;
 	}
 
-	fh = kzalloc(sizeof(struct au0828_fh), GFP_KERNEL);
-	if (NULL == fh) {
-		dprintk(1, "Failed allocate au0828_fh struct!\n");
-		return -ENOMEM;
-	}
+	dprintk(1,
+		"%s called std_set %d dev_state %d stream users %d users %d\n",
+		__func__, dev->std_set_in_tuner_core, dev->dev_state,
+		dev->streaming_users, dev->users);
 
-	fh->type = type;
-	fh->dev = dev;
-	v4l2_fh_init(&fh->fh, vdev);
-	filp->private_data = fh;
-
-	if (mutex_lock_interruptible(&dev->lock)) {
-		kfree(fh);
+	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(filp);
+	if (ret) {
+		au0828_isocdbg("%s: v4l2_fh_open() returned error %d\n",
+				__func__, ret);
+		mutex_unlock(&dev->lock);
+		return ret;
 	}
+
 	if (dev->users == 0) {
 		au0828_analog_stream_enable(dev);
 		au0828_analog_stream_reset(dev);
-
-		/* If we were doing ac97 instead of i2s, it would go here...*/
-		au0828_i2s_init(dev);
-
 		dev->stream_state = STREAM_OFF;
 		dev->dev_state |= DEV_INITIALIZED;
 	}
-
 	dev->users++;
 	mutex_unlock(&dev->lock);
-
-	videobuf_queue_vmalloc_init(&fh->vb_vidq, &au0828_video_qops,
-				    NULL, &dev->slock,
-				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
-				    V4L2_FIELD_INTERLACED,
-				    sizeof(struct au0828_buffer), fh,
-				    &dev->lock);
-
-	/* VBI Setup */
-	videobuf_queue_vmalloc_init(&fh->vb_vbiq, &au0828_vbi_qops,
-				    NULL, &dev->slock,
-				    V4L2_BUF_TYPE_VBI_CAPTURE,
-				    V4L2_FIELD_SEQ_TB,
-				    sizeof(struct au0828_buffer), fh,
-				    &dev->lock);
-	v4l2_fh_add(&fh->fh);
 	return ret;
 }
 
 static int au0828_v4l2_close(struct file *filp)
 {
 	int ret;
-	struct au0828_fh *fh = filp->private_data;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(filp);
+	struct video_device *vdev = video_devdata(filp);
 
-	v4l2_fh_del(&fh->fh);
-	v4l2_fh_exit(&fh->fh);
+	dprintk(1,
+		"%s called std_set %d dev_state %d stream users %d users %d\n",
+		__func__, dev->std_set_in_tuner_core, dev->dev_state,
+		dev->streaming_users, dev->users);
+
+	vb2_fop_release(filp);
 	mutex_lock(&dev->lock);
-	if (res_check(fh, AU0828_RESOURCE_VIDEO)) {
+	if (vdev->vfl_type == VFL_TYPE_GRABBER && dev->vid_timeout_running) {
 		/* Cancel timeout thread in case they didn't call streamoff */
 		dev->vid_timeout_running = 0;
 		del_timer_sync(&dev->vid_timeout);
-
-		videobuf_stop(&fh->vb_vidq);
-		res_free(fh, AU0828_RESOURCE_VIDEO);
-	}
-
-	if (res_check(fh, AU0828_RESOURCE_VBI)) {
+	} else if (vdev->vfl_type == VFL_TYPE_VBI &&
+			dev->vbi_timeout_running) {
 		/* Cancel timeout thread in case they didn't call streamoff */
 		dev->vbi_timeout_running = 0;
 		del_timer_sync(&dev->vbi_timeout);
-
-		videobuf_stop(&fh->vb_vbiq);
-		res_free(fh, AU0828_RESOURCE_VBI);
 	}
 
-	if (dev->users == 1 && video_is_registered(video_devdata(filp))) {
-		au0828_analog_stream_disable(dev);
-
-		au0828_uninit_isoc(dev);
+	if (dev->dev_state == DEV_DISCONNECTED)
+		goto end;
 
+	if (dev->users == 1) {
 		/* Save some power by putting tuner to sleep */
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 		dev->std_set_in_tuner_core = 0;
@@ -1095,12 +1065,9 @@ static int au0828_v4l2_close(struct file *filp)
 		if (ret < 0)
 			pr_info("Au0828 can't set alternate to 0!\n");
 	}
-	mutex_unlock(&dev->lock);
-
-	videobuf_mmap_free(&fh->vb_vidq);
-	videobuf_mmap_free(&fh->vb_vbiq);
-	kfree(fh);
+end:
 	dev->users--;
+	mutex_unlock(&dev->lock);
 	wake_up_interruptible_nr(&dev->open, 1);
 	return 0;
 }
@@ -1113,6 +1080,9 @@ static void au0828_init_tuner(struct au0828_dev *dev)
 		.type = V4L2_TUNER_ANALOG_TV,
 	};
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	if (dev->std_set_in_tuner_core)
 		return;
 	dev->std_set_in_tuner_core = 1;
@@ -1125,98 +1095,6 @@ static void au0828_init_tuner(struct au0828_dev *dev)
 	i2c_gate_ctrl(dev, 0);
 }
 
-static ssize_t au0828_v4l2_read(struct file *filp, char __user *buf,
-				size_t count, loff_t *pos)
-{
-	struct au0828_fh *fh = filp->private_data;
-	struct au0828_dev *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-	au0828_init_tuner(dev);
-	mutex_unlock(&dev->lock);
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (res_locked(dev, AU0828_RESOURCE_VIDEO))
-			return -EBUSY;
-
-		return videobuf_read_stream(&fh->vb_vidq, buf, count, pos, 0,
-					filp->f_flags & O_NONBLOCK);
-	}
-
-	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		if (!res_get(fh, AU0828_RESOURCE_VBI))
-			return -EBUSY;
-
-		if (dev->vbi_timeout_running == 0) {
-			/* Handle case where caller tries to read without
-			   calling streamon first */
-			dev->vbi_timeout_running = 1;
-			mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
-		}
-
-		return videobuf_read_stream(&fh->vb_vbiq, buf, count, pos, 0,
-					    filp->f_flags & O_NONBLOCK);
-	}
-
-	return 0;
-}
-
-static unsigned int au0828_v4l2_poll(struct file *filp, poll_table *wait)
-{
-	struct au0828_fh *fh = filp->private_data;
-	struct au0828_dev *dev = fh->dev;
-	unsigned long req_events = poll_requested_events(wait);
-	unsigned int res;
-
-	if (check_dev(dev) < 0)
-		return POLLERR;
-
-	res = v4l2_ctrl_poll(filp, wait);
-	if (!(req_events & (POLLIN | POLLRDNORM)))
-		return res;
-
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-	au0828_init_tuner(dev);
-	mutex_unlock(&dev->lock);
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (!res_get(fh, AU0828_RESOURCE_VIDEO))
-			return POLLERR;
-		return res | videobuf_poll_stream(filp, &fh->vb_vidq, wait);
-	}
-	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		if (!res_get(fh, AU0828_RESOURCE_VBI))
-			return POLLERR;
-		return res | videobuf_poll_stream(filp, &fh->vb_vbiq, wait);
-	}
-	return POLLERR;
-}
-
-static int au0828_v4l2_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct au0828_fh *fh    = filp->private_data;
-	struct au0828_dev *dev   = fh->dev;
-	int		 rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_mmap_mapper(&fh->vb_vidq, vma);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_mmap_mapper(&fh->vb_vbiq, vma);
-
-	return rc;
-}
-
 static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 			     struct v4l2_format *format)
 {
@@ -1268,13 +1146,14 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 	return 0;
 }
 
-
 static int vidioc_querycap(struct file *file, void  *priv,
 			   struct v4l2_capability *cap)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	strlcpy(cap->driver, "au0828", sizeof(cap->driver));
 	strlcpy(cap->card, dev->board.name, sizeof(cap->card));
@@ -1300,6 +1179,8 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index)
 		return -EINVAL;
 
+	dprintk(1, "%s called\n", __func__);
+
 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	strcpy(f->description, "Packed YUV2");
 
@@ -1312,8 +1193,10 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct au0828_fh *fh  = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
@@ -1329,8 +1212,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	struct au0828_fh *fh  = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	return au0828_set_format(dev, VIDIOC_TRY_FMT, f);
 }
@@ -1338,15 +1223,17 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct au0828_fh *fh  = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 	int rc;
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	rc = check_dev(dev);
 	if (rc < 0)
 		return rc;
 
-	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
+	if (vb2_is_busy(&dev->vb_vidq)) {
 		pr_info("%s queue busy\n", __func__);
 		rc = -EBUSY;
 		goto out;
@@ -1359,8 +1246,16 @@ out:
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
+	if (norm == dev->std)
+		return 0;
+
+	if (dev->streaming_users > 0)
+		return -EBUSY;
 
 	dev->std = norm;
 
@@ -1383,8 +1278,10 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	*norm = dev->std;
 	return 0;
@@ -1393,8 +1290,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *input)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 	unsigned int tmp;
 
 	static const char *inames[] = {
@@ -1407,6 +1303,9 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		[AU0828_VMUX_DEBUG] = "tv debug"
 	};
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	tmp = input->index;
 
 	if (tmp >= AU0828_MAX_INPUT)
@@ -1432,8 +1331,11 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	*i = dev->ctrl_input;
 	return 0;
 }
@@ -1442,6 +1344,9 @@ static void au0828_s_input(struct au0828_dev *dev, int index)
 {
 	int i;
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	switch (AUVI_INPUT(index).type) {
 	case AU0828_VMUX_SVIDEO:
 		dev->input_type = AU0828_VMUX_SVIDEO;
@@ -1491,8 +1396,7 @@ static void au0828_s_input(struct au0828_dev *dev, int index)
 
 static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 
 	dprintk(1, "VIDIOC_S_INPUT in function %s, input=%d\n", __func__,
 		index);
@@ -1510,6 +1414,8 @@ static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
 	if (a->index > 1)
 		return -EINVAL;
 
+	dprintk(1, "%s called\n", __func__);
+
 	if (a->index == 0)
 		strcpy(a->name, "Television");
 	else
@@ -1521,8 +1427,10 @@ static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
 
 static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	a->index = dev->ctrl_ainput;
 	if (a->index == 0)
@@ -1536,22 +1444,26 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 
 static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 
 	if (a->index != dev->ctrl_ainput)
 		return -EINVAL;
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 	return 0;
 }
 
 static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	strcpy(t->name, "Auvitek tuner");
 
 	au0828_init_tuner(dev);
@@ -1564,12 +1476,14 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 static int vidioc_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 
 	if (t->index != 0)
 		return -EINVAL;
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	au0828_init_tuner(dev);
 	i2c_gate_ctrl(dev, 1);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
@@ -1585,11 +1499,12 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *freq)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 
 	if (freq->tuner != 0)
 		return -EINVAL;
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 	freq->frequency = dev->ctrl_freq;
 	return 0;
 }
@@ -1597,13 +1512,15 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 static int vidioc_s_frequency(struct file *file, void *priv,
 				const struct v4l2_frequency *freq)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 	struct v4l2_frequency new_freq = *freq;
 
 	if (freq->tuner != 0)
 		return -EINVAL;
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	au0828_init_tuner(dev);
 	i2c_gate_ctrl(dev, 1);
 
@@ -1625,8 +1542,10 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 				struct v4l2_format *format)
 {
-	struct au0828_fh      *fh  = priv;
-	struct au0828_dev     *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	format->fmt.vbi.samples_per_line = dev->vbi_width;
 	format->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -1646,12 +1565,14 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 static int vidioc_cropcap(struct file *file, void *priv,
 			  struct v4l2_cropcap *cc)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
 
 	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
+
 	cc->bounds.left = 0;
 	cc->bounds.top = 0;
 	cc->bounds.width = dev->width;
@@ -1665,105 +1586,14 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
-{
-	struct au0828_fh      *fh  = priv;
-	struct au0828_dev     *dev = fh->dev;
-	int                   rc = -EINVAL;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (unlikely(type != fh->type))
-		return -EINVAL;
-
-	dprintk(1, "vidioc_streamon fh=%p t=%d fh->res=%d dev->res=%d\n",
-		fh, type, fh->resources, dev->resources);
-
-	if (unlikely(!res_get(fh, get_ressource(fh))))
-		return -EBUSY;
-
-	au0828_init_tuner(dev);
-	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		au0828_analog_stream_enable(dev);
-		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
-	}
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		rc = videobuf_streamon(&fh->vb_vidq);
-		dev->vid_timeout_running = 1;
-		mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
-	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		rc = videobuf_streamon(&fh->vb_vbiq);
-		dev->vbi_timeout_running = 1;
-		mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
-	}
-
-	return rc;
-}
-
-static int vidioc_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
-{
-	struct au0828_fh      *fh  = priv;
-	struct au0828_dev     *dev = fh->dev;
-	int                   rc;
-	int                   i;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    fh->type != V4L2_BUF_TYPE_VBI_CAPTURE)
-		return -EINVAL;
-	if (type != fh->type)
-		return -EINVAL;
-
-	dprintk(1, "vidioc_streamoff fh=%p t=%d fh->res=%d dev->res=%d\n",
-		fh, type, fh->resources, dev->resources);
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev->vid_timeout_running = 0;
-		del_timer_sync(&dev->vid_timeout);
-
-		au0828_analog_stream_disable(dev);
-		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
-		rc = au0828_stream_interrupt(dev);
-		if (rc != 0)
-			return rc;
-
-		for (i = 0; i < AU0828_MAX_INPUT; i++) {
-			if (AUVI_INPUT(i).audio_setup == NULL)
-				continue;
-			(AUVI_INPUT(i).audio_setup)(dev, 0);
-		}
-
-		if (res_check(fh, AU0828_RESOURCE_VIDEO)) {
-			videobuf_streamoff(&fh->vb_vidq);
-			res_free(fh, AU0828_RESOURCE_VIDEO);
-		}
-	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		dev->vbi_timeout_running = 0;
-		del_timer_sync(&dev->vbi_timeout);
-
-		if (res_check(fh, AU0828_RESOURCE_VBI)) {
-			videobuf_streamoff(&fh->vb_vbiq);
-			res_free(fh, AU0828_RESOURCE_VBI);
-		}
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	reg->val = au0828_read(dev, reg->reg);
 	reg->size = 1;
@@ -1773,8 +1603,10 @@ static int vidioc_g_register(struct file *file, void *priv,
 static int vidioc_s_register(struct file *file, void *priv,
 			     const struct v4l2_dbg_register *reg)
 {
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
+	struct au0828_dev *dev = video_drvdata(file);
+
+	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
+		dev->std_set_in_tuner_core, dev->dev_state);
 
 	return au0828_writereg(dev, reg->reg, reg->val);
 }
@@ -1784,93 +1616,13 @@ static int vidioc_log_status(struct file *file, void *fh)
 {
 	struct video_device *vdev = video_devdata(file);
 
+	dprintk(1, "%s called\n", __func__);
+
 	v4l2_ctrl_log_status(file, fh);
 	v4l2_device_call_all(vdev->v4l2_dev, 0, core, log_status);
 	return 0;
 }
 
-static int vidioc_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *rb)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_reqbufs(&fh->vb_vidq, rb);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_reqbufs(&fh->vb_vbiq, rb);
-
-	return rc;
-}
-
-static int vidioc_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *b)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_querybuf(&fh->vb_vidq, b);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_querybuf(&fh->vb_vbiq, b);
-
-	return rc;
-}
-
-static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_qbuf(&fh->vb_vidq, b);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_qbuf(&fh->vb_vbiq, b);
-
-	return rc;
-}
-
-static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct au0828_fh *fh = priv;
-	struct au0828_dev *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	/* Workaround for a bug in the au0828 hardware design that sometimes
-	   results in the colorspace being inverted */
-	if (dev->greenscreen_detected == 1) {
-		dprintk(1, "Detected green frame.  Resetting stream...\n");
-		au0828_analog_stream_reset(dev);
-		dev->greenscreen_detected = 0;
-	}
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		rc = videobuf_dqbuf(&fh->vb_vidq, b, file->f_flags & O_NONBLOCK);
-	else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
-		rc = videobuf_dqbuf(&fh->vb_vbiq, b, file->f_flags & O_NONBLOCK);
-
-	return rc;
-}
-
 void au0828_v4l2_suspend(struct au0828_dev *dev)
 {
 	struct urb *urb;
@@ -1938,9 +1690,9 @@ static struct v4l2_file_operations au0828_v4l_fops = {
 	.owner      = THIS_MODULE,
 	.open       = au0828_v4l2_open,
 	.release    = au0828_v4l2_close,
-	.read       = au0828_v4l2_read,
-	.poll       = au0828_v4l2_poll,
-	.mmap       = au0828_v4l2_mmap,
+	.read       = vb2_fop_read,
+	.poll       = vb2_fop_poll,
+	.mmap       = vb2_fop_mmap,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -1957,17 +1709,23 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
 	.vidioc_cropcap             = vidioc_cropcap,
-	.vidioc_reqbufs             = vidioc_reqbufs,
-	.vidioc_querybuf            = vidioc_querybuf,
-	.vidioc_qbuf                = vidioc_qbuf,
-	.vidioc_dqbuf               = vidioc_dqbuf,
+
+	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs         = vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf         = vb2_ioctl_prepare_buf,
+	.vidioc_querybuf            = vb2_ioctl_querybuf,
+	.vidioc_qbuf                = vb2_ioctl_qbuf,
+	.vidioc_dqbuf               = vb2_ioctl_dqbuf,
+
 	.vidioc_s_std               = vidioc_s_std,
 	.vidioc_g_std               = vidioc_g_std,
 	.vidioc_enum_input          = vidioc_enum_input,
 	.vidioc_g_input             = vidioc_g_input,
 	.vidioc_s_input             = vidioc_s_input,
-	.vidioc_streamon            = vidioc_streamon,
-	.vidioc_streamoff           = vidioc_streamoff,
+
+	.vidioc_streamon            = vb2_ioctl_streamon,
+	.vidioc_streamoff           = vb2_ioctl_streamoff,
+
 	.vidioc_g_tuner             = vidioc_g_tuner,
 	.vidioc_s_tuner             = vidioc_s_tuner,
 	.vidioc_g_frequency         = vidioc_g_frequency,
@@ -1988,6 +1746,42 @@ static const struct video_device au0828_video_template = {
 	.tvnorms                    = V4L2_STD_NTSC_M | V4L2_STD_PAL_M,
 };
 
+static int au0828_vb2_setup(struct au0828_dev *dev)
+{
+	int rc;
+	struct vb2_queue *q;
+
+	/* Setup Videobuf2 for Video capture */
+	q = &dev->vb_vidq;
+	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct au0828_buffer);
+	q->ops = &au0828_video_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+
+	rc = vb2_queue_init(q);
+	if (rc < 0)
+		return rc;
+
+	/* Setup Videobuf2 for VBI capture */
+	q = &dev->vb_vbiq;
+	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
+	q->io_modes = VB2_READ | VB2_MMAP | VB2_USERPTR;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->drv_priv = dev;
+	q->buf_struct_size = sizeof(struct au0828_buffer);
+	q->ops = &au0828_vbi_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+
+	rc = vb2_queue_init(q);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 /**************************************************************************/
 
 int au0828_analog_register(struct au0828_dev *dev,
@@ -2039,9 +1833,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
-	INIT_LIST_HEAD(&dev->vidq.queued);
 	INIT_LIST_HEAD(&dev->vbiq.active);
-	INIT_LIST_HEAD(&dev->vbiq.queued);
 
 	dev->vid_timeout.function = au0828_vid_buffer_timeout;
 	dev->vid_timeout.data = (unsigned long) dev;
@@ -2078,16 +1870,23 @@ int au0828_analog_register(struct au0828_dev *dev,
 		goto err_vdev;
 	}
 
+	mutex_init(&dev->vb_queue_lock);
+	mutex_init(&dev->vb_vbi_queue_lock);
+
 	/* Fill the video capture device struct */
 	*dev->vdev = au0828_video_template;
 	dev->vdev->v4l2_dev = &dev->v4l2_dev;
 	dev->vdev->lock = &dev->lock;
+	dev->vdev->queue = &dev->vb_vidq;
+	dev->vdev->queue->lock = &dev->vb_queue_lock;
 	strcpy(dev->vdev->name, "au0828a video");
 
 	/* Setup the VBI device */
 	*dev->vbi_dev = au0828_video_template;
 	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
 	dev->vbi_dev->lock = &dev->lock;
+	dev->vbi_dev->queue = &dev->vb_vbiq;
+	dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
 	strcpy(dev->vbi_dev->name, "au0828a vbi");
 
 	/* Register the v4l2 device */
@@ -2110,6 +1909,15 @@ int au0828_analog_register(struct au0828_dev *dev,
 		goto err_vbi_dev;
 	}
 
+	/* initialize videobuf2 stuff */
+	retval = au0828_vb2_setup(dev);
+	if (retval != 0) {
+		dprintk(1, "unable to setup videobuf2 queues (error = %d).\n",
+			retval);
+		ret = -ENODEV;
+		goto err_vbi_dev;
+	}
+
 	dprintk(1, "%s completed!\n", __func__);
 
 	return 0;
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 36815a3..4310acd 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -28,7 +28,7 @@
 
 /* Analog */
 #include <linux/videodev2.h>
-#include <media/videobuf-vmalloc.h>
+#include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
@@ -126,17 +126,7 @@ enum au0828_dev_state {
 	DEV_MISCONFIGURED = 0x04
 };
 
-struct au0828_fh {
-	/* must be the first field of this struct! */
-	struct v4l2_fh fh;
-
-	struct au0828_dev *dev;
-	unsigned int  resources;
-
-	struct videobuf_queue        vb_vidq;
-	struct videobuf_queue        vb_vbiq;
-	enum v4l2_buf_type           type;
-};
+struct au0828_dev;
 
 struct au0828_usb_isoc_ctl {
 		/* max packet size of isoc transaction */
@@ -177,21 +167,20 @@ struct au0828_usb_isoc_ctl {
 /* buffer for one video frame */
 struct au0828_buffer {
 	/* common v4l buffer stuff -- must be first */
-	struct videobuf_buffer vb;
+	struct vb2_buffer vb;
+	struct list_head list;
 
-	struct list_head frame;
+	void *mem;
+	unsigned long length;
 	int top_field;
-	int receiving;
+	/* pointer to vmalloc memory address in vb */
+	char *vb_buf;
 };
 
 struct au0828_dmaqueue {
 	struct list_head       active;
-	struct list_head       queued;
-
-	wait_queue_head_t          wq;
-
 	/* Counters to control buffer fill */
-	int                        pos;
+	int                    pos;
 };
 
 struct au0828_dev {
@@ -220,14 +209,26 @@ struct au0828_dev {
 	struct au0828_rc *ir;
 #endif
 
-	int users;
-	unsigned int resources;	/* resources in use */
 	struct video_device *vdev;
 	struct video_device *vbi_dev;
+
+	/* Videobuf2 */
+	struct vb2_queue vb_vidq;
+	struct vb2_queue vb_vbiq;
+	struct mutex vb_queue_lock;
+	struct mutex vb_vbi_queue_lock;
+
+	unsigned int field_count;
+	unsigned int vbi_field_count;
+
 	struct timer_list vid_timeout;
 	int vid_timeout_running;
 	struct timer_list vbi_timeout;
 	int vbi_timeout_running;
+
+	int users;
+	int streaming_users;
+
 	int width;
 	int height;
 	int vbi_width;
@@ -242,7 +243,6 @@ struct au0828_dev {
 	__u8 isoc_in_endpointaddr;
 	u8 isoc_init_ok;
 	int greenscreen_detected;
-	unsigned int frame_count;
 	int ctrl_freq;
 	int input_type;
 	int std_set_in_tuner_core;
@@ -277,6 +277,7 @@ struct au0828_dev {
 	char *dig_transfer_buffer[URB_COUNT];
 };
 
+
 /* ----------------------------------------------------------- */
 #define au0828_read(dev, reg) au0828_readreg(dev, reg)
 #define au0828_write(dev, reg, value) au0828_writereg(dev, reg, value)
@@ -309,13 +310,15 @@ extern int au0828_i2c_unregister(struct au0828_dev *dev);
 
 /* ----------------------------------------------------------- */
 /* au0828-video.c */
-int au0828_analog_register(struct au0828_dev *dev,
+extern int au0828_analog_register(struct au0828_dev *dev,
 			   struct usb_interface *interface);
-int au0828_analog_stream_disable(struct au0828_dev *d);
-void au0828_analog_unregister(struct au0828_dev *dev);
+extern void au0828_analog_unregister(struct au0828_dev *dev);
+extern int au0828_start_analog_streaming(struct vb2_queue *vq,
+						unsigned int count);
+extern void au0828_stop_vbi_streaming(struct vb2_queue *vq);
 #ifdef CONFIG_VIDEO_AU0828_V4L2
-void au0828_v4l2_suspend(struct au0828_dev *dev);
-void au0828_v4l2_resume(struct au0828_dev *dev);
+extern void au0828_v4l2_suspend(struct au0828_dev *dev);
+extern void au0828_v4l2_resume(struct au0828_dev *dev);
 #else
 static inline void au0828_v4l2_suspend(struct au0828_dev *dev) { };
 static inline void au0828_v4l2_resume(struct au0828_dev *dev) { };
@@ -329,7 +332,7 @@ void au0828_dvb_suspend(struct au0828_dev *dev);
 void au0828_dvb_resume(struct au0828_dev *dev);
 
 /* au0828-vbi.c */
-extern struct videobuf_queue_ops au0828_vbi_qops;
+extern struct vb2_ops au0828_vbi_qops;
 
 #define dprintk(level, fmt, arg...)\
 	do { if (au0828_debug & level)\
-- 
2.1.0

