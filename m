Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3HMSlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:41:53 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21356 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740Ab3HMSls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:41:48 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: [PATCH RFC v2 0/2] qspinlock: Introducing a 4-byte queue spinlock
Date: Tue, 13 Aug 2013 14:41:05 -0400
Message-Id: <1376419267-17663-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Add some more comments to document what the code does.
 - Add a numerous CPU mode to support >= 16K CPUs
 - Add a configuration option to allow lock stealing which can further
   improve performance in many cases.
 - Enable wakeup of queue head CPU at unlock time for non-numerous
   CPU mode.

This patch set introduces a queue-based spinlock implementation that
can be used to replace the default ticket spinlock without increasing
the size of the spinlock data structure. As a result, critical kernel
data structures that embed spinlock won't increase in size and breaking
data alignments.

The queue spinlock has about the same performance as the ticket
spinlock in uncontended case. Its performance is better with moderate
to heavy contention. It may be slightly slower in light to moderate
level of lock contention where the queue depth is around 1-2. This
patch has the potential of improving the performance of all the
workloads that have moderate to heavy spinlock contention.

The queue spinlock is especially suitable for NUMA machines with at
least 2 sockets, though noticeable performance benefit probably won't
show up in machines with less than 4 sockets.

There is also an experimental option to allow lock stealing thus breaking
the FIFO guarantee of lock acquisition. However, performance usually goes
up with an unfair lock.

The purpose of this patch set is not to solve any particular spinlock
contention problems. Those need to be solved by refactoring the code
to make more efficient use of the lock or finer granularity ones. The
main purpose is to make the lock contention problems more tolerable
until someone can spend the time and effort to fix them.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (2):
  qspinlock: Introducing a 4-byte queue spinlock implementation
  qspinlock x86: Enable x86 to use queue spinlock

 arch/x86/Kconfig                      |    3 +
 arch/x86/include/asm/spinlock.h       |    2 +
 arch/x86/include/asm/spinlock_types.h |    4 +
 arch/x86/kernel/paravirt-spinlocks.c  |   10 +
 include/asm-generic/qspinlock.h       |  207 +++++++++++++
 lib/Kconfig                           |   25 ++
 lib/Makefile                          |    1 +
 lib/qspinlock.c                       |  522 +++++++++++++++++++++++++++++++++
 8 files changed, 774 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 lib/qspinlock.c

