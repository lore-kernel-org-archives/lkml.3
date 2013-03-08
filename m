Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab3CHEhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:37:22 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45384 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647Ab3CHEhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:37:20 -0500
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] tasklist_lock fairness issues
Date: Thu,  7 Mar 2013 20:37:12 -0800
Message-Id: <1362717437-1729-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to gather comments on these patches, which apply over v3.9-rc1.

I have been looking at rwlock_t fairness issues, and in particular at
tasklist_lock as this is the one rwlock_t user that seems to be making
it difficult to switch rwlock_t to a fair lock. This is because the
tasklist_lock read side is taken both in process and irq contexts,
and we don't want to have to disable irqs when tasklist_lock is taken
in process context, so we need a rwlock_t that supports a recursive
read side.

Patches 1-3 convert the existing tasklist_lock users to use helper
functions.  For the tasklist_lock read side, we have different helpers
for call sites that are known to run only in process context, vs call
sites that may run in any context.

- Patch 1 introduces the tasklist_lock helper functions;

- Patch 2 identifies all tasklist_lock call sites that may run in
  (soft or hard) irq context and converts them to use the
  tasklist_read_[un]lock_any helper functions;

- Patch 3 converts the remaining call sites (known to run only in
  process context) to use the tasklist_{read,write}_[un]lock helpers.

Together, these 3 patches provide some kind of documentation about which
tasklist users may run in irq contexts, and are thus currently making it
difficult to do a straight conversion of rwlock_t to a fair rw spinlock.

Patch 4 introduces a generic implementation of a fair (ticket based)
rw spinlock. I did not try optimizing it; it would be possible to do
better using arch specific code. Seems too early for it though :)

Patch 5 makes tasklist_lock fair when acquired from process context.
This is done using a double locking scheme; there is a fair rwlock
that is used when tasklist_lock is acquired from process context and
an unfair rwlock_t that is used when tasklist_lock read side is acquired
from irq context. When tasklist_lock is acquired for write both locks
are taken. Clearly, such double locking is suboptimal; one would hope
that the irq context read side users could be eliminated over time.
Converting the process context users to a fair rwlock also has the
additional benefit that it lets lockdep verify that we are not trying
to do recursive acquires of the tasklist_lock read side in process context.
(I haven't been able to break this check so far).

Does this look like a reasonable approach to get traction on the
tasklist_lock issues ?

Michel Lespinasse (5):
  kernel: add tasklist_{read,write}_lock{,_any} helper functions
  kernel: use tasklist_read_lock_any() when locking tasklist in irq context
  kernel: use tasklist_{read,write}_lock() to lock tasklist in process context
  kernel: add ticket based fair rwlock
  kernel: make tasklist_lock fair for process context call sites

 arch/blackfin/kernel/trace.c     |  4 +--
 arch/frv/mm/mmu-context.c        |  4 +--
 arch/ia64/kernel/mca.c           | 13 ++++----
 arch/ia64/kernel/perfmon.c       |  8 ++---
 arch/ia64/kernel/ptrace.c        |  8 ++---
 arch/metag/kernel/smp.c          |  4 +--
 arch/mips/kernel/mips-mt-fpaff.c |  4 +--
 arch/sh/mm/asids-debugfs.c       |  4 +--
 arch/um/kernel/reboot.c          |  4 +--
 drivers/tty/sysrq.c              |  4 +--
 drivers/tty/tty_io.c             | 20 +++++------
 fs/exec.c                        | 14 ++++----
 fs/fcntl.c                       |  8 ++---
 fs/fs_struct.c                   |  4 +--
 fs/proc/array.c                  |  4 +--
 fs/proc/base.c                   |  4 +--
 include/linux/fair_rwlock.h      | 72 ++++++++++++++++++++++++++++++++++++++++
 include/linux/lockdep.h          | 15 +++++++++
 include/linux/sched.h            | 46 ++++++++++++++++++++++++-
 kernel/cgroup.c                  |  4 +--
 kernel/cpu.c                     |  4 +--
 kernel/exit.c                    | 42 +++++++++++------------
 kernel/fork.c                    | 14 +++++---
 kernel/lockdep.c                 |  6 ++--
 kernel/pid_namespace.c           |  8 ++---
 kernel/posix-cpu-timers.c        | 32 +++++++++---------
 kernel/power/process.c           | 16 ++++-----
 kernel/ptrace.c                  | 20 +++++------
 kernel/sched/core.c              | 13 ++++----
 kernel/sched/debug.c             |  5 ++-
 kernel/signal.c                  | 26 +++++++--------
 kernel/sys.c                     | 22 ++++++------
 kernel/trace/ftrace.c            |  5 ++-
 kernel/tracepoint.c              | 10 +++---
 mm/kmemleak.c                    |  4 +--
 mm/memory-failure.c              |  8 ++---
 mm/oom_kill.c                    |  4 +--
 security/keys/keyctl.c           |  4 +--
 security/selinux/hooks.c         |  4 +--
 39 files changed, 312 insertions(+), 183 deletions(-)
 create mode 100644 include/linux/fair_rwlock.h

-- 
1.8.1.3
