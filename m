Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaIXT3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:29:20 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:42582 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaIXT3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:29:17 -0400
MIME-Version: 1.0
Date: Wed, 24 Sep 2014 12:29:17 -0700
Message-ID: <CA+80gGbnSVpbG11PPPLPZzt_jEvZSchDnU-K+yc1tSe1S=HKKA@mail.gmail.com>
Subject: [PATCH 0/2] sched: deferred set priority (dprio)
From: Sergey Oboguev <oboguev.public@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resultant version of the patch based on a previous RFC.

This patch is intended to improve the support for fine-grain parallel
applications that may sometimes need to change the priority of their threads at
a very high rate, hundreds or even thousands of times per scheduling timeslice.

These are typically applications that have to execute short or very short
lock-holding critical or otherwise time-urgent sections of code at a very high
frequency and need to protect these sections with "set priority" system calls,
one "set priority" call to elevate current thread priority before entering the
critical or time-urgent section, followed by another call to downgrade thread
priority at the completion of the section. Due to the high frequency of
entering and leaving critical or time-urgent sections, the cost of these "set
priority" system calls may raise to a noticeable part of an application's
overall expended CPU time. Proposed "deferred set priority" facility allows to
largely eliminate the cost of these system calls.

Instead of executing a system call to elevate its thread priority, an
application simply writes its desired priority level to a designated memory
location in the userspace. When the kernel attempts to preempt the thread, it
first checks the content of this location, and if the application's stated
request to change its priority has been posted in the designated memory area,
the kernel will execute this request and alter the priority of the thread being
preempted before performing a rescheduling, and then make a scheduling decision
based on the new thread priority level thus implementing the priority
protection of the critical or time-urgent section desired by the application.
In a predominant number of cases however, an application will complete the
critical section before the end of the current timeslice and cancel or alter
the request held in the userspace area. Thus a vast majority of an
application's change priority requests will be handled and mutually cancelled
or coalesced within the userspace, at a very low overhead and without incurring
the cost of a system call, while maintaining safe preemption control. The cost
of an actual kernel-level "set priority" operation is incurred only if an
application is actually being preempted while inside the critical section, i.e.
typically at most once per scheduling timeslice instead of hundreds or
thousands "set priority" system calls in the same timeslice.

One of the intended purposes of this facility (but its not sole purpose) is to
render a lightweight mechanism for priority protection of lock-holding critical
sections that would be an adequate match for lightweight locking primitives
such as futex, with both featuring a fast path completing within the userspace.

More detailed description can be found in:
https://raw.githubusercontent.com/oboguev/dprio/master/dprio.txt
and also in the accompanying man page in the subsequent message.

Message 1/2 contains the patch to the kernel tree (3.16.3).
Message 2/2 contains the patch for man pages tree.

User-level library implementing userspace-side boilerplate code:
https://github.com/oboguev/dprio/tree/master/src/userlib

Test set:
https://github.com/oboguev/dprio/tree/master/src/test

Previous RFC discussion:
https://lkml.org/lkml/2014/7/25/600

Brief summary/conclusions of the discussion:
https://lkml.org/lkml/2014/8/13/744

The patch is enabled with CONFIG_DEFERRED_SETPRIO.
There is also a few other config settings: a setting for dprio debug code,
a setting that controls whether the facility is available by default for all
users or limited to tasks with CAP_DPRIO, and a setting to improve the
determinism in the rescheduling latency when dprio request is pending
under low-memory conditions. Please see dprio.txt and man page for details,
as well as the write-up in kernel/Kconfig.dprio.

The changes compared to the RFC version are:
- Replace authorization list with CAP_DPRIO and sysctl kernel.dprio_privileged.
- Move dprio_ku_area_pp inside task_struct so it is likely to share the same
  cache line with other locations accessed during __schedule().

Signed-off-by: Sergey Oboguev <oboguev@yahoo.com>

 Documentation/sysctl/kernel.txt |  14 +
 fs/exec.c                       |   8 +
 include/linux/dprio.h           | 129 +++++++++
 include/linux/init_task.h       |  17 ++
 include/linux/sched.h           |  19 ++
 include/uapi/linux/Kbuild       |   1 +
 include/uapi/linux/capability.h |   5 +-
 include/uapi/linux/dprio_api.h  | 137 +++++++++
 include/uapi/linux/prctl.h      |   2 +
 init/Kconfig                    |   2 +
 kernel/Kconfig.dprio            |  68 +++++
 kernel/exit.c                   |   6 +
 kernel/fork.c                   |  88 +++++-
 kernel/sched/Makefile           |   1 +
 kernel/sched/core.c             | 195 ++++++++++++-
 kernel/sched/dprio.c            | 617 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                    |   6 +
 kernel/sysctl.c                 |  12 +
 18 files changed, 1315 insertions(+), 12 deletions(-)

 man2/dprio.2 | 784 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man2/prctl.2 |   5 +
 2 files changed, 789 insertions(+)
--
