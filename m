Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3LMRem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:34:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab3LMRek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:34:40 -0500
Date: Fri, 13 Dec 2013 18:34:06 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: PATCH? introduce get_compound_page (Was: process 'stuck' at exit)
Message-ID: <20131213173406.GG5408@redhat.com>
References: <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
 <20131211170844.GA21700@redhat.com>
 <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
 <20131211175615.GA24546@redhat.com>
 <20131211191855.GA32485@redhat.com>
 <20131213151035.GE5408@redhat.com>
 <20131213162240.GA11762@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213162240.GA11762@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 05:22:40PM +0100, Oleg Nesterov wrote:
> Andrea. Thanks a lot for the detailed reply.
> 
> On 12/13, Andrea Arcangeli wrote:
> >
> > On Wed, Dec 11, 2013 at 08:18:55PM +0100, Oleg Nesterov wrote:
> >
> > get_huge_page_tail checks different invariants in the VM_BUG_ON and is
> > only used by gup.c not sure why to call that here.
> 
> Compared to __get_page_tail_foll(get_page_head => F) get_huge_page_tail()
> lacks  the ->first_page->_count, but it is called right after
> get_page_unless_zero(page_head) so to me get_huge_page_tail() looks a bit
> better.
> 
> Personally, I think that even this change
> 
> 	--- x/kernel/events/../../mm/internal.h
> 	+++ x/kernel/events/../../mm/internal.h
> 	@@ -47,11 +47,9 @@ static inline void __get_page_tail_foll(
> 		 * page_cache_get_speculative()) on tail pages.
> 		 */
> 		VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
> 	-	VM_BUG_ON(atomic_read(&page->_count) != 0);
> 	-	VM_BUG_ON(page_mapcount(page) < 0);
> 		if (get_page_head)
> 			atomic_inc(&page->first_page->_count);
> 	-	atomic_inc(&page->_mapcount);
> 	+	get_huge_page_tail(page);
> 	 }
> 	 
> 	 /*
> 
> makes sense. But this is minor and subjective, I am not going to argue.

The above diff looks a straightforward cleanup you could submit it as
a separate patch in a v2 series. This more clearly shows the
difference between the two functions, so there is less overlap
too.

Feel free to change it further if you want, but the current model was
to have get_huge_page_tail only for arch/*/mm/gup.c (in mm.h) and
__get_page_tail_foll in internal.h for mm/*.c and with the ability to
obtain the head page too (needed in some of the mm/*.c cases, and
never needed for arch/*/mm/gup.c).

> I'll try to make v2 based on -mm and your suggestions.

Ok great!

Thanks,
Andrea
