Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3FLXcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:32:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54224 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3FLXco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:32:44 -0400
Date: Thu, 13 Jun 2013 00:32:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, ????????? <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130612233224.GH4165@ZenIV.linux.org.uk>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
 <1370974231.9844.212.camel@gandalf.local.home>
 <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
 <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:26:25PM -0700, Linus Torvalds wrote:

> For similar reasons, I think you need to still maintain the d_lock in
> d_prune_aliases etc. That's a slow-path, so the fact that we add an
> atomic sequence there doesn't much matter.
> 
> However, one optimization missing from your patch is obvious in the
> profile. "dget_parent()" also needs to be optimized - you still have
> that as 99% of the spin-lock case. I think we could do something like
> 
>    rcu_read_lock();
>    parent = ACCESS_ONCE(dentry->d_parent);
>    if (atomic_inc_nonzero(&parent->d_count))
>       return parent;
>    .. get d_lock and do it the slow way ...
>    rcu_read_unlock();
> 
> to locklessly get the parent pointer. We know "parent" isn't going
> away (dentries are rcu-free'd and we hold the rcu read lock), and I
> think that we can optimistically take *any* parent dentry that
> happened to be valid at one point. As long as the refcount didn't go
> down to zero. Al?

What will you do with __d_rcu_to_refcount()?  Any such scheme has to
hold d_lock from zero->non-zero d_count changes, or atomic_dec_and_lock
in dput() won't help at all.  As it is, both comlete_walk() and unlazy_walk()
are grabbing ->d_lock on the dentry we'd reached, so they can call that
sucker.  And that'll give you ->d_lock contention when a bunch of threads
are hitting the same file; I don't see how atomics would avoid that
one...
