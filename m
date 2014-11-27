Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070AbaK0Vbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:31:44 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:55325 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaK0Vbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:31:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
Date: Thu, 27 Nov 2014 23:32:09 +0200
Message-ID: <4838705.gmGJIAUqrM@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1417044344-20611-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417044344-20611-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Wednesday 26 November 2014 23:25:44 Lad, Prabhakar wrote:
> This patch drops driver specific wait_prepare() and
> wait_finish() callbacks from vb2_ops and instead uses
> the the helpers vb2_ops_wait_prepare/finish() provided
> by the vb2 core, the lock member of the queue needs
> to be initalized to a mutex so that vb2 helpers
> vb2_ops_wait_prepare/finish() can make use of it.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_queue.c | 19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index cc96072..10c554e 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -143,20 +143,6 @@ static void uvc_buffer_finish(struct vb2_buffer *vb)
>  		uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
>  }
> 
> -static void uvc_wait_prepare(struct vb2_queue *vq)
> -{
> -	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> -
> -	mutex_unlock(&queue->mutex);
> -}
> -
> -static void uvc_wait_finish(struct vb2_queue *vq)
> -{
> -	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> -
> -	mutex_lock(&queue->mutex);
> -}
> -
>  static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
> @@ -195,8 +181,8 @@ static struct vb2_ops uvc_queue_qops = {
>  	.buf_prepare = uvc_buffer_prepare,
>  	.buf_queue = uvc_buffer_queue,
>  	.buf_finish = uvc_buffer_finish,
> -	.wait_prepare = uvc_wait_prepare,
> -	.wait_finish = uvc_wait_finish,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
>  	.start_streaming = uvc_start_streaming,
>  	.stop_streaming = uvc_stop_streaming,
>  };
> @@ -214,6 +200,7 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum
> v4l2_buf_type type, queue->queue.mem_ops = &vb2_vmalloc_memops;
>  	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> 
>  		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
> 
> +	queue->queue.lock = &queue->mutex;

I'm a bit concerned that this would introduce future breakages. Setting the 
queue.lock pointer enables locking in all vb2_fop_* and vb2_ops_wait_* 
functions. The uvcvideo driver isn't ready for that, but doesn't use the 
vb2_fop_* functions yet, so that's not an issue. However, in the future, 
videobuf2 might use the lock in more places, including functions used by the 
uvcvideo driver. This could then cause breakages.

It would be better to completely convert the uvcvideo driver to the vb2_fop_* 
functions if we want to use vb2_ops_*. I'm not sure how complex that would be 
though, and whether it would be possible while still keeping the fine-grained 
locking implemented by the uvcvideo driver. Do you think it should be 
attempted ?

>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;

-- 
Regards,

Laurent Pinchart

