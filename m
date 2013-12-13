Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3LMQWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:22:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3LMQWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:22:17 -0500
Date: Fri, 13 Dec 2013 17:22:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at
	exit)
Message-ID: <20131213162240.GA11762@redhat.com>
References: <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com> <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213151035.GE5408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea. Thanks a lot for the detailed reply.

On 12/13, Andrea Arcangeli wrote:
>
> On Wed, Dec 11, 2013 at 08:18:55PM +0100, Oleg Nesterov wrote:
>
> get_huge_page_tail checks different invariants in the VM_BUG_ON and is
> only used by gup.c not sure why to call that here.

Compared to __get_page_tail_foll(get_page_head => F) get_huge_page_tail()
lacks  the ->first_page->_count, but it is called right after
get_page_unless_zero(page_head) so to me get_huge_page_tail() looks a bit
better.

Personally, I think that even this change

	--- x/kernel/events/../../mm/internal.h
	+++ x/kernel/events/../../mm/internal.h
	@@ -47,11 +47,9 @@ static inline void __get_page_tail_foll(
		 * page_cache_get_speculative()) on tail pages.
		 */
		VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
	-	VM_BUG_ON(atomic_read(&page->_count) != 0);
	-	VM_BUG_ON(page_mapcount(page) < 0);
		if (get_page_head)
			atomic_inc(&page->first_page->_count);
	-	atomic_inc(&page->_mapcount);
	+	get_huge_page_tail(page);
	 }
	 
	 /*

makes sense. But this is minor and subjective, I am not going to argue.

And I agree with other comments, the patch I sent only tried to explain
what I meant.

> If we've to mess with the compound lock for this, considering
> get_compound_head would have only this user anyway, we could do:
>
>      page_head = put_compound_tail(page);
>      if (!page_head)
>      	page_head = page;
>
> Implemented as:

OK, this looks better, I agree.

I'll try to make v2 based on -mm and your suggestions.

> Considering this is going incremental with -mm, and that the -mm
> previous patches the above would depend on are not upstream yet, I'd
> suggest to fix the bug in futex with Linus patch now (s/1/!ro/).

Yes, yes, sure. I didn't mean that this (potential) cleanup can replace
the simple fix from Linus.

Thanks!

Oleg.

