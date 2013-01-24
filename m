Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3AXPTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:19:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30529 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab3AXPRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:17:37 -0500
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        ccross@google.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>
Subject: [PATCH v6 00/12] per-cgroup cpu-stat
Date: Thu, 24 Jan 2013 19:17:30 +0400
Message-Id: <1359040662-8055-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>

Hi all,

This is an attempt to provide userspace with enough information to reconstruct
per-container version of files like "/proc/stat". In particular, we are
interested in knowing the per-cgroup slices of user time, system time, wait
time, number of processes, and a variety of statistics.

This task is made more complicated by the fact that multiple controllers are
involved in collecting those statistics: cpu and cpuacct. So the first thing I
am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.

This is one of the major differences from earlier attempts: all data is provided
by the cpu controller, resulting in greater simplicity. Please note, however,
that this patchset only goes as far as deprecating it: the cpuacct can still be
mounted separately from the cpu cgroup if the user so whishes.

This also tries to hook into the existing scheduler hierarchy walks instead of
providing new ones.


Glauber Costa (8):
  don't call cpuacct_charge in stop_task.c
  sched: adjust exec_clock to use it as cpu usage metric
  cpuacct: don't actually do anything.
  sched: document the cpu cgroup.
  sched: account guest time per-cgroup as well.
  sched: record per-cgroup number of context switches
  sched: change nr_context_switches calculation.
  sched: introduce cgroup file stat_percpu

Peter Zijlstra (1):
  sched: Push put_prev_task() into pick_next_task()

Tejun Heo (3):
  cgroup: implement CFTYPE_NO_PREFIX
  cgroup, sched: let cpu serve the same files as cpuacct
  cgroup, sched: deprecate cpuacct

 Documentation/cgroups/cpu.txt | 100 +++++++++++
 include/linux/cgroup.h        |   1 +
 include/linux/sched.h         |   8 +-
 init/Kconfig                  |  11 +-
 kernel/cgroup.c               |  57 ++++++-
 kernel/sched/core.c           | 387 ++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/cputime.c        |  29 +++-
 kernel/sched/fair.c           |  39 ++++-
 kernel/sched/idle_task.c      |   9 +-
 kernel/sched/rt.c             |  42 +++--
 kernel/sched/sched.h          |  28 ++-
 kernel/sched/stop_task.c      |   8 +-
 12 files changed, 672 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/cgroups/cpu.txt

-- 
1.8.1

