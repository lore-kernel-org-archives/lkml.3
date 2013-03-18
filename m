Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3CRPYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:24:02 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62826 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3CRPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:23:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 0/7] Create sched_select_cpu() and use it for workqueues
Date: Mon, 18 Mar 2013 20:53:22 +0530
Message-Id: <cover.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to save power, it would be useful to schedule light weight work on cpus
that aren't IDLE instead of waking up an IDLE one.

By idle cpu (from scheduler's perspective) we mean:
- Current task is idle task
- nr_running == 0
- wake_list is empty

This is already implemented for timers as get_nohz_timer_target(). We can figure
out few more users of this feature, like workqueues.

This patchset converts get_nohz_timer_target() into a generic API
sched_select_cpu() so that other frameworks (like workqueue) can also use it.

This routine returns the cpu which is non-idle. It accepts a bitwise OR of SD_*
flags present in linux/sched.h. If the local CPU isn't idle OR all cpus are
idle, local cpu is returned back. If local cpu is idle, then we must look for
another CPU which have all the flags passed as argument as set and isn't idle.

This patchset in first two patches creates generic API sched_select_cpu(). In
the third patch we create a new set of APIs for workqueues to queue work on any
cpu. All other patches migrate some of the users of workqueues which showed up
significantly on my setup. Others can be migrated later.

Earlier discussions over v1 and v2 can be found here:
http://www.mail-archive.com/linaro-dev@lists.linaro.org/msg13342.html
http://lists.linaro.org/pipermail/linaro-dev/2012-November/014344.html

Earlier discussions over this concept were done at last LPC:
http://summit.linuxplumbersconf.org/lpc-2012/meeting/90/lpc2012-sched-timer-workqueue/

Setup:
-----
- ARM Vexpress TC2 - big.LITTLE CPU
- Core 0-1: A15, 2-4: A7
- rootfs: linaro-ubuntu-devel

This patchset has been tested on a big LITTLE system (heterogeneous) but is
useful for all other homogeneous systems as well. During these tests audio was
played in background using aplay.

Results:
-------

Cluster A15 Energy      Cluster A7 Energy       Total
------------------      -----------------       -----

Without this patchset (Energy in Joules):
---------------------

0.151162                2.183545                2.334707
0.223730                2.687067                2.910797
0.289687                2.732702                3.022389
0.454198                2.745908                3.200106
0.495552                2.746465                3.242017

Average:
0.322866                2.619137                2.942003
	                

With this patchset (Energy in Joules):
---------------------

0.133361                2.267822                2.401183
0.260626                2.833389                3.094015
0.142365                2.277929                2.420294
0.246793                2.582550                2.829343
0.130462                2.257033                2.387495

Average:
0.182721                2.443745                2.626466


Above tests are repeated multiple times and events are tracked using trace-cmd
and analysed using kernelshark. And it was easily noticeable that idle time for
many cpus has increased considerably, which eventually saved some power.

These patches are applied here for others to test:
http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/sched-wq-migration-v3

Viresh Kumar (7):
  sched: Create sched_select_cpu() to give preferred CPU for power
    saving
  timer: hrtimer: Don't check idle_cpu() before calling
    get_nohz_timer_target()
  workqueue: Add helpers to schedule work on any cpu
  PHYLIB: queue work on any cpu
  mmc: queue work on any cpu
  block: queue work on any cpu
  fbcon: queue work on any cpu

 block/blk-core.c              |   6 +-
 block/blk-ioc.c               |   2 +-
 block/genhd.c                 |   9 ++-
 drivers/mmc/core/core.c       |   2 +-
 drivers/net/phy/phy.c         |   9 +--
 drivers/video/console/fbcon.c |   2 +-
 include/linux/sched.h         |  21 +++++-
 include/linux/workqueue.h     |   5 ++
 kernel/hrtimer.c              |   2 +-
 kernel/sched/core.c           |  63 +++++++++-------
 kernel/timer.c                |   2 +-
 kernel/workqueue.c            | 163 +++++++++++++++++++++++++++++-------------
 12 files changed, 192 insertions(+), 94 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

