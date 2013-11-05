Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3KEXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:01:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3KEXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:01:46 -0500
Date: Tue, 5 Nov 2013 15:01:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] mm: create a separate slab for page->ptl allocation
Message-Id: <20131105150145.734a5dd5b5d455800ebfa0d3@linux-foundation.org>
In-Reply-To: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1382442839-7458-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 14:53:59 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> If DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC are enabled spinlock_t on x86_64
> is 72 bytes. For page->ptl they will be allocated from kmalloc-96 slab,
> so we loose 24 on each. An average system can easily allocate few tens
> thousands of page->ptl and overhead is significant.
> 
> Let's create a separate slab for page->ptl allocation to solve this.
> 
> ...
>
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4332,11 +4332,19 @@ void copy_user_huge_page(struct page *dst, struct page *src,
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>  
>  #if USE_SPLIT_PTE_PTLOCKS
> +struct kmem_cache *page_ptl_cachep;
> +void __init ptlock_cache_init(void)
> +{
> +	if (sizeof(spinlock_t) > sizeof(long))
> +		page_ptl_cachep = kmem_cache_create("page->ptl",
> +				sizeof(spinlock_t), 0, SLAB_PANIC, NULL);
> +}

Confused.  If (sizeof(spinlock_t) > sizeof(long)) happens to be false
then the kernel will later crash.  It would be better to use BUILD_BUG_ON()
here, if that works.  Otherwise BUG_ON.

Also, we have the somewhat silly KMEM_CACHE() macro, but it looks
inapplicable here?

>  bool __ptlock_alloc(struct page *page)
>  {
>  	spinlock_t *ptl;
>  
> -	ptl = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
> +	ptl = kmem_cache_alloc(page_ptl_cachep, GFP_KERNEL);
>  	if (!ptl)
>  		return false;
>  	page->ptl = (unsigned long)ptl;
> @@ -4346,6 +4354,6 @@ bool __ptlock_alloc(struct page *page)
>  void __ptlock_free(struct page *page)
>  {
>  	if (sizeof(spinlock_t) > sizeof(page->ptl))
> -		kfree((spinlock_t *)page->ptl);
> +		kmem_cache_free(page_ptl_cachep, (spinlock_t *)page->ptl);

A void* cast would suffice here, but I suppose the spinlock_t* cast has
some documentation value.

