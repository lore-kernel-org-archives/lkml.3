Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaDNOwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:52:44 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58977 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaDNOwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:52:42 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: davinci: vpbe: release buffers in case start_streaming call back fails
Date: Mon, 14 Apr 2014 20:22:31 +0530
Message-Id: <1397487151-6185-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support to release the buffer by calling
vb2_buffer_done(), with state marked as VB2_BUF_STATE_QUEUED
if start_streaming() call back fails.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index a9ad949..c8403ab 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -355,8 +355,17 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	/* Set parameters in OSD and VENC */
 	ret = vpbe_set_osd_display_params(fh->disp_dev, layer);
-	if (ret < 0)
+	if (ret < 0) {
+		struct vpbe_disp_buffer *buf, *tmp;
+
+		vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+		list_for_each_entry_safe(buf, tmp, &layer->dma_queue, list) {
+			list_del(&buf->list);
+			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+		}
+
 		return ret;
+	}
 
 	/*
 	 * if request format is yuv420 semiplanar, need to
-- 
1.7.9.5

