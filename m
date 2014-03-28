Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaC1LQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:16:17 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:34682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaC1LQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:16:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH 1/2] usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
Date: Fri, 28 Mar 2014 12:18:12 +0100
Message-ID: <1650089.1kJ4DQOsm3@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <533537E2.9020904@xs4all.nl>
References: <20140323001018.GA11963@localhost> <1395588754-20587-2-git-send-email-laurent.pinchart@ideasonboard.com> <533537E2.9020904@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Friday 28 March 2014 09:50:42 Hans Verkuil wrote:
> On 03/23/2014 04:32 PM, Laurent Pinchart wrote:
> > The wall time clock isn't useful for applications as it can jump around
> > due to time adjustement. Switch to the monotonic clock.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/usb/gadget/uvc_queue.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/uvc_queue.c
> > b/drivers/usb/gadget/uvc_queue.c index 0bb5d50..d4561ba 100644
> > --- a/drivers/usb/gadget/uvc_queue.c
> > +++ b/drivers/usb/gadget/uvc_queue.c
> > @@ -364,6 +364,7 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct
> > uvc_video_queue *queue,
> >  						struct uvc_buffer *buf)
> >  {
> >  	struct uvc_buffer *nextbuf;
> > +	struct timespec ts;
> > 
> >  	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
> >  	     buf->length != buf->bytesused) {
> > @@ -379,14 +380,11 @@ static struct uvc_buffer
> > *uvc_queue_next_buffer(struct uvc_video_queue *queue,> 
> >  	else
> >  		nextbuf = NULL;
> > 
> > -	/*
> > -	 * FIXME: with videobuf2, the sequence number or timestamp fields
> > -	 * are valid only for video capture devices and the UVC gadget
> > usually
> > -	 * is a video output device. Keeping these until the specs are clear
> > on
> > -	 * this aspect.
> > -	 */
> > +	ktime_get_ts(&ts);
> 
> Why not use the v4l2-common.c helper v4l2_get_timestamp()?

No reason at all. I'll fix that.

> > +
> >  	buf->buf.v4l2_buf.sequence = queue->sequence++;
> > 
> > -	do_gettimeofday(&buf->buf.v4l2_buf.timestamp);
> > +	buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
> > +	buf->buf.v4l2_buf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> 
> You should also add:
> 
> 	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
> 
> I noticed that that was never set, which is wrong.

Good point. Will be fixed in v2.

> >  	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
> >  	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);

-- 
Regards,

Laurent Pinchart

