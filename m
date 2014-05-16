Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbaEPNhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:48 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37241 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441AbaEPNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:45 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 07/49] media: davinci: vpif_display: improve vpif_buffer_queue_setup() function
Date: Fri, 16 May 2014 19:03:12 +0530
Message-Id: <1400247235-31434-9-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch sets the sizes[0] of plane according to the fmt passed
or which is being set in the channel, in both MMAP and USERPTR buffer
type.

This patch also move the calculation of offests(vpif_calculate_offsets())
to queue_setup() callback as after queue_setup() callback the
application is no longer allowed to change format, and prepares to
removal of config_params.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   53 ++++++++++---------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 1c518de..1b6cbe8 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -103,8 +103,17 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-/*
- * vpif_buffer_queue_setup: This function allocates memory for the buffers
+/**
+ * vpif_buffer_queue_setup : Callback function for buffer setup.
+ * @vq: vb2_queue ptr
+ * @fmt: v4l2 format
+ * @nbuffers: ptr to number of buffers requested by application
+ * @nplanes:: contains number of distinct video planes needed to hold a frame
+ * @sizes[]: contains the size (in bytes) of each plane.
+ * @alloc_ctxs: ptr to allocation context
+ *
+ * This callback function is called when reqbuf() is called to adjust
+ * the buffer count and buffer size
  */
 static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 				const struct v4l2_format *fmt,
@@ -113,37 +122,20 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
 {
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	unsigned long size;
-
-	if (V4L2_MEMORY_MMAP == common->memory) {
-		size = config_params.channel_bufsize[ch->channel_id];
-		/*
-		* Checking if the buffer size exceeds the available buffer
-		* ycmux_mode = 0 means 1 channel mode HD and
-		* ycmux_mode = 1 means 2 channels mode SD
-		*/
-		if (ch->vpifparams.std_info.ycmux_mode == 0) {
-			if (config_params.video_limit[ch->channel_id])
-				while (size * *nbuffers >
-					(config_params.video_limit[0]
-						+ config_params.video_limit[1]))
-					(*nbuffers)--;
-		} else {
-			if (config_params.video_limit[ch->channel_id])
-				while (size * *nbuffers >
-				config_params.video_limit[ch->channel_id])
-					(*nbuffers)--;
-		}
-	} else {
-		size = common->fmt.fmt.pix.sizeimage;
-	}
 
-	if (*nbuffers < config_params.min_numbuffers)
-			*nbuffers = config_params.min_numbuffers;
+	if (fmt && fmt->fmt.pix.sizeimage < common->fmt.fmt.pix.sizeimage)
+		return -EINVAL;
+
+	if (vq->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = size;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;
 	alloc_ctxs[0] = common->alloc_ctx;
+
+	/* Calculate the offset for Y and C data  in the buffer */
+	vpif_calculate_offsets(ch);
+
 	return 0;
 }
 
@@ -185,9 +177,6 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ch->field_id = 0;
 	common->started = 1;
 
-	/* Calculate the offset for Y and C data  in the buffer */
-	vpif_calculate_offsets(ch);
-
 	if ((ch->vpifparams.std_info.frm_fmt &&
 		((common->fmt.fmt.pix.field != V4L2_FIELD_NONE)
 		&& (common->fmt.fmt.pix.field != V4L2_FIELD_ANY)))
-- 
1.7.9.5

