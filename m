Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaEPNlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:35 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56207 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbaEPNla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:30 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 29/49] media: davinci: vpif_capture: release buffers in case start_streaming() call back fails
Date: Fri, 16 May 2014 19:03:35 +0530
Message-Id: <1400247235-31434-32-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support to release the buffer by calling
vb2_buffer_done(), with state marked as VB2_BUF_STATE_QUEUED
if start_streaming() call back fails.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   39 ++++++++++++++++---------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 8572efe..fd384d0 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -231,24 +231,15 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	struct vpif_params *vpif = &ch->vpifparams;
-	unsigned long addr = 0;
-	unsigned long flags;
+	struct vpif_cap_buffer *buf, *tmp;
+	unsigned long addr, flags;
 	int ret;
 
 	spin_lock_irqsave(&common->irqlock, flags);
 
-	/* Get the next frame from the buffer queue */
-	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
-				    struct vpif_cap_buffer, list);
-	/* Remove buffer from the buffer queue */
-	list_del(&common->cur_frm->list);
-	spin_unlock_irqrestore(&common->irqlock, flags);
-	/* Mark state of the current frame to active */
-	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
 	/* Initialize field_id and started member */
 	ch->field_id = 0;
 	common->started = 1;
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
 
 	/* Calculate the offset for Y and C data in the buffer */
 	vpif_calculate_offsets(ch);
@@ -259,7 +250,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	    (!vpif->std_info.frm_fmt &&
 	     (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
 		vpif_dbg(1, debug, "conflict in field format and std format\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	/* configure 1 or 2 channel mode */
@@ -268,7 +260,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 			setup_input_channel_mode(vpif->std_info.ycmux_mode);
 		if (ret < 0) {
 			vpif_dbg(1, debug, "can't set vpif channel mode\n");
-			return ret;
+			goto err;
 		}
 	}
 
@@ -277,12 +269,23 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	if (ret < 0) {
 		vpif_dbg(1, debug, "can't set video params\n");
-		return ret;
+		goto err;
 	}
 
 	common->started = ret;
 	vpif_config_addr(ch, ret);
 
+	/* Get the next frame from the buffer queue */
+	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
+				    struct vpif_cap_buffer, list);
+	/* Remove buffer from the buffer queue */
+	list_del(&common->cur_frm->list);
+	spin_unlock_irqrestore(&common->irqlock, flags);
+	/* Mark state of the current frame to active */
+	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
+
+	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+
 	common->set_addr(addr + common->ytop_off,
 			 addr + common->ybtm_off,
 			 addr + common->ctop_off,
@@ -306,6 +309,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
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
-- 
1.7.9.5

