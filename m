Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab3HNKVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:21:06 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60040 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574Ab3HNKU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:20:59 -0400
Date: Wed, 14 Aug 2013 12:20:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 0/3] qrwlock: Introducing a queue read/write lock
 implementation
Message-ID: <20130814102041.GG10849@gmail.com>
References: <1375315259-29392-1-git-send-email-Waiman.Long@hp.com>
 <520A811A.7080907@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A811A.7080907@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 07/31/2013 08:00 PM, Waiman Long wrote:
> >v2->v3:
> >  - Make read lock stealing the default and fair rwlock an option with
> >    a different initializer.
> >  - In queue_read_lock_slowpath(), check irq_count() and force spinning
> >    and lock stealing in interrupt context.
> >  - Unify the fair and classic read-side code path, and make write-side
> >    to use cmpxchg with 2 different writer states. This slows down the
> >    write lock fastpath to make the read side more efficient, but is
> >    still slightly faster than a spinlock.
> >
> >v1->v2:
> >  - Improve lock fastpath performance.
> >  - Optionally provide classic read/write lock behavior for backward
> >    compatibility.
> >  - Use xadd instead of cmpxchg for fair reader code path to make it
> >    immute to reader contention.
> >  - Run more performance testing.
> >
> >As mentioned in the LWN article http://lwn.net/Articles/364583/, the
> >classic read/write lock suffer from an unfairness problem that it is
> >possible for a stream of incoming readers to block a waiting writer
> >from getting the lock for a long time. Also, a waiting reader/writer
> >contending a rwlock in local memory will have a higher chance of
> >acquiring the lock than a reader/writer in remote node.
> >
> >This patch set introduces a queue-based read/write lock implementation
> >that can largely solve this unfairness problem if the lock owners
> >choose to use the fair variant of the lock. The queue rwlock has two
> >variants selected at initialization time - classic (with read lock
> >stealing) and fair (to both readers and writers). The classic rwlock
> >is the default.
> >
> >The read lock slowpath will check if the reader is in an interrupt
> >context. If so, it will force lock spinning and stealing without
> >waiting in a queue. This is to ensure the read lock will be granted
> >as soon as possible.
> >
> >Even the classic rwlock is fairer than the current version as there
> >is a higher chance for writers to get the lock and is fair among
> >the writers.
> >
> >The queue write lock can also be used as a replacement for ticket
> >spinlocks that are highly contended if lock size increase is not
> >an issue.
> >
> >There is no change in the interface. By just selecting the QUEUE_RWLOCK
> >config parameter during the configuration phase, the classic read/write
> >lock will be replaced by the new queue read/write lock. This will
> >made the systems more deterministic and faster in lock contention
> >situations. In uncontended cases, the queue read/write lock may be
> >a bit slower than the classic one depending on the exact mix of read
> >and write locking primitives. Given the fact that locking overhead is
> >typically a very small percentage of the total CPU time in uncontended
> >cases, there won't be any noticeable degradation in performance with
> >this replacement.
> >
> >This patch set currently provides queue read/write lock support on
> >x86 architecture only. Support for other architectures can be added
> >later on once proper testing is done.
> >
> >Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> >
> >Waiman Long (3):
> >   qrwlock: A queue read/write lock implementation
> >   qrwlock x86: Enable x86 to use queue read/write lock
> >   qrwlock: Enable fair queue read/write lock behavior
> >
> >  arch/x86/Kconfig                      |    3 +
> >  arch/x86/include/asm/spinlock.h       |    2 +
> >  arch/x86/include/asm/spinlock_types.h |    4 +
> >  include/asm-generic/qrwlock.h         |  239 ++++++++++++++++++++++++++++++++
> >  include/linux/rwlock.h                |   15 ++
> >  include/linux/rwlock_types.h          |   13 ++
> >  lib/Kconfig                           |   23 +++
> >  lib/Makefile                          |    1 +
> >  lib/qrwlock.c                         |  242 +++++++++++++++++++++++++++++++++
> >  lib/spinlock_debug.c                  |   19 +++
> >  10 files changed, 561 insertions(+), 0 deletions(-)
> >  create mode 100644 include/asm-generic/qrwlock.h
> >  create mode 100644 lib/qrwlock.c
> 
> I would like to share with you a rwlock related system crash that I 
> encountered during my testing with hackbench on an 80-core DL980. The 
> kernel crash because of a "watchdog detected hard lockup on cpu 79". The 
> crashing CPU was running "write_lock_irq(&tasklist_lock)" in 
> forget_original_parent() of the exit code path when I interrupted the 
> hackbench which was spawning thousands of processes. Apparently, the 
> remote CPU was not able to get the lock for a sufficient long time due 
> to the unfairness of the rwlock which I think my version of queue rwlock 
> will be able to alleviate this issue.
> 
> So far, I was not able to reproduce the crash. I will try to see if I 
> could more consistently reproduce it.

Was it an actual crash/lockup, or a longish hang followed by a lock 
detector splat followed by the system eventually recovering back to 
working order?

Thanks,

	Ingo
