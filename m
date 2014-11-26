Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaKZXSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:18:07 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35898 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaKZXSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <2698849.pKqLKtTreZ@avalon>
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
 <1417041754-8714-12-git-send-email-prabhakar.csengg@gmail.com> <2698849.pKqLKtTreZ@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 26 Nov 2014 23:17:32 +0000
Message-ID: <CA+V-a8tQj0nG44k2FZUD3N=v4+PmmWG-tD5WC_nKz4E1bEU9hQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Wed, Nov 26, 2014 at 10:59 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Wednesday 26 November 2014 22:42:34 Lad, Prabhakar wrote:
>> This patch drops driver specific wait_prepare() and
>> wait_finish() callbacks from vb2_ops and instead uses
>> the the helpers vb2_ops_wait_prepare/finish() provided
>> by the vb2 core, the lock member of the queue needs
>> to be initalized to a mutex so that vb2 helpers
>> vb2_ops_wait_prepare/finish() can make use of it.
>
> The queue lock field isn't initialized by the uvcvideo driver, so you can't
> use vb2_ops_wait_prepare|finish().
>
Oops not sure what happened here I just took the patch from [1]
and added commit message. anyway will post a single patch v3.

[1] https://patchwork.kernel.org/patch/5327451/

Thanks,
--Prabhakar Lad

>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>  drivers/media/usb/uvc/uvc_queue.c | 18 ++----------------
>>  1 file changed, 2 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_queue.c
>> b/drivers/media/usb/uvc/uvc_queue.c index cc96072..64147b5 100644
>> --- a/drivers/media/usb/uvc/uvc_queue.c
>> +++ b/drivers/media/usb/uvc/uvc_queue.c
>> @@ -143,20 +143,6 @@ static void uvc_buffer_finish(struct vb2_buffer *vb)
>>               uvc_video_clock_update(stream, &vb->v4l2_buf, buf);
>>  }
>>
>> -static void uvc_wait_prepare(struct vb2_queue *vq)
>> -{
>> -     struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>> -
>> -     mutex_unlock(&queue->mutex);
>> -}
>> -
>> -static void uvc_wait_finish(struct vb2_queue *vq)
>> -{
>> -     struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>> -
>> -     mutex_lock(&queue->mutex);
>> -}
>> -
>>  static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
>>  {
>>       struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
>> @@ -195,8 +181,8 @@ static struct vb2_ops uvc_queue_qops = {
>>       .buf_prepare = uvc_buffer_prepare,
>>       .buf_queue = uvc_buffer_queue,
>>       .buf_finish = uvc_buffer_finish,
>> -     .wait_prepare = uvc_wait_prepare,
>> -     .wait_finish = uvc_wait_finish,
>> +     .wait_prepare = vb2_ops_wait_prepare,
>> +     .wait_finish = vb2_ops_wait_finish,
>>       .start_streaming = uvc_start_streaming,
>>       .stop_streaming = uvc_stop_streaming,
>>  };
>
> --
> Regards,
>
> Laurent Pinchart
>
