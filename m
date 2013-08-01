Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3HAACH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:02:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:19284 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3HAABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:01:32 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 0/3] qrwlock: Introducing a queue read/write lock implementation
Date: Wed, 31 Jul 2013 20:00:56 -0400
Message-Id: <1375315259-29392-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

As mentioned in the LWN article http://lwn.net/Articles/364583/, the
classic read/write lock suffer from an unfairness problem that it is
possible for a stream of incoming readers to block a waiting writer
from getting the lock for a long time. Also, a waiting reader/writer
contending a rwlock in local memory will have a higher chance of
acquiring the lock than a reader/writer in remote node.

This patch set introduces a queue-based read/write lock implementation
that can largely solve this unfairness problem if the lock owners
choose to use the fair variant of the lock. The queue rwlock has two
variants selected at initialization time - classic (with read lock
stealing) and fair (to both readers and writers). The classic rwlock
is the default.

The read lock slowpath will check if the reader is in an interrupt
context. If so, it will force lock spinning and stealing without
waiting in a queue. This is to ensure the read lock will be granted
as soon as possible.

Even the classic rwlock is fairer than the current version as there
is a higher chance for writers to get the lock and is fair among
the writers.

The queue write lock can also be used as a replacement for ticket
spinlocks that are highly contended if lock size increase is not
an issue.

There is no change in the interface. By just selecting the QUEUE_RWLOCK
config parameter during the configuration phase, the classic read/write
lock will be replaced by the new queue read/write lock. This will
made the systems more deterministic and faster in lock contention
situations. In uncontended cases, the queue read/write lock may be
a bit slower than the classic one depending on the exact mix of read
and write locking primitives. Given the fact that locking overhead is
typically a very small percentage of the total CPU time in uncontended
cases, there won't be any noticeable degradation in performance with
this replacement.

This patch set currently provides queue read/write lock support on
x86 architecture only. Support for other architectures can be added
later on once proper testing is done.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (3):
  qrwlock: A queue read/write lock implementation
  qrwlock x86: Enable x86 to use queue read/write lock
  qrwlock: Enable fair queue read/write lock behavior

 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 include/asm-generic/qrwlock.h         |  239 ++++++++++++++++++++++++++++++++
 include/linux/rwlock.h                |   15 ++
 include/linux/rwlock_types.h          |   13 ++
 lib/Kconfig                           |   23 +++
 lib/Makefile                          |    1 +
 lib/qrwlock.c                         |  242 +++++++++++++++++++++++++++++++++
 lib/spinlock_debug.c                  |   19 +++
 10 files changed, 561 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

