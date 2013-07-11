Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3GKWNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:13:11 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35144 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab3GKWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:13:06 -0400
Date: Thu, 11 Jul 2013 15:13:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mempolicy: turn vma_set_policy() into
 vma_dup_policy()
In-Reply-To: <20130710170205.GA26425@redhat.com>
Message-ID: <alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com>
References: <20130710170205.GA26425@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Oleg Nesterov wrote:

> Simple cleanup. Every user of vma_set_policy() does the same work,
> this looks a bit annoying imho. And the new trivial helper which
> does mpol_dup() + vma_set_policy() to simplify the callers.
> 

Good idea, just a few simple issues to fix.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4baf12e..6b1d426 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2065,6 +2065,16 @@ retry_cpuset:
>  }
>  EXPORT_SYMBOL(alloc_pages_current);
>  
> +int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
> +{
> +	struct mempolicy *pol = mpol_dup(vma_policy(src));
> +
> +	if (IS_ERR(pol))
> +		return PTR_ERR(pol);

PTR_ERR() returns long, so vma_dup_policy() needs to return long.

> +	dst->vm_policy = pol;
> +	return 0;
> +}
> +
>  /*
>   * If mpol_dup() sees current->cpuset == cpuset_being_rebound, then it
>   * rebinds the mempolicy its copying by calling mpol_rebind_policy()
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7a1ba76..d8a310b 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2481,7 +2481,6 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>  static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
>  	      unsigned long addr, int new_below)
>  {
> -	struct mempolicy *pol;
>  	struct vm_area_struct *new;
>  	int err = -ENOMEM;
>  
> @@ -2505,12 +2504,9 @@ static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
>  		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
>  	}
>  
> -	pol = mpol_dup(vma_policy(vma));
> -	if (IS_ERR(pol)) {
> -		err = PTR_ERR(pol);
> +	err = vma_dup_policy(vma, new);
> +	if (err)
>  		goto out_free_vma;
> -	}
> -	vma_set_policy(new, pol);
>  
>  	if (anon_vma_clone(new, vma))
>  		goto out_free_mpol;

This isn't the first occurrence in mm/mmap.c, what about vma_adjust()?  
Probably need to patch 3.10 or later.

Otherwise looks good.
