Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKGNK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:10:58 -0500
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57724 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbaKGNKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:10:54 -0500
Message-ID: <545CC4C4.6080600@xs4all.nl>
Date: Fri, 07 Nov 2014 14:10:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 01/10] [media] Move mediabus format definition to a
 more standard place
References: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com> <1415267829-4177-2-git-send-email-boris.brezillon@free-electrons.com> <20141107114358.GB3136@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141107114358.GB3136@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 12:43, Sakari Ailus wrote:
> Hi Boris,
> 
> Thank you for the update.
> 
> On Thu, Nov 06, 2014 at 10:56:59AM +0100, Boris Brezillon wrote:
>> Rename mediabus formats and move the enum into a separate header file so
>> that it can be used by DRM/KMS subsystem without any reference to the V4L2
>> subsystem.
>>
>> Old v4l2_mbus_pixelcode now points to media_bus_format.
>>
>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> ---
>>  include/uapi/linux/Kbuild             |   1 +
>>  include/uapi/linux/media-bus-format.h | 131 ++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/v4l2-mediabus.h    | 114 +----------------------------
>>  3 files changed, 134 insertions(+), 112 deletions(-)
>>  create mode 100644 include/uapi/linux/media-bus-format.h
>>
>> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
>> index b70237e..b2c23f8 100644
>> --- a/include/uapi/linux/Kbuild
>> +++ b/include/uapi/linux/Kbuild
>> @@ -414,6 +414,7 @@ header-y += veth.h
>>  header-y += vfio.h
>>  header-y += vhost.h
>>  header-y += videodev2.h
>> +header-y += media-bus-format.h
> 
> Could you arrange this to the list alphabetically, please?
> 
>>  header-y += virtio_9p.h
>>  header-y += virtio_balloon.h
>>  header-y += virtio_blk.h
>> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
>> new file mode 100644
>> index 0000000..251a902
>> --- /dev/null
>> +++ b/include/uapi/linux/media-bus-format.h
>> @@ -0,0 +1,131 @@
>> +/*
>> + * Media Bus API header
>> + *
>> + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __LINUX_MEDIA_BUS_FORMAT_H
>> +#define __LINUX_MEDIA_BUS_FORMAT_H
>> +
>> +/*
>> + * These bus formats uniquely identify data formats on the data bus. Format 0
>> + * is reserved, MEDIA_BUS_FMT_FIXED shall be used by host-client pairs, where
>> + * the data format is fixed. Additionally, "2X8" means that one pixel is
>> + * transferred in two 8-bit samples, "BE" or "LE" specify in which order those
>> + * samples are transferred over the bus: "LE" means that the least significant
>> + * bits are transferred first, "BE" means that the most significant bits are
>> + * transferred first, and "PADHI" and "PADLO" define which bits - low or high,
>> + * in the incomplete high byte, are filled with padding bits.
>> + *
>> + * The bus formats are grouped by type, bus_width, bits per component, samples
>> + * per pixel and order of subsamples. Numerical values are sorted using generic
>> + * numerical sort order (8 thus comes before 10).
>> + *
>> + * As their value can't change when a new bus format is inserted in the
>> + * enumeration, the bus formats are explicitly given a numerical value. The next
>> + * free values for each category are listed below, update them when inserting
>> + * new pixel codes.
>> + */
>> +
>> +#define MEDIA_BUS_FMT_ENTRY(name, val)	\
>> +	MEDIA_BUS_FMT_ ## name = val,	\
>> +	V4L2_MBUS_FMT_ ## name = val
>> +
>> +enum media_bus_format {
> 
> There's no really a need to keep the definitions inside the enum. It looks a
> little bit confusing to me. That made me realise something I missed
> yesterday.
> 
> There's a difference: the enum in C++ is a different thing than in C, and
> the enum type isn't able to contain any other values than those defined in
> the enumeration.
> 
> So what I propose is the following. Keep enum v4l2_mbus_pixelcode around,
> including the enum values. Define new values for MEDIA_BUS_* equivalents
> using preprocessor macros, as you've done below. Drop the definition of enum
> media_bus_format, and use u32 (or uint32_t) type for the variables.
> 
> This way the enum stays intact for existing C++ applications, and new
> applications will have to use a 32-bit type.
> 
> I'd like to get an ok from Hans to this as well.

OK, let's do this. Let's keep enum v4l2_mbus_pixelcode but only under #ifndef
__KERNEL and with a comment that this enum is deprecated and frozen and that
the values from the new header should be used.

And make the new MEDIA_BUS_FMT_ values defines instead of an enum.

Regards,

	Hans
