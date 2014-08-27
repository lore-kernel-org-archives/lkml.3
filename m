Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936130AbaH0XFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:05:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaH0XFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:05:17 -0400
Date: Wed, 27 Aug 2014 16:05:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH 1/2] x86: Optimize resource lookups for ioremap
Message-Id: <20140827160515.c59f1c191fde5f788a7c42f6@linux-foundation.org>
In-Reply-To: <20140827225927.602319674@asylum.americas.sgi.com>
References: <20140827225927.364537333@asylum.americas.sgi.com>
	<20140827225927.602319674@asylum.americas.sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 17:59:28 -0500 Mike Travis <travis@sgi.com> wrote:

> Since the ioremap operation is verifying that the specified address range
> is NOT RAM, it will search the entire ioresource list if the condition
> is true.  To make matters worse, it does this one 4k page at a time.
> For a 128M BAR region this is 32 passes to determine the entire region
> does not contain any RAM addresses.
> 
> This patch provides another resource lookup function, region_is_ram,
> that searches for the entire region specified, verifying that it is
> completely contained within the resource region.  If it is found, then
> it is checked to be RAM or not, within a single pass.
> 
> The return result reflects if it was found or not (-1), and whether it is
> RAM (1) or not (0).  This allows the caller to fallback to the previous
> page by page search if it was not found.
> 
> ...
>
> --- linux.orig/kernel/resource.c
> +++ linux/kernel/resource.c
> @@ -494,6 +494,43 @@ int __weak page_is_ram(unsigned long pfn
>  }
>  EXPORT_SYMBOL_GPL(page_is_ram);
>  
> +/*
> + * Search for a resouce entry that fully contains the specified region.
> + * If found, return 1 if it is RAM, 0 if not.
> + * If not found, or region is not fully contained, return -1
> + *
> + * Used by the ioremap functions to insure user not remapping RAM and is as
> + * vast speed up over walking through the resource table page by page.
> + */
> +int __weak region_is_ram(resource_size_t start, unsigned long size)
> +{
> +	struct resource *p;
> +	resource_size_t end = start + size - 1;
> +	int flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> +	const char *name = "System RAM";
> +	int ret = -1;
> +
> +	read_lock(&resource_lock);
> +	for (p = iomem_resource.child; p ; p = p->sibling) {
> +		if (end < p->start)
> +			continue;
> +
> +		if (p->start <= start && end <= p->end) {
> +			/* resource fully contains region */
> +			if ((p->flags != flags) || strcmp(p->name, name))
> +				ret = 0;
> +			else
> +				ret = 1;
> +			break;
> +		}
> +		if (p->end < start)
> +			break;	/* not found */
> +	}
> +	read_unlock(&resource_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(region_is_ram);

Exporting a __weak symbol is strange.  I guess it works, but neither
the __weak nor the export are actually needed?

