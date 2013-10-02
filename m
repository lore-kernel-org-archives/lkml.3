Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3JBOJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:09:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29139 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3JBOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:09:43 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 0/3] qrwlock: Introducing a queue read/write lock implementation
Date: Wed,  2 Oct 2013 10:09:03 -0400
Message-Id: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3->v4:
 - Optimize the fast path with better cold cache behavior and
   performance.
 - Removing some testing code.
 - Make x86 use queue rwlock with no user configuration.

v2->v3:
 - Make read lock stealing the default and fair rwlock an option with
   a different initializer.
 - In queue_read_lock_slowpath(), check irq_count() and force spinning
   and lock stealing in interrupt context.
 - Unify the fair and classic read-side code path, and make write-side
   to use cmpxchg with 2 different writer states. This slows down the
   write lock fastpath to make the read side more efficient, but is
   still slightly faster than a spinlock.

v1->v2:
 - Improve lock fastpath performance.
 - Optionally provide classic read/write lock behavior for backward
   compatibility.
 - Use xadd instead of cmpxchg for fair reader code path to make it
   immute to reader contention.
 - Run more performance testing.

As mentioned in the LWN article http://lwn.net/Articles/364583/,
the read/write lock suffer from an unfairness problem that it is
possible for a stream of incoming readers to block a waiting writer
from getting the lock for a long time. Also, a waiting reader/writer
contending a rwlock in local memory will have a higher chance of
acquiring the lock than a reader/writer in remote node.

This patch set introduces a queue-based read/write lock implementation
that can largely solve this unfairness problem if the lock owners
choose to use the fair variant of the lock.

The queue rwlock has two variants selected at initialization time
- unfair (with read lock stealing) and fair (to both readers and
writers). The unfair rwlock is the default.

The read lock slowpath will check if the reader is in an interrupt
context. If so, it will force lock spinning and stealing without
waiting in a queue. This is to ensure the read lock will be granted
as soon as possible.

Even the unfair rwlock is fairer than the current version as there
is a higher chance for writers to get the lock and is fair among
the writers.

The queue write lock can also be used as a replacement for ticket
spinlocks that are highly contended if lock size increase is not
an issue.

This patch set currently provides queue read/write lock support on
x86 architecture only. Support for other architectures can be added
later on once architecture specific support infrastructure is added
and proper testing is done.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (3):
  qrwlock: A queue read/write lock implementation
  qrwlock x86: Enable x86 to use queue read/write lock
  qrwlock: Enable fair queue read/write lock

 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 include/asm-generic/qrwlock.h         |  256 +++++++++++++++++++++++++++++++++
 include/linux/rwlock.h                |   15 ++
 include/linux/rwlock_types.h          |   13 ++
 kernel/Kconfig.locks                  |    7 +
 lib/Makefile                          |    1 +
 lib/qrwlock.c                         |  247 +++++++++++++++++++++++++++++++
 lib/spinlock_debug.c                  |   19 +++
 10 files changed, 565 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

