Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3CaOcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 10:32:09 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:48182 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab3CaOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 10:32:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tj@kernel.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 0/4] Queue work on UNBOUND wq
Date: Sun, 31 Mar 2013 20:01:43 +0530
Message-Id: <cover.1364740180.git.viresh.kumar@linaro.org>
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

For power saving it is better to schedule work on cpus that aren't idle, as
bringing a cpu/cluster from idle state can be very costly (both performance and
power wise). Earlier we tried to use timer infrastructure to take this decision
but we found out later that scheduler gives even better results and so we should
use scheduler for choosing cpu for scheduling work.

In workqueue subsystem workqueues with flag WQ_UNBOUND are the ones which uses
cpu to select target cpu.

Here we are migrating few users of workqueues to WQ_UNBOUND. These drivers are
found to be very much active on idle or lightly busy system and using WQ_UNBOUND
for these gave impressive results.

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

PS: All the earlier Acks we got for drivers are reverted here as patches have
been updated significantly.

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

Viresh Kumar (4):
  workqueue: Add system wide system_freezable_unbound_wq
  PHYLIB: queue work on unbound wq
  block: queue work on unbound wq
  fbcon: queue work on unbound wq

 block/blk-core.c              |  3 ++-
 block/blk-ioc.c               |  2 +-
 block/genhd.c                 | 10 ++++++----
 drivers/net/phy/phy.c         |  9 +++++----
 drivers/video/console/fbcon.c |  2 +-
 include/linux/workqueue.h     |  4 ++++
 kernel/workqueue.c            |  7 ++++++-
 7 files changed, 25 insertions(+), 12 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

