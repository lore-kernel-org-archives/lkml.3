Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3AWAEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:04:12 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54850 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3AWAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:04:10 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 0/8] cputime: Full dynticks task/cputime accounting v6
Date: Wed, 23 Jan 2013 01:03:54 +0100
Message-Id: <1358899442-3110-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version fixes everything I had on the TODO list. I'm just not very
happy with the dependency on CONFIG_64BIT. It is necessary because cputime_t
maps to unsigned long long in order to implement a per nanosec granularity
fitting in a reasonable range. And 32 bits archs can't read 64 bits cputime_t
safely (they read low and high part separately, this can race against an update
that does an arithmetic carry after incrementing the low part).
Usual utime/stime/gtime/... are fine because they are protected with the
new seqcount. But kernel_cpustat is not protected on the read side.

I don't know what the right fix is. May be we could use per cpu spinlocks
or seqlocks from both read/update side of kernel_cpustat. Hmm, or perhaps
take curr_task(cpu)->vtime_seqlock before reading it. This requires rq
lock though.

Anyway I believe that specific issue can wait for now. The patchset is already
complicated enough and it depends on context_tracking that is only implemented
on x86-64 yet. I guess once that gets merged and we get a 32 arch to support
the context_tracking, we can start to think about that.

This set is pullable from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
        vtime/generic-v6

Changes since v5:

- Handle guest cputime
- Handle idle tasks. Those were special because they don't start from schedule()
so they need their own initializations.
- Fix build error with CONFIG_IRQ_TIME_ACCOUNTING (thanks Wu Fenguang)
- Depend on 64 bits archs to make kern_cpustat reading to be atomic

Thanks.

---
Frederic Weisbecker (8):
  context_tracking: Export context state for generic vtime
  cputime: Librarize per nsecs resolution cputime definitions
  cputime: Move default nsecs_to_cputime() to jiffies based cputime
    file
  cputime: Generic on-demand virtual cputime accounting
  cputime: Allow dynamic switch between tick/virtual based cputime
    accounting
  cputime: Use accessors to read task cputime stats
  kvm: Prepare to add generic guest entry/exit callbacks
  cputime: Safely read cputime of full dynticks CPUs

 arch/alpha/kernel/osf_sys.c                  |    6 +-
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
 arch/s390/kernel/vtime.c                     |    6 +-
 arch/x86/kernel/apm_32.c                     |   11 +-
 drivers/isdn/mISDN/stack.c                   |    7 +-
 fs/binfmt_elf.c                              |    8 +-
 fs/binfmt_elf_fdpic.c                        |    7 +-
 fs/proc/array.c                              |    4 +-
 include/asm-generic/cputime.h                |   66 +-----
 include/asm-generic/cputime_jiffies.h        |   72 ++++++
 include/asm-generic/cputime_nsecs.h          |  104 +++++++++
 include/linux/context_tracking.h             |   28 +++
 include/linux/hardirq.h                      |    4 +-
 include/linux/init_task.h                    |   11 +
 include/linux/kernel_stat.h                  |    2 +-
 include/linux/kvm_host.h                     |   55 ++++-
 include/linux/sched.h                        |   40 ++++
 include/linux/tsacct_kern.h                  |    3 +
 include/linux/vtime.h                        |   59 ++++--
 init/Kconfig                                 |   23 ++-
 kernel/acct.c                                |    6 +-
 kernel/context_tracking.c                    |   41 ++--
 kernel/cpu.c                                 |    4 +-
 kernel/delayacct.c                           |    7 +-
 kernel/exit.c                                |   10 +-
 kernel/fork.c                                |    6 +
 kernel/posix-cpu-timers.c                    |   28 ++-
 kernel/sched/core.c                          |    1 +
 kernel/sched/cputime.c                       |  298 +++++++++++++++++++++++---
 kernel/signal.c                              |   12 +-
 kernel/softirq.c                             |    6 +-
 kernel/time/tick-sched.c                     |    5 +-
 kernel/tsacct.c                              |   44 +++-
 52 files changed, 840 insertions(+), 320 deletions(-)
 create mode 100644 include/asm-generic/cputime_jiffies.h
 create mode 100644 include/asm-generic/cputime_nsecs.h

-- 
1.7.5.4

