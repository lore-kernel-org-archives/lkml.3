Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733Ab3DIFsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:48:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48172 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3DIFsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:48:36 -0400
Date: Tue, 9 Apr 2013 13:48:25 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, guz.fnst@cn.fujitsu.com, tmac@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [UPDATE][PATCH v2 2/3] resource: Add
 release_mem_region_adjustable()
Message-ID: <20130409054825.GB7251@ram.oc3035372033.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1365457655-7453-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365457655-7453-1-git-send-email-toshi.kani@hp.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040905-2876-0000-0000-000007431719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:47:35PM -0600, Toshi Kani wrote:
> Added release_mem_region_adjustable(), which releases a requested
> region from a currently busy memory resource.  This interface
> adjusts the matched memory resource accordingly even if the
> requested region does not match exactly but still fits into.
> 
> This new interface is intended for memory hot-delete.  During
> bootup, memory resources are inserted from the boot descriptor
> table, such as EFI Memory Table and e820.  Each memory resource
> entry usually covers the whole contigous memory range.  Memory
> hot-delete request, on the other hand, may target to a particular
> range of memory resource, and its size can be much smaller than
> the whole contiguous memory.  Since the existing release interfaces
> like __release_region() require a requested region to be exactly
> matched to a resource entry, they do not allow a partial resource
> to be released.
> 
> There is no change to the existing interfaces since their restriction
> is valid for I/O resources.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by : Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
> 
> Added #ifdef CONFIG_MEMORY_HOTPLUG as suggested by Andrew Morton.
> 
> ---
>  include/linux/ioport.h |    4 ++
>  kernel/resource.c      |   96 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 100 insertions(+)
> 
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 85ac9b9b..961d4dc 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -192,6 +192,10 @@ extern struct resource * __request_region(struct resource *,
>  extern int __check_region(struct resource *, resource_size_t, resource_size_t);
>  extern void __release_region(struct resource *, resource_size_t,
>  				resource_size_t);
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +extern int release_mem_region_adjustable(struct resource *, resource_size_t,
> +				resource_size_t);
> +#endif
> 
>  static inline int __deprecated check_region(resource_size_t s,
>  						resource_size_t n)
> diff --git a/kernel/resource.c b/kernel/resource.c
> index ae246f9..25b945c 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1021,6 +1021,102 @@ void __release_region(struct resource *parent, resource_size_t start,
>  }
>  EXPORT_SYMBOL(__release_region);
> 
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +/**
> + * release_mem_region_adjustable - release a previously reserved memory region
> + * @parent: parent resource descriptor
> + * @start: resource start address
> + * @size: resource region size
> + *
> + * This interface is intended for memory hot-delete.  The requested region is
> + * released from a currently busy memory resource.  It adjusts the matched
> + * busy memory resource accordingly even if the requested region does not
> + * match exactly but still fits into.  Existing children of the busy memory
> + * resource must be immutable in this request.
> + *
> + * Note, when the busy memory resource gets split into two entries, the code
> + * assumes that all children remain in the lower address entry for simplicity.
> + * Enhance this logic when necessary.
> + */
> +int release_mem_region_adjustable(struct resource *parent,
> +			resource_size_t start, resource_size_t size)
> +{
> +	struct resource **p;
> +	struct resource *res, *new;
> +	resource_size_t end;
> +	int ret = -EINVAL;
> +
> +	end = start + size - 1;
> +	if ((start < parent->start) || (end > parent->end))
> +		return ret;
> +
> +	p = &parent->child;
> +	write_lock(&resource_lock);
> +
> +	while ((res = *p)) {
> +		if (res->start >= end)
> +			break;
> +
> +		/* look for the next resource if it does not fit into */
> +		if (res->start > start || res->end < end) {
> +			p = &res->sibling;
> +			continue;
> +		}

What if the resource overlaps. In other words, the res->start > start 
but res->end > end  ? 

Also do you handle the case where the range <start,end> spans
across multiple adjacent resources?

-- 
Ram Pai

