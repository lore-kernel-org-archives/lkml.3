Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbaHHWhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:37:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759794AbaHHWgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:36:38 -0400
Date: Fri, 8 Aug 2014 15:36:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Riley <davidriley@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Ritesh Harjain <ritesh.harjani@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6 1/5] lib/genalloc.c: Add power aligned algorithm
Message-Id: <20140808153635.36f27a4fbfbd8f715e51d15e@linux-foundation.org>
In-Reply-To: <1407529397-6642-1-git-send-email-lauraa@codeaurora.org>
References: <1407529397-6642-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Aug 2014 13:23:13 -0700 Laura Abbott <lauraa@codeaurora.org> wrote:

> 
> One of the more common algorithms used for allocation
> is to align the start address of the allocation to
> the order of size requested. Add this as an algorithm
> option for genalloc.
> 
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -481,6 +481,27 @@ unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
>  EXPORT_SYMBOL(gen_pool_first_fit);
>  
>  /**
> + * gen_pool_first_fit_order_align - find the first available region
> + * of memory matching the size requirement. The region will be aligned
> + * to the order of the size specified.
> + * @map: The address to base the search on
> + * @size: The bitmap size in bits
> + * @start: The bitnumber to start searching at
> + * @nr: The number of zeroed bits we're looking for
> + * @data: additional data - unused

`data' is used.

> + */
> +unsigned long gen_pool_first_fit_order_align(unsigned long *map,
> +		unsigned long size, unsigned long start,
> +		unsigned int nr, void *data)
> +{
> +	unsigned long order = (unsigned long) data;

Why pass a void*?  Why not pass "unsigned order;"?

> +	unsigned long align_mask = (1 << get_order(nr << order)) - 1;
> +
> +	return bitmap_find_next_zero_area(map, size, start, nr, align_mask);
> +}
> +EXPORT_SYMBOL(gen_pool_first_fit_order_align);
> +
> +/**
>   * gen_pool_best_fit - find the best fitting region of memory
>   * macthing the size requirement (no alignment constraint)
>   * @map: The address to base the search on

