Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaC1QKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:10:08 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:36182 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaC1QKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:10:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Anton Leontiev <bunder@t-25.ru>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Fix marking buffer erroneous in case of FID toggling
Date: Fri, 28 Mar 2014 17:12:03 +0100
Message-ID: <1459346.J1YUbuH55p@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5334F348.6070308@t-25.ru>
References: <1395722457-28080-1-git-send-email-bunder@t-25.ru> <1462972.4R5jTG4a0F@avalon> <5334F348.6070308@t-25.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Friday 28 March 2014 07:58:00 Anton Leontiev wrote:
> 26.03.2014 21:41, Laurent Pinchart wrote:
> > On Tuesday 25 March 2014 08:40:57 Anton Leontiev wrote:
> >> Set error bit for incomplete buffers when end of buffer is detected by
> >> FID toggling (for example when last transaction with EOF is lost).
> >> This prevents passing incomplete buffers to the userspace.
> > 
> > But this would also breaks buggy webcams that toggle the FID bit but don't
> > set the EOF bit. Support for this was added before the driver got merged
> > in the mainline kernel, and the SVN log is a bit terse I'm afraid:
> > 
> > V 104
> > - Check both EOF and FID bits to detect end of frames.
> > - Updated disclaimer and general status comment.
> > 
> > I don't remember which webcam(s) exhibit this behaviour.
> > 
> > Your patch would also mark valid buffers as erroneous when the list EOF
> > bit is in a packet of its own with no data.
> 
> If camera streams compressed video the patch doesn't affect it. It affects
> only uncompressed streams.
> 
> If we get EOF bit in a packet of its own with no data we take second
> check under 'if (buf->state == UVC_BUF_STATE_READY)' that was before my
> patch. In this case if all data were received buffer is processed
> normally, but if some data is missing buffer is marked erroneous.
> 
> > As the uvcvideo driver already marks buffers smaller than the expected
> > image size as erroneous, missing EOF packets that contain data should
> > already result in buffers with the error bit set.
> 
> No, because there was no check for that in case then new frame is detected
> by FID toggling, it was there only for the case then new frame is detected
> by EOF bit.

Right, my bad, I had misread your patch. Please see below for a couple of 
small comments.

> > Are you concerned about compressed formats only ?
> 
> No, I'm concerning about uncompressed frames only.
> 
> > While this patch would correctly detect the missing EOF packet in that
> > case, any other missing packet would still result in a corrupt image, so
> > I'm not sure if this would be worth it.
> > 
> >> Signed-off-by: Anton Leontiev <bunder@t-25.ru>
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_video.c | 21 +++++++++++++++------
> >>  1 file changed, 15 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_video.c
> >> b/drivers/media/usb/uvc/uvc_video.c index 8d52baf..57c9a4b 100644
> >> --- a/drivers/media/usb/uvc/uvc_video.c
> >> +++ b/drivers/media/usb/uvc/uvc_video.c
> >> @@ -1133,6 +1133,17 @@ static int uvc_video_encode_data(struct
> >> uvc_streaming *stream, */
> >> 
> >>  /*
> >> 
> >> + * Set error flag for incomplete buffer.
> >> + */
> >> +static void uvc_buffer_check_bytesused(const struct uvc_streaming *const
> >> stream,

No need for the second const keyword here.

I would have used "uvc_video_" as a prefix, to be in sync with the surrounding 
functions. What would you think of uvc_video_validate_buffer() ?

> >> +	struct uvc_buffer *const buf)

And no need for const at all here.

> >> +{
> >> +	if (buf->length != buf->bytesused &&
> >> +			!(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))

The indentation is wrong here, the ! on the second line should be aligned to 
the first 'buf' of the first line.

If you agree with these changes I can perform them while applying, there's no 
need to resubmit the patch.

> >> +		buf->error = 1;
> >> +}
> >> +
> >> +/*
> >>   * Completion handler for video URBs.
> >>   */
> >>  static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming
> >> *stream,
> >> @@ -1156,9 +1167,11 @@ static void uvc_video_decode_isoc(struct
> >> urb *urb, struct uvc_streaming *stream,
> >>  		do {
> >>  			ret = uvc_video_decode_start(stream, buf, mem,
> >>  				urb->iso_frame_desc[i].actual_length);
> >> -			if (ret == -EAGAIN)
> >> +			if (ret == -EAGAIN) {
> >> +				uvc_buffer_check_bytesused(stream, buf);
> >>  				buf = uvc_queue_next_buffer(&stream->queue,
> >>  							    buf);
> >> +			}
> >>  		} while (ret == -EAGAIN);
> >>  		
> >>  		if (ret < 0)
> >> @@ -1173,11 +1186,7 @@ static void uvc_video_decode_isoc(struct urb *urb,
> >> struct uvc_streaming *stream, urb->iso_frame_desc[i].actual_length);
> >>  		if (buf->state == UVC_BUF_STATE_READY) {
> >> -			if (buf->length != buf->bytesused &&
> >> -			    !(stream->cur_format->flags &
> >> -			      UVC_FMT_FLAG_COMPRESSED))
> >> -				buf->error = 1;
> >> -
> >> +			uvc_buffer_check_bytesused(stream, buf);
> >>  			buf = uvc_queue_next_buffer(&stream->queue, buf);
> >>  		}
> >>  	}

-- 
Regards,

Laurent Pinchart

