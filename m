Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3LCOif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:38:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42311 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3LCOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:38:32 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Olivier Langlois <olivier@olivierlanglois.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [GIT PULL v2] dynticks updates for 3.14
Date: Tue,  3 Dec 2013 15:38:20 +0100
Message-Id: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/core-v2 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/core-v2

It's a rebase of the previous pull request against 3.13-rc2 which addresses
your reviews:

* Fix build error with tick_check_nohz() off case

* Refine changelog of "posix-timers: Fix full dynticks CPUs kick on timer rescheduling"
  to make it clearer that it's a bug fix and not just an optimization.
  Also add more overall details in the changelog about the description of the issue.

* Rename tick_check_nohz() and tick_check_oneshot_broadcast() to extend with *_this_cpu()
  suffix. Note that I left functions that use *_idle_* based naming as is because idle
  itself is a per cpu notion already. Now I can still extend these functions as well
  in a delta if you want, although IMHO I fear that would uglify the code more than helping.

---
Here is a summary of the overall changes against tip:timers/core :

* Optimizations and cleanups on the use of per CPU APIs to improve code readability,
performance and debuggability in the nohz subsystem;

* Rename some functions to extend with *_this_cpu() suffix for clarity

* Refine the naming of some context tracking subsystem state accessors

* Optimize posix cpu timer by sparing stub workqueue queue with full dynticks off case

* Trivial spelling fix by Paul Gortmaker

* Fix a bug where posix cpu timers requeued due to interval got ignored on full
  dynticks CPUs (not a regression though as it only impacts full dynticks and the
  bug is there since we merged full dynticks).


Let me know if you find any issue.

Thanks,
	Frederic
---

Frederic Weisbecker (5):
      nohz: Convert a few places to use local per cpu accesses
      context_tracking: Wrap static key check into more intuitive function name
      context_tracking: Rename context_tracking_active() to context_tracking_cpu_is_enabled()
      posix-timers: Spare workqueue if there is no full dynticks CPU to kick
      posix-timers: Fix full dynticks CPUs kick on timer rescheduling

Paul Gortmaker (1):
      trivial: fix spelling in CONTEXT_TRACKING_FORCE help text


 include/linux/context_tracking.h       | 10 ++++-----
 include/linux/context_tracking_state.h | 11 +++++++---
 include/linux/tick.h                   |  8 +++----
 include/linux/vtime.h                  |  4 ++--
 init/Kconfig                           |  2 +-
 kernel/context_tracking.c              |  8 +++----
 kernel/posix-cpu-timers.c              | 21 ++++++++----------
 kernel/softirq.c                       |  4 +---
 kernel/time/tick-broadcast.c           |  6 +++---
 kernel/time/tick-internal.h            |  4 ++--
 kernel/time/tick-sched.c               | 39 ++++++++++++++--------------------
 11 files changed, 55 insertions(+), 62 deletions(-)
