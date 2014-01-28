Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaA1SUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:20:10 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32001 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaA1SUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:20:07 -0500
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
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v3 0/2] qspinlock: Introducing a 4-byte queue spinlock
Date: Tue, 28 Jan 2014 13:19:09 -0500
Message-Id: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3:
 - Simplify the code by using numerous mode only without an unfair option.
 - Use the latest smp_load_acquire()/smp_store_release() barriers.
 - Move the queue spinlock code to kernel/locking.
 - Make the use of queue spinlock the default for x86-64 without user
   configuration.
 - Additional performance tuning.

v1->v2:
 - Add some more comments to document what the code does.
 - Add a numerous CPU mode to support >= 16K CPUs
 - Add a configuration option to allow lock stealing which can further
   improve performance in many cases.
 - Enable wakeup of queue head CPU at unlock time for non-numerous
   CPU mode.

This patch set introduces a queue-based spinlock implementation that
can replace the default ticket spinlock without increasing the size
of the spinlock data structure. As a result, critical kernel data
structures that embed spinlock won't increase in size and breaking
data alignments.

The queue spinlock has slight better performance than the ticket
spinlock in uncontended case. Its performance can be much better
with moderate to heavy contention.  This patch has the potential of
improving the performance of all the workloads that have moderate to
heavy spinlock contention.

The queue spinlock is especially suitable for NUMA machines with at
least 2 sockets, though noticeable performance benefit probably won't
show up in machines with less than 4 sockets.

The purpose of this patch set is not to solve any particular spinlock
contention problems. Those need to be solved by refactoring the code
to make more efficient use of the lock or finer granularity ones. The
main purpose is to make the lock contention problems more tolerable
until someone can spend the time and effort to fix them.

Waiman Long (2):
  qspinlock: Introducing a 4-byte queue spinlock implementation
  qspinlock, x86: Enable x86-64 to use queue spinlock

 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 include/asm-generic/qspinlock.h       |  156 +++++++++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 +
 kernel/locking/qspinlock.c            |  398 +++++++++++++++++++++++++++++++++
 7 files changed, 569 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 kernel/locking/qspinlock.c

