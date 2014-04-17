Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaDQPE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:04:58 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:23421 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaDQPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:42 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 00/19] qspinlock: a 4-byte queue spinlock with PV support
Date: Thu, 17 Apr 2014 11:03:52 -0400
Message-Id: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v8->v9:
  - Integrate PeterZ's version of the queue spinlock patch with some
    modification:
    http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
  - Break the more complex patches into smaller ones to ease review effort.
  - Fix a racing condition in the PV qspinlock code.

v7->v8:
  - Remove one unneeded atomic operation from the slowpath, thus
    improving performance.
  - Simplify some of the codes and add more comments.
  - Test for X86_FEATURE_HYPERVISOR CPU feature bit to enable/disable
    unfair lock.
  - Reduce unfair lock slowpath lock stealing frequency depending
    on its distance from the queue head.
  - Add performance data for IvyBridge-EX CPU.

v6->v7:
  - Remove an atomic operation from the 2-task contending code
  - Shorten the names of some macros
  - Make the queue waiter to attempt to steal lock when unfair lock is
    enabled.
  - Remove lock holder kick from the PV code and fix a race condition
  - Run the unfair lock & PV code on overcommitted KVM guests to collect
    performance data.

v5->v6:
 - Change the optimized 2-task contending code to make it fairer at the
   expense of a bit of performance.
 - Add a patch to support unfair queue spinlock for Xen.
 - Modify the PV qspinlock code to follow what was done in the PV
   ticketlock.
 - Add performance data for the unfair lock as well as the PV
   support code.

v4->v5:
 - Move the optimized 2-task contending code to the generic file to
   enable more architectures to use it without code duplication.
 - Address some of the style-related comments by PeterZ.
 - Allow the use of unfair queue spinlock in a real para-virtualized
   execution environment.
 - Add para-virtualization support to the qspinlock code by ensuring
   that the lock holder and queue head stay alive as much as possible.

v3->v4:
 - Remove debugging code and fix a configuration error
 - Simplify the qspinlock structure and streamline the code to make it
   perform a bit better
 - Add an x86 version of asm/qspinlock.h for holding x86 specific
   optimization.
 - Add an optimized x86 code path for 2 contending tasks to improve
   low contention performance.

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

This patch set has 3 different sections:
 1) Patches 1-7: Introduces a queue-based spinlock implementation that
    can replace the default ticket spinlock without increasing the
    size of the spinlock data structure. As a result, critical kernel
    data structures that embed spinlock won't increase in size and
    break data alignments.
 2) Patches 8-13: Enables the use of unfair queue spinlock in a
    virtual guest. This can resolve some of the locking related
    performance issues due to the fact that the next CPU to get the
    lock may have been scheduled out for a period of time.
 3) Patches 14-19: Enable qspinlock para-virtualization support
    by halting the waiting CPUs after spinning for a certain amount of
    time. The unlock code will detect the a sleeping waiter and wake it
    up. This is essentially the same logic as the PV ticketlock code.

The queue spinlock has slightly better performance than the ticket
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

Waiman Long (19):
  qspinlock: A simple generic 4-byte queue spinlock
  qspinlock, x86: Enable x86-64 to use queue spinlock
  qspinlock: Add pending bit
  qspinlock: Extract out the exchange of tail code word
  qspinlock: Optimize for smaller NR_CPUS
  qspinlock: prolong the stay in the pending bit path
  qspinlock: Use a simple write to grab the lock, if applicable
  qspinlock: Make a new qnode structure to support virtualization
  qspinlock: Prepare for unfair lock support
  qspinlock, x86: Allow unfair spinlock in a virtual guest
  qspinlock: Split the MCS queuing code into a separate slowerpath
  unfair qspinlock: Variable frequency lock stealing mechanism
  unfair qspinlock: Enable lock stealing in lock waiters
  pvqspinlock, x86: Rename paravirt_ticketlocks_enabled
  pvqspinlock, x86: Add PV data structure & methods
  pvqspinlock: Enable coexistence with the unfair lock
  pvqspinlock: Add qspinlock para-virtualization support
  pvqspinlock, x86: Enable PV qspinlock PV for KVM
  pvqspinlock, x86: Enable PV qspinlock for XEN

 arch/x86/Kconfig                      |   12 +
 arch/x86/include/asm/paravirt.h       |   18 +-
 arch/x86/include/asm/paravirt_types.h |   17 +
 arch/x86/include/asm/pvqspinlock.h    |  306 +++++++++++
 arch/x86/include/asm/qspinlock.h      |  141 +++++
 arch/x86/include/asm/spinlock.h       |    9 +-
 arch/x86/include/asm/spinlock_types.h |    4 +
 arch/x86/kernel/Makefile              |    1 +
 arch/x86/kernel/kvm.c                 |  137 +++++-
 arch/x86/kernel/paravirt-spinlocks.c  |   36 ++-
 arch/x86/xen/spinlock.c               |  148 +++++-
 include/asm-generic/qspinlock.h       |  118 +++++
 include/asm-generic/qspinlock_types.h |   82 +++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 +
 kernel/locking/mcs_spinlock.h         |    1 +
 kernel/locking/qspinlock.c            |  918 +++++++++++++++++++++++++++++++++
 17 files changed, 1944 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/include/asm/pvqspinlock.h
 create mode 100644 arch/x86/include/asm/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock_types.h
 create mode 100644 kernel/locking/qspinlock.c

