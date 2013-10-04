Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3JDOJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:09:40 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4093 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3JDOJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:09:39 -0400
Message-ID: <524ECC06.2000706@xs4all.nl>
Date: Fri, 04 Oct 2013 16:09:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vb2: Allow STREAMOFF for io emulator
References: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ricardo,

On 10/04/2013 03:49 PM, Ricardo Ribalda Delgado wrote:
> A video device opened and streaming in io emulator mode can only stop
> streamming if its file descriptor is closed.
> 
> There are some parameters that can only be changed if the device is not
> streaming. Also, the power consumption of a device streaming could be
> different than one not streaming.
> 
> With this patch a video device opened in io emulator can be stopped on
> demand.

Why would you want this? If you can call STREAMOFF, why not use stream I/O
all the way? That's much more efficient than read() anyway.

Unless there is a very good use-case, I don't see a good reason for mixing
file I/O with streaming I/O ioctls.

Regards,

	Hans

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9fc4bab..097fba8 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1686,6 +1686,7 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>  }
>  EXPORT_SYMBOL_GPL(vb2_streamon);
>  
> +static int __vb2_cleanup_fileio(struct vb2_queue *q);
>  
>  /**
>   * vb2_streamoff - stop streaming
> @@ -1704,11 +1705,6 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
>   */
>  int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  {
> -	if (q->fileio) {
> -		dprintk(1, "streamoff: file io in progress\n");
> -		return -EBUSY;
> -	}
> -
>  	if (type != q->type) {
>  		dprintk(1, "streamoff: invalid stream type\n");
>  		return -EINVAL;
> @@ -1719,6 +1715,11 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>  		return -EINVAL;
>  	}
>  
> +	if (q->fileio) {
> +		__vb2_cleanup_fileio(q);
> +		return 0;
> +	}
> +
>  	/*
>  	 * Cancel will pause streaming and remove all buffers from the driver
>  	 * and videobuf, effectively returning control over them to userspace.
> 

