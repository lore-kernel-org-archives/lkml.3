Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3JDNiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3JDNix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:38:53 -0400
Date: Fri, 4 Oct 2013 15:31:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131004133135.GA11097@redhat.com>
References: <20131003193206.GA17796@redhat.com> <20131003193319.GB17796@redhat.com> <20131003195026.GT5790@linux.vnet.ibm.com> <20131003200002.GA23768@redhat.com> <20131003211009.GA4127@redhat.com> <20131004071814.GS28601@twins.programming.kicks-ass.net> <20131004111513.GA5699@redhat.com> <20131004114442.GJ3081@twins.programming.kicks-ass.net> <20131004121300.GA7725@redhat.com> <20131004123806.GK3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004123806.GK3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Peter Zijlstra wrote:
>
> On Fri, Oct 04, 2013 at 02:13:00PM +0200, Oleg Nesterov wrote:
> > On 10/04, Peter Zijlstra wrote:
> > >
> > > I'm not entirely sure what the advantage is of having that logic in this
> > > primitive. Shouldn't that be something the user of this rcu_sync stuff
> > > does (or not) depending on its needs.
> >
> > Yes, the user can do the locking itself. But I think this option can help.
> > If nothing else it can help to avoid another mutex/whatever and unnecessary
> > wakeup/scheule's, even if this is minor.
> >
> > And. rcu_sync_enter() should be "bool", it should return "need_sync". IOW,
> > rcu_sync_enter() == T means that this thread has done the FAST -> SLOW
> > transition, this is particularly useful in "exclusive" mode.
> >
> > Consider percpu_down_write(). It takes rw_sem for writing (and this blocks
> > the readers) before clear_fast_ctr(), but we only need to do this this
> > after sync_sched(), so it could do
> >
> > 	if (rcu_sync_enter(&brw->rcu_sync))
> > 		atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
> > 	else
> > 		; /* the above was already done */
> >
> > 	/* exclude readers */
> > 	down_write(&brw->rw_sem);
> >
> > and now ->rw_sem is only needed to serialize readers/writer.
> >
> > Sure, this all is minor (and we will probably copy the "pending writer"
> > logic from cpu_hotplug_begin/get_online_cpus).
> >
> > But we can get this feature almost for free, so I think it makes sense.
>
> Well, the whole reason I asked is because adding that completion in
> there didn't at all smell like free to me;

Why? this only adds sizeof(long).

If you dislike the idea to add the new __complete_locked() one-liner,
this is not strictly necessary, just a bit simpler/understandable.

> not to mention that I hadn't
> at all realized you're using it as a semaphore.

And the logic is trivial.

> Also; what would be the use once you convert the per-cpu rwsem over to
> the scheme I used with hotplug?

It will still use the exclusive more to block other writers? This avoids
another mutex simplifies the code.

> I'm really starting to think we shouldn't do this in rcu_sync at all.

I do not really understand why you insist that rcu_sync() should not
try to help to the users which need the exclusive mode.

rcu_sync_enter/exit have to do some work to serialize with each other
anyway, we already have ->nr_writers, so why we can't add 3 simple
"if exclusive" checks?

Oleg.

