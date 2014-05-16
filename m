Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbaEPNln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:41:43 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50911 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaEPNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:41:40 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 31/49] media: davinci: vpif_capture: improve vpif_buffer_prepare() callback
Date: Fri, 16 May 2014 19:03:37 +0530
Message-Id: <1400247235-31434-34-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   32 +++++++++++--------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 6c5ff0f..025eb24 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -79,7 +79,7 @@ static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
 }
 
 /**
- * buffer_prepare :  callback function for buffer prepare
+ * vpif_buffer_prepare :  callback function for buffer prepare
  * @vb: ptr to vb2_buffer
  *
  * This is the callback function for buffer prepare when vb2_qbuf()
@@ -97,26 +97,22 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
 
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	if (vb->state != VB2_BUF_STATE_ACTIVE &&
-		vb->state != VB2_BUF_STATE_PREPARED) {
-		vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
-		if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			goto exit;
-		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	vb2_set_plane_payload(vb, 0, common->fmt.fmt.pix.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
 
-		if (q->streaming) {
-			if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
-				!IS_ALIGNED((addr + common->ybtm_off), 8) ||
-				!IS_ALIGNED((addr + common->ctop_off), 8) ||
-				!IS_ALIGNED((addr + common->cbtm_off), 8))
-				goto exit;
-		}
+	vb->v4l2_buf.field = common->fmt.fmt.pix.field;
+
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
+		!IS_ALIGNED((addr + common->ybtm_off), 8) ||
+		!IS_ALIGNED((addr + common->ctop_off), 8) ||
+		!IS_ALIGNED((addr + common->cbtm_off), 8)) {
+		vpif_dbg(1, debug, "offset is not aligned\n");
+		return -EINVAL;
 	}
+
 	return 0;
-exit:
-	vpif_dbg(1, debug, "buffer_prepare:offset is not aligned to 8 bytes\n");
-	return -EINVAL;
 }
 
 /**
-- 
1.7.9.5

