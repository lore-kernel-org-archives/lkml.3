Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab3AWAfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:35:07 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:44993 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3AWAfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:35:03 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ANNOUNCE] 3.8-rc4-nohz3
Date: Wed, 23 Jan 2013 01:34:54 +0100
Message-Id: <1358901294-3269-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version of the full dynticks patchset integrates the latest full
dynticks cputime accounting changes (see https://lkml.org/lkml/2013/1/22/652)
and is rebased against 3.8-rc4.

All of these patches have been posted already so I'm not spamming
you again.

You can pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	3.8-rc4-nohz3

So this fixes and improve a lot of things since 3.8-rc2-nohz2:

- Use sched_clock() instead of jiffies for better precision. And because
jiffies granularity was requiring too much dirty hacks to make it working.
(Thanks Steven for the suggestion).

- To fully support sched_clock(), use a per nanosec granularity in cputime_t

- Fix a deadlock with tsacct

- Better description of the Kconfig

- Don't scale generic vtime accounting against CFS precise task time accounting.
Now that we use sched_clock() we should have precise enough statistics.

- Consolidate some code in the reader side

- Make the reader irqsafe (fix potential deadlock against writers)

- Handle guest cputime

- Handle idle tasks. Those were special because they don't start from schedule()
so they need their own initializations.

- Fix build error with CONFIG_IRQ_TIME_ACCOUNTING (thanks Wu Fenguang)

- Depend on 64 bits archs to make kernel_cpustat reading to be atomic


Thanks.

---
Frederic Weisbecker (44):
      irq_work: Fix racy IRQ_WORK_BUSY flag setting
      irq_work: Fix racy check on work pending flag
      irq_work: Remove CONFIG_HAVE_IRQ_WORK
      nohz: Add API to check tick state
      irq_work: Don't stop the tick with pending works
      irq_work: Make self-IPIs optable
      printk: Wake up klogd using irq_work
      context_tracking: Add comments on interface and internals
      context_tracking: Export context state for generic vtime
      cputime: Librarize per nsecs resolution cputime definitions
      cputime: Move default nsecs_to_cputime() to jiffies based cputime file
      cputime: Generic on-demand virtual cputime accounting
      cputime: Allow dynamic switch between tick/virtual based cputime accounting
      cputime: Use accessors to read task cputime stats
      kvm: Prepare to add generic guest entry/exit callbacks
      cputime: Safely read cputime of full dynticks CPUs
      Merge branch 'nohz/printk-v8'
      nohz: Basic full dynticks interface
      nohz: Assign timekeeping duty to a non-full-nohz CPU
      nohz: Trace timekeeping update
      nohz: Wake up full dynticks CPUs when a timer gets enqueued
      rcu: Restart the tick on non-responding full dynticks CPUs
      sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
      sched: Update rq clock on nohz CPU before migrating tasks
      sched: Update rq clock on nohz CPU before setting fair group shares
      sched: Update rq clock on tickless CPUs before calling check_preempt_curr()
      sched: Update rq clock earlier in unthrottle_cfs_rq
      sched: Update clock of nohz busiest rq before balancing
      sched: Update rq clock before idle balancing
      sched: Update nohz rq clock before searching busiest group on load balancing
      nohz: Move nohz load balancer selection into idle logic
      nohz: Full dynticks mode
      nohz: Only stop the tick on RCU nocb CPUs
      nohz: Don't turn off the tick if rcu needs it
      nohz: Don't stop the tick if posix cpu timers are running
      nohz: Add some tracing
      rcu: Don't keep the tick for RCU while in userspace
      profiling: Remove unused timer hook
      timer: Don't run non-pinned timer to full dynticks CPUs
      sched: Use an accessor to read rq clock
      sched: Debug nohz rq clock
      sched: Remove broken check for skip clock update
      sched: Update rq clock before rt sched average scale
      sched: Disable lb_bias feature for full dynticks

Steven Rostedt (2):
      irq_work: Flush work on CPU_DYING
      irq_work: Warn if there's still work on cpu_down

 arch/alpha/Kconfig                           |    1 -
 arch/alpha/kernel/osf_sys.c                  |    6 +-
 arch/arm/Kconfig                             |    1 -
 arch/arm64/Kconfig                           |    1 -
 arch/blackfin/Kconfig                        |    1 -
 arch/frv/Kconfig                             |    1 -
 arch/hexagon/Kconfig                         |    1 -
 arch/ia64/include/asm/cputime.h              |   92 +--------
 arch/ia64/include/asm/thread_info.h          |    4 +-
 arch/ia64/include/asm/xen/minstate.h         |    2 +-
 arch/ia64/kernel/asm-offsets.c               |    2 +-
 arch/ia64/kernel/entry.S                     |   16 +-
 arch/ia64/kernel/fsys.S                      |    4 +-
 arch/ia64/kernel/head.S                      |    4 +-
 arch/ia64/kernel/ivt.S                       |    8 +-
 arch/ia64/kernel/minstate.h                  |    2 +-
 arch/ia64/kernel/time.c                      |    4 +-
 arch/mips/Kconfig                            |    1 -
 arch/parisc/Kconfig                          |    1 -
 arch/powerpc/Kconfig                         |    1 -
 arch/powerpc/configs/chroma_defconfig        |    2 +-
 arch/powerpc/configs/corenet64_smp_defconfig |    2 +-
 arch/powerpc/configs/pasemi_defconfig        |    2 +-
 arch/powerpc/include/asm/cputime.h           |    6 +-
 arch/powerpc/include/asm/lppaca.h            |    2 +-
 arch/powerpc/include/asm/ppc_asm.h           |    4 +-
 arch/powerpc/kernel/entry_64.S               |    4 +-
 arch/powerpc/kernel/time.c                   |    4 +-
 arch/powerpc/platforms/pseries/dtl.c         |    6 +-
 arch/powerpc/platforms/pseries/setup.c       |    6 +-
 arch/s390/Kconfig                            |    1 -
 arch/s390/kernel/vtime.c                     |    6 +-
 arch/sh/Kconfig                              |    1 -
 arch/sparc/Kconfig                           |    1 -
 arch/x86/Kconfig                             |    1 -
 arch/x86/kernel/apm_32.c                     |   11 +-
 drivers/isdn/mISDN/stack.c                   |    7 +-
 drivers/staging/iio/trigger/Kconfig          |    1 -
 fs/binfmt_elf.c                              |    8 +-
 fs/binfmt_elf_fdpic.c                        |    7 +-
 fs/proc/array.c                              |    4 +-
 include/asm-generic/cputime.h                |   66 +-----
 include/asm-generic/cputime_jiffies.h        |   72 ++++++
 include/asm-generic/cputime_nsecs.h          |  104 +++++++++
 include/linux/context_tracking.h             |   28 +++
 include/linux/hardirq.h                      |    4 +-
 include/linux/init_task.h                    |   11 +
 include/linux/irq_work.h                     |   20 ++
 include/linux/kernel_stat.h                  |    2 +-
 include/linux/kvm_host.h                     |   55 ++++-
 include/linux/posix-timers.h                 |    1 +
 include/linux/printk.h                       |    3 -
 include/linux/profile.h                      |   13 --
 include/linux/rcupdate.h                     |    8 +
 include/linux/sched.h                        |   50 ++++-
 include/linux/tick.h                         |   26 +++-
 include/linux/tsacct_kern.h                  |    3 +
 include/linux/vtime.h                        |   59 ++++--
 init/Kconfig                                 |   28 ++-
 kernel/acct.c                                |    6 +-
 kernel/context_tracking.c                    |  110 ++++++++---
 kernel/cpu.c                                 |    4 +-
 kernel/delayacct.c                           |    7 +-
 kernel/exit.c                                |   10 +-
 kernel/fork.c                                |    6 +
 kernel/hrtimer.c                             |    3 +-
 kernel/irq_work.c                            |  131 +++++++++---
 kernel/posix-cpu-timers.c                    |   39 +++-
 kernel/printk.c                              |   36 ++--
 kernel/profile.c                             |   24 --
 kernel/rcutree.c                             |   19 ++-
 kernel/rcutree.h                             |    1 -
 kernel/rcutree_plugin.h                      |   13 +-
 kernel/sched/core.c                          |  105 ++++++++-
 kernel/sched/cputime.c                       |  298 +++++++++++++++++++++++---
 kernel/sched/fair.c                          |   96 ++++++---
 kernel/sched/features.h                      |    3 +
 kernel/sched/rt.c                            |    8 +-
 kernel/sched/sched.h                         |   50 +++++
 kernel/sched/stats.h                         |    8 +-
 kernel/sched/stop_task.c                     |    8 +-
 kernel/signal.c                              |   12 +-
 kernel/softirq.c                             |   11 +-
 kernel/time/Kconfig                          |    9 +
 kernel/time/tick-broadcast.c                 |    3 +-
 kernel/time/tick-common.c                    |    5 +-
 kernel/time/tick-sched.c                     |  144 +++++++++++--
 kernel/timer.c                               |    6 +-
 kernel/tsacct.c                              |   44 +++-
 89 files changed, 1489 insertions(+), 522 deletions(-)
