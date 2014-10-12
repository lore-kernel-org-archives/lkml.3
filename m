Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaJLUlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:41:21 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49767 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaJLUlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:41:09 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 12/15] media: davinci: vpbe: use helpers provided by core if streaming is started
Date: Sun, 12 Oct 2014 21:40:42 +0100
Message-Id: <1413146445-7304-13-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch uses vb2_is_busy() helper to check if streaming is
actually started, instead of driver managing it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 34 ++++++++-------------------
 include/media/davinci/vpbe_display.h          |  4 ----
 2 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 378f31b..b57fa68 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -152,8 +152,8 @@ static irqreturn_t venc_isr(int irq, void *arg)
 
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
 		layer = disp_dev->dev[i];
-		/* If streaming is started in this layer */
-		if (!layer->started)
+
+		if (!vb2_start_streaming_called(&layer->buffer_queue))
 			continue;
 
 		if (layer->layer_first_int) {
@@ -314,7 +314,6 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * if request format is yuv420 semiplanar, need to
 	 * enable both video windows
 	 */
-	layer->started = 1;
 	layer->layer_first_int = 1;
 
 	return ret;
@@ -829,11 +828,9 @@ static int vpbe_display_s_fmt(struct file *file, void *priv,
 			"VIDIOC_S_FMT, layer id = %d\n",
 			layer->device_id);
 
-	/* If streaming is started, return error */
-	if (layer->started) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
+	if (vb2_is_busy(&layer->buffer_queue))
 		return -EBUSY;
-	}
+
 	if (V4L2_BUF_TYPE_VIDEO_OUTPUT != fmt->type) {
 		v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "invalid type\n");
 		return -EINVAL;
@@ -937,11 +934,9 @@ static int vpbe_display_s_std(struct file *file, void *priv,
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_STD\n");
 
-	/* If streaming is started, return error */
-	if (layer->started) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
+	if (vb2_is_busy(&layer->buffer_queue))
 		return -EBUSY;
-	}
+
 	if (NULL != vpbe_dev->ops.s_std) {
 		ret = vpbe_dev->ops.s_std(vpbe_dev, std_id);
 		if (ret) {
@@ -1021,11 +1016,10 @@ static int vpbe_display_s_output(struct file *file, void *priv,
 	int ret;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,	"VIDIOC_S_OUTPUT\n");
-	/* If streaming is started, return error */
-	if (layer->started) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
+
+	if (vb2_is_busy(&layer->buffer_queue))
 		return -EBUSY;
-	}
+
 	if (NULL == vpbe_dev->ops.set_output)
 		return -EINVAL;
 
@@ -1102,12 +1096,8 @@ vpbe_display_s_dv_timings(struct file *file, void *priv,
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_S_DV_TIMINGS\n");
 
-
-	/* If streaming is started, return error */
-	if (layer->started) {
-		v4l2_err(&vpbe_dev->v4l2_dev, "Streaming is started\n");
+	if (vb2_is_busy(&layer->buffer_queue))
 		return -EBUSY;
-	}
 
 	/* Set the given standard in the encoder */
 	if (!vpbe_dev->ops.s_dv_timings)
@@ -1212,13 +1202,9 @@ static int vpbe_display_release(struct file *file)
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_release\n");
 
 	mutex_lock(&layer->opslock);
-	/* Reset io_usrs member of layer object */
-	layer->io_usrs = 0;
 
 	osd_device->ops.disable_layer(osd_device,
 			layer->layer_info.id);
-	layer->started = 0;
-
 	/* Decrement layer usrs counter */
 	layer->usrs--;
 	/* If this file handle has initialize encoder device, reset it */
diff --git a/include/media/davinci/vpbe_display.h b/include/media/davinci/vpbe_display.h
index 06ea815..de0843d 100644
--- a/include/media/davinci/vpbe_display.h
+++ b/include/media/davinci/vpbe_display.h
@@ -106,12 +106,8 @@ struct vpbe_layer {
 	unsigned char window_enable;
 	/* number of open instances of the layer */
 	unsigned int usrs;
-	/* number of users performing IO */
-	unsigned int io_usrs;
 	/* Indicates id of the field which is being displayed */
 	unsigned int field_id;
-	/* Indicates whether streaming started */
-	unsigned char started;
 	/* Identifies device object */
 	enum vpbe_display_device_id device_id;
 	/* facilitation of ioctl ops lock by v4l2*/
-- 
1.9.1

