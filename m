Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaAIUC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:02:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbaAIUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:02:49 -0500
Date: Thu, 9 Jan 2014 12:03:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] drivers: base: support cpu cache information
 interface to userspace via sysfs
Message-ID: <20140109200320.GA15986@kroah.com>
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
 <1389209168-17189-2-git-send-email-sudeep.holla@arm.com>
 <20140108202707.GE8417@kroah.com>
 <52CEF624.9020702@arm.com>
 <20140109193121.GA14991@kroah.com>
 <52CEFCE3.1040701@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CEFCE3.1040701@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 07:47:47PM +0000, Sudeep Holla wrote:
> On 09/01/14 19:31, Greg Kroah-Hartman wrote:
> > On Thu, Jan 09, 2014 at 07:19:00PM +0000, Sudeep Holla wrote:
> >> On 08/01/14 20:27, Greg Kroah-Hartman wrote:
> >>> On Wed, Jan 08, 2014 at 07:26:06PM +0000, Sudeep Holla wrote:
> >>>> From: Sudeep Holla <sudeep.holla@arm.com>
> >>>>
> >>>> This patch adds initial support for providing processor cache information
> >>>> to userspace through sysfs interface. This is based on x86 implementation
> >>>> and hence the interface is intended to be fully compatible.
> >>>>
> >>>> A per-cpu array of cache information maintained is used mainly for
> >>>> sysfs-related book keeping.
> >>>>
> >>>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> >>>> ---
> >>>>  drivers/base/Makefile     |   2 +-
> >>>>  drivers/base/cacheinfo.c  | 296 ++++++++++++++++++++++++++++++++++++++++++++++
> >>>>  include/linux/cacheinfo.h |  43 +++++++
> >>>>  3 files changed, 340 insertions(+), 1 deletion(-)
> >>>>  create mode 100644 drivers/base/cacheinfo.c
> >>>>  create mode 100644 include/linux/cacheinfo.h
> >>>>
> >>>> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> >>>> index 94e8a80..76f07c8 100644
> >>>> --- a/drivers/base/Makefile
> >>>> +++ b/drivers/base/Makefile
> >>>> @@ -4,7 +4,7 @@ obj-y			:= core.o bus.o dd.o syscore.o \
> >>>>  			   driver.o class.o platform.o \
> >>>>  			   cpu.o firmware.o init.o map.o devres.o \
> >>>>  			   attribute_container.o transport_class.o \
> >>>> -			   topology.o
> >>>> +			   topology.o cacheinfo.o
> >>>>  obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
> >>>>  obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
> >>>>  obj-y			+= power/
> >>>> diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
> >>>> new file mode 100644
> >>>> index 0000000..f436c31
> >>>> --- /dev/null
> >>>> +++ b/drivers/base/cacheinfo.c
> >>>> @@ -0,0 +1,296 @@
> >>>> +/*
> >>>> + * cacheinfo support - processor cache information via sysfs
> >>>> + *
> >>>> + * Copyright (C) 2013 ARM Ltd.
> >>>> + * All Rights Reserved
> >>>> + *
> >>>> + * Author: Sudeep Holla <sudeep.holla@arm.com>
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or modify
> >>>> + * it under the terms of the GNU General Public License version 2 as
> >>>> + * published by the Free Software Foundation.
> >>>> + *
> >>>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> >>>> + * kind, whether express or implied; without even the implied warranty
> >>>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>> + * GNU General Public License for more details.
> >>>> + */
> >>>> +#include <linux/bitops.h>
> >>>> +#include <linux/cacheinfo.h>
> >>>> +#include <linux/compiler.h>
> >>>> +#include <linux/cpu.h>
> >>>> +#include <linux/device.h>
> >>>> +#include <linux/init.h>
> >>>> +#include <linux/kobject.h>
> >>>> +#include <linux/of.h>
> >>>> +#include <linux/sched.h>
> >>>> +#include <linux/slab.h>
> >>>> +#include <linux/smp.h>
> >>>> +#include <linux/sysfs.h>
> >>>> +
> >>>> +struct cache_attr {
> >>>> +	struct attribute attr;
> >>>> +	 ssize_t(*show) (unsigned int, unsigned short, char *);
> >>>> +	 ssize_t(*store) (unsigned int, unsigned short, const char *, size_t);
> >>>> +};
> >>>> +
> >>>> +/* pointer to kobject for cpuX/cache */
> >>>> +static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
> >>>> +#define per_cpu_cache_kobject(cpu)     (per_cpu(ci_cache_kobject, cpu))
> >>>> +
> >>>> +struct index_kobject {
> >>>> +	struct kobject kobj;
> >>>> +	unsigned int cpu;
> >>>> +	unsigned short index;
> >>>> +};
> >>>> +
> >>>> +static cpumask_t cache_dev_map;
> >>>> +
> >>>> +/* pointer to array of kobjects for cpuX/cache/indexY */
> >>>
> >>> Please don't use "raw" kobjects for this, use the device attribute
> >>> groups, that's what they are there for.  Bonus is that your code should
> >>> get a lot simpler when you do that.
> >>>
> >>
> >> Yes I now understand device attribute group simplifies the code, but I think
> >> kobjects are still needed as we need to track both cpu and cache index.
> >> By reusing only cpu device kobject, we can track cpu only.
> > 
> > I don't understand, you are putting things under the cpu device object,
> > why do you care about a "cache" kobject?
> > 
> Yes though the cache attributes are under cpu objects, it's hierarchical
> something like:
> /sys/devices/system/cpu/cpu<n>/cache/index<m>/<attribute_x>
> <attribute_x> is unique for each pair of (cpu<n>, index<m>
> index is more like cache level, but with 2 indices if they are separate(I$,D$)

Then make the "cache" a struct device, and then create the attribute
group under that?  You'll want that anyway as you don't have any
visibility to userspace tools by using raw kobjects, they don't see them
at all (i.e. libudev and the like.)

thanks,

greg k-h
