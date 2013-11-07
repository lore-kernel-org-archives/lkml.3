Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3KGNoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:44:21 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47360 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3KGNoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:44:18 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com
Subject: [PATCH 00/14] sched: SCHED_DEADLINE v9
Date: Thu,  7 Nov 2013 14:43:34 +0100
Message-Id: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

SCHED_DEADLINE patchset v9, less than a month after last version [1]!

Changes w.r.t. v8:

 - rebase on top of 3.12;
 - all comments from Peter Zijlstra and Ingo Molnar applied (thanks!):
    + auxiliary functions for UP/SMP cases
    + add a smp_rmb to match dl_set_overload smp_wmb
    + different clocks for deadlines and runtime need further study
    + amend the comment about yield_task_dl semantic
    + use an accessor to read the rq clock
    + clarify 06/14 changelog (why we want to specify periods != deadlines)

The development is taking place at:
   https://github.com/jlelli/sched-deadline

branch: sched-dl-V9-rebase (this patchset on top of tip/master).

Check the repositories frequently if you're interested, and feel free to
e-mail me for any issue you run into.

Test applications:
  https://github.com/gbagnoli/rt-app 
  https://github.com/jlelli/schedtool-dl

Development mailing list: linux-dl; you can subscribe from here:
http://feanor.sssup.it/mailman/listinfo/linux-dl
or via e-mail (send a message to linux-dl-request@retis.sssup.it with
just the word `help' as subject or in the body to receive info).

The code was being jointly developed by ReTiS Lab (http://retis.sssup.it)
and Evidence S.r.l (http://www.evidence.eu.com) in the context of the ACTORS
EU-funded project (http://www.actors-project.eu) and the S(o)OS EU-funded
project (http://www.soos-project.eu/). Development is now supported by the
JUNIPER EU-funded project [2].

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,

 - Juri

[1] http://lwn.net/Articles/376502, http://lwn.net/Articles/353797,
    http://lwn.net/Articles/412410, http://lwn.net/Articles/490944,
    http://lwn.net/Articles/498472, http://lwn.net/Articles/521091,
    http://lwn.net/Articles/537388, http://lwn.net/Articles/570293

[2] http://www.juniper-project.org/page/overview

Dario Faggioli (9):
  sched: add sched_class->task_dead.
  sched: add extended scheduling interface.
  sched: SCHED_DEADLINE structures & implementation.
  sched: SCHED_DEADLINE avg_update accounting.
  sched: add schedstats for -deadline tasks.
  sched: add latency tracing for -deadline tasks.
  sched: drafted deadline inheritance logic.
  sched: add bandwidth management for sched_dl.
  sched: add sched_dl documentation.

Harald Gustafsson (1):
  sched: add period support for -deadline tasks.

Juri Lelli (3):
  sched: SCHED_DEADLINE SMP-related data structures & logic.
  sched: make dl_bw a sub-quota of rt_bw
  sched: speed up -dl pushes with a push-heap.

Peter Zijlstra (1):
  rtmutex: turn the plist into an rb-tree.

 Documentation/scheduler/sched-deadline.txt |  196 ++++
 arch/arm/include/asm/unistd.h              |    2 +-
 arch/arm/include/uapi/asm/unistd.h         |    3 +
 arch/arm/kernel/calls.S                    |    3 +
 arch/x86/syscalls/syscall_32.tbl           |    3 +
 arch/x86/syscalls/syscall_64.tbl           |    3 +
 include/linux/init_task.h                  |   10 +
 include/linux/rtmutex.h                    |   18 +-
 include/linux/sched.h                      |  122 +-
 include/linux/sched/deadline.h             |   26 +
 include/linux/sched/rt.h                   |    3 +-
 include/linux/sched/sysctl.h               |   11 +
 include/linux/syscalls.h                   |    7 +
 include/uapi/linux/sched.h                 |    1 +
 kernel/fork.c                              |    8 +-
 kernel/futex.c                             |    2 +
 kernel/hrtimer.c                           |    3 +-
 kernel/rtmutex-debug.c                     |    8 +-
 kernel/rtmutex.c                           |  164 ++-
 kernel/rtmutex_common.h                    |   22 +-
 kernel/sched/Makefile                      |    4 +-
 kernel/sched/core.c                        |  674 ++++++++++-
 kernel/sched/cpudeadline.c                 |  216 ++++
 kernel/sched/cpudeadline.h                 |   33 +
 kernel/sched/deadline.c                    | 1666 ++++++++++++++++++++++++++++
 kernel/sched/debug.c                       |   46 +
 kernel/sched/rt.c                          |    2 +-
 kernel/sched/sched.h                       |  150 +++
 kernel/sched/stop_task.c                   |    2 +-
 kernel/sysctl.c                            |    7 +
 kernel/trace/trace_sched_wakeup.c          |   45 +-
 kernel/trace/trace_selftest.c              |   28 +-
 32 files changed, 3363 insertions(+), 125 deletions(-)
 create mode 100644 Documentation/scheduler/sched-deadline.txt
 create mode 100644 include/linux/sched/deadline.h
 create mode 100644 kernel/sched/cpudeadline.c
 create mode 100644 kernel/sched/cpudeadline.h
 create mode 100644 kernel/sched/deadline.c

-- 
1.7.9.5

