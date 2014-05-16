Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaEPNhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:06 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51589 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaEPNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:03 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 04/49] media: davinci: vpif_display: release buffers in case start_streaming() call back fails
Date: Fri, 16 May 2014 19:03:09 +0530
Message-Id: <1400247235-31434-6-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_display.c |   42 +++++++++++++++----------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 8bb9f02..1a17a45 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -196,26 +196,16 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct channel_obj *ch = vb2_get_drv_priv(vq);
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
 	/* Initialize field_id and started member */
 	ch->field_id = 0;
 	common->started = 1;
-	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
+
 	/* Calculate the offset for Y and C data  in the buffer */
 	vpif_calculate_offsets(ch);
 
@@ -225,7 +215,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		|| (!ch->vpifparams.std_info.frm_fmt
 		&& (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
 		vpif_err("conflict in field format and std format\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	/* clock settings */
@@ -234,17 +225,28 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
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
 
 	common->started = ret;
 	vpif_config_addr(ch, ret);
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
 	common->set_addr((addr + common->ytop_off),
 			    (addr + common->ybtm_off),
 			    (addr + common->ctop_off),
@@ -271,6 +273,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
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

