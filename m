Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbaEMQOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:14:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54888 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaEMQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:14:23 -0400
Date: Tue, 13 May 2014 09:14:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 19/19] mm: filemap: Avoid unnecessary barries and
 waitqueue lookups in unlock_page fastpath
Message-ID: <20140513161418.GH18164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-20-git-send-email-mgorman@suse.de>
 <20140513125313.GR23991@suse.de>
 <20140513141748.GD2485@laptop.programming.kicks-ass.net>
 <20140513152719.GF18164@linux.vnet.ibm.com>
 <20140513154435.GG2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513154435.GG2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051316-0928-0000-0000-000001DAD298
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:44:35PM +0200, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 08:27:19AM -0700, Paul E. McKenney wrote:
> > > Subject: doc: Update wakeup barrier documentation
> > > 
> > > As per commit e0acd0a68ec7 ("sched: fix the theoretical signal_wake_up()
> > > vs schedule() race") both wakeup and schedule now imply a full barrier.
> > > 
> > > Furthermore, the barrier is unconditional when calling try_to_wake_up()
> > > and has been for a fair while.
> > > 
> > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > > Cc: David Howells <dhowells@redhat.com>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > 
> > Some questions below.
> > 
> > 							Thanx, Paul
> > 
> > > ---
> > >  Documentation/memory-barriers.txt | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > > index 46412bded104..dae5158c2382 100644
> > > --- a/Documentation/memory-barriers.txt
> > > +++ b/Documentation/memory-barriers.txt
> > > @@ -1881,9 +1881,9 @@ The whole sequence above is available in various canned forms, all of which
> > >  	event_indicated = 1;
> > >  	wake_up_process(event_daemon);
> > > 
> > > -A write memory barrier is implied by wake_up() and co. if and only if they wake
> > > -something up.  The barrier occurs before the task state is cleared, and so sits
> > > -between the STORE to indicate the event and the STORE to set TASK_RUNNING:
> > > +A full memory barrier is implied by wake_up() and co. The barrier occurs
> > 
> > Last I checked, the memory barrier was guaranteed only if a wakeup
> > actually occurred.  If there is a sleep-wakeup race, for example,
> > between wait_event_interruptible() and wake_up(), then it looks to me
> > that the following can happen:
> > 
> > o	Task A invokes wait_event_interruptible(), waiting for
> > 	X==1.
> > 
> > o	Before Task A gets anywhere, Task B sets Y=1, does
> > 	smp_mb(), then sets X=1.
> > 
> > o	Task B invokes wake_up(), which invokes __wake_up(), which
> > 	acquires the wait_queue_head_t's lock and invokes
> > 	__wake_up_common(), which sees nothing to wake up.
> > 
> > o	Task A tests the condition, finds X==1, and returns without
> > 	locks, memory barriers, atomic instructions, or anything else
> > 	that would guarantee ordering.
> > 
> > o	Task A then loads from Y.  Because there have been no memory
> > 	barriers, it might well see Y==0.
> > 
> > So what am I missing here?
> 
> Ah, that's what was meant :-) The way I read it was that
> wake_up_process() would only imply the barrier if the task actually got
> a wakeup (ie. the return value is 1).
> 
> But yes, this makes a lot more sense. Sorry for the confusion.

I will work out a better wording and queue a patch.  I bet that you
are not the only one who got confused.

> > On the wake_up() side, wake_up() calls __wake_up(), which as mentioned
> > earlier calls __wake_up_common() under a lock.  This invokes the
> > wake-up function stored by the sleeping task, for example,
> > autoremove_wake_function(), which calls default_wake_function(),
> > which invokes try_to_wake_up(), which does smp_mb__before_spinlock()
> > before acquiring the to-be-waked task's PI lock.
> > 
> > The definition of smp_mb__before_spinlock() is smp_wmb().  There is
> > also an smp_rmb() in try_to_wake_up(), which still does not get us
> > to a full memory barrier.  It also calls select_task_rq(), which
> > does not seem to guarantee any particular memory ordering (but
> > I could easily have missed something).  It also calls ttwu_queue(),
> > which invokes ttwu_do_activate() under the RQ lock.  I don't see a
> > full memory barrier in ttwu_do_activate(), but again could easily
> > have missed one.  Ditto for ttwu_stat().
> 
> Ah, yes, so I'll defer to Oleg and Linus to explain that one. As per the
> name: smp_mb__before_spinlock() should of course imply a full barrier.

How about if I queue a name change to smp_wmb__before_spinlock()?

							Thanx, Paul

