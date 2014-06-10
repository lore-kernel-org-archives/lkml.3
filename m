Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaFJM5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:57:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47618 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaFJM5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:57:03 -0400
Date: Tue, 10 Jun 2014 05:56:55 -0700
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
Message-ID: <20140610125655.GJ4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140603130233.658a6a3c@gandalf.local.home>
 <20140603172632.GA27956@redhat.com>
 <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
 <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home>
 <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061012-0928-0000-0000-0000028B6D0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:51:09AM -0700, Linus Torvalds wrote:
> On Mon, Jun 9, 2014 at 11:29 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>
> >> And once again, note that the normal mutex is already unsafe (unless I missed
> >> something).
> >
> > Is it unsafe?
> >
> > This thread was started because of a bug we triggered in -rt, which
> > ended up being a change specific to -rt that modified the way slub
> > handled SLAB_DESTROY_BY_RCU. What else was wrong with it?
> 
> There's a different issue with freeing of mutexes, which is not a bug,
> but "by design". Namely that mutexes aren't truly "atomic". They are
> complex data structures, and they have issues that a spinlock does not
> have.
> 
> When unlocking a mutex, the thread doing the unlocking will still
> touch the mutex itself _after_ another thread could already have
> successfully acquired the mutex. This is not a problem in any normal
> use. since all of this is perfectly coherent in general, but it means
> that code sequences like:
> 
>   mutex_lock(mem->mutex);
>   kill_it = !--mem->refcount;
>   mutex_unlock(mem->mutex);
>   if (kill_it)
>      free(mem);
> 
> are fundamentally buggy.
> 
> Note that if you think of mutexes as truly indivisible atomic
> operations, the above is "obviously correct": the last person who got
> the mutex marked it for killing. But the fact is, the *next-to-last*
> mutex acquirer may still actively be in the *non-indivisible*
> mutex_unlock() when the last person frees it, resulting in a
> use-after-free. And yes, we've had this bug, and as far as I know it's
> possible that the RT code *introduces* this bug when it changes
> spinlocks into mutexes. Because we do exactly the above code sequence
> with spinlocks. So just replacing spinlocks with mutexes is a very
> subtly buggy thing to do in general.
> 
> Another example of this kind of situation is using a mutex as a
> completion event: that's simply buggy. Again, it's because mutexes are
> complex data structures, and you have a very similar use-after-free
> issue. It's why the fundamental data structure for a "struct
> completion" is a spinlock, not a mutex.
> 
> Again, in *theory*, a completion could be just a mutex that starts out
> locked, and then the completer completes it by just unlocking it. The
> person who waits for a completion does so by just asking for a lock.
> Obvious, simple, and trivial, right? Not so, because of the *exact*
> same issue above: the completer (who does an "unlock") may still be
> accessing the completion data structure when the completion waiter has
> successfully gotten the lock. So the standard thing of the completer
> freeing the underlying completion memory (which is often on the stack,
> so "freeing" is just he act of going out of scope of the liveness of
> the completion data structure) would not work if the completion was a
> mutex.
> 
> This is subtle, and it is basically unavoidable. If a mutex (or
> counting semaphore) has a fast-path - and a mutex/semaphore without a
> fast-path is shit - then this issue will exist. Exactly because the
> fast-path will depend on just one part of the whole big mutex
> structure, and the slow-path will have other pieces to it.
> 
> There might be reasonable ways to avoid this issue (having the
> fastpath locking field share memory with the slow-path locking, for
> example), but it's not how our semaphores and mutexes work, and I
> suspect it cannot be the case in general (because it limits you too
> badly in how to implement the mutex). As a result, this is all "by
> design" as opposed to being a bug.

So to safely free a structure containing a mutex, is there some better
approach than the following?

	mutex_lock(mem->mutex);
	kill_it = !--mem->refcount;
	rcu_read_lock();
	mutex_unlock(mem->mutex);
	rcu_read_unlock();
	if (kill_it)
		kfree_rcu(mem, rh); /* rh is the rcu_head field in mem. */

For example, is there some other way to know that all the prior lock
releases have finished their post-release accesses?

							Thanx, Paul

