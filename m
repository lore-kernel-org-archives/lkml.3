Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaKZWpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:45:35 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59946 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaKZWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:43:19 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH v2 05/11] media: sh_veu: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 22:42:28 +0000
Message-Id: <1417041754-8714-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
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
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/sh_veu.c | 35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index be3b3bc..7884117 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -242,20 +242,6 @@ static void sh_veu_job_abort(void *priv)
 	veu->aborting = true;
 }
 
-static void sh_veu_lock(void *priv)
-{
-	struct sh_veu_dev *veu = priv;
-
-	mutex_lock(&veu->fop_lock);
-}
-
-static void sh_veu_unlock(void *priv)
-{
-	struct sh_veu_dev *veu = priv;
-
-	mutex_unlock(&veu->fop_lock);
-}
-
 static void sh_veu_process(struct sh_veu_dev *veu,
 			   struct vb2_buffer *src_buf,
 			   struct vb2_buffer *dst_buf)
@@ -950,36 +936,28 @@ static void sh_veu_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(veu->m2m_ctx, vb);
 }
 
-static void sh_veu_wait_prepare(struct vb2_queue *q)
-{
-	sh_veu_unlock(vb2_get_drv_priv(q));
-}
-
-static void sh_veu_wait_finish(struct vb2_queue *q)
-{
-	sh_veu_lock(vb2_get_drv_priv(q));
-}
-
 static const struct vb2_ops sh_veu_qops = {
 	.queue_setup	 = sh_veu_queue_setup,
 	.buf_prepare	 = sh_veu_buf_prepare,
 	.buf_queue	 = sh_veu_buf_queue,
-	.wait_prepare	 = sh_veu_wait_prepare,
-	.wait_finish	 = sh_veu_wait_finish,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 			     struct vb2_queue *dst_vq)
 {
+	struct sh_veu_dev *veu = priv;
 	int ret;
 
 	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
-	src_vq->drv_priv = priv;
+	src_vq->drv_priv = veu;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &sh_veu_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->lock = &veu->fop_lock;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret < 0)
@@ -988,10 +966,11 @@ static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
 	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
-	dst_vq->drv_priv = priv;
+	dst_vq->drv_priv = veu;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &sh_veu_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->lock = &veu->fop_lock;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
1.9.1

