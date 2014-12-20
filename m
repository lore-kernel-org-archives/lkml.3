Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaLTKus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:50:48 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46357 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaLTKsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:36 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 08/15] media: blackfin: bfin_capture: use vb2_ioctl_* helpers
Date: Sat, 20 Dec 2014 16:17:35 +0530
Message-Id: <1419072462-3168-9-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support to vb2_ioctl_* helpers.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 107 +++++--------------------
 1 file changed, 22 insertions(+), 85 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 30f1fe0..80a0efc 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -272,15 +272,28 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct ppi_if *ppi = bcap_dev->ppi;
 	struct bcap_buffer *buf, *tmp;
 	struct ppi_params params;
+	dma_addr_t addr;
 	int ret;
 
 	/* enable streamon on the sub device */
 	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
 	if (ret && (ret != -ENOIOCTLCMD)) {
 		v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
+		bcap_dev->cur_frm = NULL;
 		goto err;
 	}
 
+	/* get the next frame from the dma queue */
+	bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
+					struct bcap_buffer, list);
+	/* remove buffer from the dma queue */
+	list_del_init(&bcap_dev->cur_frm->list);
+	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
+	/* update DMA address */
+	ppi->ops->update_addr(ppi, (unsigned long)addr);
+	/* enable ppi */
+	ppi->ops->start(ppi);
+
 	/* set ppi params */
 	params.width = bcap_dev->fmt.width;
 	params.height = bcap_dev->fmt.height;
@@ -334,6 +347,9 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	return 0;
 
 err:
+	if (bcap_dev->cur_frm)
+		vb2_buffer_done(&bcap_dev->cur_frm->vb, VB2_BUF_STATE_QUEUED);
+
 	list_for_each_entry_safe(buf, tmp, &bcap_dev->dma_queue, list) {
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
@@ -377,40 +393,6 @@ static struct vb2_ops bcap_video_qops = {
 	.stop_streaming         = bcap_stop_streaming,
 };
 
-static int bcap_reqbufs(struct file *file, void *priv,
-			struct v4l2_requestbuffers *req_buf)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct vb2_queue *vq = &bcap_dev->buffer_queue;
-
-	return vb2_reqbufs(vq, req_buf);
-}
-
-static int bcap_querybuf(struct file *file, void *priv,
-				struct v4l2_buffer *buf)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return vb2_querybuf(&bcap_dev->buffer_queue, buf);
-}
-
-static int bcap_qbuf(struct file *file, void *priv,
-			struct v4l2_buffer *buf)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return vb2_qbuf(&bcap_dev->buffer_queue, buf);
-}
-
-static int bcap_dqbuf(struct file *file, void *priv,
-			struct v4l2_buffer *buf)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return vb2_dqbuf(&bcap_dev->buffer_queue,
-				buf, file->f_flags & O_NONBLOCK);
-}
-
 static irqreturn_t bcap_isr(int irq, void *dev_id)
 {
 	struct ppi_if *ppi = dev_id;
@@ -452,51 +434,6 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int bcap_streamon(struct file *file, void *priv,
-				enum v4l2_buf_type buf_type)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct ppi_if *ppi = bcap_dev->ppi;
-	dma_addr_t addr;
-	int ret;
-
-	/* call streamon to start streaming in videobuf */
-	ret = vb2_streamon(&bcap_dev->buffer_queue, buf_type);
-	if (ret)
-		return ret;
-
-	/* if dma queue is empty, return error */
-	if (list_empty(&bcap_dev->dma_queue)) {
-		v4l2_err(&bcap_dev->v4l2_dev, "dma queue is empty\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	/* get the next frame from the dma queue */
-	bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
-					struct bcap_buffer, list);
-	/* remove buffer from the dma queue */
-	list_del_init(&bcap_dev->cur_frm->list);
-	addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
-	/* update DMA address */
-	ppi->ops->update_addr(ppi, (unsigned long)addr);
-	/* enable ppi */
-	ppi->ops->start(ppi);
-
-	return 0;
-err:
-	vb2_streamoff(&bcap_dev->buffer_queue, buf_type);
-	return ret;
-}
-
-static int bcap_streamoff(struct file *file, void *priv,
-				enum v4l2_buf_type buf_type)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-
-	return vb2_streamoff(&bcap_dev->buffer_queue, buf_type);
-}
-
 static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
@@ -782,12 +719,12 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_g_dv_timings     = bcap_g_dv_timings,
 	.vidioc_query_dv_timings = bcap_query_dv_timings,
 	.vidioc_enum_dv_timings  = bcap_enum_dv_timings,
-	.vidioc_reqbufs          = bcap_reqbufs,
-	.vidioc_querybuf         = bcap_querybuf,
-	.vidioc_qbuf             = bcap_qbuf,
-	.vidioc_dqbuf            = bcap_dqbuf,
-	.vidioc_streamon         = bcap_streamon,
-	.vidioc_streamoff        = bcap_streamoff,
+	.vidioc_reqbufs          = vb2_ioctl_reqbufs,
+	.vidioc_querybuf         = vb2_ioctl_querybuf,
+	.vidioc_qbuf             = vb2_ioctl_qbuf,
+	.vidioc_dqbuf            = vb2_ioctl_dqbuf,
+	.vidioc_streamon         = vb2_ioctl_streamon,
+	.vidioc_streamoff        = vb2_ioctl_streamoff,
 	.vidioc_g_parm           = bcap_g_parm,
 	.vidioc_s_parm           = bcap_s_parm,
 	.vidioc_log_status       = bcap_log_status,
-- 
1.9.1

