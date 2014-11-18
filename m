Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaKRLZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:25:40 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32910 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaKRLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:10 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 08/12] media: blackfin: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:37 +0000
Message-Id: <1416309821-5426-9-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com> 
---
 drivers/media/platform/blackfin/bfin_capture.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index b3345b3..819ec0e 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -349,18 +349,6 @@ static void bcap_buffer_cleanup(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&bcap_dev->lock, flags);
 }
 
-static void bcap_lock(struct vb2_queue *vq)
-{
-	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
-	mutex_lock(&bcap_dev->mutex);
-}
-
-static void bcap_unlock(struct vb2_queue *vq)
-{
-	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
-	mutex_unlock(&bcap_dev->mutex);
-}
-
 static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
@@ -457,8 +445,8 @@ static struct vb2_ops bcap_video_qops = {
 	.buf_prepare            = bcap_buffer_prepare,
 	.buf_cleanup            = bcap_buffer_cleanup,
 	.buf_queue              = bcap_buffer_queue,
-	.wait_prepare           = bcap_unlock,
-	.wait_finish            = bcap_lock,
+	.wait_prepare           = vb2_ops_wait_prepare,
+	.wait_finish            = vb2_ops_wait_finish,
 	.start_streaming        = bcap_start_streaming,
 	.stop_streaming         = bcap_stop_streaming,
 };
@@ -995,6 +983,7 @@ static int bcap_probe(struct platform_device *pdev)
 	q->ops = &bcap_video_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &bcap_dev->mutex;
 
 	ret = vb2_queue_init(q);
 	if (ret)
-- 
1.9.1

