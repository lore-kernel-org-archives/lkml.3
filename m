Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbbA2HuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:50:12 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44643 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbbA2HuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:50:10 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 29 Jan 2015 16:51:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, lauraa@codeaurora.org
Subject: Re: [PATCH v3 3/3] mm: cma: release trigger
Message-ID: <20150129075130.GB19607@js1304-P5Q-DELUXE>
References: <1422411777-22332-1-git-send-email-sasha.levin@oracle.com>
 <1422411777-22332-4-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422411777-22332-4-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:22:57PM -0500, Sasha Levin wrote:
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
>  mm/cma_debug.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/mm/cma_debug.c b/mm/cma_debug.c
> index 5bd6863..c29f029 100644
> --- a/mm/cma_debug.c
> +++ b/mm/cma_debug.c
> @@ -39,6 +39,59 @@ static void cma_add_to_cma_mem_list(struct cma *cma, struct cma_mem *mem)
>  	spin_unlock(&cma->mem_head_lock);
>  }
>  
> +static struct cma_mem *cma_get_entry_from_list(struct cma *cma)
> +{
> +	struct cma_mem *mem = NULL;
> +
> +	spin_lock(&cma->mem_head_lock);
> +	if (!hlist_empty(&cma->mem_head)) {
> +		mem = hlist_entry(cma->mem_head.first, struct cma_mem, node);
> +		hlist_del_init(&mem->node);
> +	}
> +	spin_unlock(&cma->mem_head_lock);
> +
> +	return mem;
> +}
> +
> +static int cma_free_mem(struct cma *cma, int count)
> +{
> +	struct cma_mem *mem = NULL;
> +
> +	while (count) {
> +		mem = cma_get_entry_from_list(cma);
> +		if (mem == NULL)
> +			return 0;
> +
> +		if (mem->n <= count) {
> +			cma_release(cma, mem->p, mem->n);
> +			count -= mem->n;
> +			kfree(mem);
> +		} else if (cma->order_per_bit == 0) {
> +			cma_release(cma, mem->p, count);
> +			mem->p += count;
> +			mem->n -= count;
> +			count = 0;
> +			cma_add_to_cma_mem_list(cma, mem);
> +		} else {
> +			cma_add_to_cma_mem_list(cma, mem);
> +			break;
> +		}
> +	}

Hmm... I'm not sure we need to deal with "mem->m < count" case.
It is not suitable for any cma_alloc/release usecase.
And, I'd like to insert some error log to last case rather than
silently ignoring the request.

Thanks.
