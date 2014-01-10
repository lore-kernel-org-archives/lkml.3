Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbaAJQMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:12:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbaAJQMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:12:33 -0500
Date: Fri, 10 Jan 2014 17:12:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20140110161227.GB31491@redhat.com>
References: <20140104164347.GA31359@redhat.com> <20140108115400.GD27046@suse.de> <20140108161338.GA10434@redhat.com> <20140108180202.GL27046@suse.de> <20140108190443.GA17282@redhat.com> <20140109112736.GR27046@suse.de> <20140109140447.GA25391@redhat.com> <20140109185254.GC1141@redhat.com> <20140109194350.GA22436@redhat.com> <20140109213657.GD1141@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109213657.GD1141@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Andrea Arcangeli wrote:
>
> >
> > But we probably need barrier() in between, we can't use ACCESS_ONCE().
>
> After get_page_unless_zero I don't think there's any need of
> barrier(). barrier() should have been implicit in __atomic_add_unless
> in fact it should be a full smp_mb() equivalent too. Memory is always
> clobbered there and the asm is volatile.

Yes, yes,

> My wondering was only about the runtime (not compiler) barrier after
> running PageTail and before compound_lock,

Yes, this is what I meant.

Except I really meant the compiler barrier, although I do not think it
is actually needed, test_and_set_bit() implies mb().

> because bit_spin_lock has
> only acquire semantics so in absence of the branch that bails out the
> lock, the spinlock could run before PageTail. If the branch is good
> enough guarantee for all archs it's good and cheap solution.

The recent "[PATCH v6 tip/core/locking 3/8] Documentation/memory-barriers.txt:
Prohibit speculative writes" from Paul says:

	No SMP architecture currently supporting Linux allows speculative writes,

	...

	+ACCESS_ONCE(), which preserves the ordering between
	+the load from variable 'a' and the store to variable 'b':
	+
	+       q = ACCESS_ONCE(a);
	+       if (q) {
	+               ACCESS_ONCE(b) = p;
	+               do_something();
	+       }


We can't use ACCESS_ONCE(), but I think that

		if (PageTail(page)) {
			barrier();
			compound_lock(page_head);
		}

should obviously work (even if compound_lock() didn't imply mb).

Oleg.

