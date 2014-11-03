Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaKCOGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:06:37 -0500
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51624 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816AbaKCOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:06:33 -0500
Message-ID: <54578BE3.401@xs4all.nl>
Date: Mon, 03 Nov 2014 15:06:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more
 standard place
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com> <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris, Laurent,

My apologies, I missed this patch when it was posted.

First of all, please convert all existing kernel drivers that use V4L2_MBUS_FMT
to the new macro. It's easy to automate, and I see no reason why we shouldn't
do this.

If you don't do that now, then we'll be stuck with two naming conventions
in the kernel for a long time.

Actually, to be explicit, I will NACK this if this conversion isn't done
as part of the patch series.

Also add something like:

#ifdef __KERNEL__
#error Use video-bus-format.h instead of v4l2-mediabus.h
#else
#warning Use video-bus-format.h instead of v4l2-mediabus.h
#endif

to the old header to prevent future drivers from using it. I'm not sure
about the warning when included by userspace applications. I personally
think it makes sense. While everyone claims now to keep the two headers
in sync, I think that in practice this will not work. Freezing the old
header and only adding new values to the new header is better.

Secondly, is there any reason why this shouldn't be named media-bus-format.h
instead? Besides regular video these busses can also carry VBI data or even
audio. I prefer the more generic term 'media'. Besides, it's already called a
mediabus format, just with a V4L2 prefix, so why not keep that name? Less
confusing for existing users of this header.

Thirdly, as others mentioned, the updated documentation must be part of the
patch series. I'll NACK it if it isn't. One reason why V4L2 has really good
API documentation is the strict requirement that patches that touch on the
userspace API must also update documentation.

It happened too often that developers swear up and down that they will update
the documentation later, and then they don't.

So, based on the above points:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

But it really shouldn't be hard to fix it because I do like the idea behind
it very much.

Apologies once again for the late reply and thanks to Laurent for asking me
to review this.

Regards,

	Hans

