Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3LMPLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:11:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3LMPLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:11:13 -0500
Date: Fri, 13 Dec 2013 16:10:35 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at exit)
Message-ID: <20131213151035.GE5408@redhat.com>
References: <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
 <20131211170844.GA21700@redhat.com>
 <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
 <20131211175615.GA24546@redhat.com>
 <20131211191855.GA32485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211191855.GA32485@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:18:55PM +0100, Oleg Nesterov wrote:
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -210,7 +210,7 @@ EXPORT_SYMBOL(put_page);
>   * This function is exported but must not be called by anything other
>   * than get_page(). It implements the slow path of get_page().
>   */
> -bool __get_page_tail(struct page *page)
> +static struct page *__get_compound_head(struct page *page, bool and_tail)
>  {

This is not necessarily inline (unlike __get_page_tail_foll which is
inline and optimizes away the build time known "false"/"true" params).

>  	/*
>  	 * This takes care of get_page() if run on a tail page
> @@ -234,8 +234,9 @@ bool __get_page_tail(struct page *page)
>  				 * cannot race here.
>  				 */
>  				VM_BUG_ON(!PageHead(page_head));
> -				__get_page_tail_foll(page, false);
> -				return true;
> +				if (and_tail)
> +					get_huge_page_tail(page);

So you may be introducing a real branch here unless gcc decides to
self-inline the static func.

> +				return page_head;
>  			} else {
>  				/*
>  				 * __split_huge_page_refcount run
> @@ -260,17 +261,34 @@ bool __get_page_tail(struct page *page)
>  		flags = compound_lock_irqsave(page_head);
>  		/* here __split_huge_page_refcount won't run anymore */
>  		if (likely(PageTail(page))) {
> -			__get_page_tail_foll(page, false);
> +			if (and_tail)
> +				get_huge_page_tail(page);

Same here.

> +bool __get_page_tail(struct page *page)
> +{
> +	return !!__get_compound_head(page, true);
>  }

I hope gcc would optimize away the !! overhead vs the old got =
true/false, once __get_compound_head is inline.

So I think you should add inline to __get_compound_head, there's no
benefit to keep the get_compound_head in the CPU icache.

get_huge_page_tail checks different invariants in the VM_BUG_ON and is
only used by gup.c not sure why to call that here.

But __get_page_tail has changed in -mm so the above will reject, in
-mm you will find __get_page_tail_foll called with "true" parameter
too in __get_page_tail for example (not equivalent to
get_huge_page_tail even ignoring the invariant checking in VM_BUG_ON)
and it defines a fast path for hugetlbfs and slab (faster than the one
upstream).

But here we have a "tail page" that has reference on both head and
tail, and you're taking one more reference on the head, just to
release it later by releasing the tail.

Your objective is to do:
	 
	page_head = get_compound_head(page);
	if (page_head)
		put_page(page);
	else
		page_head = page;

If we've to mess with the compound lock for this, considering
get_compound_head would have only this user anyway, we could do:

     page_head = put_compound_tail(page);
     if (!page_head)
     	page_head = page;

Implemented as:

put_compound_tail(page) {
	    page_head = compound_trans_head(page);
	    if (!__compound_tail_refcounted(page_head)) {
	       smp_rmb();
	       if (PageTail(page)) {
			VM_BUG_ON(!PageHead(page_head));
			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
			VM_BUG_ON(page_mapcount(page) != 0);
			return page_head;
		} else
		  return NULL;

	    }
	    flags = compound_lock_irqsave(page_head);
	    if (!PageTail(page)) {
	       unlock
	       return NULL
	    }
            VM_BUG_ON(page_head != page->first_page);
	    /* __split_huge_page_refcount will wait now */
	    VM_BUG_ON(page_mapcount(page) <= 0);
	    atomic_dec(&page->_mapcount);
	    VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
	    VM_BUG_ON(atomic_read(&page->_count) != 0);
	    compound_unlock_irqrestore(page_head, flags);
	    return page_head;
}

Considering this is going incremental with -mm, and that the -mm
previous patches the above would depend on are not upstream yet, I'd
suggest to fix the bug in futex with Linus patch now (s/1/!ro/).

The strict obviously safe fix Linus posted, is not going to interfere
with these optimization later, so there's no downside to apply it now
and defer the optimizations to the -mm queue.

Thanks!
Andrea
