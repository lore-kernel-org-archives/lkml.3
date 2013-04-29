Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3D2Rgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:36:32 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:52539 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3D2Rga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:36:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH] media: i2c: tvp7002: enable TVP7002 decoder for media controller based usage
Date: Mon, 29 Apr 2013 19:36:36 +0200
Message-ID: <1696679.tiFHy28fsU@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CA+V-a8u_YA=TJaRebboigM6z-A=R6-ZdyxZSED7H+4w+LN+cTQ@mail.gmail.com>
References: <1366963535-15963-1-git-send-email-prabhakar.csengg@gmail.com> <32556864.ElKWl0cdN2@avalon> <CA+V-a8u_YA=TJaRebboigM6z-A=R6-ZdyxZSED7H+4w+LN+cTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Monday 29 April 2013 23:00:26 Prabhakar Lad wrote:
> On Mon, Apr 29, 2013 at 7:57 PM, Laurent Pinchart wrote:
> > On Friday 26 April 2013 13:35:35 Prabhakar Lad wrote:
> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> 
> >> This patch enables tvp7002 decoder driver for media controller
> >> based usage by adding v4l2_subdev_pad_ops  operations support
> >> for enum_mbus_code, set_pad_format, get_pad_format and
> >> media_entity_init()
> >> on probe and media_entity_cleanup() on remove.
> >> 
> >> The device supports 1 output pad and no input pads.
> > 
> > We should actually define input pads, connected to connector entities, but
> > that's out of scope for this patch.
> > 
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> ---

[snip]

> >> +/*
> >> + * tvp7002_set_pad_format() - set video format on pad
> >> + * @sd: pointer to standard V4L2 sub-device structure
> >> + * @fh: file handle for the subdev
> >> + * @fmt: pointer to subdev format struct
> >> + *
> >> + * set video format for pad.
> >> +*/
> >> +static int
> >> +tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> >> *fh,
> >> +                    struct v4l2_subdev_format *fmt)
> >> +{
> >> +     struct tvp7002 *tvp7002 = to_tvp7002(sd);
> >> +
> >> +     /* Check pad index is valid */
> >> +     if (fmt->pad != 0)
> >> +             return -EINVAL;
> > 
> > Redundant check as well.
> 
> OK
> 
> >> +     if (fmt->format.field != tvp7002->current_timings->scanmode ||
> >> +         fmt->format.code != V4L2_MBUS_FMT_YUYV10_1X20 ||
> >> +         fmt->format.colorspace != tvp7002->current_timings->color_space
> >> || +         fmt->format.width !=
> >> tvp7002->current_timings->timings.bt.width || +        
> >> fmt->format.height != tvp7002->current_timings->timings.bt.height) +    
> >>         return -EINVAL;
> > 
> > You shouldn't return an error, but fix the input parameters according to
> > what the device supports. As the format is fixed for a giving set of
> > timings, the .set_pad_format() handler should just perform the same
> > operations as .get_pad_format(). You could even define
> > tvp7002_get_pad_format() only and use it as a handler for both
> > .get_pad_format() and .set_pad_format().
> 
> OK. So its the job back in the application end to see what format was set.

That's right. The format ioctls work that way to negotiate formats with 
userspace.

> >> +     tvp7002->format = fmt->format;
> >> +
> >> +     return 0;
> >> +}

[snip]

> >> +/* media pad related operation handlers */
> >> +static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
> >> +     .enum_mbus_code = tvp7002_enum_mbus_code,
> >> +     .get_fmt = tvp7002_get_pad_format,
> >> +     .set_fmt = tvp7002_set_pad_format,
> > 
> > We will need to define pad-aware DV timings operations.
> 
> I didn't get you this?

We will need to extend the pad operations (struct v4l2_subdev_pad_ops) with 
operations to enumerate, get and set DV timings at the pad level.

-- 
Regards,

Laurent Pinchart

