Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaLSNwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:52:42 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53945 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaLSNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:52:40 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2] media: ti-vpe: Use mem-to-mem ioctl helpers
Date: Fri, 19 Dec 2014 19:22:04 +0530
Message-Id: <1418997124-28426-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1: Simplify the vpe mem-to-mem driver by using the m2m ioctl
   and vb2 helpers.
2: Align and arranged the v4l2_ioctl_ops.
3: Fixes a typo.
4: Use of_match_ptr() instead of explicitly defining the macro
   to NULL in case CONFIG_OF is not defined.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Note:-
 1: This patch is on top of https://patchwork.linuxtv.org/patch/27161/
 2: Compile tested only.
 
 drivers/media/platform/ti-vpe/vpe.c | 157 ++++++++++++------------------------
 1 file changed, 50 insertions(+), 107 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d5d745d..7d2564c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -25,6 +25,7 @@
 #include <linux/io.h>
 #include <linux/ioctl.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/sched.h>
@@ -74,7 +75,7 @@
 #define VPE_DEF_BUFS_PER_JOB	1	/* default one buffer per batch job */
 
 /*
- * each VPE context can need up to 3 config desciptors, 7 input descriptors,
+ * each VPE context can need up to 3 config descriptors, 7 input descriptors,
  * 3 output descriptors, and 10 control descriptors
  */
 #define VPE_DESC_LIST_SIZE	(10 * VPDMA_DTD_DESC_SIZE +	\
@@ -373,7 +374,6 @@ struct vpe_dev {
 struct vpe_ctx {
 	struct v4l2_fh		fh;
 	struct vpe_dev		*dev;
-	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct v4l2_ctrl_handler hdl;
 
 	unsigned int		field;			/* current field */
@@ -887,10 +887,10 @@ static int job_ready(void *priv)
 	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL)
 		needed += 2;	/* need additional two most recent fields */
 
-	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) < needed)
+	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < needed)
 		return 0;
 
-	if (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) < needed)
+	if (v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < needed)
 		return 0;
 
 	return 1;
@@ -1100,15 +1100,15 @@ static void device_run(void *priv)
 	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
 
 	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL) {
-		ctx->src_vbs[2] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		ctx->src_vbs[2] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		WARN_ON(ctx->src_vbs[2] == NULL);
-		ctx->src_vbs[1] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		ctx->src_vbs[1] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		WARN_ON(ctx->src_vbs[1] == NULL);
 	}
 
-	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	WARN_ON(ctx->src_vbs[0] == NULL);
-	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	WARN_ON(ctx->dst_vb == NULL);
 
 	/* config descriptors */
@@ -1334,7 +1334,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 finished:
 	vpe_dbg(ctx->dev, "finishing transaction\n");
 	ctx->bufs_completed = 0;
-	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
+	v4l2_m2m_job_finish(dev->m2m_dev, ctx->fh.m2m_ctx);
 handled:
 	return IRQ_HANDLED;
 }
@@ -1395,7 +1395,7 @@ static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct vpe_q_data *q_data;
 	int i;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
@@ -1527,7 +1527,7 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	int i;
 
-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;
 
@@ -1739,52 +1739,6 @@ static int vpe_s_selection(struct file *file, void *fh,
 	return set_srcdst_params(ctx);
 }
 
