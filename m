Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3LSA6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:58:07 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55355 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3LSA6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:58:05 -0500
X-AuditID: 9c93017d-b7c5eae000004296-1e-52b2449ba0fd
Date: Thu, 19 Dec 2013 09:58:05 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: fix BUG at rmap_walk
Message-ID: <20131219005805.GA25161@lge.com>
References: <1387412195-26498-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20131218162858.6ec808c067baf4644532e110@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218162858.6ec808c067baf4644532e110@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Dec 18, 2013 at 04:28:58PM -0800, Andrew Morton wrote:
> On Thu, 19 Dec 2013 08:16:35 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> 
> > page_get_anon_vma() called in page_referenced_anon() will lock and 
> > increase the refcount of anon_vma, page won't be locked for anonymous 
> > page. This patch fix it by skip check anonymous page locked.
> > 
> > [  588.698828] kernel BUG at mm/rmap.c:1663!
> 
> Why is all this suddenly happening.  Did we change something, or did a
> new test get added to trinity?

It is my fault.
I should remove this VM_BUG_ON() since rmap_walk() can be called
without holding PageLock() in this case.

I think that adding VM_BUG_ON() to each rmap_walk calllers is better
than this patch, because, now, rmap_walk() is called by many places and
each places has different contexts.

> 
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1660,7 +1660,8 @@ done:
> >  
> >  int rmap_walk(struct page *page, struct rmap_walk_control *rwc)
> >  {
> > -	VM_BUG_ON(!PageLocked(page));
> > +	if (!PageAnon(page) || PageKsm(page))
> > +		VM_BUG_ON(!PageLocked(page));
> >  
> >  	if (unlikely(PageKsm(page)))
> >  		return rmap_walk_ksm(page, rwc);
> 
> Is there any reason why rmap_walk_ksm() and rmap_walk_file() *need*
> PageLocked() whereas rmap_walk_anon() does not?  If so, let's implement
> it like this:

I will investigate this more.
I don't know why the pagelock is needed only (!PageAnon || PageKsm) case
on page_referenced(). I changed page_referenced() from it's own rmap walker
to common rmap walker directly. So for now, I don't know exact reason.

Thanks.

> 
> 
> --- a/mm/rmap.c~a
> +++ a/mm/rmap.c
> @@ -1716,6 +1716,10 @@ static int rmap_walk_file(struct page *p
>  	struct vm_area_struct *vma;
>  	int ret = SWAP_AGAIN;
>  
> +	/*
> +	 * page must be locked because <reason goes here>
> +	 */
> +	VM_BUG_ON(!PageLocked(page));
>  	if (!mapping)
>  		return ret;
>  	mutex_lock(&mapping->i_mmap_mutex);
> @@ -1737,8 +1741,6 @@ static int rmap_walk_file(struct page *p
>  int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
>  		struct vm_area_struct *, unsigned long, void *), void *arg)
>  {
> -	VM_BUG_ON(!PageLocked(page));
> -
>  	if (unlikely(PageKsm(page)))
>  		return rmap_walk_ksm(page, rmap_one, arg);
>  	else if (PageAnon(page))
> --- a/mm/ksm.c~a
> +++ a/mm/ksm.c
> @@ -2006,6 +2006,9 @@ int rmap_walk_ksm(struct page *page, int
>  	int search_new_forks = 0;
>  
>  	VM_BUG_ON(!PageKsm(page));
> +	/*
> +	 * page must be locked because <reason goes here>
> +	 */
>  	VM_BUG_ON(!PageLocked(page));
>  
>  	stable_node = page_stable_node(page);
> 
> 
> Or if there is no reason why the page must be locked for
> rmap_walk_ksm() and rmap_walk_file(), let's just remove rmap_walk()'s
> VM_BUG_ON()?  And rmap_walk_ksm()'s as well - it's duplicative anyway.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
