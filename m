Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaKZX0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:26:01 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55994 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaKZXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:25:59 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v3] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 23:25:44 +0000
Message-Id: <1417044344-20611-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch drops driver specific wait_prepare() and
wait_finish() callbacks from vb2_ops and instead uses
the the helpers vb2_ops_wait_prepare/finish() provided
by the vb2 core, the lock member of the queue needs
to be initalized to a mutex so that vb2 helpers
vb2_ops_wait_prepare/finish() can make use of it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cc96072..10c554e 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -143,20 +143,6 @@ static void uvc_buffer_finish(struct vb2_buffer *vb)
 		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
 }
 
-static void uvc_wait_prepare(struct vb2_queue *vq)
-{
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&queue->mutex);
-}
-
-static void uvc_wait_finish(struct vb2_queue *vq)
-{
-	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-
-	mutex_lock(&queue->mutex);
-}
-
 static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
@@ -195,8 +181,8 @@ static struct vb2_ops uvc_queue_qops = {
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
 	.buf_finish = uvc_buffer_finish,
-	.wait_prepare = uvc_wait_prepare,
-	.wait_finish = uvc_wait_finish,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = uvc_start_streaming,
 	.stop_streaming = uvc_stop_streaming,
 };
@@ -214,6 +200,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
 		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
+	queue->queue.lock = &queue->mutex;
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
-- 
1.9.1

