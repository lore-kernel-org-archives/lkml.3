Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3HGGIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:08:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:52379 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3HGGIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:08:13 -0400
Date: Wed, 7 Aug 2013 02:08:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/4] mm, rmap: allocate anon_vma_chain before starting to
 link anon_vma_chain
Message-ID: <20130807060803.GJ1845@cmpxchg.org>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778620-31593-2-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778620-31593-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:43:38PM +0900, Joonsoo Kim wrote:
> If we allocate anon_vma_chain before starting to link, we can reduce
> the lock hold time. This patch implement it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index c2f51cb..1603f64 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -240,18 +240,21 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  {
>  	struct anon_vma_chain *avc, *pavc;
>  	struct anon_vma *root = NULL;
> +	LIST_HEAD(avc_list);
> +
> +	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
> +		avc = anon_vma_chain_alloc(GFP_KERNEL);
> +		if (unlikely(!avc))
> +			goto enomem_failure;
> +
> +		list_add_tail(&avc->same_vma, &avc_list);
> +	}
>  
>  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma;
>  
> -		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
> -		if (unlikely(!avc)) {
> -			unlock_anon_vma_root(root);
> -			root = NULL;
> -			avc = anon_vma_chain_alloc(GFP_KERNEL);
> -			if (!avc)
> -				goto enomem_failure;
> -		}
> +		avc = list_entry((&avc_list)->next, typeof(*avc), same_vma);

list_first_entry() please

> +		list_del(&avc->same_vma);
>  		anon_vma = pavc->anon_vma;
>  		root = lock_anon_vma_root(root, anon_vma);
>  		anon_vma_chain_link(dst, avc, anon_vma);
> @@ -259,8 +262,11 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  	unlock_anon_vma_root(root);
>  	return 0;
>  
> - enomem_failure:
> -	unlink_anon_vmas(dst);
> +enomem_failure:
> +	list_for_each_entry_safe(avc, pavc, &avc_list, same_vma) {
> +		list_del(&avc->same_vma);
> +		anon_vma_chain_free(avc);
> +	}
>  	return -ENOMEM;
>  }

Otherwise, looks good.

Thanks!
