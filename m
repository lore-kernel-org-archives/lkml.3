Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaK1SYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:10 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:59417 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaK1SYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:08 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 00/30] cputime: Convert task/cpu cputime accounting to nsecs
Date: Fri, 28 Nov 2014 19:23:30 +0100
Message-Id: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thomas suggested to store the cpu and task stats in nanoseconds in order
to avoid back and forth conversion between cputime_t to nsecs.

This patchset does that (plus many fixes and cleanups).

There should be a performance impact for CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
configurations which account cputime from arch's kernel entrypoint. As
this config always use cputime_t as a time source, the conversion to nsecs
is required on each accounting update. This concern only powerpc and s390
(ia64 also support this mode but its cputime_t wraps nsecs so the conversion
is a noop there). I'm not sure how much this config is used in powerpc,
it doesn't appear in its defconfigs and that mode is expected to be a
bit slower than tick based accounting anyway. But s390 only supports
this mode (no support for tick based accounting).

But on the other side of the balance, it simplifies the core code a bit.

The patchset isn't complete, I have yet to convert the posix cpu timers
code as well. I just need to post the current state before moving forward
to details.

I need to get your opinion on that patchset before going deeper. Is this
conversion a right direction to take?

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	cpustat/nsecs

HEAD: 3539960cb3be04512d5f601c8e83c8bab658e0c1

Thanks,
	Frederic
---

Frederic Weisbecker (30):
      jiffies: Remove HZ > USEC_PER_SEC special case
      time: Introduce jiffies64_to_nsecs()
      cputime: Introduce nsecs_to_cputime64()
      s390: Convert open coded idle time seqcount
      s390: Translate cputime magic constants to macros
      s390: Introduce cputime64_to_nsecs()
      cputime: Convert kcpustat to nsecs
      apm32: Fix cputime == jiffies assumption
      alpha: Fix jiffies based cputime assumption
      cputime: Convert guest time accounting to nsecs
      cputime: Special API to return old-typed cputime
      cputime: Convert task/group cputime to nsecs
      alpha: Convert obsolete cputime_t to nsecs
      x86: Convert obsolete cputime type to nsecs
      isdn: Convert obsolete cputime type to nsecs
      binfmt: Convert obsolete cputime type to nsecs
      acct: Convert obsolete cputime type to nsecs
      delaycct: Convert obsolete cputime type to nsecs
      tsacct: Convert obsolete cputime type to nsecs
      signal: Convert obsolete cputime type to nsecs
      cputime: Remove task_cputime_t_scaled
      u64_stats_sync: Introduce preempt-unsafe readers
      cputime: Convert irq_time_accounting to use u64_stats_sync
      cputime: Increment kcpustat directly on irqtime account
      cputime: Remove temporary irqtime states
      cputime: Push time to account_user_time() in nanosecs
      cputime: Push time to account_steal_time() in nanosecs
      cputime: Push time to account_idle_time() in nanosecs
      cputime: Push time to account_guest_time() in nanosecs
      cputime: Push time to account_system_time() in nanosecs


 arch/alpha/kernel/osf_sys.c        |  15 ++-
 arch/ia64/kernel/time.c            |   9 +-
 arch/powerpc/kernel/time.c         |  10 +-
 arch/s390/appldata/appldata_os.c   |  16 +--
 arch/s390/include/asm/cputime.h    |  52 +++++----
 arch/s390/include/asm/idle.h       |   3 +-
 arch/s390/kernel/idle.c            |  30 ++---
 arch/s390/kernel/vtime.c           |  15 ++-
 arch/x86/kernel/apm_32.c           |   6 +-
 drivers/cpufreq/cpufreq.c          |   6 +-
 drivers/cpufreq/cpufreq_governor.c |  14 +--
 drivers/isdn/mISDN/stack.c         |   4 +-
 drivers/macintosh/rack-meter.c     |   2 +-
 fs/binfmt_elf.c                    |  15 +--
 fs/binfmt_elf_fdpic.c              |  14 +--
 fs/compat_binfmt_elf.c             |  20 ++--
 fs/proc/array.c                    |  15 ++-
 fs/proc/stat.c                     |  68 +++++------
 fs/proc/uptime.c                   |   6 +-
 include/linux/cputime.h            |  22 ++++
 include/linux/init_task.h          |   2 +-
 include/linux/jiffies.h            |   2 +
 include/linux/kernel_stat.h        |  10 +-
 include/linux/sched.h              |  83 ++++++++++----
 include/linux/u64_stats_sync.h     |  29 +++--
 kernel/acct.c                      |   7 +-
 kernel/delayacct.c                 |   6 +-
 kernel/exit.c                      |   4 +-
 kernel/sched/cputime.c             | 224 ++++++++++++++++++-------------------
 kernel/sched/sched.h               |  44 ++------
 kernel/sched/stats.h               |   8 +-
 kernel/signal.c                    |  12 +-
 kernel/sys.c                       |  16 +--
 kernel/time/itimer.c               |   2 +-
 kernel/time/posix-cpu-timers.c     |  44 ++++----
 kernel/time/time.c                 |  21 +++-
 kernel/time/timeconst.bc           |   6 +
 kernel/tsacct.c                    |  18 +--
 38 files changed, 475 insertions(+), 405 deletions(-)
