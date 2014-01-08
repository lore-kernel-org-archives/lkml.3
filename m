Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaAHTEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:04:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaAHTEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:04:48 -0500
Date: Wed, 8 Jan 2014 20:04:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20140108190443.GA17282@redhat.com>
References: <20131219190846.GA24566@redhat.com> <20131219190920.GB24566@redhat.com> <20131223114300.GC727@redhat.com> <20140103195519.GA26555@redhat.com> <20140103195547.GB26555@redhat.com> <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org> <20140104164347.GA31359@redhat.com> <20140108115400.GD27046@suse.de> <20140108161338.GA10434@redhat.com> <20140108180202.GL27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108180202.GL27046@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Mel Gorman wrote:
>
> On Wed, Jan 08, 2014 at 05:13:38PM +0100, Oleg Nesterov wrote:
> >
> > Yes. But, for example, get_futex_key() does
> >
> > 	if (unlikely(PageTail(page))) {
> > 		put_page(page);
> >
> > why this put_page() can't race with _split? If nothing else, another thread
> > can unmap the part of this vma.
> >
>
> The race is not prevented but that does not mean it matters. Basic
> scenario where a split starts after the PageTail check but before the
> put_page in get_futex_key
>
> CPU A
> get_futex_key
>   -> fast gup, page table removing prevents parallel unmap and free
>     -> gup_huge_pmd (arch/x86/mm/gup.c at least)
>       -> get_huge_page_tail (increment page tail _map_count)
>       -> get_huge_page_multiple (increment ref on head page)
>   -> Check PageTail
> 					CPU B
> 					split_huge_page_to_list
> 					  -> split_huge_page_refcount
> 					     spin_lock_irq(lru_lock)
> 					     compound_lock
>   -> put_page(tail_page)
>     ->put_compound_page
>        looks up head page

Yes.

But suppose that CPU B completes split_huge_page_to_list/munmap/etc
and frees this head page.

>        takes reference unless zero

suppose this page_head was reallocated and get_page_unless_zero()
succeds right after set_page_refcounted(),

>        compound_lock (block)
> 					     complete split
> 					     compound_unlock
>        check PageTail
>
> This put_page blocks on the compound lock, finds the page is no longer a
> PageTail

Sure. The problem is that compound_lock() itself can race with prep_new_page()
or I missed something.

> The parallel unmap is prevented by get_huge_page_multiple in the gup path
> and held in place until put_page_compound frees it later.

Again, I can easily miss something. And yes, page_tail returned by gup
has a reference to its page_head (via page_head->_count). But
__split_huge_page_refcount() destroys this connection and decrements
page_head->_count.

Oleg.

