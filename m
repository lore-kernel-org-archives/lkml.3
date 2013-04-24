Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab3DXLqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:46:23 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43133 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3DXLqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:46:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 0/5] Queue work on power efficient wq
Date: Wed, 24 Apr 2013 17:12:52 +0530
Message-Id: <cover.1366803121.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset was called: "Create sched_select_cpu() and use it for workqueues"
for the first three versions.

Earlier discussions over v3, v2 and v1 can be found here:
https://lkml.org/lkml/2013/3/18/364
http://lists.linaro.org/pipermail/linaro-dev/2012-November/014344.html
http://www.mail-archive.com/linaro-dev@lists.linaro.org/msg13342.html

V4 is here:
https://lkml.org/lkml/2013/3/31/55

Workqueues can be performance or power oriented. For performance we may want to
keep them running on a single cpu, so that it remains cache hot. For power we
can give scheduler the liberty to choose target cpu for running work handler.

Later one (Power oriented WQ) can be achieved if the workqueue is allocated with
WQ_UNBOUND flag. Enabling CONFIG_WQ_POWER_EFFICIENT will set
'wq_power_efficient' to 'true'. Setting 'power_efficient' boot param will
override value of 'wq_power_efficient' variable. When 'wq_power_efficient' is
set to 'true', we will convert WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq
allocation. And so scheduler will have the liberty to choose where to run this
work.

Here we are migrating few users of workqueues to WQ_POWER_EFFICIENT. These
drivers are found to be very much active on idle or lightly busy system and
using WQ_POWER_EFFICIENT for these gave impressive results.

These would be used in power saving mode only if relevant configs are enabled
at compile time or in bootargs. Otherwise behavior is unchanged.

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
-------------------------      -----------------------       ------

Without this patchset (Energy in Joules):
---------------------------------------------------

0.151162                2.183545                2.334707
0.223730                2.687067                2.910797
0.289687                2.732702                3.022389
0.454198                2.745908                3.200106
0.495552                2.746465                3.242017

Average:
0.322866                2.619137                2.942003


With this patchset (Energy in Joules):
-----------------------------------------------

0.226421                2.283658                2.510079
0.151361                2.236656                2.388017
0.197726                2.249849                2.447575
0.221915                2.229446                2.451361
0.347098                2.257707                2.604805

Average:
0.2289042              2.2514632              2.4803674

Above tests are repeated multiple times and events are tracked using trace-cmd
and analysed using kernelshark. And it was easily noticeable that idle time for
many cpus has increased considerably, which eventually saved some power.

V4->V5:
-------
- Created new wq flag: WQ_POWER_EFFICIENT, config option:
  CONFIG_WQ_POWER_EFFICIENT and kernel param workqueue.power_efficient.
- Created few system wide workqueues aligned towards power saving.

V3->V4:
-------
- Dropped changes to kernel/sched directory and hence
  sched_select_non_idle_cpu().
- Dropped queue_work_on_any_cpu()
- Created system_freezable_unbound_wq
- Changed all patches accordingly.

V2->V3:
-------
- Dropped changes into core queue_work() API, rather create *_on_any_cpu()
  APIs
- Dropped running timers migration patch as that was broken
- Migrated few users of workqueues to use *_on_any_cpu() APIs.

Viresh Kumar (5):
  workqueues: Introduce new flag WQ_POWER_EFFICIENT for power oriented
    workqueues
  workqueue: Add system wide power_efficient workqueues
  PHYLIB: queue work on system_power_efficient_wq
  block: queue work on power efficient wq
  fbcon: queue work on power efficient wq

 Documentation/kernel-parameters.txt | 17 +++++++++++++++++
 block/blk-core.c                    |  3 ++-
 block/blk-ioc.c                     |  3 ++-
 block/genhd.c                       | 12 ++++++++----
 drivers/net/phy/phy.c               |  9 +++++----
 drivers/video/console/fbcon.c       |  2 +-
 include/linux/workqueue.h           | 10 ++++++++++
 kernel/power/Kconfig                | 19 +++++++++++++++++++
 kernel/workqueue.c                  | 24 +++++++++++++++++++++++-
 9 files changed, 87 insertions(+), 12 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