-static int vpe_reqbufs(struct file *file, void *priv,
-		       struct v4l2_requestbuffers *reqbufs)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
-}
-
-static int vpe_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vpe_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vpe_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
-}
-
-static int vpe_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
-
-static int vpe_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-
-	vpe_dump_regs(ctx->dev);
-	vpdma_dump_regs(ctx->dev->vpdma);
-
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
-
 /*
  * defines number of buffers/frames a context can process with VPE before
  * switching to a different context. default value is 1 buffer per context
@@ -1814,14 +1768,14 @@ static const struct v4l2_ctrl_ops vpe_ctrl_ops = {
 };
 
 static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
-	.vidioc_querycap	= vpe_querycap,
+	.vidioc_querycap		= vpe_querycap,
 
-	.vidioc_enum_fmt_vid_cap_mplane = vpe_enum_fmt,
+	.vidioc_enum_fmt_vid_cap_mplane	= vpe_enum_fmt,
 	.vidioc_g_fmt_vid_cap_mplane	= vpe_g_fmt,
 	.vidioc_try_fmt_vid_cap_mplane	= vpe_try_fmt,
 	.vidioc_s_fmt_vid_cap_mplane	= vpe_s_fmt,
 
-	.vidioc_enum_fmt_vid_out_mplane = vpe_enum_fmt,
+	.vidioc_enum_fmt_vid_out_mplane	= vpe_enum_fmt,
 	.vidioc_g_fmt_vid_out_mplane	= vpe_g_fmt,
 	.vidioc_try_fmt_vid_out_mplane	= vpe_try_fmt,
 	.vidioc_s_fmt_vid_out_mplane	= vpe_s_fmt,
@@ -1829,16 +1783,15 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 	.vidioc_g_selection		= vpe_g_selection,
 	.vidioc_s_selection		= vpe_s_selection,
 
-	.vidioc_reqbufs		= vpe_reqbufs,
-	.vidioc_querybuf	= vpe_querybuf,
+	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
+	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
+	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
+	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
-	.vidioc_qbuf		= vpe_qbuf,
-	.vidioc_dqbuf		= vpe_dqbuf,
-
-	.vidioc_streamon	= vpe_streamon,
-	.vidioc_streamoff	= vpe_streamoff,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 /*
@@ -1910,7 +1863,23 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
 static void vpe_buf_queue(struct vb2_buffer *vb)
 {
 	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+
+	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
+}
+
+static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	/* currently we do nothing here */
+
+	return 0;
+}
+
+static void vpe_stop_streaming(struct vb2_queue *q)
+{
+	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
+
+	vpe_dump_regs(ctx->dev);
+	vpdma_dump_regs(ctx->dev->vpdma);
 }
 
 static struct vb2_ops vpe_qops = {
@@ -1919,6 +1888,8 @@ static struct vb2_ops vpe_qops = {
 	.buf_queue	 = vpe_buf_queue,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
+	.start_streaming = vpe_start_streaming,
+	.stop_streaming  = vpe_stop_streaming,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
@@ -1972,9 +1943,9 @@ static const struct v4l2_ctrl_config vpe_bufs_per_job = {
 static int vpe_open(struct file *file)
 {
 	struct vpe_dev *dev = video_drvdata(file);
-	struct vpe_ctx *ctx = NULL;
 	struct vpe_q_data *s_q_data;
 	struct v4l2_ctrl_handler *hdl;
+	struct vpe_ctx *ctx;
 	int ret;
 
 	vpe_dbg(dev, "vpe_open\n");
@@ -2047,10 +2018,10 @@ static int vpe_open(struct file *file)
 	if (ret)
 		goto exit_fh;
 
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
+	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
 
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
+	if (IS_ERR(ctx->fh.m2m_ctx)) {
+		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		goto exit_fh;
 	}
 
@@ -2069,7 +2040,7 @@ static int vpe_open(struct file *file)
 	ctx->load_mmrs = true;
 
 	vpe_dbg(dev, "created instance %p, m2m_ctx: %p\n",
-		ctx, ctx->m2m_ctx);
+		ctx, ctx->fh.m2m_ctx);
 
 	mutex_unlock(&dev->dev_mutex);
 
@@ -2107,7 +2078,7 @@ static int vpe_release(struct file *file)
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->hdl);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
 	kfree(ctx);
 
@@ -2124,39 +2095,13 @@ static int vpe_release(struct file *file)
 	return 0;
 }
 
-static unsigned int vpe_poll(struct file *file,
-			     struct poll_table_struct *wait)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-	struct vpe_dev *dev = ctx->dev;
-	int ret;
-
-	mutex_lock(&dev->dev_mutex);
-	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&dev->dev_mutex);
-	return ret;
-}
-
-static int vpe_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct vpe_ctx *ctx = file2ctx(file);
-	struct vpe_dev *dev = ctx->dev;
-	int ret;
-
-	if (mutex_lock_interruptible(&dev->dev_mutex))
-		return -ERESTARTSYS;
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&dev->dev_mutex);
-	return ret;
-}
-
 static const struct v4l2_file_operations vpe_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vpe_open,
 	.release	= vpe_release,
-	.poll		= vpe_poll,
+	.poll		= v4l2_m2m_fop_poll,
 	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= vpe_mmap,
+	.mmap		= v4l2_m2m_fop_mmap,
 };
 
 static struct video_device vpe_videodev = {
@@ -2358,8 +2303,6 @@ static const struct of_device_id vpe_of_match[] = {
 	},
 	{},
 };
-#else
-#define vpe_of_match NULL
 #endif
 
 static struct platform_driver vpe_pdrv = {
@@ -2368,7 +2311,7 @@ static struct platform_driver vpe_pdrv = {
 	.driver		= {
 		.name	= VPE_MODULE_NAME,
 		.owner	= THIS_MODULE,
-		.of_match_table = vpe_of_match,
+		.of_match_table = of_match_ptr(vpe_of_match),
 	},
 };
 
-- 
1.9.1

