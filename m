Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaFLEln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 00:41:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60434 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaFLEll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 00:41:41 -0400
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
Subject: Re: [PATCH v2 01/10] DMA, CMA: clean-up log message
In-Reply-To: <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 12 Jun 2014 10:11:19 +0530
Message-ID: <87y4x2pwnk.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061204-2000-0000-0000-0000007ED7E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> We don't need explicit 'CMA:' prefix, since we already define prefix
> 'cma:' in pr_fmt. So remove it.
>
> And, some logs print function name and others doesn't. This looks
> bad to me, so I unify log format to print function name consistently.
>
> Lastly, I add one more debug log on cma_activate_area().
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 83969f8..bd0bb81 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -144,7 +144,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>  	}
>
>  	if (selected_size && !dma_contiguous_default_area) {
> -		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
> +		pr_debug("%s(): reserving %ld MiB for global area\n", __func__,
>  			 (unsigned long)selected_size / SZ_1M);

Do we need to do function(), or just function:. I have seen the later
usage in other parts of the kernel.

>
>  		dma_contiguous_reserve_area(selected_size, selected_base,
> @@ -163,8 +163,9 @@ static int __init cma_activate_area(struct cma *cma)
>  	unsigned i = cma->count >> pageblock_order;
>  	struct zone *zone;
>
> -	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> +	pr_debug("%s()\n", __func__);

why ?

>
> +	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
>  	if (!cma->bitmap)
>  		return -ENOMEM;
>
> @@ -234,7 +235,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>
>  	/* Sanity checks */
>  	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> -		pr_err("Not enough slots for CMA reserved regions!\n");
> +		pr_err("%s(): Not enough slots for CMA reserved regions!\n",
> +			__func__);
>  		return -ENOSPC;
>  	}
>
> @@ -274,14 +276,15 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>  	*res_cma = cma;
>  	cma_area_count++;
>
> -	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> -		(unsigned long)base);
> +	pr_info("%s(): reserved %ld MiB at %08lx\n",
> +		__func__, (unsigned long)size / SZ_1M, (unsigned long)base);
>
>  	/* Architecture specific contiguous memory fixup. */
>  	dma_contiguous_early_fixup(base, size);
>  	return 0;
>  err:
> -	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
> +	pr_err("%s(): failed to reserve %ld MiB\n",
> +		__func__, (unsigned long)size / SZ_1M);
>  	return ret;
>  }
>
> -- 
> 1.7.9.5

