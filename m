Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3BFS3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:29:15 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37731 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3BFS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:29:14 -0500
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
Subject: [ANNOUNCE] 3.8-rc6-nohz4
Date: Wed,  6 Feb 2013 19:28:58 +0100
Message-Id: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The support for printk and cputime accounting to work on full dynticks CPUs have
been merged in -tip tree and is likely deemed for the 3.9 merge window. So this
new release is a rebase against the relevant branches in -tip and v3.8-rc6.

The remaining amount of patches has thus quite schrinked.

You can pull this branch from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	3.8-rc6-nohz4

Remember it doesn't yet support everything the tick does, namely it lacks
full support for:

- Posix CPU timers
- Perf events
- sched_class::task_tick()
- various other scheduler details
- ...

So use it with caution!

Thanks.

PS: next upstream focus will probably be on posix cpu timers. May be we can try to
make it work using timer_list or hrtimers, I don't know yet. I need to experiment.

---
Changes since 3.8-rc4-nohz3 (including those of cputime):

* Rebase against v3.8-rc6 and latest tip:/sched/core and tip:/irq/core

* Fix cputime build error with kvm modules (Thanks Sedat Dilek and
Wu Fenguang)

* Fix cputime mistyped header inclusion in ia64

* Fix more missing symbols for kvm

* Removal of profiling's timer hook also applied in -tip


---
Frederic Weisbecker (26):
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
  sched: Update clock of nohz busiest rq before balancing
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
  sched: Remove broken check for skip clock update
  sched: Update rq clock before rt sched average scale
  sched: Disable lb_bias feature for full dynticks

 include/linux/posix-timers.h |    1 +
 include/linux/rcupdate.h     |    8 +++
 include/linux/sched.h        |   10 +++-
 include/linux/tick.h         |    9 +++
 kernel/hrtimer.c             |    3 +-
 kernel/posix-cpu-timers.c    |   11 ++++
 kernel/rcutree.c             |   19 +++++--
 kernel/rcutree.h             |    1 -
 kernel/rcutree_plugin.h      |   13 +---
 kernel/sched/core.c          |  104 ++++++++++++++++++++++++++++++---
 kernel/sched/fair.c          |   96 ++++++++++++++++++++++--------
 kernel/sched/features.h      |    3 +
 kernel/sched/rt.c            |    8 +-
 kernel/sched/sched.h         |   50 ++++++++++++++++
 kernel/sched/stats.h         |    8 +-
 kernel/sched/stop_task.c     |    8 +-
 kernel/softirq.c             |    5 +-
 kernel/time/Kconfig          |    9 +++
 kernel/time/tick-broadcast.c |    3 +-
 kernel/time/tick-common.c    |    5 +-
 kernel/time/tick-sched.c     |  132 +++++++++++++++++++++++++++++++++++++----
 kernel/timer.c               |    5 +-
 22 files changed, 427 insertions(+), 84 deletions(-)

-- 
1.7.5.4

