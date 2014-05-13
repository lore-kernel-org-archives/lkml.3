Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaEMTcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaEMTcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:32:45 -0400
Date: Tue, 13 May 2014 21:31:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 19/19] mm: filemap: Avoid unnecessary barries and
	waitqueue lookups in unlock_page fastpath
Message-ID: <20140513193146.GA17051@redhat.com>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-20-git-send-email-mgorman@suse.de> <20140513125313.GR23991@suse.de> <20140513141748.GD2485@laptop.programming.kicks-ass.net> <20140513152719.GF18164@linux.vnet.ibm.com> <20140513181852.GB12123@redhat.com> <20140513185250.GM18164@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513185250.GM18164@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Paul E. McKenney wrote:
>
> On Tue, May 13, 2014 at 08:18:52PM +0200, Oleg Nesterov wrote:
> >
> > I have to admit, I am confused. I simply do not understand what "memory
> > barrier" actually means in this discussion.
> >
> > To me, wake_up/ttwu should only guarantee one thing: all the preceding
> > STORE's should be serialized with all the subsequent manipulations with
> > task->state (even with LOAD(task->state)).
>
> I was thinking in terms of "everything done before the wake_up() is
> visible after the wait_event*() returns" -- but only if the task doing
> the wait_event*() actually sleeps and is awakened by that particular
> wake_up().

Hmm. The question is, visible to whom ;) To the woken task?

Yes sure, and this is simply because both sleeper/waker take rq->lock.

> > > If there is a sleep-wakeup race, for example,
> > > between wait_event_interruptible() and wake_up(), then it looks to me
> > > that the following can happen:
> > >
> > > o	Task A invokes wait_event_interruptible(), waiting for
> > > 	X==1.
> > >
> > > o	Before Task A gets anywhere, Task B sets Y=1, does
> > > 	smp_mb(), then sets X=1.
> > >
> > > o	Task B invokes wake_up(), which invokes __wake_up(), which
> > > 	acquires the wait_queue_head_t's lock and invokes
> > > 	__wake_up_common(), which sees nothing to wake up.
> > >
> > > o	Task A tests the condition, finds X==1, and returns without
> > > 	locks, memory barriers, atomic instructions, or anything else
> > > 	that would guarantee ordering.
> > >
> > > o	Task A then loads from Y.  Because there have been no memory
> > > 	barriers, it might well see Y==0.
> >
> > Sure, but I can't understand "Because there have been no memory barriers".
> >
> > IOW. Suppose we add mb() into wake_up(). The same can happen anyway?
>
> If the mb() is placed just after the fastpath condition check, then the
> awakened task will be guaranteed to see Y=1.

Of course. My point was, this has nothing to do with the barriers provided
by wake_up(), that is why I was confused.

> > > On the other hand, if a wake_up() really does happen, then
> > > the fast-path out of wait_event_interruptible() is not taken,
> > > and __wait_event_interruptible() is called instead.  This calls
> > > ___wait_event(), which eventually calls prepare_to_wait_event(), which
> > > in turn calls set_current_state(), which calls set_mb(), which does a
> > > full memory barrier.
> >
> > Can't understand this part too... OK, and suppose that right after that
> > the task B from the scenario above does
> >
> > 	Y = 1;
> > 	mb();
> > 	X = 1;
> > 	wake_up();
> >
> > After that task A checks the condition, sees X==1, and returns from
> > wait_event() without spin_lock(wait_queue_head_t->lock) (if it also
> > sees list_empty_careful() == T). Then it can see Y==0 again?
>
> Yes.  You need the barriers to be paired, and in this case, Task A isn't
> executing a memory barrier.  Yes, the mb() has forced Task B's CPU to
> commit the writes in order (or at least pretend to), but Task A might
> have speculated the read to Y.
>
> Or am I missing your point?

I only meant that this case doesn't really differ from the scenario you
described above.

> > > 	A read and a write memory barrier (-not- a full memory barrier)
> > > 	are implied by wake_up() and co. if and only if they wake
> > > 	something up.
> >
> > Now this looks as if you document that, say,
> >
> > 	X = 1;
> > 	wake_up();
> > 	Y = 1;
> >
> > doesn't need wmb() before "Y = 1" if wake_up() wakes something up. Do we
> > really want to document this? Is it fine to rely on this guarantee?
>
> That is an excellent question.  It would not be hard to argue that we
> should either make the guarantee unconditional by adding smp_mb() to
> the wait_event*() paths or alternatively just saying that there isn't
> a guarantee to begin with.

I'd vote for "no guarantees".

> > In short: I am totally confused and most probably misunderstood you ;)
>
> Oleg, if it confuses you, it is in desperate need of help!  ;-)

Thanks, this helped ;)

Oleg.

