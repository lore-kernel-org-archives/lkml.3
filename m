Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaKRLYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:24:13 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37385 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaKRLYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:24:05 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Josh Wu <josh.wu@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 04/12] media: soc_camera: use vb2_ops_wait_prepare/finish helper
Date: Tue, 18 Nov 2014 11:23:33 +0000
Message-Id: <1416309821-5426-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/atmel-isi.c            |  7 +++++--
 drivers/media/platform/soc_camera/mx3_camera.c           |  7 +++++--
 drivers/media/platform/soc_camera/rcar_vin.c             |  7 +++++--
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  7 +++++--
 drivers/media/platform/soc_camera/soc_camera.c           | 16 ----------------
 5 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index ee5650f..6306ba5 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -455,8 +455,8 @@ static struct vb2_ops isi_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
-	.wait_prepare		= soc_camera_unlock,
-	.wait_finish		= soc_camera_lock,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /* ------------------------------------------------------------------
@@ -465,6 +465,8 @@ static struct vb2_ops isi_video_qops = {
 static int isi_camera_init_videobuf(struct vb2_queue *q,
 				     struct soc_camera_device *icd)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP;
 	q->drv_priv = icd;
@@ -472,6 +474,7 @@ static int isi_camera_init_videobuf(struct vb2_queue *q,
 	q->ops = &isi_video_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &ici->host_lock;
 
 	return vb2_queue_init(q);
 }
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 8e52ccc..1000c2e 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -435,14 +435,16 @@ static struct vb2_ops mx3_videobuf_ops = {
 	.buf_queue	= mx3_videobuf_queue,
 	.buf_cleanup	= mx3_videobuf_release,
 	.buf_init	= mx3_videobuf_init,
-	.wait_prepare	= soc_camera_unlock,
-	.wait_finish	= soc_camera_lock,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
 	.stop_streaming	= mx3_stop_streaming,
 };
 
 static int mx3_camera_init_videobuf(struct vb2_queue *q,
 				     struct soc_camera_device *icd)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = icd;
@@ -450,6 +452,7 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mx3_camera_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &ici->host_lock;
 
 	return vb2_queue_init(q);
 }
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 8d8438b..724e239 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -535,8 +535,8 @@ static struct vb2_ops rcar_vin_vb2_ops = {
 	.buf_cleanup	= rcar_vin_videobuf_release,
 	.buf_queue	= rcar_vin_videobuf_queue,
 	.stop_streaming	= rcar_vin_stop_streaming,
-	.wait_prepare	= soc_camera_unlock,
-	.wait_finish	= soc_camera_lock,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
 };
 
 static irqreturn_t rcar_vin_irq(int irq, void *data)
@@ -1364,6 +1364,8 @@ static int rcar_vin_querycap(struct soc_camera_host *ici,
 static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
 				   struct soc_camera_device *icd)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	vq->drv_priv = icd;
@@ -1371,6 +1373,7 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
 	vq->mem_ops = &vb2_dma_contig_memops;
 	vq->buf_struct_size = sizeof(struct rcar_vin_buffer);
 	vq->timestamp_flags  = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	vq->lock = &ici->host_lock;
 
 	return vb2_queue_init(vq);
 }
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 5f58ed9..d92b746 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -496,8 +496,8 @@ static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 	.buf_queue	= sh_mobile_ceu_videobuf_queue,
 	.buf_cleanup	= sh_mobile_ceu_videobuf_release,
 	.buf_init	= sh_mobile_ceu_videobuf_init,
-	.wait_prepare	= soc_camera_unlock,
-	.wait_finish	= soc_camera_lock,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
 	.stop_streaming	= sh_mobile_ceu_stop_streaming,
 };
 
@@ -1659,6 +1659,8 @@ static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
 static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 				       struct soc_camera_device *icd)
 {
+	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_USERPTR;
 	q->drv_priv = icd;
@@ -1666,6 +1668,7 @@ static int sh_mobile_ceu_init_videobuf(struct vb2_queue *q,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct sh_mobile_ceu_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock = &ici->host_lock;
 
 	return vb2_queue_init(q);
 }
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4be2a1..5aad197 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -843,22 +843,6 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	return res;
 }
 
-void soc_camera_lock(struct vb2_queue *vq)
-{
-	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	mutex_lock(&ici->host_lock);
-}
-EXPORT_SYMBOL(soc_camera_lock);
-
-void soc_camera_unlock(struct vb2_queue *vq)
-{
-	struct soc_camera_device *icd = vb2_get_drv_priv(vq);
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
-	mutex_unlock(&ici->host_lock);
-}
-EXPORT_SYMBOL(soc_camera_unlock);
-
 static struct v4l2_file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
-- 
1.9.1

