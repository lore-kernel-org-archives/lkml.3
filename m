Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaJLUoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:44:16 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62706 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaJLUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:59 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 05/15] media: davinci: vpbe: improve vpbe_buffer_prepare() callback
Date: Sun, 12 Oct 2014 21:40:35 +0100
Message-Id: <1413146445-7304-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch improve vpbe_buffer_prepare() callback, as buf_prepare()
callback is never called with invalid state and check for
vb2_plane_vaddr(vb, 0) is dropped as payload check should
be done unconditionally.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 491b832..524e1fd 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -215,22 +215,15 @@ static int vpbe_buffer_prepare(struct vb2_buffer *vb)
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
 				"vpbe_buffer_prepare\n");
 
-	if (vb->state != VB2_BUF_STATE_ACTIVE &&
-		vb->state != VB2_BUF_STATE_PREPARED) {
-		vb2_set_plane_payload(vb, 0, layer->pix_fmt.sizeimage);
-		if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			return -EINVAL;
+	vb2_set_plane_payload(vb, 0, layer->pix_fmt.sizeimage);
+	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
 
-		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
-		if (q->streaming) {
-			if (!IS_ALIGNED(addr, 8)) {
-				v4l2_err(&vpbe_dev->v4l2_dev,
-					"buffer_prepare:offset is \
-					not aligned to 32 bytes\n");
-				return -EINVAL;
-			}
-		}
+	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (!IS_ALIGNED(addr, 8)) {
+		v4l2_err(&vpbe_dev->v4l2_dev,
+			 "buffer_prepare:offset is not aligned to 32 bytes\n");
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
1.9.1

