Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaKZW6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:58:48 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:53955 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZW6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:58:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 11/11] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
Date: Thu, 27 Nov 2014 00:59:12 +0200
Message-ID: <2698849.pKqLKtTreZ@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1417041754-8714-12-git-send-email-prabhakar.csengg@gmail.com>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com> <1417041754-8714-12-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Wednesday 26 November 2014 22:42:34 Lad, Prabhakar wrote:
> This patch drops driver specific wait_prepare() and
> wait_finish() callbacks from vb2_ops and instead uses
> the the helpers vb2_ops_wait_prepare/finish() provided
> by the vb2 core, the lock member of the queue needs
> to be initalized to a mutex so that vb2 helpers
> vb2_ops_wait_prepare/finish() can make use of it.

The queue lock field isn't initialized by the uvcvideo driver, so you can't 
use vb2_ops_wait_prepare|finish().

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_queue.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index cc96072..64147b5 100644
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

-- 
Regards,

Laurent Pinchart

