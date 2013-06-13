Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3FMAVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:21:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54302 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab3FMAVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:21:15 -0400
Date: Thu, 13 Jun 2013 01:20:58 +0100
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
Message-ID: <20130613002058.GI4165@ZenIV.linux.org.uk>
References: <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
 <1370974231.9844.212.camel@gandalf.local.home>
 <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
 <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
 <20130612233224.GH4165@ZenIV.linux.org.uk>
 <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 05:01:19PM -0700, Linus Torvalds wrote:
> I'd actually suggest we do *not* remove any existing d_lock usage
> outside of the particular special cases we want to optimize, which at
> least from Davidlohr's profile is just dput() (which has shown up a
> lot before) and dget_parent() (which I'm not sure why it happens so
> much on his load, but it really seems trivially safe to optimistically
> do under just the RCU lock).

Actually, dget_parent() change might be broken; the thing is, the assumptions
are more subtle than "zero -> non-zero only happens under ->d_lock".  It's
actually "new references are grabbed by somebody who's either already holding
one on the same dentry _or_ holding ->d_lock".  That's what d_invalidate()
check for ->d_count needs for correctness - caller holds one reference, so
comparing ->d_count with 2 under ->d_lock means checking that there's no other
holders _and_ there won't be any new ones appearing.

Consider the following situation:
X is dentry of a/b
Y is dentry of a/b/c
Z is dentry of d/e

A holds a reference to Y and enters dget_parent(Y)
B holds a reference to X and enters d_invalidate(X)
A picks the value of Y->d_parent (== X)
C moves Y to Z
B grabs ->d_lock on X
B checks X->d_count; it's 1, we deduce that no other references exist or
are going to appear
A does atomic_inc_not_zero(&X->d_count).  And since it's not zero (it's 1,
actually), we've just grabbed an extra reference on X that was not going
to appear according to B...

> That said, I do wonder if we could do something like
> "atomic_inc_not_zero()" on the d_count, and only if it is zero (which
> won't be horribly unusual, since for leaf dentries that nobody else is
> using) we'd do the whole locking sequence.

Same correctness issue as above, I'm afraid...

> End result: I think it would be interesting to try this all out, and
> it could be a noticeable win under some cases, but it *definitely*
> needs a lot of timing and testing to see which ways it goes..

*nod*

What's more, we need the underlying assumptions documented very clearly for
any such change; it's _not_ as simple as "protect transitions from zero to
non-zero and we are done" ;-/
