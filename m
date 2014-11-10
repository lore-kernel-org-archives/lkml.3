Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaKJRC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:02:29 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44922 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752244AbaKJRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:02:27 -0500
Date: Mon, 10 Nov 2014 18:02:22 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v5 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Message-ID: <20141110180222.39508a63@bbrezillon>
In-Reply-To: <54609CDF.8030303@xs4all.nl>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415461632-31236-1-git-send-email-boris.brezillon@free-electrons.com>
	<54609CDF.8030303@xs4all.nl>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 12:09:19 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 11/08/2014 04:47 PM, Boris Brezillon wrote:
> > Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
> > users don't have access to these definitions.
> > 
> > We have to keep this definition for user-space users even though they're
> > encouraged to move to the new media_bus_format enum.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  include/uapi/linux/v4l2-mediabus.h | 45 ++++++++++++++++++++++++--------------
> >  1 file changed, 28 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> > index d712df8..5c9410d 100644
> > --- a/include/uapi/linux/v4l2-mediabus.h
> > +++ b/include/uapi/linux/v4l2-mediabus.h
> > @@ -15,6 +15,33 @@
> >  #include <linux/types.h>
> >  #include <linux/videodev2.h>
> >  
> > +/**
> > + * struct v4l2_mbus_framefmt - frame format on the media bus
> > + * @width:	frame width
> > + * @height:	frame height
> > + * @code:	data format code (from enum v4l2_mbus_pixelcode)
> > + * @field:	used interlacing type (from enum v4l2_field)
> > + * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> > + */
> > +struct v4l2_mbus_framefmt {
> > +	__u32			width;
> > +	__u32			height;
> > +	__u32			code;
> > +	__u32			field;
> > +	__u32			colorspace;
> > +	__u32			reserved[7];
> > +};
> > +
> > +#ifndef __KERNEL__
> > +/*
> > + * enum v4l2_mbus_pixelcode and its definitions are now deprecated, and
> > + * MEDIA_BUS_FMT_ definitions (defined in media-bus-format.h) should be
> > + * used instead.
> > + *
> > + * New defines should only be added to media-bus-format.h. The
> > + * v4l2_mbus_pixelcode enum is frozen.
> > + */
> > +
> >  #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
> >  	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
> 
> Shouldn't this be the other way around?
> 
>   	V4L2_MBUS_FMT_ ## name = MEDIA_BUS_FMT_ ## name

Argh! Absolutely, I'll fix that.

> 
> Regards,
> 
> 	Hans
> 
> >  
> > @@ -102,22 +129,6 @@ enum v4l2_mbus_pixelcode {
> >  
> >  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
> >  };
> > -
> > -/**
> > - * struct v4l2_mbus_framefmt - frame format on the media bus
> > - * @width:	frame width
> > - * @height:	frame height
> > - * @code:	data format code (from enum v4l2_mbus_pixelcode)
> > - * @field:	used interlacing type (from enum v4l2_field)
> > - * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> > - */
> > -struct v4l2_mbus_framefmt {
> > -	__u32			width;
> > -	__u32			height;
> > -	__u32			code;
> > -	__u32			field;
> > -	__u32			colorspace;
> > -	__u32			reserved[7];
> > -};
> > +#endif /* __KERNEL__ */
> >  
> >  #endif
> > 
> 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
