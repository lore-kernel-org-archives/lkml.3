Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbbA0II5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:08:57 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50833 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbA0IIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:08:55 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 27 Jan 2015 17:10:12 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH v2 3/3] mm: cma: release trigger
Message-ID: <20150127081012.GD11358@js1304-P5Q-DELUXE>
References: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com>
 <1422282365-20015-4-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422282365-20015-4-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:26:05AM -0500, Sasha Levin wrote:
> Provides a userspace interface to trigger a CMA release.
> 
> Usage:
> 
> 	echo [pages] > free
> 
> This would provide testing/fuzzing access to the CMA release paths.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  mm/cma_debug.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/mm/cma_debug.c b/mm/cma_debug.c
> index 39c7116..0a63945 100644
> --- a/mm/cma_debug.c
> +++ b/mm/cma_debug.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/dma-contiguous.h>
>  #include <linux/slab.h>
> +#include <linux/mm_types.h>

Is mm_types.h needed?

>  
>  #include "cma.h"
>  
> @@ -43,6 +44,56 @@ static void cma_add_to_cma_mem_list(struct cma_mem *mem)
>  	spin_unlock(&cma_mem_head_lock);
>  }
>  
> +static struct cma_mem *cma_get_entry_from_list(void)
> +{
> +	struct cma_mem *mem = NULL;
> +
> +	spin_lock(&cma_mem_head_lock);
> +	if (!hlist_empty(&cma_mem_head)) {
> +		mem = hlist_entry(cma_mem_head.first, struct cma_mem, node);
> +		hlist_del_init(&mem->node);
> +	}
> +	spin_unlock(&cma_mem_head_lock);
> +
> +	return mem;
> +}
> +
> +static int cma_free_mem(struct cma *cma, int count)
> +{
> +	struct cma_mem *mem = NULL;
> +
> +	while (count) {
> +		mem = cma_get_entry_from_list();
> +		if (mem == NULL)
> +			return 0;
> +
> +		if (mem->n <= count) {
> +			cma_release(cma, mem->p, mem->n);
> +			count -= mem->n;
> +			kfree(mem);
> +		} else {
> +			cma_release(cma, mem->p, count);
> +			mem->p += count;
> +			mem->n -= count;
> +			count = 0;
> +			cma_add_to_cma_mem_list(mem);
> +		}
> +	}

If order_per_bit is not 0 and count used in cma_release() is
different with the count used in cma_alloc(), problem could
occur since bitmap management code can't handle that situation.

Could we just disable this case in this testing module?

Thanks.
