Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaKRL1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:27:30 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51488 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaKRLYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:02 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 02/12] media: ti-vpe: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:31 +0000
Message-Id: <1416309821-5426-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 9a081c2..d5d745d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1913,30 +1913,19 @@ static void vpe_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
-static void vpe_wait_prepare(struct vb2_queue *q)
-{
-	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
-	vpe_unlock(ctx);
-}
-
-static void vpe_wait_finish(struct vb2_queue *q)
-{
-	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
-	vpe_lock(ctx);
-}
-
 static struct vb2_ops vpe_qops = {
 	.queue_setup	 = vpe_queue_setup,
 	.buf_prepare	 = vpe_buf_prepare,
 	.buf_queue	 = vpe_buf_queue,
-	.wait_prepare	 = vpe_wait_prepare,
-	.wait_finish	 = vpe_wait_finish,
+	.wait_prepare	 = vb2_ops_wait_prepare,
+	.wait_finish	 = vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
 		      struct vb2_queue *dst_vq)
 {
 	struct vpe_ctx *ctx = priv;
+	struct vpe_dev *dev = ctx->dev;
 	int ret;
 
 	memset(src_vq, 0, sizeof(*src_vq));
@@ -1947,6 +1936,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &vpe_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	src_vq->lock = &dev->dev_mutex;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1960,6 +1950,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &vpe_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	dst_vq->lock = &dev->dev_mutex;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
1.9.1

