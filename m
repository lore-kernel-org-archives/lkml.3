Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaC1Iv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:51:27 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3762 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaC1IvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:51:05 -0400
Message-ID: <533537E2.9020904@xs4all.nl>
Date: Fri, 28 Mar 2014 09:50:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH 1/2] usb: gadget: uvc: Switch to monotonic clock for buffer
 timestamps
References: <20140323001018.GA11963@localhost> <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com> <1395588754-20587-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1395588754-20587-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

I have a few comments:

On 03/23/2014 04:32 PM, Laurent Pinchart wrote:
> The wall time clock isn't useful for applications as it can jump around
> due to time adjustement. Switch to the monotonic clock.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/usb/gadget/uvc_queue.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index 0bb5d50..d4561ba 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -364,6 +364,7 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
>  						struct uvc_buffer *buf)
>  {
>  	struct uvc_buffer *nextbuf;
> +	struct timespec ts;
>  
>  	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
>  	     buf->length != buf->bytesused) {
> @@ -379,14 +380,11 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
>  	else
>  		nextbuf = NULL;
>  
> -	/*
> -	 * FIXME: with videobuf2, the sequence number or timestamp fields
> -	 * are valid only for video capture devices and the UVC gadget usually
> -	 * is a video output device. Keeping these until the specs are clear on
> -	 * this aspect.
> -	 */
> +	ktime_get_ts(&ts);

Why not use the v4l2-common.c helper v4l2_get_timestamp()?

> +
>  	buf->buf.v4l2_buf.sequence = queue->sequence++;
> -	do_gettimeofday(&buf->buf.v4l2_buf.timestamp);
> +	buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
> +	buf->buf.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;

You should also add:

	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;

I noticed that that was never set, which is wrong.

Regards,

	Hans

>  
>  	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
>  	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
> 

