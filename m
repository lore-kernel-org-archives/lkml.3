Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaFJPSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:18:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39696 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaFJPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:18:13 -0400
Date: Tue, 10 Jun 2014 08:18:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610151807.GO4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
 <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home>
 <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
 <20140610125655.GJ4581@linux.vnet.ibm.com>
 <20140610144830.GD3213@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610144830.GD3213@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061015-1542-0000-0000-00000278B001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:48:30PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 10, 2014 at 05:56:55AM -0700, Paul E. McKenney wrote:
> > On Mon, Jun 09, 2014 at 11:51:09AM -0700, Linus Torvalds wrote:
> 
> > > This is subtle, and it is basically unavoidable. If a mutex (or
> > > counting semaphore) has a fast-path - and a mutex/semaphore without a
> > > fast-path is shit - then this issue will exist. Exactly because the
> > > fast-path will depend on just one part of the whole big mutex
> > > structure, and the slow-path will have other pieces to it.
> > > 
> > > There might be reasonable ways to avoid this issue (having the
> > > fastpath locking field share memory with the slow-path locking, for
> > > example), but it's not how our semaphores and mutexes work, and I
> > > suspect it cannot be the case in general (because it limits you too
> > > badly in how to implement the mutex). As a result, this is all "by
> > > design" as opposed to being a bug.
> > 
> > So to safely free a structure containing a mutex, is there some better
> > approach than the following?
> > 
> > 	mutex_lock(mem->mutex);
> > 	kill_it = !--mem->refcount;
> > 	rcu_read_lock();
> > 	mutex_unlock(mem->mutex);
> > 	rcu_read_unlock();
> > 	if (kill_it)
> > 		kfree_rcu(mem, rh); /* rh is the rcu_head field in mem. */
> > 
> > For example, is there some other way to know that all the prior lock
> > releases have finished their post-release accesses?
> 
> So Thomas posted a patch curing rt_mutex, and for that we really _have_
> to because it needs to replace a spinlock_t. But for the regular mutex
> its better (from a performance pov) to not do this.
> 
> By releasing early and checking for pending waiters later we allow
> earlier lock stealing, which is good for throughput.
> 
> Back to your example, I think your example is misleading in that it
> states: 'a structure containing a mutex'. The problem only arises when
> that mutex is used as part of the life-time management of said
> structure.

Hey, I just minimally modified the example from this thread!  ;-)

> If it has regular (atomic_t or atomic_long_t or spinlock_t) reference
> counting, we know the mutex_unlock() must have competed by the time we
> do put_*(), and if that put was the last one, there cannot have been
> another, otherwise your reference counting is broken.

So your point is that we need to have some other lifetime management
mechanism for the structure, and that whatever that is, we need to release
-after- our unlock completes, correct?  Which is in fact what I did with
the rcu_read_unlock() above, so we might actually be in agreement here.

							Thanx, Paul

