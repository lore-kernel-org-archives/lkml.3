Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaEPNzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:55:33 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34893 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbaEPNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:57 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 08/49] media: davinci: vpif_display: improve start/stop_streaming callbacks
Date: Fri, 16 May 2014 19:03:13 +0530
Message-Id: <1400247235-31434-10-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops unnecessary check from start_streaming() callback
as this is already done in try/s_fmt and some minor code cleanups,
drops check for vb2_is_streaming() as this check is done by vb2
itself before calling this callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   59 ++++++++++++++-----------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1b6cbe8..933d28f 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -62,11 +62,18 @@ static struct vpif_config_params config_params = {
 	.channel_bufsize[1]	= 720 * 576 * 2,
 };
 
+static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
+
 static struct vpif_device vpif_obj = { {NULL} };
 static struct device *vpif_dev;
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
+static inline struct vpif_disp_buffer *to_vpif_buffer(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct vpif_disp_buffer, vb);
+}
+
 /**
  * vpif_buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
@@ -139,13 +146,15 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-/*
- * vpif_buffer_queue: This function adds the buffer to DMA queue
+/**
+ * vpif_buffer_queue : Callback function to add buffer to DMA queue
+ * @vb: ptr to vb2_buffer
+ *
+ * This callback fucntion queues the buffer to DMA engine
  */
 static void vpif_buffer_queue(struct vb2_buffer *vb)
 {
-	struct vpif_disp_buffer *buf = container_of(vb,
-				struct vpif_disp_buffer, vb);
+	struct vpif_disp_buffer *buf = to_vpif_buffer(vb);
 	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
 	unsigned long flags;
@@ -158,8 +167,11 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-static u8 channel_first_int[VPIF_NUMOBJECTS][2] = { {1, 1} };
-
+/**
+ * vpif_start_streaming : Starts the DMA engine for streaming
+ * @vb: ptr to vb2_buffer
+ * @count: number of buffers
+ */
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_display_config *vpif_config_data =
@@ -177,16 +189,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ch->field_id = 0;
 	common->started = 1;
 
-	if ((ch->vpifparams.std_info.frm_fmt &&
-		((common->fmt.fmt.pix.field != V4L2_FIELD_NONE)
-		&& (common->fmt.fmt.pix.field != V4L2_FIELD_ANY)))
-		|| (!ch->vpifparams.std_info.frm_fmt
-		&& (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
-		vpif_err("conflict in field format and std format\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
 	/* clock settings */
 	if (vpif_config_data->set_clock) {
 		ret = vpif_config_data->set_clock(ch->vpifparams.std_info.
@@ -220,8 +222,10 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
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
@@ -231,8 +235,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 			channel2_clipping_enable(1);
 	}
 
-	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id)
-		|| (common->started == 2)) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id ||
+		common->started == 2) {
 		channel3_intr_assert();
 		channel3_intr_enable(1);
 		enable_channel3(1);
@@ -251,16 +255,19 @@ err:
 	return ret;
 }
 
-/* abort streaming and wait for last buffer */
+/**
+ * vpif_stop_streaming : Stop the DMA engine
+ * @vq: ptr to vb2_queue
+ *
+ * This callback stops the DMA engine and any remaining buffers
+ * in the DMA queue are released.
+ */
 static void vpif_stop_streaming(struct vb2_queue *vq)
 {
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common;
 	unsigned long flags;
 
-	if (!vb2_is_streaming(vq))
-		return;
-
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
 	/* Disable channel */
@@ -268,8 +275,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		enable_channel2(0);
 		channel2_intr_enable(0);
 	}
-	if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
-		(2 == common->started)) {
+	if (VPIF_CHANNEL3_VIDEO == ch->channel_id ||
+		2 == common->started) {
 		enable_channel3(0);
 		channel3_intr_enable(0);
 	}
-- 
1.7.9.5

