Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaAHU0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:26:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbaAHU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:26:37 -0500
Date: Wed, 8 Jan 2014 12:27:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: x86@kernel.org, linuxppc-dev@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] drivers: base: support cpu cache information
 interface to userspace via sysfs
Message-ID: <20140108202707.GE8417@kroah.com>
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com>
 <1389209168-17189-2-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389209168-17189-2-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 07:26:06PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch adds initial support for providing processor cache information
> to userspace through sysfs interface. This is based on x86 implementation
> and hence the interface is intended to be fully compatible.
> 
> A per-cpu array of cache information maintained is used mainly for
> sysfs-related book keeping.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  drivers/base/Makefile     |   2 +-
>  drivers/base/cacheinfo.c  | 296 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cacheinfo.h |  43 +++++++
>  3 files changed, 340 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/base/cacheinfo.c
>  create mode 100644 include/linux/cacheinfo.h
> 
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 94e8a80..76f07c8 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -4,7 +4,7 @@ obj-y			:= core.o bus.o dd.o syscore.o \
>  			   driver.o class.o platform.o \
>  			   cpu.o firmware.o init.o map.o devres.o \
>  			   attribute_container.o transport_class.o \
> -			   topology.o
> +			   topology.o cacheinfo.o
>  obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
>  obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
>  obj-y			+= power/
> diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
> new file mode 100644
> index 0000000..f436c31
> --- /dev/null
> +++ b/drivers/base/cacheinfo.c
> @@ -0,0 +1,296 @@
> +/*
> + * cacheinfo support - processor cache information via sysfs
> + *
> + * Copyright (C) 2013 ARM Ltd.
> + * All Rights Reserved
> + *
> + * Author: Sudeep Holla <sudeep.holla@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/bitops.h>
> +#include <linux/cacheinfo.h>
> +#include <linux/compiler.h>
> +#include <linux/cpu.h>
> +#include <linux/device.h>
> +#include <linux/init.h>
> +#include <linux/kobject.h>
> +#include <linux/of.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/smp.h>
> +#include <linux/sysfs.h>
> +
> +struct cache_attr {
> +	struct attribute attr;
> +	 ssize_t(*show) (unsigned int, unsigned short, char *);
> +	 ssize_t(*store) (unsigned int, unsigned short, const char *, size_t);
> +};
> +
> +/* pointer to kobject for cpuX/cache */
> +static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
> +#define per_cpu_cache_kobject(cpu)     (per_cpu(ci_cache_kobject, cpu))
> +
> +struct index_kobject {
> +	struct kobject kobj;
> +	unsigned int cpu;
> +	unsigned short index;
> +};
> +
> +static cpumask_t cache_dev_map;
> +
> +/* pointer to array of kobjects for cpuX/cache/indexY */

Please don't use "raw" kobjects for this, use the device attribute
groups, that's what they are there for.  Bonus is that your code should
get a lot simpler when you do that.

thanks,

greg k-h
