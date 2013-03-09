Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3CIAvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:51:10 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52617 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3CIAvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:51:08 -0500
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
        Thomas Gleixner <tglx@linutronix.de>,
        Kevin Hilman <khilman@linaro.org>,
        Mats Liljegren <mats.liljegren@enea.com>
Subject: [ANNOUNCE] 3.9-rc1-nohz1
Date: Sat,  9 Mar 2013 01:50:59 +0100
Message-Id: <1362790259-7837-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Several fixes there. And this version should have much lesser spurious
warnings. Your testing and reviews is very appreciated.

The 5 first patches of the series are pending on a pull request for -tip
(3.10 material).

I'm now considering how I should upstream the rest of the series.
All the pieces that got merged until now were sort of easy because the various
chunks were pretty self contained and independant (full dynticks cputime
accounting, printk, RCU user mode, dynticks API generalization, etc...).

Now what remains in this series is hard to cut into individual parts.
Everything depends on defining an interface with kernel parameter
to partition the full dynticks CPUs set.

I think we really need to start using a branch in -tip and move incrementally
from there with the following steps:

	1) Set the kernel parameters and config option
	2) Handle timers wakeup, timekeeping, posix cpu timers, perf, sched etc...
	   on top of kernel parameter based CPU partition
	3) Once we know _everything_ is handled, bring the final dynticks infrastructure
	4) Upstream

This will make everything much easier for everyone: easier piecewise reviews and easier for
other people to contribute.

Because you don't want me to spam you with ~40 commits for 2 more years, right?

Thanks.

This version can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	3.9-rc1-nohz1

---
Changes since 3.8-rc6-nohz4:

* Rebase against 3.9-rc1

* Fixed a few races with exception and preemption handling [1-3/29]

* Dropped commit "sched: Remove broken check for skip clock update"
that was buggy (thanks Steve for pointing that)

* Ignore noisy stale rq clock detection on boot and other situations
with rq->skip_clock_update [27/29]

* Dropped commit "sched: Update clock of nohz busiest rq before balancing"
that became useless (thanks Li Zhong)

* Don't issue a self IPI on timer enqueue if the CPU didn't stop its
tick [9/29]

* Rename a bit the Kconfig menu after discussion with Borislav [6/29]

* Handle broken full_nohz mask in kernel parameters (thanks Borislav) [6/29]

---
TODO list hasn't changed much:

- Posix CPU timers
- Perf events
- sched_class::task_tick()
- various other scheduler details
- ...

---
Frederic Weisbecker (29):
  context_tracking: Move exception handling to generic code
  context_tracking: Restore correct previous context state on exception
    exit
  context_tracking: Restore preempted context state after
    preempt_schedule_irq()
  cputime: Dynamically scale cputime for full dynticks accounting
  context_tracking: Enable probes by default for selftesting
  nohz: Basic full dynticks interface
  nohz: Assign timekeeping duty to a non-full-nohz CPU
  nohz: Trace timekeeping update
  nohz: Wake up full dynticks CPUs when a timer gets enqueued
  rcu: Restart the tick on non-responding full dynticks CPUs
  sched: Comment on rq->clock correctness in ttwu_do_wakeup() in nohz
  sched: Update rq clock on nohz CPU before migrating tasks
  sched: Update rq clock on nohz CPU before setting fair group shares
  sched: Update rq clock on tickless CPUs before calling
    check_preempt_curr()
  sched: Update rq clock earlier in unthrottle_cfs_rq
  sched: Update rq clock before idle balancing
  sched: Update nohz rq clock before searching busiest group on load
    balancing
  nohz: Move nohz load balancer selection into idle logic
  nohz: Full dynticks mode
  nohz: Only stop the tick on RCU nocb CPUs
  nohz: Don't turn off the tick if rcu needs it
  nohz: Don't stop the tick if posix cpu timers are running
  nohz: Add some tracing
  rcu: Don't keep the tick for RCU while in userspace
  timer: Don't run non-pinned timer to full dynticks CPUs
  sched: Use an accessor to read rq clock
  sched: Debug nohz rq clock
  sched: Update rq clock before rt sched average scale
  sched: Disable lb_bias feature for full dynticks

 arch/x86/include/asm/context_tracking.h |   21 ----
 arch/x86/kernel/kvm.c                   |    8 +-
 arch/x86/kernel/traps.c                 |   68 +++++++++-----
 arch/x86/mm/fault.c                     |    8 +-
 include/linux/context_tracking.h        |   24 +++++-
 include/linux/posix-timers.h            |    1 +
 include/linux/rcupdate.h                |    8 ++
 include/linux/sched.h                   |   14 ++-
 include/linux/tick.h                    |    9 ++
 init/Kconfig                            |    1 +
 kernel/fork.c                           |    2 +-
 kernel/hrtimer.c                        |    3 +-
 kernel/posix-cpu-timers.c               |   11 ++
 kernel/rcutree.c                        |   19 +++-
 kernel/rcutree.h                        |    1 -
 kernel/rcutree_plugin.h                 |   13 +--
 kernel/sched/core.c                     |  110 ++++++++++++++++++++--
 kernel/sched/cputime.c                  |  154 ++++++++++++++++---------------
 kernel/sched/fair.c                     |   79 +++++++++++-----
 kernel/sched/features.h                 |    3 +
 kernel/sched/rt.c                       |    8 +-
 kernel/sched/sched.h                    |   61 ++++++++++++
 kernel/sched/stats.h                    |    8 +-
 kernel/sched/stop_task.c                |    8 +-
 kernel/softirq.c                        |    5 +-
 kernel/time/Kconfig                     |    9 ++
 kernel/time/tick-broadcast.c            |    3 +-
 kernel/time/tick-common.c               |    5 +-
 kernel/time/tick-sched.c                |  134 ++++++++++++++++++++++++---
 kernel/timer.c                          |    5 +-
 30 files changed, 587 insertions(+), 216 deletions(-)

-- 
1.7.5.4

