Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaFHNIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 09:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaFHNIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 09:08:40 -0400
Date: Sun, 8 Jun 2014 15:07:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
	when accessed by /proc)
Message-ID: <20140608130718.GA11129@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606203350.GU4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06, Paul E. McKenney wrote:
>
> On Tue, Jun 03, 2014 at 10:01:25PM +0200, Oleg Nesterov wrote:
> >
> > I'll try to recheck rt_mutex_unlock() tomorrow. _Perhaps_ rcu_read_unlock()
> > should be shifted from lock_task_sighand() to unlock_task_sighand() to
> > ensure that rt_mutex_unlock() does nothihg with this memory after it
> > makes another lock/unlock possible.
> >
> > But if we need this (currently I do not think so), this doesn't depend on
> > SLAB_DESTROY_BY_RCU. And, at first glance, in this case rcu_read_unlock_special()
> > might be wrong too.
>
> OK, I will bite...  What did I mess up in rcu_read_unlock_special()?
>
> This function does not report leaving the RCU read-side critical section
> until after its call to rt_mutex_unlock() has returned, so any RCU
> read-side critical sections in rt_mutex_unlock() will be respected.

Sorry for confusion.

I only meant that afaics rcu_read_unlock_special() equally depends on the
fact that rt_mutex_unlock() does nothing with "struct rt_mutex" after it
makes another rt_mutex_lock() + rt_mutex_unlock() possible, otherwise this
code is wrong (and unlock_task_sighand() would be wrong too).

Just to simplify the discussion... suppose we add "atomic_t nr_slow_unlock"
into "struct rt_mutex" and change rt_mutex_slowunlock() to do
atomic_inc(&lock->nr_slow_unlock) after it drops ->wait_lock. Of course this
would be ugly, just for illustration.

In this case atomic_inc() above can write to rcu_boost()'s stack after this
functions returns to the caller. And unlock_task_sighand() would be wrong
too, atomic_inc() could write to the memory which was already returned to
system because "unlock" path runs outside of rcu-protected section.

But it seems to me that currently we are safe, rt_mutex_unlock() doesn't do
something like this, a concurrent rt_mutex_lock() must always take wait_lock
too.


And while this is off-topic and I can be easily wrong, it seems that the
normal "struct mutex" is not safe in this respect. If nothing else, once
__mutex_unlock_common_slowpath()->__mutex_slowpath_needs_to_unlock() sets
lock->count = 1, a concurent mutex_lock() can take and then release this
mutex before __mutex_unlock_common_slowpath() takes ->wait_lock.

So _perhaps_ we should not rely on this property of rt_mutex "too much".

Oleg.

