Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3FLSPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:15:24 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51333 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3FLSPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<1370911480.9844.160.camel@gandalf.local.home>
	<CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	<1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	<1370974231.9844.212.camel@gandalf.local.home>
	<1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
Date: Wed, 12 Jun 2013 11:15:17 -0700
X-Google-Sender-Auth: oxL3uRsrjC84rOhbbJu8eExDR3o
Message-ID: <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
        Silas Boyd-Wickizer <sbw@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:50 AM, Davidlohr Bueso
<davidlohr.bueso@hp.com> wrote:
>
> * short: is the big winner for this patch, +69% throughput improvement
> with 100-2000 users. This makes a lot of sense since the workload spends
> a ridiculous amount of time trying to acquire the d_lock:
>
>   84.86%    1569902            reaim  [kernel.kallsyms]            [k] _raw_spin_lock
>                       |
>                       --- _raw_spin_lock
>                          |
>                          |--49.96%-- dget_parent
>                          |          __fsnotify_parent
>                          |--49.71%-- dput

Ugh. Do you have any idea what the heck that thing actually does?

Normally, we shouldn't see lots of dget contention, since the dcache
these days does everything but the last path component locklessly.

But there's a few exceptions, like symlinks (act as "last component"
in the middle). And obviously, if some crazy threaded program opens
the *same* file concurrently over and over again, then that "last
component" will hammer on the dentry lock of that particular path. But
that "open the same file concurrently" seems totally unrealistic -
although maybe that's what AIM does..

Anybody know the AIM subtests?

Also, we *may* actually be able to optimize this by making
dentry->d_count atomic, which will allow us to often do dget_parent
and put() without taking the dcache lock at all. That's what it used
to be, but the RCU patches actually made it be protected by the
d_lock. It made sense at the time, as a step in the sequence, and many
of the dentry d_count accesses are under the lock, but now that the
remaining hot-paths are dget_parent and dput and many of the dentry
d_count increments are gone from the hot-paths, we might want to
re-visit that decision.  It could go either way.

Al, comments?

             Linus
