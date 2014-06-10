Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaFJQPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:15:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41952 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaFJQPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:15:51 -0400
Date: Tue, 10 Jun 2014 09:15:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610161545.GQ4581@linux.vnet.ibm.com>
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
 <CA+55aFxVV04KOyha80-b6RL_vSNAgn2J15paKgHza6C=cBZJMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxVV04KOyha80-b6RL_vSNAgn2J15paKgHza6C=cBZJMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061016-6688-0000-0000-00000278606A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 08:35:53AM -0700, Linus Torvalds wrote:
> On Tue, Jun 10, 2014 at 5:56 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > So to safely free a structure containing a mutex, is there some better
> > approach than the following?
> 
> Yes.
> 
> A data structure *containing* a mutex is fine. The problem only occurs
> when that mutex also acts the lock for the data structure. As a
> result, there are two fixes for the "locks are not one single atomic
> field":
> 
>  (a) don't do self-locking objects
>  (b) use spinlocks for these "self-locking" objects
> 
> And quite frankly, (a) is the normal "solution" to the problem.
> 
> The fact is, having the data structure contain its own lifetime lock
> is unusual, and generally broken. The *normal* sequence for freeing
> something should be that the last access to it is the atomic referenc
> count access:
> 
>   .. do whatever, including "unlock(&mem->lock)" ..
>   if (atomic_dec_and_test(&mem->refcount))
>     .. we can now free it ..
> 
> and that's safe. It doesn't matter if "mem" had a mutex in it, it
> doesn't matter if you walked around three times widdershins with a
> dead chicken around your neck. You can do whatever you want, the above
> is fine (and you shouldn't even need to worry about CPU memory
> ordering, because the alloc/free had better have the barriers to make
> sure) that nothing can leak from a free to the next allocation,
> although that is another discussion perhaps worth having).
> 
> The whole notion of having the lock that protects the lifetime of the
> data structure inside the structure itself is pretty crazy. Because
> while it is true that we sometimes have the refcount be non-atomic,
> and instead protected with a lock, that lock is generally always
> *outside* the object itself, because you want the lock for lookup etc.
> So having the lock _and_ the refcount be inside the object really is
> crazy.

Agreed!  You need to have something external to the object that holds the
object down long enough to safely acquire the object's lock, refcount,
or whatever.  Contention usually rules out that "something" being a
global lock or refcount, but per-CPU locks, per-CPU refcounts, RCU,
and so on can work.

> That said, "crazy" has happened. We do occasionally do it. It's
> generally a mistake (the last example of this was the pipe thing), but
> sometimes we do it on purpose (the dcache, for example). You can do
> lookups without holding a lock (generally using RCU), and taking the
> lock and incrementing a refcount, but then the lock has to be a
> spinlock *anyway*, so that's ok.

And of course you have to acquire the lock before doing your
rcu_read_unlock() in that case.

> The last case where we actually had this bug (the afore-mentioned pipe
> thing), the mutex lock wasn't even needed - we had a real spinlock
> protecting the reference count. The bug was that we did the mutex
> unlock *after* the spinlock, for no good reason.
> 
> So it really isn't normally a problem. The RT spinlock conversion
> people need to be aware of it, but normally you can't even screw this
> up.

And yes, I might need to add in a reference-count handoff around RCU's
use of rt_mutex.  Haven't yet come up with a reasonable way to use RCU
at that point instead.  I suppose I could use SRCU, but...  ;-)

							Thanx, Paul

