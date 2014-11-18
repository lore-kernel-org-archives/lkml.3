Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaKRL0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:26:32 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62920 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaKRLYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:09 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 07/12] media: s5p-tv: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:36 +0000
Message-Id: <1416309821-5426-8-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index b4d2696..72d4f2e 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -926,22 +926,6 @@ static void buf_queue(struct vb2_buffer *vb)
 	mxr_dbg(mdev, "queuing buffer\n");
 }
 
-static void wait_lock(struct vb2_queue *vq)
-{
-	struct mxr_layer *layer = vb2_get_drv_priv(vq);
-
-	mxr_dbg(layer->mdev, "%s\n", __func__);
-	mutex_lock(&layer->mutex);
-}
-
-static void wait_unlock(struct vb2_queue *vq)
-{
-	struct mxr_layer *layer = vb2_get_drv_priv(vq);
-
-	mxr_dbg(layer->mdev, "%s\n", __func__);
-	mutex_unlock(&layer->mutex);
-}
-
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct mxr_layer *layer = vb2_get_drv_priv(vq);
@@ -1040,8 +1024,8 @@ static void stop_streaming(struct vb2_queue *vq)
 static struct vb2_ops mxr_video_qops = {
 	.queue_setup = queue_setup,
 	.buf_queue = buf_queue,
-	.wait_prepare = wait_unlock,
-	.wait_finish = wait_lock,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
 };
@@ -1122,6 +1106,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 		.ops = &mxr_video_qops,
 		.min_buffers_needed = 1,
 		.mem_ops = &vb2_dma_contig_memops,
+		.lock = &layer->mutex,
 	};
 
 	return layer;
-- 
1.9.1

