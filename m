Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaFITlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:41:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:42979 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750805AbaFITlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:41:16 -0400
Date: Mon, 9 Jun 2014 15:41:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140609154114.20585056@gandalf.local.home>
In-Reply-To: <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
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
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014 11:51:09 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

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

Oh this again. I remember you having a discussion about it in the past.
I'm trying to wrap my head around it so let me make sure I understand
the spinlock (working) case, and then a bad mutex case.

For this to work, you have some item, lets say on a list. When it is
created, the refcount is 1 and it's added to the list. To remove it,
you remove it from the list and dec the refcount, and if it is zero
then you can free it. The issue is that you don't know what may have
seen it while its on the list and the last one to dec it to zero frees
it. Is this a situation that is used?

Because spinlocks are atomic, this is all fine, but if you have a
mutex, then this is where you can have issues. I think rtmutex has an
issue with it too. Specifically in the slow_unlock case:

	if (!rt_mutex_has_waiters(lock)) {
		lock->owner = NULL;
		raw_spin_unlock(&lock->wait_lock);
		return;
	}

That is, you can have:


	CPU0				CPU1
	----				----
				[refcount = 1]
				read foo from list
				[refcount = 2]
  [refcount 2]
  remove foo from list

  mutex_lock(foo->mutex);
  kill_it = !--mem->refcount;
  [refcount = 1]
  [kill_it == 0]
  mutex_unlock(foo->mutex)
    lock->owner = NULL;

				mutex_lock()
				 [ owner == NULL, fast path!]
				kill_it = !--mem->refcount;
				 [refcount = 0]
				 [kill_it = 1]
				mutex_unlock()
				 [ owner == current, fast path!]

				if (kill_it)
				   free(foo);

  raw_spin_unlock(&lock->wait_lock);
   [access freed foo's wait_lock, BUG!]

Is this the problem? I'm just trying to visualize it, and maybe even
visualize it for others that are reading this thread.

Thanks,

-- Steve
