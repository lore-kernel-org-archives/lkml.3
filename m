Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3BKSvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:51:32 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40873 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab3BKSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:51:30 -0500
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
        vincent.guittot@linaro.org
Subject: [PATCH 00/14] sched: SCHED_DEADLINE v7
Date: Mon, 11 Feb 2013 10:50:42 -0800
Message-Id: <1360608656-7969-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

several changes, some bugfixes and a major testing effort bring me to
release a new version of the SCHED_DEADLINE patchset (v7). In addition,
given the fact that the project has been around for quite some time with
always a positive feedback from the community and since we have reached
a stable and tested set of functionalities, I think it is time to remove
the RFC tag. However, I consider this as another intermediate release as
I would like even more testing from the community itself and I'm also
working to ship a motivating use case with next releases. I had many
interactions with users, especially from industry, after past releases.
Some of them seem to confirm their interest proposing enhancements and
modifications (e.g., http://bit.ly/XVQWrb); some others are willing to
collaborate directly. This makes me confident that such a use case is
on the way. 

If you missed the whole story[1], this patchset introduces a new deadline
based real-time task scheduling policy --called SCHED_DEADLINE-- with
bandwidth isolation (aka "resource reservation") capabilities. It supports
global/clustered multiprocessor scheduling through dynamic task migrations.

>From the previous releases[1]:

  - rebase on top of 3.8-rc7;
  - comments and fixes coming from the reviews we got have been considered
    and applied;
  - u128 support has been removed and internal math has been restricted
    to microseconds resolution (to avoid overflows);
  - dl.c, cpudl.{c,h} renamed as deadline.c, cpudeadline.{c,h};
  - documentation fixed and extended (how to pin -dl tasks to CPUs via
    cpusets example added).

The development is taking place at:
   https://github.com/jlelli/sched-deadline

Main branches:

 - sched-dl-V7: this patchset on top of tip/master.
 - mainline-dl: tracking tip/master (raw commits);

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
EU-funded project (http://www.actors-project.eu). It is now supported by
the S(o)OS EU-funded project (http://www.soos-project.eu/).
It has also some users, both in academic and applied research. We got
positive feedbacks from Ericsson, Wind River, Porto (ISEP), Trento,
Lund and Malardalen universities.

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,

 - Juri

[1] http://lwn.net/Articles/376502, http://lwn.net/Articles/353797,
    http://lwn.net/Articles/412410, http://lwn.net/Articles/490944,
    http://lwn.net/Articles/498472, http://lwn.net/Articles/521091

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

 Documentation/scheduler/sched-deadline.txt |  195 ++++
 arch/arm/include/asm/unistd.h              |    2 +-
 arch/arm/include/uapi/asm/unistd.h         |    3 +
 arch/arm/kernel/calls.S                    |    3 +
 arch/x86/syscalls/syscall_32.tbl           |    3 +
 arch/x86/syscalls/syscall_64.tbl           |    3 +
 include/linux/init_task.h                  |   10 +
 include/linux/rtmutex.h                    |   18 +-
 include/linux/sched.h                      |  152 ++-
 include/linux/syscalls.h                   |    7 +
 include/uapi/linux/sched.h                 |    1 +
 kernel/fork.c                              |    8 +-
 kernel/futex.c                             |    2 +
 kernel/hrtimer.c                           |    2 +-
 kernel/rtmutex-debug.c                     |    8 +-
 kernel/rtmutex.c                           |  163 ++-
 kernel/rtmutex_common.h                    |   22 +-
 kernel/sched/Makefile                      |    4 +-
 kernel/sched/core.c                        |  657 ++++++++++-
 kernel/sched/cpudeadline.c                 |  208 ++++
 kernel/sched/cpudeadline.h                 |   33 +
 kernel/sched/deadline.c                    | 1658 ++++++++++++++++++++++++++++
 kernel/sched/debug.c                       |   46 +
 kernel/sched/rt.c                          |    2 +-
 kernel/sched/sched.h                       |  146 +++
 kernel/sched/stop_task.c                   |    2 +-
 kernel/sysctl.c                            |    7 +
 kernel/trace/trace_sched_wakeup.c          |   44 +-
 kernel/trace/trace_selftest.c              |   28 +-
 29 files changed, 3317 insertions(+), 120 deletions(-)
 create mode 100644 Documentation/scheduler/sched-deadline.txt
 create mode 100644 kernel/sched/cpudeadline.c
 create mode 100644 kernel/sched/cpudeadline.h
 create mode 100644 kernel/sched/deadline.c

-- 
1.7.9.5

