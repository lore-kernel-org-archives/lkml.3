Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3GXUNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:13:16 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31651 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3GXUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:13:14 -0400
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
Subject: [PATCH v2 0/3] qrwlock: Introducing a queue read/write lock implementation
Date: Wed, 24 Jul 2013 16:12:23 -0400
Message-Id: <1374696746-40184-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
that can largely solve this unfairness problem while, at the same
time, can optionally provide the classic read/write lock behavior
for those locks that need it. This new queue read/write lock is both
fairer than the classic read/write lock and will be faster in lock
contention situations.

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
cases, there won't be any noticeable degraduation in performance with
this replacement.

This patch set currently provides queue read/write lock support on
x86 architecture only. Support for other architectures can be added
later on once proper testing is done.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (3):
  qrwlock: A queue read/write lock implementation
  qrwlock x86: Enable x86 to use queue read/write lock
  qrwlock: Optionally enable classic read/write lock behavior

 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 include/asm-generic/qrwlock.h         |  251 +++++++++++++++++++++++++++++++++
 include/linux/rwlock.h                |   15 ++
 include/linux/rwlock_types.h          |   12 ++-
 include/linux/spinlock_types.h        |    4 +
 lib/Kconfig                           |   23 +++
 lib/Makefile                          |    1 +
 lib/qrwlock.c                         |  194 +++++++++++++++++++++++++
 lib/spinlock_debug.c                  |   20 +++
 11 files changed, 528 insertions(+), 1 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 lib/qrwlock.c

