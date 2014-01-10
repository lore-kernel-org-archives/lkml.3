Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbaAJQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:50:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbaAJQuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:50:52 -0500
Date: Fri, 10 Jan 2014 17:50:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20140110165041.GH7572@laptop.programming.kicks-ass.net>
References: <20140108115400.GD27046@suse.de>
 <20140108161338.GA10434@redhat.com>
 <20140108180202.GL27046@suse.de>
 <20140108190443.GA17282@redhat.com>
 <20140109112736.GR27046@suse.de>
 <20140109140447.GA25391@redhat.com>
 <20140109185254.GC1141@redhat.com>
 <20140109194350.GA22436@redhat.com>
 <20140109213657.GD1141@redhat.com>
 <20140110161227.GB31491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110161227.GB31491@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 05:12:27PM +0100, Oleg Nesterov wrote:
> The recent "[PATCH v6 tip/core/locking 3/8] Documentation/memory-barriers.txt:
> Prohibit speculative writes" from Paul says:
> 
> 	No SMP architecture currently supporting Linux allows speculative writes,
> 
> 	...
> 
> 	+ACCESS_ONCE(), which preserves the ordering between
> 	+the load from variable 'a' and the store to variable 'b':
> 	+
> 	+       q = ACCESS_ONCE(a);
> 	+       if (q) {
> 	+               ACCESS_ONCE(b) = p;
> 	+               do_something();
> 	+       }
> 
> 
> We can't use ACCESS_ONCE(), but I think that
> 
> 		if (PageTail(page)) {
> 			barrier();
> 			compound_lock(page_head);
> 		}
> 
> should obviously work (even if compound_lock() didn't imply mb).

The compiler can actually screw you over if that's preceded by something
like: SetPageTail(page). In which case it can prove that if (PageTail())
is a non-condition.

But yes, barring that, the version with barrier() in should stop the
compiler from doing most terrible things and it ought to work out.
