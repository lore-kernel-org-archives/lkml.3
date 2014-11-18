Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaKRLYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:24:05 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60930 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaKRLYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:01 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 01/12] media: s3c-camif: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:30 +0000
Message-Id: <1416309821-5426-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index aa40c82..54479d6 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -536,24 +536,12 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&camif->slock, flags);
 }
 
-static void camif_lock(struct vb2_queue *vq)
-{
-	struct camif_vp *vp = vb2_get_drv_priv(vq);
-	mutex_lock(&vp->camif->lock);
-}
-
-static void camif_unlock(struct vb2_queue *vq)
-{
-	struct camif_vp *vp = vb2_get_drv_priv(vq);
-	mutex_unlock(&vp->camif->lock);
-}
-
 static const struct vb2_ops s3c_camif_qops = {
 	.queue_setup	 = queue_setup,
 	.buf_prepare	 = buffer_prepare,
 	.buf_queue	 = buffer_queue,
-	.wait_prepare	 = camif_unlock,
-	.wait_finish	 = camif_lock,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = start_streaming,
 	.stop_streaming	 = stop_streaming,
 };
@@ -1161,6 +1149,7 @@ int s3c_camif_register_video_node(struct camif_dev *camif, int idx)
 	q->buf_struct_size = sizeof(struct camif_buffer);
 	q->drv_priv = vp;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &vp->camif->lock;
 
 	ret = vb2_queue_init(q);
 	if (ret)
-- 
1.9.1

