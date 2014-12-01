Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaLALXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:23:46 -0500
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53899 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbaLALXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:23:44 -0500
Message-ID: <547C4FB0.6030409@xs4all.nl>
Date: Mon, 01 Dec 2014 12:23:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>, Archit Taneja <archit@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: ti-vpe: Use mem-to-mem ioctl helpers
References: <1416315613-24446-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1416315613-24446-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 02:00 PM, Lad, Prabhakar wrote:
> This patch does the following:
> 
> 1: Simplify the vpe mem-to-mem driver by using the m2m ioctl
>    and vb2 helpers.
> 2: Minor code cleanup

FYI: I want to postpone this patch until Nikhil's ti-vpe changes are in (assuming
that will happen soon). I think his series conflicts with this, and it is likely
to be easier for you to rebase once his code is in.

Regards,

	Hans

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c | 152 +++++++++++-------------------------
>  1 file changed, 47 insertions(+), 105 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 74b858d..faf38d4 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -21,6 +21,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/err.h>
>  #include <linux/fs.h>
> +#include <linux/of.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
>  #include <linux/ioctl.h>
> @@ -377,7 +378,6 @@ struct vpe_dev {
>  struct vpe_ctx {
>  	struct v4l2_fh		fh;
>  	struct vpe_dev		*dev;
> -	struct v4l2_m2m_ctx	*m2m_ctx;
>  	struct v4l2_ctrl_handler hdl;
>  
>  	unsigned int		field;			/* current field */
> @@ -916,8 +916,8 @@ static int job_ready(void *priv)
>  	 * When called by m2m framework, this will always satisy, but when
>  	 * called from vpe_irq, this might fail. (src stream with zero buffers)
>  	 */
> -	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) <= 0 ||
> -		v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) <= 0)
> +	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) <= 0 ||
> +		v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) <= 0)
>  		return 0;
>  
>  	return 1;
> @@ -1155,14 +1155,14 @@ static void device_run(void *priv)
>  		 * in the same buffer. (so that job_ready won't fail)
>  		 * It will be removed when using bottom field
>  		 */
> -		ctx->src_vbs[0] = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +		ctx->src_vbs[0] = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  		WARN_ON(ctx->src_vbs[0] == NULL);
>  	} else {
> -		ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>  		WARN_ON(ctx->src_vbs[0] == NULL);
>  	}
>  
> -	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>  	WARN_ON(ctx->dst_vb == NULL);
>  
>  	if (ctx->deinterlacing) {
> @@ -1422,7 +1422,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
>  finished:
>  	vpe_dbg(ctx->dev, "finishing transaction\n");
>  	ctx->bufs_completed = 0;
> -	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
> +	v4l2_m2m_job_finish(dev->m2m_dev, ctx->fh.m2m_ctx);
>  handled:
>  	return IRQ_HANDLED;
>  }
> @@ -1483,7 +1483,7 @@ static int vpe_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	struct vpe_q_data *q_data;
>  	int i;
>  
> -	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>  	if (!vq)
>  		return -EINVAL;
>  
> @@ -1624,7 +1624,7 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
>  	struct vb2_queue *vq;
>  	int i;
>  
> -	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
>  	if (!vq)
>  		return -EINVAL;
>  
> @@ -1852,55 +1852,6 @@ static int vpe_s_selection(struct file *file, void *fh,
>  	return set_srcdst_params(ctx);
>  }
>  
> -static int vpe_reqbufs(struct file *file, void *priv,
> -		       struct v4l2_requestbuffers *reqbufs)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> -}
> -
> -static int vpe_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vpe_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vpe_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -
> -	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> -}
> -
> -static int vpe_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -
> -	if (ctx->deinterlacing)
> -		config_edi_input_mode(ctx, 0x0);
> -
> -	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> -}
> -
> -static int vpe_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -
> -	vpe_dump_regs(ctx->dev);
> -	vpdma_dump_regs(ctx->dev->vpdma);
> -
> -	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> -}
> -
>  /*
>   * defines number of buffers/frames a context can process with VPE before
>   * switching to a different context. default value is 1 buffer per context
> @@ -1945,16 +1896,15 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
>  	.vidioc_g_selection		= vpe_g_selection,
>  	.vidioc_s_selection		= vpe_s_selection,
>  
> -	.vidioc_reqbufs		= vpe_reqbufs,
> -	.vidioc_querybuf	= vpe_querybuf,
> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
>  
> -	.vidioc_qbuf		= vpe_qbuf,
> -	.vidioc_dqbuf		= vpe_dqbuf,
> -
> -	.vidioc_streamon	= vpe_streamon,
> -	.vidioc_streamoff	= vpe_streamoff,
> -	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> -	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  };
>  
>  /*
> @@ -2027,7 +1977,25 @@ static int vpe_buf_prepare(struct vb2_buffer *vb)
>  static void vpe_buf_queue(struct vb2_buffer *vb)
>  {
>  	struct vpe_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> -	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
> +}
> +
> +static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
> +
> +	if (ctx->deinterlacing)
> +		config_edi_input_mode(ctx, 0x0);
> +
> +	return 0;
> +}
> +
> +static void vpe_stop_streaming(struct vb2_queue *q)
> +{
> +	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
> +
> +	vpe_dump_regs(ctx->dev);
> +	vpdma_dump_regs(ctx->dev->vpdma);
>  }
>  
>  static struct vb2_ops vpe_qops = {
> @@ -2036,6 +2004,8 @@ static struct vb2_ops vpe_qops = {
>  	.buf_queue	 = vpe_buf_queue,
>  	.wait_prepare	 = vb2_ops_wait_prepare,
>  	.wait_finish	 = vb2_ops_wait_finish,
> +	.start_streaming = vpe_start_streaming,
> +	.stop_streaming  = vpe_stop_streaming,
>  };
>  
>  static int queue_init(void *priv, struct vb2_queue *src_vq,
> @@ -2089,7 +2059,7 @@ static const struct v4l2_ctrl_config vpe_bufs_per_job = {
>  static int vpe_open(struct file *file)
>  {
>  	struct vpe_dev *dev = video_drvdata(file);
> -	struct vpe_ctx *ctx = NULL;
> +	struct vpe_ctx *ctx;
>  	struct vpe_q_data *s_q_data;
>  	struct v4l2_ctrl_handler *hdl;
>  	int ret;
> @@ -2164,10 +2134,10 @@ static int vpe_open(struct file *file)
>  	if (ret)
>  		goto exit_fh;
>  
> -	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
>  
> -	if (IS_ERR(ctx->m2m_ctx)) {
> -		ret = PTR_ERR(ctx->m2m_ctx);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
>  		goto exit_fh;
>  	}
>  
> @@ -2186,7 +2156,7 @@ static int vpe_open(struct file *file)
>  	ctx->load_mmrs = true;
>  
>  	vpe_dbg(dev, "created instance %p, m2m_ctx: %p\n",
> -		ctx, ctx->m2m_ctx);
> +		ctx, ctx->fh.m2m_ctx);
>  
>  	mutex_unlock(&dev->dev_mutex);
>  
> @@ -2224,7 +2194,7 @@ static int vpe_release(struct file *file)
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
>  	v4l2_ctrl_handler_free(&ctx->hdl);
> -	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
>  
>  	kfree(ctx);
>  
> @@ -2241,39 +2211,13 @@ static int vpe_release(struct file *file)
>  	return 0;
>  }
>  
> -static unsigned int vpe_poll(struct file *file,
> -			     struct poll_table_struct *wait)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -	struct vpe_dev *dev = ctx->dev;
> -	int ret;
> -
> -	mutex_lock(&dev->dev_mutex);
> -	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> -	mutex_unlock(&dev->dev_mutex);
> -	return ret;
> -}
> -
> -static int vpe_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct vpe_ctx *ctx = file2ctx(file);
> -	struct vpe_dev *dev = ctx->dev;
> -	int ret;
> -
> -	if (mutex_lock_interruptible(&dev->dev_mutex))
> -		return -ERESTARTSYS;
> -	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> -	mutex_unlock(&dev->dev_mutex);
> -	return ret;
> -}
> -
>  static const struct v4l2_file_operations vpe_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= vpe_open,
>  	.release	= vpe_release,
> -	.poll		= vpe_poll,
> +	.poll		= v4l2_m2m_fop_poll,
>  	.unlocked_ioctl	= video_ioctl2,
> -	.mmap		= vpe_mmap,
> +	.mmap		= v4l2_m2m_fop_mmap,
>  };
>  
>  static struct video_device vpe_videodev = {
> @@ -2475,8 +2419,6 @@ static const struct of_device_id vpe_of_match[] = {
>  	},
>  	{},
>  };
> -#else
> -#define vpe_of_match NULL
>  #endif
>  
>  static struct platform_driver vpe_pdrv = {
> @@ -2485,7 +2427,7 @@ static struct platform_driver vpe_pdrv = {
>  	.driver		= {
>  		.name	= VPE_MODULE_NAME,
>  		.owner	= THIS_MODULE,
> -		.of_match_table = vpe_of_match,
> +		.of_match_table = of_match_ptr(vpe_of_match),
>  	},
>  };
>  
> 

