Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbaC1D6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:58:09 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:56633 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbaC1D6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:58:06 -0400
Message-ID: <5334F348.6070308@t-25.ru>
Date: Fri, 28 Mar 2014 07:58:00 +0400
From: Anton Leontiev <bunder@t-25.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Fix marking buffer erroneous in case
 of FID toggling
References: <1395722457-28080-1-git-send-email-bunder@t-25.ru> <1462972.4R5jTG4a0F@avalon>
In-Reply-To: <1462972.4R5jTG4a0F@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

26.03.2014 21:41, Laurent Pinchart wrote:
> Hi Anton,
> 
> Thank you for the patch.
> 
> On Tuesday 25 March 2014 08:40:57 Anton Leontiev wrote:
>> Set error bit for incomplete buffers when end of buffer is detected by
>> FID toggling (for example when last transaction with EOF is lost).
>> This prevents passing incomplete buffers to the userspace.
> 
> But this would also breaks buggy webcams that toggle the FID bit but don't set 
> the EOF bit. Support for this was added before the driver got merged in the 
> mainline kernel, and the SVN log is a bit terse I'm afraid:
> 
> V 104
> - Check both EOF and FID bits to detect end of frames.
> - Updated disclaimer and general status comment.
> 
> I don't remember which webcam(s) exhibit this behaviour.
> 
> Your patch would also mark valid buffers as erroneous when the list EOF bit is 
> in a packet of its own with no data.

If camera streams compressed video the patch doesn't affect it. It
affects only uncompressed streams.

If we get EOF bit in a packet of its own with no data we take second
check under 'if (buf->state == UVC_BUF_STATE_READY)' that was before my
patch. In this case if all data were received buffer is processed
normally, but if some data is missing buffer is marked erroneous.

> As the uvcvideo driver already marks buffers smaller than the expected image 
> size as erroneous, missing EOF packets that contain data should already result 
> in buffers with the error bit set.

No, because there was no check for that in case then new frame is
detected by FID toggling, it was there only for the case then new frame
is detected by EOF bit.

> Are you concerned about compressed formats only ?

No, I'm concerning about uncompressed frames only.

> While this patch would correctly detect the missing EOF packet in that
> case, any other missing packet would still result in a corrupt image, so I'm 
> not sure if this would be worth it.
> 
>> Signed-off-by: Anton Leontiev <bunder@t-25.ru>
>> ---
>>  drivers/media/usb/uvc/uvc_video.c | 21 +++++++++++++++------
>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>> b/drivers/media/usb/uvc/uvc_video.c index 8d52baf..57c9a4b 100644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
>> @@ -1133,6 +1133,17 @@ static int uvc_video_encode_data(struct uvc_streaming
>> *stream, */
>>
>>  /*
>> + * Set error flag for incomplete buffer.
>> + */
>> +static void uvc_buffer_check_bytesused(const struct uvc_streaming *const
>> stream,
>> +	struct uvc_buffer *const buf)
>> +{
>> +	if (buf->length != buf->bytesused &&
>> +			!(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))
>> +		buf->error = 1;
>> +}
>> +
>> +/*
>>   * Completion handler for video URBs.
>>   */
>>  static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming
>> *stream, @@ -1156,9 +1167,11 @@ static void uvc_video_decode_isoc(struct
>> urb *urb, struct uvc_streaming *stream, do {
>>  			ret = uvc_video_decode_start(stream, buf, mem,
>>  				urb->iso_frame_desc[i].actual_length);
>> -			if (ret == -EAGAIN)
>> +			if (ret == -EAGAIN) {
>> +				uvc_buffer_check_bytesused(stream, buf);
>>  				buf = uvc_queue_next_buffer(&stream->queue,
>>  							    buf);
>> +			}
>>  		} while (ret == -EAGAIN);
>>
>>  		if (ret < 0)
>> @@ -1173,11 +1186,7 @@ static void uvc_video_decode_isoc(struct urb *urb,
>> struct uvc_streaming *stream, urb->iso_frame_desc[i].actual_length);
>>
>>  		if (buf->state == UVC_BUF_STATE_READY) {
>> -			if (buf->length != buf->bytesused &&
>> -			    !(stream->cur_format->flags &
>> -			      UVC_FMT_FLAG_COMPRESSED))
>> -				buf->error = 1;
>> -
>> +			uvc_buffer_check_bytesused(stream, buf);
>>  			buf = uvc_queue_next_buffer(&stream->queue, buf);
>>  		}
>>  	}
> 

-- 
Anton Leontiev
