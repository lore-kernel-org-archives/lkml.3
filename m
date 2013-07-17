Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3GQQom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:44:42 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53248 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab3GQQok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:44:40 -0400
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
Subject: [PATCH 00/18] nohz patches for 3.12 preview
Date: Wed, 17 Jul 2013 18:44:13 +0200
Message-Id: <1374079471-3129-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So patch 1 and 2 are fixes that I'll rather queue for 3.11.

The rest is 3.12 material. There is a strong focus on minimizing
the overhead for the full dynticks off case: nohz_full= parameter
not passed and CONFIG_NO_HZ_FULL_ALL=n.

I'm working on that because it seems that distros want to enable
CONFIG_NO_HZ_FULL and of course they quickly hit the resulting
overhead and powersaving issues.

So I tried to optimize the off case with static keys. I hope this
will be sufficient. Otherwise the last resort is to create an
exception and irq slow path. I believe that x86 irq tracepoints
overwrite the IDT for that purpose? At least that was a plan, not
sure if we sticked to it but that's just an idea.
At least static keys don't require further arch backend support,
expect of course the support for static keys themselves, so I hope
that will be enough.

There is one little remaining thing to take care of: let the boot CPU
go idle as well in the off case.

I also hope we'll get Paul's patches that allow the timekeeper to go
idle in 3.12, but that's another story.

---

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-3.12-preview

Frederic Weisbecker (16):
  sched: Consolidate open coded preemptible() checks
  context_tracing: Fix guest accounting with native vtime
  vtime: Update a few comments
  context_tracking: Fix runtime CPU off-case
  nohz: Selectively enable context tracking on full dynticks CPUs
  context_tracking: Ground setup for static key use
  context_tracking: Optimize main APIs off case with static key
  context_tracking: Optimize context switch off case with static keys
  context_tracking: User/kernel broundary cross trace events
  vtime: Remove a few unneeded generic vtime state checks
  vtime: Fix racy cputime delta update
  context_tracking: Split low level state headers
  vtime: Describe overriden functions in dedicated arch headers
  vtime: Optimize full dynticks accounting off case with static keys
  vtime: Always scale generic vtime accounting results
  vtime: Always debug check snapshot source _before_ updating it

Li Zhong (1):
  nohz: fix compile warning in tick_nohz_init()

Steven Rostedt (1):
  nohz: Do not warn about unstable tsc unless user uses nohz_full

 arch/ia64/include/asm/Kbuild            |    1 +
 arch/powerpc/include/asm/Kbuild         |    1 +
 arch/s390/include/asm/cputime.h         |    3 -
 arch/s390/include/asm/vtime.h           |    7 ++
 arch/s390/kernel/vtime.c                |    1 +
 include/linux/context_tracking.h        |  118 ++++++++++++++--------------
 include/linux/context_tracking_state.h  |   39 ++++++++++
 include/linux/vtime.h                   |   74 ++++++++++++++++--
 include/trace/events/context_tracking.h |   58 ++++++++++++++
 init/Kconfig                            |    2 +-
 kernel/context_tracking.c               |  126 ++++++++++++++++++-------------
 kernel/sched/core.c                     |    4 +-
 kernel/sched/cputime.c                  |   53 ++++---------
 kernel/time/Kconfig                     |    1 -
 kernel/time/tick-sched.c                |    7 ++-
 15 files changed, 327 insertions(+), 168 deletions(-)
 create mode 100644 arch/s390/include/asm/vtime.h
 create mode 100644 include/asm-generic/vtime.h
 create mode 100644 include/linux/context_tracking_state.h
 create mode 100644 include/trace/events/context_tracking.h

-- 
1.7.5.4

