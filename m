Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbbA0IEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:04:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48039 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbbA0IEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:04:48 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 27 Jan 2015 17:06:03 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH v2 2/3] mm: cma: allocation trigger
Message-ID: <20150127080603.GC11358@js1304-P5Q-DELUXE>
References: <1422282365-20015-1-git-send-email-sasha.levin@oracle.com>
 <1422282365-20015-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422282365-20015-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:26:04AM -0500, Sasha Levin wrote:
> Provides a userspace interface to trigger a CMA allocation.
> 
> Usage:
> 
> 	echo [pages] > alloc
> 
> This would provide testing/fuzzing access to the CMA allocation paths.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  mm/cma_debug.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/cma_debug.c b/mm/cma_debug.c
> index 3a25413..39c7116 100644
> --- a/mm/cma_debug.c
> +++ b/mm/cma_debug.c
> @@ -7,9 +7,22 @@
>  
>  #include <linux/debugfs.h>
>  #include <linux/cma.h>
> +#include <linux/list.h>
> +#include <linux/kernel.h>
> +#include <linux/dma-contiguous.h>

dma-contiguous.h doesn't needed now.

> +#include <linux/slab.h>
>  
>  #include "cma.h"
>  
> +struct cma_mem {
> +	struct hlist_node node;
> +	struct page *p;
> +	unsigned long n;
> +};
> +
> +static HLIST_HEAD(cma_mem_head);
> +static DEFINE_SPINLOCK(cma_mem_head_lock);
> +
>  static struct dentry *cma_debugfs_root;

How about keeping cma_mem_head on each cma area separately?

>  static int cma_debugfs_get(void *data, u64 *val)
> @@ -23,8 +36,48 @@ static int cma_debugfs_get(void *data, u64 *val)
>  
>  DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
>  
> -static void cma_debugfs_add_one(struct cma *cma, int idx)
> +static void cma_add_to_cma_mem_list(struct cma_mem *mem)
> +{
> +	spin_lock(&cma_mem_head_lock);
> +	hlist_add_head(&mem->node, &cma_mem_head);
> +	spin_unlock(&cma_mem_head_lock);
> +}
> +
> +static int cma_alloc_mem(struct cma *cma, int count)
>  {
> +	struct cma_mem *mem;
> +	struct page *p;
> +
> +	mem = kzalloc(sizeof(*mem), GFP_KERNEL);
> +	if (!mem)
> +		return -ENOMEM;
> +
> +	p = cma_alloc(cma, count, CONFIG_CMA_ALIGNMENT);
> +	if (!p) {
> +		kfree(mem);
> +		return -ENOMEM;
> +	}

CONFIG_CMA_ALIGNMENT looks not good. It means just maximum aligment
so it is odd to use this value in testing. Is there special meaning
to use it here?

Could we also get alignment parameter from user? Something like below.

echo "4 1" > alloc
4 for number of pages
1 for alignment.

If it is impossible, just 0 looks better than CONFIG_CMA_ALIGNMENT.

Thanks.
