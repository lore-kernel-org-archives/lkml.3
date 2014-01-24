Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaAXE3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:29:33 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:29787 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaAXE3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:29:31 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
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
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v11 0/4] Introducing a queue read/write lock implementation
Date: Thu, 23 Jan 2014 23:28:47 -0500
Message-Id: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v10->v11:
 - Insert appropriate smp_mb__{before,after}_atomic_* calls to make sure
   that the lock and unlock functions provide the proper memory barrier.

v9->v10:
 - Eliminate the temporary smp_load_acquire()/smp_store_release() macros
   by merging v9 patch 4 into patch 1.
 - Include <linux/mutex.h> & remove xadd() macro check. 
 - Incorporate review comments from PeterZ.

v8->v9:
 - Rebase to the tip branch which has the PeterZ's
   smp_load_acquire()/smp_store_release() patch.
 - Only pass integer type arguments to smp_load_acquire() &
   smp_store_release() functions.
 - Add a new patch to make any data type less than or equal to long as
   atomic or native in x86.
 - Modify write_unlock() to use atomic_sub() if the writer field is
   not atomic.

v7->v8:
 - Use atomic_t functions (which are implemented in all arch's) to
   modify reader counts.
 - Use smp_load_acquire() & smp_store_release() for barriers.
 - Further tuning in slowpath performance.

v6->v7:
 - Remove support for unfair lock, so only fair qrwlock will be provided.
 - Move qrwlock.c to the kernel/locking directory.

v5->v6:
 - Modify queue_read_can_lock() to avoid false positive result.
 - Move the two slowpath functions' performance tuning change from
   patch 4 to patch 1.
 - Add a new optional patch to use the new smp_store_release() function 
   if that is merged.

v4->v5:
 - Fix wrong definitions for QW_MASK_FAIR & QW_MASK_UNFAIR macros.
 - Add an optional patch 4 which should only be applied after the
   mcs_spinlock.h header file is merged.

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
that can largely solve this unfairness problem.

The read lock slowpath will check if the reader is in an interrupt
context. If so, it will force lock spinning and stealing without
waiting in a queue. This is to ensure the read lock will be granted
as soon as possible.

The queue write lock can also be used as a replacement for ticket
spinlocks that are highly contended if lock size increase is not
an issue.

The first 2 patches provides the base queue read/write lock support
on x86 architecture. Support for other architectures can be added
later on once architecture specific support infrastructure is added
and proper testing is done.

Patch 3 is for optimizing performance for x86 architecture.

The optional patch 4 has a dependency on the the mcs_spinlock.h
header file which has not been merged yet. So this patch should only
be applied after the mcs_spinlock.h header file is merged.

Waiman Long (4):
  qrwlock: A queue read/write lock implementation
  qrwlock, x86: Enable x86 to use queue read/write lock
  qrwlock, x86: Add char and short as atomic data type in x86
  qrwlock: Use the mcs_spinlock helper functions for MCS queuing

 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/barrier.h        |   18 +++
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 include/asm-generic/qrwlock.h         |  215 +++++++++++++++++++++++++++++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 +
 kernel/locking/qrwlock.c              |  183 ++++++++++++++++++++++++++++
 8 files changed, 431 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qrwlock.h
 create mode 100644 kernel/locking/qrwlock.c

