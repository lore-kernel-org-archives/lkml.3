Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaEPNhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62174 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbaEPNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:30 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 06/49] media: davinci: vpif_display: improve vpif_buffer_prepare() callback
Date: Fri, 16 May 2014 19:03:11 +0530
Message-Id: <1400247235-31434-8-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch improve vpif_buffer_prepare() callback, as buf_prepare()
callback is never called with invalid state and check for
vb2_plane_vaddr(vb, 0) is dropped as payload check should
be done unconditionally.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   47 ++++++++++++-------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 9999b9c..1c518de 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -67,41 +67,40 @@ static struct device *vpif_dev;
 static void vpif_calculate_offsets(struct channel_obj *ch);
 static void vpif_config_addr(struct channel_obj *ch, int muxmode);
 
-/*
- * buffer_prepare: This is the callback function called from vb2_qbuf()
- * function the buffer is prepared and user space virtual address is converted
- * into physical address
+/**
+ * vpif_buffer_prepare :  callback function for buffer prepare
+ * @vb: ptr to vb2_buffer
+ *
+ * This is the callback function for buffer prepare when vb2_qbuf()
+ * function is called. The buffer is prepared and user space virtual address
+ * or user address is converted into  physical address
  */
 static int vpif_buffer_prepare(struct vb2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
-	struct channel_obj *ch = vb2_get_drv_priv(q);
+	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
 	struct common_obj *common;
-	unsigned long addr;
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
-	if (vb->state != VB2_BUF_STATE_ACTIVE &&
-		vb->state != VB2_BUF_STATE_PREPARED) {
-		vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
-		if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			goto buf_align_exit;
-
-		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
-		if (q->streaming &&
-			(V4L2_BUF_TYPE_SLICED_VBI_OUTPUT != q->type)) {
-			if (!ISALIGNED(addr + common->ytop_off) ||
+
+	vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
+
+	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+
+	if (vb->vb2_queue->type != V4L2_BUF_TYPE_SLICED_VBI_OUTPUT) {
+		unsigned long addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+		if (!ISALIGNED(addr + common->ytop_off) ||
 			!ISALIGNED(addr + common->ybtm_off) ||
 			!ISALIGNED(addr + common->ctop_off) ||
-			!ISALIGNED(addr + common->cbtm_off))
-				goto buf_align_exit;
+			!ISALIGNED(addr + common->cbtm_off)) {
+			vpif_err("buffer offset not aligned to 8 bytes\n");
+			return -EINVAL;
 		}
 	}
-	return 0;
 
-buf_align_exit:
-	vpif_err("buffer offset not aligned to 8 bytes\n");
-	return -EINVAL;
+	return 0;
 }
 
 /*
-- 
1.7.9.5

