Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbaEPNmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:24 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32778 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428AbaEPNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:19 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 39/49] media: davinic: vpif_capture: drop started member from struct common_obj
Date: Fri, 16 May 2014 19:03:45 +0530
Message-Id: <1400247235-31434-42-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   36 ++++++++++---------------
 drivers/media/platform/davinci/vpif_capture.h |    2 --
 2 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 6b66f55..b898779 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -73,6 +73,9 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
 static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
 
+/* Is set to 1 in case of SDTV formats, 2 in case of HDTV formats. */
+static int ycmux_mode;
+
 static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
 {
 	return container_of(vb, struct vpif_cap_buffer, vb);
@@ -194,9 +197,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irqsave(&common->irqlock, flags);
 
-	/* Initialize field_id and started member */
+	/* Initialize field_id */
 	ch->field_id = 0;
-	common->started = 1;
 
 	/* configure 1 or 2 channel mode */
 	if (vpif_config_data->setup_input_channel_mode) {
@@ -216,13 +218,12 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	/* Call vpif_set_params function to set the parameters and addresses */
 	ret = vpif_set_video_params(vpif, ch->channel_id);
-
 	if (ret < 0) {
 		vpif_dbg(1, debug, "can't set video params\n");
 		goto err;
 	}
 
-	common->started = ret;
+	ycmux_mode = ret;
 	vpif_config_addr(ch, ret);
 
 	/* Get the next frame from the buffer queue */
@@ -252,7 +253,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		enable_channel0(1);
 	}
 	if (VPIF_CHANNEL1_VIDEO == ch->channel_id ||
-		common->started == 2) {
+		ycmux_mode == 2) {
 		channel1_intr_assert();
 		channel1_intr_enable(1);
 		enable_channel1(1);
@@ -291,11 +292,12 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		channel0_intr_enable(0);
 	}
 	if (VPIF_CHANNEL1_VIDEO == ch->channel_id ||
-		2 == common->started) {
+		ycmux_mode == 2) {
 		enable_channel1(0);
 		channel1_intr_enable(0);
 	}
-	common->started = 0;
+
+	ycmux_mode = 0;
 
 	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
 	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
@@ -404,9 +406,6 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	for (i = 0; i < VPIF_NUMBER_OF_OBJECTS; i++) {
 		common = &ch->common[i];
 		/* skip If streaming is not started in this channel */
-		if (0 == common->started)
-			continue;
-
 		/* Check the field format */
 		if (1 == ch->vpifparams.std_info.frm_fmt) {
 			/* Progressive mode */
@@ -910,10 +909,8 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 
 	vpif_dbg(2, debug, "vpif_s_std\n");
 
-	if (common->started) {
-		vpif_err("streaming in progress\n");
+	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
-	}
 
 	/* Call encoder subdevice function to set the standard */
 	ch->video.stdid = std_id;
@@ -998,10 +995,8 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 	if (index >= chan_cfg->input_count)
 		return -EINVAL;
 
-	if (common->started) {
-		vpif_err("Streaming in progress\n");
+	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
-	}
 
 	return vpif_set_input(config, ch, index);
 }
@@ -1092,11 +1087,8 @@ static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
 
 	vpif_dbg(2, debug, "%s\n", __func__);
 
-	/* If streaming is started, return error */
-	if (common->started) {
-		vpif_dbg(1, debug, "Streaming is started\n");
+	if (vb2_is_busy(&common->buffer_queue))
 		return -EBUSY;
-	}
 
 	pixfmt = &fmt->fmt.pix;
 	/* Check for valid field format */
@@ -1707,7 +1699,7 @@ static int vpif_suspend(struct device *dev)
 				channel0_intr_enable(0);
 			}
 			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
-			    common->started == 2) {
+				ycmux_mode == 2) {
 				enable_channel1(0);
 				channel1_intr_enable(0);
 			}
@@ -1739,7 +1731,7 @@ static int vpif_resume(struct device *dev)
 				channel0_intr_enable(1);
 			}
 			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
-			    common->started == 2) {
+				ycmux_mode == 2) {
 				enable_channel1(1);
 				channel1_intr_enable(1);
 			}
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 9b7dd06..4960504 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -77,8 +77,6 @@ struct common_obj {
 	struct mutex lock;
 	/* number of users performing IO */
 	u32 io_usrs;
-	/* Indicates whether streaming started */
-	u8 started;
 	/* Function pointer to set the addresses */
 	void (*set_addr) (unsigned long, unsigned long, unsigned long,
 			  unsigned long);
-- 
1.7.9.5

