Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKGQJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:09:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60382 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbaKGQJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:09:37 -0500
Date: Fri, 7 Nov 2014 17:09:33 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 01/10] [media] Move mediabus format definition to a
 more standard place
Message-ID: <20141107170933.20234344@bbrezillon>
In-Reply-To: <20141107152416.GC3136@valkosipuli.retiisi.org.uk>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415369269-5064-2-git-send-email-boris.brezillon@free-electrons.com>
	<20141107152416.GC3136@valkosipuli.retiisi.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On Fri, 7 Nov 2014 17:24:16 +0200
Sakari Ailus <sakari.ailus@iki.fi> wrote:

> Hi Boris,
> 
> On Fri, Nov 07, 2014 at 03:07:40PM +0100, Boris Brezillon wrote:
> > Define MEDIA_BUS_FMT macros (re-using the values defined in the
> > v4l2_mbus_pixelcode enum) into a separate header file so that they can be
> > used from the DRM/KMS subsystem without any reference to the V4L2
> > subsystem.
> > 
> > Then set V4L2_MBUS_FMT definitions to the MEDIA_BUS_FMT values using the
> > V4L2_MBUS_FROM_MEDIA_BUS_FMT macro.
> > 
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  include/uapi/linux/Kbuild             |   1 +
> >  include/uapi/linux/media-bus-format.h | 125 +++++++++++++++++++++++
> >  include/uapi/linux/v4l2-mediabus.h    | 184 +++++++++++++++-------------------
> >  3 files changed, 206 insertions(+), 104 deletions(-)
> >  create mode 100644 include/uapi/linux/media-bus-format.h
> > 
> > diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> > index b70237e..ed39ac8 100644
> > --- a/include/uapi/linux/Kbuild
> > +++ b/include/uapi/linux/Kbuild
> > @@ -241,6 +241,7 @@ header-y += map_to_7segment.h
> >  header-y += matroxfb.h
> >  header-y += mdio.h
> >  header-y += media.h
> > +header-y += media-bus-format.h
> >  header-y += mei.h
> >  header-y += memfd.h
> >  header-y += mempolicy.h
> > diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> > new file mode 100644
> > index 0000000..23b4090

[...]

> > +/* Vendor specific formats - next is	0x5002 */
> > +
> > +/* S5C73M3 sensor specific interleaved UYVY and JPEG */
> > +#define MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8		0x5001
> > +
> > +/* HSV - next is	0x6002 */
> > +#define MEDIA_BUS_FMT_AHSV8888_1X32		0x6001
> > +
> > +#endif /* __LINUX_MEDIA_BUS_FORMAT_H */
> > diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> > index 1445e85..3d87db7 100644
> > --- a/include/uapi/linux/v4l2-mediabus.h
> > +++ b/include/uapi/linux/v4l2-mediabus.h
> > @@ -13,118 +13,94 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/videodev2.h>
> > +#include <linux/media-bus-format.h>
> 
> Alphabetical order, please.

I'll fix that.

> 
> >  
> > -/*
> > - * These pixel codes uniquely identify data formats on the media bus. Mostly
> > - * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
> > - * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
> > - * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> > - * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> > - * transferred over the bus: "LE" means that the least significant bits are
> > - * transferred first, "BE" means that the most significant bits are transferred
> > - * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> > - * incomplete high byte, are filled with padding bits.
> > - *
> > - * The pixel codes are grouped by type, bus_width, bits per component, samples
> > - * per pixel and order of subsamples. Numerical values are sorted using generic
> > - * numerical sort order (8 thus comes before 10).
> > - *
> > - * As their value can't change when a new pixel code is inserted in the
> > - * enumeration, the pixel codes are explicitly given a numerical value. The next
> > - * free values for each category are listed below, update them when inserting
> > - * new pixel codes.
> > - */
> > -enum v4l2_mbus_pixelcode {
> > -	V4L2_MBUS_FMT_FIXED = 0x0001,
> > +#define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
> > +	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
> 
> Could you add a comment telling these values should no longer be changed?

I'll add this comment in patch 10 as suggested by Hans.

Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
