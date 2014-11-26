Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaKZWoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:44:03 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58359 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaKZWnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:43:25 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>
Subject: [PATCH v2 09/11] media: s5p-mfc: use vb2_ops_wait_prepare/finish helper
Date: Wed, 26 Nov 2014 22:42:32 +0000
Message-Id: <1417041754-8714-10-git-send-email-prabhakar.csengg@gmail.com>
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
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Jeongtae Park <jtp.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c     |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 20 ++------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 20 ++------------------
 3 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 03204fd..52f65e9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -810,6 +810,7 @@ static int s5p_mfc_open(struct file *file)
 	q = &ctx->vq_dst;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->drv_priv = &ctx->fh;
+	q->lock = &dev->mfc_mutex;
 	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 74bcec8..78b3e0e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -946,22 +946,6 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void s5p_mfc_unlock(struct vb2_queue *q)
-{
-	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mutex_unlock(&dev->mfc_mutex);
-}
-
-static void s5p_mfc_lock(struct vb2_queue *q)
-{
-	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mutex_lock(&dev->mfc_mutex);
-}
-
 static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
@@ -1109,8 +1093,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 
 static struct vb2_ops s5p_mfc_dec_qops = {
 	.queue_setup		= s5p_mfc_queue_setup,
-	.wait_prepare		= s5p_mfc_unlock,
-	.wait_finish		= s5p_mfc_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 	.buf_init		= s5p_mfc_buf_init,
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e7240cb..ffa9c1d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1869,22 +1869,6 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void s5p_mfc_unlock(struct vb2_queue *q)
-{
-	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mutex_unlock(&dev->mfc_mutex);
-}
-
-static void s5p_mfc_lock(struct vb2_queue *q)
-{
-	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mutex_lock(&dev->mfc_mutex);
-}
-
 static int s5p_mfc_buf_init(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
@@ -2054,8 +2038,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 
 static struct vb2_ops s5p_mfc_enc_qops = {
 	.queue_setup		= s5p_mfc_queue_setup,
-	.wait_prepare		= s5p_mfc_unlock,
-	.wait_finish		= s5p_mfc_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 	.buf_init		= s5p_mfc_buf_init,
 	.buf_prepare		= s5p_mfc_buf_prepare,
 	.start_streaming	= s5p_mfc_start_streaming,
-- 
1.9.1

