Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaKRLYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:24:10 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44740 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaKRLYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:07 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 05/12] media: sh_veu: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:34 +0000
Message-Id: <1416309821-5426-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

