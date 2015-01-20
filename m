Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbbATUND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:13:03 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:57267 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbbATUM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:12:58 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v14 00/11] qspinlock: a 4-byte queue spinlock with PV support
Date: Tue, 20 Jan 2015 15:12:24 -0500
Message-Id: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v13->v14:
 - Patches 1 & 2: Add queue_spin_unlock_wait() to accommodate commit
   78bff1c86 from Oleg Nesterov.
 - Fix the system hang problem when using PV qspinlock in an
   over-committed guest due to a racing condition in the
   pv_set_head_in_tail() function.
 - Increase the MAYHALT_THRESHOLD from 10 to 1024.
 - Change kick_cpu into a regular function pointer instead of a
   callee-saved function.
 - Change lock statistics code to use separate bits for different
   statistics.

v12->v13:
 - Change patch 9 to generate separate versions of the
   queue_spin_lock_slowpath functions for bare metal and PV guest. This
   reduces the performance impact of the PV code on bare metal systems.

v11->v12:
 - Based on PeterZ's version of the qspinlock patch
   (https://lkml.org/lkml/2014/6/15/63).
 - Incorporated many of the review comments from Konrad Wilk and
   Paolo Bonzini.
 - The pvqspinlock code is largely from my previous version with
   PeterZ's way of going from queue tail to head and his idea of
   using callee saved calls to KVM and XEN codes.

v10->v11:
  - Use a simple test-and-set unfair lock to simplify the code,
    but performance may suffer a bit for large guest with many CPUs.
  - Take out Raghavendra KT's test results as the unfair lock changes
    may render some of his results invalid.
  - Add PV support without increasing the size of the core queue node
    structure.
  - Other minor changes to address some of the feedback comments.

v9->v10:
  - Make some minor changes to qspinlock.c to accommodate review feedback.
  - Change author to PeterZ for 2 of the patches.
  - Include Raghavendra KT's test results in patch 18.

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
 1) Patches 1-6: Introduces a queue-based spinlock implementation that
    can replace the default ticket spinlock without increasing the
    size of the spinlock data structure. As a result, critical kernel
    data structures that embed spinlock won't increase in size and
    break data alignments.
 2) Patch 7: Enables the use of unfair lock in a virtual guest. This
    can resolve some of the locking related performance issues due to
    halting the waiting CPUs after spinning for a certain amount of
    time. The unlock code will detect the a sleeping waiter and wake it
    up. This is essentially the same logic as the PV ticketlock code.
 3) Patches 8-11: Add paravirtualization spinlock support. This
    is needed as paravirt spinlock was enabled by default on
    distribution like RHEL 7.

The queue spinlock has slightly better performance than the ticket
spinlock in uncontended case. Its performance can be much better
with moderate to heavy contention.  This patch has the potential of
however, will not be able to support TSX.

The queue spinlock is especially suitable for NUMA machines with
at least 2 sockets. Though even at the 2-socket level, there can
be significant speedup depending on the workload. I got report that
the queue spinlock patch can improve the performance of an I/O and
interrupt intensive stress test with a lot of spinlock contention on
a 2-socket system by up to 20%.

The purpose of this patch set is not to solve any particular spinlock
contention problems. Those need to be solved by refactoring the code
to make more efficient use of the lock or finer granularity ones. The
main purpose is to make the lock contention problems more tolerable
until someone can spend the time and effort to fix them.

There had been discussions about using the call site patching mechanism
to patch out the PV unlock code to the simple non-PV unlock code in
x86. The code ran fine in bare-metal systems. However, it was found
that this didn't work with PV guest as it seemed like some lock
and unlock calls were invoked before the PV spinlock initialization
code was run. As a result, there is no easy way to figure out if the
unlock code should be patched in those cases. Various kinds of system
panics happened.  Further study needs to done to figure out a way to
work around that. For the time being, unlock call site patching will
not be part of this patch series.

Peter Zijlstra (3):
  qspinlock: Add pending bit
  qspinlock: Optimize for smaller NR_CPUS
  qspinlock: Revert to test-and-set on hypervisors

Waiman Long (8):
  qspinlock: A simple generic 4-byte queue spinlock
  qspinlock, x86: Enable x86-64 to use queue spinlock
  qspinlock: Extract out code snippets for the next patch
  qspinlock: Use a simple write to grab the lock
  qspinlock, x86: Rename paravirt_ticketlocks_enabled
  pvqspinlock, x86: Add para-virtualization support
  pvqspinlock, x86: Enable PV qspinlock for KVM
  pvqspinlock, x86: Enable PV qspinlock for XEN

 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/paravirt.h       |   22 ++
 arch/x86/include/asm/paravirt_types.h |   27 ++
 arch/x86/include/asm/pvqspinlock.h    |  426 +++++++++++++++++++++++++++++
 arch/x86/include/asm/qspinlock.h      |  104 +++++++
 arch/x86/include/asm/spinlock.h       |    9 +-
 arch/x86/include/asm/spinlock_types.h |    4 +
 arch/x86/kernel/kvm.c                 |  145 ++++++++++-
 arch/x86/kernel/paravirt-spinlocks.c  |   10 +-
 arch/x86/xen/spinlock.c               |  151 ++++++++++-
 include/asm-generic/qspinlock.h       |  141 ++++++++++
 include/asm-generic/qspinlock_types.h |   79 ++++++
 kernel/Kconfig.locks                  |    7 +
 kernel/locking/Makefile               |    1 +
 kernel/locking/mcs_spinlock.h         |    1 +
 kernel/locking/qspinlock.c            |  474 +++++++++++++++++++++++++++++++++
 16 files changed, 1590 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/include/asm/pvqspinlock.h
 create mode 100644 arch/x86/include/asm/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock.h
 create mode 100644 include/asm-generic/qspinlock_types.h
 create mode 100644 kernel/locking/qspinlock.c

