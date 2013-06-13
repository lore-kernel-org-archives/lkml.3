Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab3FMABW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:01:22 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55759 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3FMABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130612233224.GH4165@ZenIV.linux.org.uk>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<1370911480.9844.160.camel@gandalf.local.home>
	<CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	<1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	<1370974231.9844.212.camel@gandalf.local.home>
	<1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
	<1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
	<20130612233224.GH4165@ZenIV.linux.org.uk>
Date: Wed, 12 Jun 2013 17:01:19 -0700
X-Google-Sender-Auth: TVBTTgGzdKeR_7NbeIPicJw1sU0
Message-ID: <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "?????????" <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 4:32 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Jun 12, 2013 at 01:26:25PM -0700, Linus Torvalds wrote:
>>
>> However, one optimization missing from your patch is obvious in the
>> profile. "dget_parent()" also needs to be optimized - you still have
>> that as 99% of the spin-lock case. I think we could do something like
>>
>>    rcu_read_lock();
>>    parent = ACCESS_ONCE(dentry->d_parent);
>>    if (atomic_inc_nonzero(&parent->d_count))
>>       return parent;
>>    .. get d_lock and do it the slow way ...
>>    rcu_read_unlock();
>>
>> to locklessly get the parent pointer. We know "parent" isn't going
>> away (dentries are rcu-free'd and we hold the rcu read lock), and I
>> think that we can optimistically take *any* parent dentry that
>> happened to be valid at one point. As long as the refcount didn't go
>> down to zero. Al?
>
> What will you do with __d_rcu_to_refcount()?  Any such scheme has to
> hold d_lock from zero->non-zero d_count changes, or atomic_dec_and_lock
> in dput() won't help at all.

I'd actually suggest we do *not* remove any existing d_lock usage
outside of the particular special cases we want to optimize, which at
least from Davidlohr's profile is just dput() (which has shown up a
lot before) and dget_parent() (which I'm not sure why it happens so
much on his load, but it really seems trivially safe to optimistically
do under just the RCU lock).

>  As it is, both complete_walk() and unlazy_walk()
> are grabbing ->d_lock on the dentry we'd reached, so they can call that
> sucker.  And that'll give you ->d_lock contention when a bunch of threads
> are hitting the same file; I don't see how atomics would avoid that
> one...

I'd love to get rid of complete_walk() using the dcache lock too, but
if we really can't get rid of it, I won't cry.

That said, I do wonder if we could do something like
"atomic_inc_not_zero()" on the d_count, and only if it is zero (which
won't be horribly unusual, since for leaf dentries that nobody else is
using) we'd do the whole locking sequence.

But my first reaction is to not even bother until it shows up on some
profile. Of course, maybe it immediately does.

There's a real downside to making d_count an "atomic_t", and there
might be loads where it actually bites us. But even in the absense of
contention, atomics tend to be sufficiently faster than spinlocks that
even if we end up adding two or even three atomics for each d_lock
lock we get rid of, we should be ok even for single-thread. On the
contention case, we'll obviously win almost regardless of how many
atomics we add.

Of course, that assumes we get rid of any locking at all for the
normal case. with dput() having to take the lock when the refcount
goes to zero, and most single-threaded file opens using the final path
component with a dentry that isn't otherwise used, doing an atomic
d_count might hurt the single-thread case without getting any spinlock
advantage at all. dget_parent() would be the only case that helps even
there, and that should normally only happen for "..", I think.

So who knows.. Are we willing to take a hit on the single-thread case
(*if* that is the case) if it helps scalability a lot? If it was a
common scalability issue, sure. But just for AIM7 looking up
/etc/passwd? Maybe that's not a good idea.

Of course, for the mostly non-contended case, it's quite possible that
the extra atomic isn't even noticeable. As long as the dentry is dirty
in the cache (which it would be, normally), the atomic cost is just in
the 10-20 cycles.

End result: I think it would be interesting to try this all out, and
it could be a noticeable win under some cases, but it *definitely*
needs a lot of timing and testing to see which ways it goes..

            Linus
