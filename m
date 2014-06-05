Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaFERjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:39:16 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50645 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaFERjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:39:13 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC PATCH 1/3] CMA: generalize CMA reserved area management functionality
In-Reply-To: <1401757919-30018-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com> <1401757919-30018-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 05 Jun 2014 23:09:05 +0530
Message-ID: <87zjhrtfwm.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060517-9574-0000-0000-00000E117486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Currently, there are two users on CMA functionality, one is the DMA
> subsystem and the other is the kvm on powerpc. They have their own code
> to manage CMA reserved area even if they looks really similar.
> From my guess, it is caused by some needs on bitmap management. Kvm side
> wants to maintain bitmap not for 1 page, but for more size. Eventually it
> use bitmap where one bit represents 64 pages.
>
> When I implement CMA related patches, I should change those two places
> to apply my change and it seem to be painful to me. I want to change
> this situation and reduce future code management overhead through
> this patch.
>
> This change could also help developer who want to use CMA in their
> new feature development, since they can use CMA easily without
> copying & pasting this reserved area management code.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>


The way patches are split makes it difficult to review. Will it be
possible to make changes against one implementation and them move that
to generic code. That helps in finding out what exactly changed.

>
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 00e13ce..b3fe1cc 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -283,7 +283,7 @@ config CMA_ALIGNMENT
>
>  	  If unsure, leave the default value "8".
>
> -config CMA_AREAS
> +config DMA_CMA_AREAS
>  	int "Maximum count of the CMA device-private areas"
>  	default 7
>  	help

for ex: The above can be a seperate patch along with further DMA related
cleanups . 


> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 83969f8..48cdac8 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -186,7 +186,7 @@ static int __init cma_activate_area(struct cma *cma)
>  	return 0;
>  }
>
> -static struct cma cma_areas[MAX_CMA_AREAS];
> +static struct cma cma_areas[MAX_DMA_CMA_AREAS];
>  static unsigned cma_area_count;
>
>  static int __init cma_init_reserved_areas(void)
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> new file mode 100644
> index 0000000..60ba06f
> --- /dev/null
> +++ b/include/linux/cma.h
> @@ -0,0 +1,28 @@
> +/*
> + * Contiguous Memory Allocator
> + *
> + * Copyright LG Electronics Inc., 2014
> + * Written by:
> + *	Joonsoo Kim <iamjoonsoo.kim@lge.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License or (at your optional) any later version of the license.
> + *
> + */
> +
> +#ifndef __CMA_H__
> +#define __CMA_H__
> +
> +struct cma;
> +
> +extern struct page *cma_alloc(struct cma *cma, unsigned long count,
> +				unsigned long align);
> +extern bool cma_release(struct cma *cma, struct page *pages,
> +				unsigned long count);
> +extern int __init cma_declare_contiguous(phys_addr_t size, phys_addr_t base,
> +				phys_addr_t limit, phys_addr_t alignment,
> +				unsigned long bitmap_shift, bool fixed,
> +				struct cma **res_cma);
> +#endif
> diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
> index 772eab5..dfb1dc9 100644
> --- a/include/linux/dma-contiguous.h
> +++ b/include/linux/dma-contiguous.h
> @@ -63,7 +63,7 @@ struct device;
>   * There is always at least global CMA area and a few optional device
>   * private areas configured in kernel .config.
>   */
> -#define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
> +#define MAX_DMA_CMA_AREAS  (1 + CONFIG_DMA_CMA_AREAS)
>
>  extern struct cma *dma_contiguous_default_area;
>
> @@ -123,7 +123,7 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>
>  #else
>
> -#define MAX_CMA_AREAS	(0)
> +#define MAX_DMA_CMA_AREAS	(0)
>
>  static inline struct cma *dev_get_cma_area(struct device *dev)
>  {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 7511b4a..0877ddc 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -515,6 +515,17 @@ config CMA_DEBUG
>  	  processing calls such as dma_alloc_from_contiguous().
>  	  This option does not affect warning and error messages.
>
> +config CMA_AREAS
> +	int "Maximum count of the CMA areas"
> +	depends on CMA
> +	default 7
> +	help
> +	  CMA allows to create CMA areas for particular purpose, mainly,
> +	  used as device private area. This parameter sets the maximum
> +	  number of CMA area in the system.
> +
> +	  If unsure, leave the default value "7".
> +

If we have 7 declare continugous request, a kvm cma allocation request will fail ?

>  config ZBUD
>  	tristate
>  	default n
> diff --git a/mm/Makefile b/mm/Makefile
> index 1eaa70b..bc0422b 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -62,3 +62,4 @@ obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
>  obj-$(CONFIG_ZBUD)	+= zbud.o
>  obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
>  obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
> +obj-$(CONFIG_CMA)	+= cma.o
> diff --git a/mm/cma.c b/mm/cma.c
> new file mode 100644
> index 0000000..0dae88d
> --- /dev/null
> +++ b/mm/cma.c
> @@ -0,0 +1,329 @@
> +/*
> + * Contiguous Memory Allocator
> + *
> + * Copyright (c) 2010-2011 by Samsung Electronics.
> + * Copyright IBM Corporation, 2013
> + * Copyright LG Electronics Inc., 2014
> + * Written by:
> + *	Marek Szyprowski <m.szyprowski@samsung.com>
> + *	Michal Nazarewicz <mina86@mina86.com>
> + *	Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> + *	Joonsoo Kim <iamjoonsoo.kim@lge.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License or (at your optional) any later version of the license.
> + */
> +
> +#define pr_fmt(fmt) "cma: " fmt
> +
> +#ifdef CONFIG_CMA_DEBUG
> +#ifndef DEBUG
> +#  define DEBUG
> +#endif
> +#endif
> +
> +#include <linux/memblock.h>
> +#include <linux/err.h>
> +#include <linux/mm.h>
> +#include <linux/mutex.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +
> +struct cma {
> +	unsigned long	base_pfn;
> +	unsigned long	count;
> +	unsigned long	*bitmap;
> +	unsigned long	bitmap_shift;

I guess this is added to accommodate the kvm specific alloc chunks. May
be you should do this as a patch against kvm implementation and then
move the code to generic ?

> +	struct mutex	lock;
> +};
> +

-aneesh

