Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3LQWvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:51:40 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:55379 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3LQWvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:38 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Alex Shi <alex.shi@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [RFC PATCH 00/13] nohz: Use sysidle detection to let the timekeeper sleep
Date: Tue, 17 Dec 2013 23:51:19 +0100
Message-Id: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series makes the nohz subsystem eventually use the RCU full sysidle
detection.

When we have CPUs running in full dynticks mode in the system, the
CPU 0 handles the timekeeping duty on behalf of all other CPUs. Given
that full dynticks can run anytime, CPU 0 stays periodic and never
enter into dynticks idle mode. This is of course a powersaving issue.

Now making CPU 0 to become more power-friendly sounds like an easy task.
After all we just need to allow it to enter in dynticks idle mode as
soon as all full dynticks CPUs are idle (aka sysidle state, we'll
probably need some more precise name as it only applies to full dynticks
CPUs).

But sysidle state detection is actually difficult to get right. It
must scale with growing number of CPUs, minimize IPIs and atomic
operations on fast paths. Given that this detection already existed into
a bit more generalized form through the existing RCU extended quiescent
state detection, it has been implemented by specializing this code and
adding a state machine on top of it.
(Thanks to Paul for this work, more details: https://lwn.net/Articles/558284/)

This feature which is enabled with CONFIG_NO_HZ_FULL_SYSIDLE=y, is
working but is not yet plugged into the nohz subsystem. Namely we can
detect states where all full dynticks CPUs are sleeping, but we don't
yet take benefit from it by opportunistically stopping the tick of
the timekeeper CPU 0.

So this is what this series brings, more details following:

* Some code, naming and whitespace cleanups

* Allow all CPUs outside the nohz_full range to handle the timekeeping
  duty, not just CPU 0. Balancing the timekeeping duty should improve
  powersavings.

* Let the timekeeper (including CPU 0) sleep when its duty is
  handed over to another CPU

* Allow timekeeper to sleep when all full dynticks CPUs are sleeping
  (plug nohz to RCU sysidle detection)

* Wake up timekeeper with an IPI when full dynticks CPUs exit sysidle
  state

* Wake up CPU 0 when a secondary timekeeper is offlined so that its
  duty gets migrated


For convenience, you can fetch this from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/full_sysidle-rfc

Thanks,
	Frederic
---

Frederic Weisbecker (12):
      tick: Rename tick_check_idle() to tick_irq_enter()
      time: New helper to check CPU eligibility to handle timekeeping
      rcu: Exclude all potential timekeepers from sysidle detection
      tick: Use timekeeping_cpu() to elect the CPU handling timekeeping duty
      rcu: Fix unraised IPI to timekeeping CPU
      nohz: Introduce full dynticks' default timekeeping target
      sched: Enable IPI reception on timekeeper under nohz full system
      nohz: Get timekeeping max deferment outside jiffies_lock
      nohz: Allow timekeeper's tick to stop when all full dynticks CPUs are idle
      nohz: Hand over timekeeping duty on cpu offlining
      nohz: Wake up timekeeper on exit from sysidle state
      nohz: Allow all CPUs outside nohz_full range to do timekeeping

Alex Shi (1):
      nohz_full: fix code style issue of tick_nohz_full_stop_tick


 include/linux/tick.h      |  38 ++++++++++++--
 kernel/rcu/tree_plugin.h  |  12 ++---
 kernel/sched/core.c       |   6 +--
 kernel/softirq.c          |   2 +-
 kernel/time/tick-common.c |   2 +-
 kernel/time/tick-sched.c  | 128 +++++++++++++++++++++++++++++++++++-----------
 6 files changed, 142 insertions(+), 46 deletions(-)
