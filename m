Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3FLU02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:26:28 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:37614 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3FLU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<1370911480.9844.160.camel@gandalf.local.home>
	<CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	<1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	<1370974231.9844.212.camel@gandalf.local.home>
	<1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
	<1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
Date: Wed, 12 Jun 2013 13:26:25 -0700
X-Google-Sender-Auth: o_4yYCRFrG-pD8EdHb7HljM5234
Message-ID: <CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 1:03 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> According to him:
>
> "the short workload calls security functions like getpwnam(),
> getpwuid(), getgrgid() a couple of times. These functions open
> the /etc/passwd or /etc/group files, read their content and close the
> files.

Ahh, ok. So yeah, it's multiple threads all hitting the same file.

I guess that /etc/passwd case is historically interesting, but I'm not
sure we really want to care too deeply..

> I did a quick attempt at this (patch attached).

Yeah, that's wrong, although it probably approximates the dget() case
(but incorrectly).

One of the points behind using an atomic d_count is that then dput() should do

   if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_count))
      return;

at the very top of the function. It can avoid taking the lock entirely
if the count doesn't go down to zero, which would be a common case if
you have lots of users opening the same file. While still protecting
d_count from ever going to zero while the lock is held.

Your

+       if (atomic_read(&dentry->d_count) > 1) {
+               atomic_dec(&dentry->d_count);
+               return;
+       }
+       spin_lock(&dentry->d_lock);

pattern is fundamentally racy, but it's what "atomic_dec_and_lock()"
should do race-free.

For similar reasons, I think you need to still maintain the d_lock in
d_prune_aliases etc. That's a slow-path, so the fact that we add an
atomic sequence there doesn't much matter.

However, one optimization missing from your patch is obvious in the
profile. "dget_parent()" also needs to be optimized - you still have
that as 99% of the spin-lock case. I think we could do something like

   rcu_read_lock();
   parent = ACCESS_ONCE(dentry->d_parent);
   if (atomic_inc_nonzero(&parent->d_count))
      return parent;
   .. get d_lock and do it the slow way ...
   rcu_read_unlock();

to locklessly get the parent pointer. We know "parent" isn't going
away (dentries are rcu-free'd and we hold the rcu read lock), and I
think that we can optimistically take *any* parent dentry that
happened to be valid at one point. As long as the refcount didn't go
down to zero. Al?

With dput and dget_parent() both being lockless for the common case,
you might get rid of the d_lock contention entirely for that load. I
dunno. And I should really think more about that dget_parent() thing a
bit more, but I cannot imagine how it could not be right (because even
with the current d_lock model, the lock is gotten *within*
dget_parent(), so the caller can never know if it gets a new or an old
parent, so there is no higher-level serialization going on - and we
might as well return *either* the new or the old as such).

I really want Al to double-check me if we decide to try going down
this hole. But the above two fixes to your patch should at least
approximate the d_lock changes, even if I'd have to look more closely
at the other details of your patch..

                Linus
