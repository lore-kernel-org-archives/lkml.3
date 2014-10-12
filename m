Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaJLUlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:41:00 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64961 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaJLUk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:40:57 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 03/15] media: davinci: vpbe: use vb2_ops_wait_prepare/finish helper functions
Date: Sun, 12 Oct 2014 21:40:33 +0100
Message-Id: <1413146445-7304-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch makes use of vb2_ops_wait_prepare/finish helper functions.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index e2bda17..6f9599d 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -308,20 +308,6 @@ static void vpbe_buf_cleanup(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&layer->irqlock, flags);
 }
 
-static void vpbe_wait_prepare(struct vb2_queue *vq)
-{
-	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&layer->opslock);
-}
-
-static void vpbe_wait_finish(struct vb2_queue *vq)
-{
-	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
-
-	mutex_lock(&layer->opslock);
-}
-
 static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vpbe_layer *layer = vb2_get_drv_priv(vq);
@@ -394,8 +380,8 @@ static void vpbe_stop_streaming(struct vb2_queue *vq)
 
 static struct vb2_ops video_qops = {
 	.queue_setup = vpbe_buffer_queue_setup,
-	.wait_prepare = vpbe_wait_prepare,
-	.wait_finish = vpbe_wait_finish,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 	.buf_prepare = vpbe_buffer_prepare,
 	.start_streaming = vpbe_start_streaming,
 	.stop_streaming = vpbe_stop_streaming,
@@ -1749,7 +1735,7 @@ static int vpbe_display_probe(struct platform_device *pdev)
 		q->buf_struct_size = sizeof(struct vpbe_disp_buffer);
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 1;
-
+		q->lock = &disp_dev->dev[i]->opslock;
 		err = vb2_queue_init(q);
 		if (err) {
 			v4l2_err(v4l2_dev, "vb2_queue_init() failed\n");
-- 
1.9.1

