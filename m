Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab3GZXmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:42:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46106 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3GZXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:42:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 00/21] nohz patches for 3.12 preview v2
Date: Sat, 27 Jul 2013 01:42:23 +0200
Message-Id: <1374882164-32519-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a respin of the series that optimize full dynticks off-case with
static keys. It seems that some distros are interested in full dynticks so we
need to optimize the off case such that unconcerned users are not impacted
by performance regressions. 

Thanks to Steve for his reviews on the previous version! I hope the
changelogs and comments are better in this version.

---

Changes since last posting:

* Rebase against 3.11-rc2

* Dropped because merged in -tip through urgent queue: 
	nohz: Do not warn about unstable tsc unless user uses nohz_full
	nohz: fix compile warning in tick_nohz_init()

Reported by Steve:

* Fix confusing comments in [03/21]
* Fix confusing changelog [05/21]
* Split [05/21] with new patch to enhance CONFIG_CONTEXT_TRACKING_FORCE
  Kconfig help text, see [06/21]

Bugfixes:

* Fix missing exported symbol, clarify changes by seperating guest APIs
optimization in a seperate patch [09/21]

Further:

* Use static keys on full dynticks APIs [19-21/21]


You can snort from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-3.12-preview-v2

Thanks,
	Frederic
---

Frederic Weisbecker (21):
      sched: Consolidate open coded preemptible() checks
      context_tracing: Fix guest accounting with native vtime
      vtime: Update a few comments
      context_tracking: Fix runtime CPU off-case
      nohz: Only enable context tracking on full dynticks CPUs
      context_tracking: Remove full dynticks' hacky dependency on wide context tracking
      context_tracking: Ground setup for static key use
      context_tracking: Optimize main APIs off case with static key
      context_tracking: Optimize guest APIs off case with static key
      context_tracking: Optimize context switch off case with static keys
      context_tracking: User/kernel broundary cross trace events
      vtime: Remove a few unneeded generic vtime state checks
      vtime: Fix racy cputime delta update
      context_tracking: Split low level state headers
      vtime: Describe overriden functions in dedicated arch headers
      vtime: Optimize full dynticks accounting off case with static keys
      vtime: Always scale generic vtime accounting results
      vtime: Always debug check snapshot source _before_ updating it
      nohz: Rename a few state variables
      nohz: Optimize full dynticks state checks with static keys
      nohz: Optimize full dynticks's sched hooks with static keys


 arch/ia64/include/asm/Kbuild            |    1 +
 arch/powerpc/include/asm/Kbuild         |    1 +
 arch/s390/include/asm/cputime.h         |    3 -
 arch/s390/include/asm/vtime.h           |    7 ++
 arch/s390/kernel/vtime.c                |    1 +
 include/linux/context_tracking.h        |  120 +++++++++++++++--------------
 include/linux/context_tracking_state.h  |   39 +++++++++
 include/linux/tick.h                    |   45 +++++++++--
 include/linux/vtime.h                   |   74 ++++++++++++++++--
 include/trace/events/context_tracking.h |   58 ++++++++++++++
 init/Kconfig                            |   28 +++++--
 kernel/context_tracking.c               |  128 ++++++++++++++++++-------------
 kernel/sched/core.c                     |    4 +-
 kernel/sched/cputime.c                  |   53 ++++---------
 kernel/time/Kconfig                     |    1 -
 kernel/time/tick-sched.c                |   56 ++++++--------
 16 files changed, 410 insertions(+), 209 deletions(-)
