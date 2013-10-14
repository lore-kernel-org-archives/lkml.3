Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3JNKoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:44:12 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35920 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:44:10 -0400
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
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: [PATCH 00/14] sched: SCHED_DEADLINE v8
Date: Mon, 14 Oct 2013 12:43:32 +0200
Message-Id: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

here we go with a new version of the SCHED_DEADLINE patchset (v8). I know that
it has been a while since I released last version [1], but I thought not to
spam the mailing list with simple updates. Well... this IS basically an update
to 3.12-rc5, but it comes right before the next Kernel Summit and Real Time
Linux Workshop and, since I'll be present at both events, it is probably time
to fire-up the discussion again.

Moreover, interesting news:

 - a better mechanism for coordinating mutually exclusive access to critical
   sections is coming soon (we wrote a paper about it for RTLWS15 [2]);
 - the patchset is now available in the 3.4 and 3.10 Yocto kernels [3] (thanks
   a lot for this to Bruce Ashfield and Insop Song); even though it is hard to
   say how many new users we got with this, we can say that having
   SCHED_DEADLINE in Yocto provides availabily to OSVs like Wind River and
   others;
 - a european project has started (JUNIPER [4]) for which we will provide
   kernel level support based on this patchset (and we will soon have a real
   use case for it! yayyy! :)).

The development is taking place at:
   https://github.com/jlelli/sched-deadline

branch: sched-dl-V8 (this patchset on top of tip/master).

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
JUNIPER EU-funded project [4].

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,

 - Juri

[1] http://lwn.net/Articles/376502, http://lwn.net/Articles/353797,
    http://lwn.net/Articles/412410, http://lwn.net/Articles/490944,
    http://lwn.net/Articles/498472, http://lwn.net/Articles/521091,
    http://lwn.net/Articles/537388

[2] https://www.osadl.org/?id=1743

[3] https://www.yoctoproject.org/

[4] http://www.juniper-project.org/page/overview

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
 include/linux/sched/deadline.h             |   24 +
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
 kernel/sched/core.c                        |  660 ++++++++++-
 kernel/sched/cpudeadline.c                 |  216 ++++
 kernel/sched/cpudeadline.h                 |   33 +
 kernel/sched/deadline.c                    | 1658 ++++++++++++++++++++++++++++
 kernel/sched/debug.c                       |   46 +
 kernel/sched/rt.c                          |    2 +-
 kernel/sched/sched.h                       |  150 +++
 kernel/sched/stop_task.c                   |    2 +-
 kernel/sysctl.c                            |    7 +
 kernel/trace/trace_sched_wakeup.c          |   45 +-
 kernel/trace/trace_selftest.c              |   28 +-
 32 files changed, 3343 insertions(+), 121 deletions(-)
 create mode 100644 Documentation/scheduler/sched-deadline.txt
 create mode 100644 include/linux/sched/deadline.h
 create mode 100644 kernel/sched/cpudeadline.c
 create mode 100644 kernel/sched/cpudeadline.h
 create mode 100644 kernel/sched/deadline.c

-- 
1.7.9.5

