Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbaEPNkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:40:14 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53299 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaEPNkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:10 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 16/49] media: davinic: vpif_display: drop started member from struct common_obj
Date: Fri, 16 May 2014 19:03:21 +0530
Message-Id: <1400247235-31434-18-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

the started member was indicating whether streaming was started
or not, this can be determined by vb2 offering, this patch replaces
the started member from struct common_obj with appropriate vb2 calls.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   42 ++++++++++---------------
 drivers/media/platform/davinci/vpif_display.h |    2 --
 2 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5ea2db8..aa487a6 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -62,6 +62,10 @@ static struct vpif_config_params config_params = {
 	.channel_bufsize[1]	= 720 * 576 * 2,
 };
 
+
+/* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
+static int ycmux_mode;
+
 static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
 
 static struct vpif_device vpif_obj = { {NULL} };
@@ -185,9 +189,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irqsave(&common->irqlock, flags);
 
-	/* Initialize field_id and started member */
+	/* Initialize field_id */
 	ch->field_id = 0;
-	common->started = 1;
 
 	/* clock settings */
 	if (vpif_config_data->set_clock) {
@@ -204,7 +207,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0)
 		goto err;
 
-	common->started = ret;
+	ycmux_mode = ret;
 	vpif_config_addr(ch, ret);
 	/* Get the next frame from the buffer queue */
 	common->next_frm = common->cur_frm =
@@ -235,8 +238,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 			channel2_clipping_enable(1);
 	}
 
-	if (VPIF_CHANNEL3_VIDEO == ch->channel_id ||
-		common->started == 2) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id || ycmux_mode == 2) {
 		channel3_intr_assert();
 		channel3_intr_enable(1);
 		enable_channel3(1);
@@ -275,12 +277,10 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		enable_channel2(0);
 		channel2_intr_enable(0);
 	}
-	if (VPIF_CHANNEL3_VIDEO == ch->channel_id ||
-		2 == common->started) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id || ycmux_mode == 2) {
 		enable_channel3(0);
 		channel3_intr_enable(0);
 	}
-	common->started = 0;
 
 	/* release all active buffers */
 	spin_lock_irqsave(&common->irqlock, flags);
@@ -392,8 +392,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	for (i = 0; i < VPIF_NUMOBJECTS; i++) {
 		common = &ch->common[i];
 		/* If streaming is started in this channel */
-		if (0 == common->started)
-			continue;
 
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
 			spin_lock(&common->irqlock);
@@ -704,10 +702,8 @@ static int vpif_s_fmt_vid_out(struct file *file, void *priv,
 	struct v4l2_pix_format *pixfmt;
 	int ret = 0;
 
-	if (common->started) {
-		vpif_dbg(1, debug, "Streaming in progress\n");
+	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
-	}
 
 	pixfmt = &fmt->fmt.pix;
 	/* Check for valid field format */
@@ -747,13 +743,12 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
+
 	if (!(std_id & VPIF_V4L2_STD))
 		return -EINVAL;
 
-	if (common->started) {
-		vpif_err("streaming in progress\n");
-		return -EBUSY;
-	}
 
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = std_id;
@@ -920,16 +915,14 @@ static int vpif_s_output(struct file *file, void *priv, unsigned int i)
 	struct vpif_display_chan_config *chan_cfg;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 
+	if (vb2_is_busy(&common->buffer_queue))
+		return -EBUSY;
+
 	chan_cfg = &config->chan_config[ch->channel_id];
 
 	if (i >= chan_cfg->output_count)
 		return -EINVAL;
 
-	if (common->started) {
-		vpif_err("Streaming in progress\n");
-		return -EBUSY;
-	}
-
 	return vpif_set_output(config, ch, i);
 }
 
@@ -1223,7 +1216,6 @@ static int vpif_probe_complete(void)
 		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
 			common = &ch->common[k];
 			common->io_usrs = 0;
-			common->started = 0;
 			spin_lock_init(&common->irqlock);
 			mutex_init(&common->lock);
 			common->set_addr = NULL;
@@ -1488,7 +1480,7 @@ static int vpif_suspend(struct device *dev)
 				channel2_intr_enable(0);
 			}
 			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					common->started == 2) {
+				ycmux_mode == 2) {
 				enable_channel3(0);
 				channel3_intr_enable(0);
 			}
@@ -1518,7 +1510,7 @@ static int vpif_resume(struct device *dev)
 				channel2_intr_enable(1);
 			}
 			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					common->started == 2) {
+					ycmux_mode == 2) {
 				enable_channel3(1);
 				channel3_intr_enable(1);
 			}
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index e21a343..029e0c5 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -85,8 +85,6 @@ struct common_obj {
 						 * structure */
 	u32 io_usrs;				/* number of users performing
 						 * IO */
-	u8 started;				/* Indicates whether streaming
-						 * started */
 	u32 ytop_off;				/* offset of Y top from the
 						 * starting of the buffer */
 	u32 ybtm_off;				/* offset of Y bottom from the
-- 
1.7.9.5

