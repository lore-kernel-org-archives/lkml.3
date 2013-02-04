Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3BDX2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:28:30 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53469 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3BDX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:28:28 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Christoph Lameter <cl@linux.com>
Subject: [GIT PULL] cputime: Full dynticks task/cputime accounting v8
Date: Tue,  5 Feb 2013 00:28:20 +0100
Message-Id: <1360020500-32496-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the new full dynticks cputime accounting code that
can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
        tags/full-dynticks-cputime-for-mingo

It's exactly the same tag/HEAD as in my v7. I'm just making a new pull
request in order to restart a fresh thread like you suggested. The old
one was filled with a discussion with Steve about what we thought was a bug.
We concluded it was actually an unavoidable tiny error margin due to how we
consider the boundary between kernel and user space (tick uses user_mode(regs)
whereas generic vtime uses context tracking callbacks). The artificial
testcase we were using was making this margin visible. No big difference
should be found with real workloads though. So Steve gave his Ack on the pull
request.

Then Christoph reported a build error but it doesn't belong to this tree:
it's about an old version of my full dynticks tree.

So in the end I see no opposition for this tree to be pulled. If anybody
has any concern, please raise your hand here.

Thanks.

---
This implements the cputime accounting on full dynticks CPUs.

Typical cputime stats infrastructure relies on the timer tick and
its periodic polling on the CPU to account the amount of time
spent by the CPUs and the tasks per high level domains such as
userspace, kernelspace, guest, ...

Now we are preparing to implement full  dynticks capability on
Linux for Real Time and HPC users who want full CPU isolation.
This feature requires a cputime accounting that doesn't depend
on the timer tick.

To implement it, this new cputime infrastructure plugs into
kernel/user/guest boundaries to take snapshots of cputime and
flush these to the stats when needed. This performs pretty
much like CONFIG_VIRT_CPU_ACCOUNTING except that context location
and cputime snaphots are synchronized between write and read
side such that the latter can safely retrieve the pending tickless
cputime of a task and add it to its latest cputime snapshot to
return the correct result to the user.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
 arch/ia64/kernel/time.c                      |    5 +-
 arch/powerpc/configs/chroma_defconfig        |    2 +-
 arch/powerpc/configs/corenet64_smp_defconfig |    2 +-
 arch/powerpc/configs/pasemi_defconfig        |    2 +-
 arch/powerpc/include/asm/cputime.h           |    6 +-
 arch/powerpc/include/asm/lppaca.h            |    2 +-
 arch/powerpc/include/asm/ppc_asm.h           |    4 +-
 arch/powerpc/kernel/entry_64.S               |    4 +-
 arch/powerpc/kernel/time.c                   |    5 +-
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
 kernel/context_tracking.c                    |   43 +++--
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
 52 files changed, 842 insertions(+), 322 deletions(-)
 create mode 100644 include/asm-generic/cputime_jiffies.h
 create mode 100644 include/asm-generic/cputime_nsecs.h

-- 
1.7.5.4

