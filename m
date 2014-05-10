Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaEJUXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 16:23:11 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61088 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaEJUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 16:23:08 -0400
Date: Sat, 10 May 2014 13:21:58 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jianyu Zhan <nasa4836@gmail.com>
cc: akpm@linux-foundation.org, riel@redhat.com, aarcange@redhat.com,
        fabf@skynet.be, zhangyanfei@cn.fujitsu.com, sasha.levin@oracle.com,
        mgorman@suse.de, oleg@redhat.com, n-horiguchi@ah.jp.nec.com,
        iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com,
        liwanp@linux.vnet.ibm.com, gorcunov@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: rename mlocked_vma_newpage to
 newpage_in_mlocked_vma
In-Reply-To: <7ab379a001bd44ed980a884f819178cffe7df577.1399705884.git.nasa4836@gmail.com>
Message-ID: <alpine.LSU.2.11.1405101316470.1680@eggly.anvils>
References: <1d32d83e54542050dba3f711a8d10b1e951a9a58.1399705884.git.nasa4836@gmail.com> <7ab379a001bd44ed980a884f819178cffe7df577.1399705884.git.nasa4836@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014, Jianyu Zhan wrote:

> mlocked_vma_newpage is used to determine if a new page is mapped into
> a *mlocked* vma. It is poorly named, so rename it to newpage_in_mlocked_vma.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

newpage_in_mlocked_vma() is not as bad a name as mlocked_vma_newpage(),
but it's not especially good either (sounds like it answers a question,
not like it actually does something).  Please just put it into its
sole caller and we don't need an obscuring name at all.

> ---
>  mm/internal.h | 4 ++--
>  mm/rmap.c     | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 20abafb..35efd79 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -183,7 +183,7 @@ static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
>  	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
>  }
>  
> -extern int mlocked_vma_newpage(struct vm_area_struct *vma,
> +extern int newpage_in_mlocked_vma(struct vm_area_struct *vma,
>  				struct page *page);

This should have vanished in the previous patch.

>  /*
>   * must be called with vma's mmap_sem held for read or write, and page locked.
> @@ -227,7 +227,7 @@ extern unsigned long vma_address(struct page *page,
>  				 struct vm_area_struct *vma);
>  #endif
>  #else /* !CONFIG_MMU */
> -static inline int mlocked_vma_newpage(struct vm_area_struct *v, struct page *p)
> +static inline int newpage_in_mlocked_vma(struct vm_area_struct *v, struct page *p)

Ditto.

Hugh

>  {
>  	return 0;
>  }
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a9d02ef..9ff6915 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1014,7 +1014,7 @@ void do_page_add_anon_rmap(struct page *page,
>   * pte is locked while calling page_add_new_anon_rmap(), so using a
>   * light-weight version __mod_zone_page_state() would be OK.
>   */
> -int mlocked_vma_newpage(struct vm_area_struct *vma,
> +int newpage_in_mlocked_vma(struct vm_area_struct *vma,
>  					struct page *page)
>  {
>  	VM_BUG_ON_PAGE(PageLRU(page), page);
> @@ -1050,7 +1050,7 @@ void page_add_new_anon_rmap(struct page *page,
>  	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
>  			hpage_nr_pages(page));
>  	__page_set_anon_rmap(page, vma, address, 1);
> -	if (!mlocked_vma_newpage(vma, page)) {
> +	if (!newpage_in_mlocked_vma(vma, page)) {
>  		SetPageActive(page);
>  		lru_cache_add(page);
>  	} else
> -- 
> 2.0.0-rc1