On 09/29/2014 04:02 PM, Boris Brezillon wrote:
> Rename mediabus formats and move the enum into a separate header file so
> that it can be used by DRM/KMS subsystem without any reference to the V4L2
> subsystem.
> 
> Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FMT_
> definitions.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/uapi/linux/Kbuild             |   1 +
>  include/uapi/linux/v4l2-mediabus.h    | 183 +++++++++++++++-------------------
>  include/uapi/linux/video-bus-format.h | 127 +++++++++++++++++++++++
>  3 files changed, 207 insertions(+), 104 deletions(-)
>  create mode 100644 include/uapi/linux/video-bus-format.h
> 
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index be88166..8712730 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -410,6 +410,7 @@ header-y += veth.h
>  header-y += vfio.h
>  header-y += vhost.h
>  header-y += videodev2.h
> +header-y += video-bus-format.h
>  header-y += virtio_9p.h
>  header-y += virtio_balloon.h
>  header-y += virtio_blk.h
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 1445e85..7b0a06c 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -13,118 +13,93 @@
>  
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
> +#include <linux/video-bus-format.h>
>  
> -/*
> - * These pixel codes uniquely identify data formats on the media bus. Mostly
> - * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
> - * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
> - * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> - * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> - * transferred over the bus: "LE" means that the least significant bits are
> - * transferred first, "BE" means that the most significant bits are transferred
> - * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> - * incomplete high byte, are filled with padding bits.
> - *
> - * The pixel codes are grouped by type, bus_width, bits per component, samples
> - * per pixel and order of subsamples. Numerical values are sorted using generic
> - * numerical sort order (8 thus comes before 10).
> - *
> - * As their value can't change when a new pixel code is inserted in the
> - * enumeration, the pixel codes are explicitly given a numerical value. The next
> - * free values for each category are listed below, update them when inserting
> - * new pixel codes.
> - */
> -enum v4l2_mbus_pixelcode {
> -	V4L2_MBUS_FMT_FIXED = 0x0001,
> +#define VIDEO_BUS_TO_V4L2_MBUS(x)	V4L2_MBUS_FMT_ ## x = VIDEO_BUS_FMT_ ## x
>  
> -	/* RGB - next is 0x100e */
> -	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
> -	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
> -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1004,
> -	V4L2_MBUS_FMT_BGR565_2X8_BE = 0x1005,
> -	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
> -	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
> -	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> -	V4L2_MBUS_FMT_RGB666_1X18 = 0x1009,
> -	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
> -	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
> -	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
> -	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
> +enum v4l2_mbus_pixelcode {
> +	VIDEO_BUS_TO_V4L2_MBUS(FIXED),
>  
> -	/* YUV (including grey) - next is 0x2024 */
> -	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> -	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
> -	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> -	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> -	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
> -	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2005,
> -	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2006,
> -	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2007,
> -	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
> -	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
> -	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
> -	V4L2_MBUS_FMT_UYVY10_2X10 = 0x2018,
> -	V4L2_MBUS_FMT_VYUY10_2X10 = 0x2019,
> -	V4L2_MBUS_FMT_YUYV10_2X10 = 0x200b,
> -	V4L2_MBUS_FMT_YVYU10_2X10 = 0x200c,
> -	V4L2_MBUS_FMT_Y12_1X12 = 0x2013,
> -	V4L2_MBUS_FMT_UYVY8_1X16 = 0x200f,
> -	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
> -	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
> -	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
> -	V4L2_MBUS_FMT_YDYUYDYV8_1X16 = 0x2014,
> -	V4L2_MBUS_FMT_UYVY10_1X20 = 0x201a,
> -	V4L2_MBUS_FMT_VYUY10_1X20 = 0x201b,
> -	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
> -	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> -	V4L2_MBUS_FMT_YUV10_1X30 = 0x2016,
> -	V4L2_MBUS_FMT_AYUV8_1X32 = 0x2017,
> -	V4L2_MBUS_FMT_UYVY12_2X12 = 0x201c,
> -	V4L2_MBUS_FMT_VYUY12_2X12 = 0x201d,
> -	V4L2_MBUS_FMT_YUYV12_2X12 = 0x201e,
> -	V4L2_MBUS_FMT_YVYU12_2X12 = 0x201f,
> -	V4L2_MBUS_FMT_UYVY12_1X24 = 0x2020,
> -	V4L2_MBUS_FMT_VYUY12_1X24 = 0x2021,
> -	V4L2_MBUS_FMT_YUYV12_1X24 = 0x2022,
> -	V4L2_MBUS_FMT_YVYU12_1X24 = 0x2023,
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB444_2X8_PADHI_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB444_2X8_PADHI_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB555_2X8_PADHI_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB555_2X8_PADHI_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(BGR565_2X8_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(BGR565_2X8_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB565_2X8_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB565_2X8_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB666_1X18),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB888_1X24),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB888_2X12_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB888_2X12_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(ARGB8888_1X32),
>  
> -	/* Bayer - next is 0x3019 */
> -	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
> -	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
> -	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> -	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
> -	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> -	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> -	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> -	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
> -	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
> -	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
> -	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
> -	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
> -	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
> -	V4L2_MBUS_FMT_SGBRG10_1X10 = 0x300e,
> -	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x300a,
> -	V4L2_MBUS_FMT_SRGGB10_1X10 = 0x300f,
> -	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
> -	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
> -	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
> -	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
> +	VIDEO_BUS_TO_V4L2_MBUS(Y8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(UV8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY8_1_5X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY8_1_5X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV8_1_5X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU8_1_5X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY8_2X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY8_2X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV8_2X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU8_2X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(Y10_1X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY10_2X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY10_2X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV10_2X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU10_2X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(Y12_1X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY8_1X16),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY8_1X16),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV8_1X16),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU8_1X16),
> +	VIDEO_BUS_TO_V4L2_MBUS(YDYUYDYV8_1X16),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY10_1X20),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY10_1X20),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV10_1X20),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU10_1X20),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUV10_1X30),
> +	VIDEO_BUS_TO_V4L2_MBUS(AYUV8_1X32),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY12_2X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY12_2X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV12_2X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU12_2X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(UYVY12_1X24),
> +	VIDEO_BUS_TO_V4L2_MBUS(VYUY12_1X24),
> +	VIDEO_BUS_TO_V4L2_MBUS(YUYV12_1X24),
> +	VIDEO_BUS_TO_V4L2_MBUS(YVYU12_1X24),
>  
> -	/* JPEG compressed formats - next is 0x4002 */
> -	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGBRG8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGRBG8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SRGGB8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_ALAW8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGBRG10_ALAW8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGRBG10_ALAW8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SRGGB10_ALAW8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_DPCM8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGBRG10_DPCM8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGRBG10_DPCM8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SRGGB10_DPCM8_1X8),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_2X8_PADHI_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_2X8_PADHI_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_2X8_PADLO_BE),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_2X8_PADLO_LE),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR10_1X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGBRG10_1X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGRBG10_1X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(SRGGB10_1X10),
> +	VIDEO_BUS_TO_V4L2_MBUS(SBGGR12_1X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGBRG12_1X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(SGRBG12_1X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(SRGGB12_1X12),
>  
> -	/* Vendor specific formats - next is 0x5002 */
> +	VIDEO_BUS_TO_V4L2_MBUS(JPEG_1X8),
>  
> -	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
> -	V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
> +	VIDEO_BUS_TO_V4L2_MBUS(S5C_UYVY_JPEG_1X8),
>  
> -	/* HSV - next is 0x6002 */
> -	V4L2_MBUS_FMT_AHSV8888_1X32 = 0x6001,
> +	VIDEO_BUS_TO_V4L2_MBUS(AHSV8888_1X32),
>  };
>  
>  /**
> diff --git a/include/uapi/linux/video-bus-format.h b/include/uapi/linux/video-bus-format.h
> new file mode 100644
> index 0000000..4abbd5d
> --- /dev/null
> +++ b/include/uapi/linux/video-bus-format.h
> @@ -0,0 +1,127 @@
> +/*
> + * Video Bus API header
> + *
> + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __LINUX_VIDEO_BUS_FORMAT_H
> +#define __LINUX_VIDEO_BUS_FORMAT_H
> +
> +/*
> + * These bus formats uniquely identify data formats on the data bus. Mostly
> + * they correspond to similarly named VIDEO_PIX_FMT_* formats, format 0 is
> + * reserved, VIDEO_BUS_FMT_FIXED shall be used by host-client pairs, where the
> + * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> + * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> + * transferred over the bus: "LE" means that the least significant bits are
> + * transferred first, "BE" means that the most significant bits are transferred
> + * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> + * incomplete high byte, are filled with padding bits.
> + *
> + * The bus formats are grouped by type, bus_width, bits per component, samples
> + * per pixel and order of subsamples. Numerical values are sorted using generic
> + * numerical sort order (8 thus comes before 10).
> + *
> + * As their value can't change when a new bus format is inserted in the
> + * enumeration, the bus formats are explicitly given a numerical value. The next
> + * free values for each category are listed below, update them when inserting
> + * new pixel codes.
> + */
> +enum video_bus_format {
> +	VIDEO_BUS_FMT_FIXED = 0x0001,
> +
> +	/* RGB - next is 0x100e */
> +	VIDEO_BUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
> +	VIDEO_BUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
> +	VIDEO_BUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> +	VIDEO_BUS_FMT_RGB555_2X8_PADHI_LE = 0x1004,
> +	VIDEO_BUS_FMT_BGR565_2X8_BE = 0x1005,
> +	VIDEO_BUS_FMT_BGR565_2X8_LE = 0x1006,
> +	VIDEO_BUS_FMT_RGB565_2X8_BE = 0x1007,
> +	VIDEO_BUS_FMT_RGB565_2X8_LE = 0x1008,
> +	VIDEO_BUS_FMT_RGB666_1X18 = 0x1009,
> +	VIDEO_BUS_FMT_RGB888_1X24 = 0x100a,
> +	VIDEO_BUS_FMT_RGB888_2X12_BE = 0x100b,
> +	VIDEO_BUS_FMT_RGB888_2X12_LE = 0x100c,
> +	VIDEO_BUS_FMT_ARGB8888_1X32 = 0x100d,
> +
> +	/* YUV (including grey) - next is 0x2024 */
> +	VIDEO_BUS_FMT_Y8_1X8 = 0x2001,
> +	VIDEO_BUS_FMT_UV8_1X8 = 0x2015,
> +	VIDEO_BUS_FMT_UYVY8_1_5X8 = 0x2002,
> +	VIDEO_BUS_FMT_VYUY8_1_5X8 = 0x2003,
> +	VIDEO_BUS_FMT_YUYV8_1_5X8 = 0x2004,
> +	VIDEO_BUS_FMT_YVYU8_1_5X8 = 0x2005,
> +	VIDEO_BUS_FMT_UYVY8_2X8 = 0x2006,
> +	VIDEO_BUS_FMT_VYUY8_2X8 = 0x2007,
> +	VIDEO_BUS_FMT_YUYV8_2X8 = 0x2008,
> +	VIDEO_BUS_FMT_YVYU8_2X8 = 0x2009,
> +	VIDEO_BUS_FMT_Y10_1X10 = 0x200a,
> +	VIDEO_BUS_FMT_UYVY10_2X10 = 0x2018,
> +	VIDEO_BUS_FMT_VYUY10_2X10 = 0x2019,
> +	VIDEO_BUS_FMT_YUYV10_2X10 = 0x200b,
> +	VIDEO_BUS_FMT_YVYU10_2X10 = 0x200c,
> +	VIDEO_BUS_FMT_Y12_1X12 = 0x2013,
> +	VIDEO_BUS_FMT_UYVY8_1X16 = 0x200f,
> +	VIDEO_BUS_FMT_VYUY8_1X16 = 0x2010,
> +	VIDEO_BUS_FMT_YUYV8_1X16 = 0x2011,
> +	VIDEO_BUS_FMT_YVYU8_1X16 = 0x2012,
> +	VIDEO_BUS_FMT_YDYUYDYV8_1X16 = 0x2014,
> +	VIDEO_BUS_FMT_UYVY10_1X20 = 0x201a,
> +	VIDEO_BUS_FMT_VYUY10_1X20 = 0x201b,
> +	VIDEO_BUS_FMT_YUYV10_1X20 = 0x200d,
> +	VIDEO_BUS_FMT_YVYU10_1X20 = 0x200e,
> +	VIDEO_BUS_FMT_YUV10_1X30 = 0x2016,
> +	VIDEO_BUS_FMT_AYUV8_1X32 = 0x2017,
> +	VIDEO_BUS_FMT_UYVY12_2X12 = 0x201c,
> +	VIDEO_BUS_FMT_VYUY12_2X12 = 0x201d,
> +	VIDEO_BUS_FMT_YUYV12_2X12 = 0x201e,
> +	VIDEO_BUS_FMT_YVYU12_2X12 = 0x201f,
> +	VIDEO_BUS_FMT_UYVY12_1X24 = 0x2020,
> +	VIDEO_BUS_FMT_VYUY12_1X24 = 0x2021,
> +	VIDEO_BUS_FMT_YUYV12_1X24 = 0x2022,
> +	VIDEO_BUS_FMT_YVYU12_1X24 = 0x2023,
> +
> +	/* Bayer - next is 0x3019 */
> +	VIDEO_BUS_FMT_SBGGR8_1X8 = 0x3001,
> +	VIDEO_BUS_FMT_SGBRG8_1X8 = 0x3013,
> +	VIDEO_BUS_FMT_SGRBG8_1X8 = 0x3002,
> +	VIDEO_BUS_FMT_SRGGB8_1X8 = 0x3014,
> +	VIDEO_BUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> +	VIDEO_BUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> +	VIDEO_BUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> +	VIDEO_BUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
> +	VIDEO_BUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
> +	VIDEO_BUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
> +	VIDEO_BUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
> +	VIDEO_BUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
> +	VIDEO_BUS_FMT_SBGGR10_1X10 = 0x3007,
> +	VIDEO_BUS_FMT_SGBRG10_1X10 = 0x300e,
> +	VIDEO_BUS_FMT_SGRBG10_1X10 = 0x300a,
> +	VIDEO_BUS_FMT_SRGGB10_1X10 = 0x300f,
> +	VIDEO_BUS_FMT_SBGGR12_1X12 = 0x3008,
> +	VIDEO_BUS_FMT_SGBRG12_1X12 = 0x3010,
> +	VIDEO_BUS_FMT_SGRBG12_1X12 = 0x3011,
> +	VIDEO_BUS_FMT_SRGGB12_1X12 = 0x3012,
> +
> +	/* JPEG compressed formats - next is 0x4002 */
> +	VIDEO_BUS_FMT_JPEG_1X8 = 0x4001,
> +
> +	/* Vendor specific formats - next is 0x5002 */
> +
> +	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
> +	VIDEO_BUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
> +
> +	/* HSV - next is 0x6002 */
> +	VIDEO_BUS_FMT_AHSV8888_1X32 = 0x6001,
> +};
> +
> +#endif /* __LINUX_VIDEO_BUS_FORMAT_H */
> 

