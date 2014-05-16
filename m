Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbaEPNlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:52 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51147 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaEPNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:49 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 33/49] media: davinci: vpif_capture: improve start/stop_streaming callbacks
Date: Fri, 16 May 2014 19:03:39 +0530
Message-Id: <1400247235-31434-36-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   36 ++++++++++++-------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index c77c176..58dddf6 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -176,6 +176,11 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
+/**
+ * vpif_start_streaming : Starts the DMA engine for streaming
+ * @vb: ptr to vb2_buffer
+ * @count: number of buffers
+ */
 static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpif_capture_config *vpif_config_data =
@@ -193,16 +198,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ch->field_id = 0;
 	common->started = 1;
 
-	if ((vpif->std_info.frm_fmt &&
-	    ((common->fmt.fmt.pix.field != V4L2_FIELD_NONE) &&
-	     (common->fmt.fmt.pix.field != V4L2_FIELD_ANY))) ||
-	    (!vpif->std_info.frm_fmt &&
-	     (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
-		vpif_dbg(1, debug, "conflict in field format and std format\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
 	/* configure 1 or 2 channel mode */
 	if (vpif_config_data->setup_input_channel_mode) {
 		ret = vpif_config_data->
@@ -245,13 +240,13 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * VPIF register
 	 */
 	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
-	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)) {
+	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
 		channel0_intr_assert();
 		channel0_intr_enable(1);
 		enable_channel0(1);
 	}
-	if ((VPIF_CHANNEL1_VIDEO == ch->channel_id) ||
-	    (common->started == 2)) {
+	if (VPIF_CHANNEL1_VIDEO == ch->channel_id ||
+		common->started == 2) {
 		channel1_intr_assert();
 		channel1_intr_enable(1);
 		enable_channel1(1);
@@ -268,16 +263,19 @@ err:
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
 
 	/* Disable channel as per its device type and channel id */
@@ -285,8 +283,8 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 		enable_channel0(0);
 		channel0_intr_enable(0);
 	}
-	if ((VPIF_CHANNEL1_VIDEO == ch->channel_id) ||
-		(2 == common->started)) {
+	if (VPIF_CHANNEL1_VIDEO == ch->channel_id ||
+		2 == common->started) {
 		enable_channel1(0);
 		channel1_intr_enable(0);
 	}
-- 
1.7.9.5

