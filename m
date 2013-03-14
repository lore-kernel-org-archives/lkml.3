Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3CNXBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:01:39 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33846 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3CNXBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:37 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com
Subject: [PATCHSET wq/for-3.10] workqueue: simplify per-cpu worker rebinding and implement unbound worker CPU affinity restoration
Date: Thu, 14 Mar 2013 16:01:25 -0700
Message-Id: <1363302090-16117-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

per-cpu worker rebinding on CPU_ONLINE has always been complex.  A lot
of the complexity comes from the fact that CPU_ONLINE should ask each
worker, which may be in any state, to rebind itself.  With recent
patch to replace PF_THREAD_BOUND with PF_NO_SETAFFINITY (the patch is
pending and included here for review), CPU_ONLINE can directly invoke
set_cpus_allowed_ptr() on the workers.

This patchset simplifies rebinding of per-cpu workers by making
CPU_ONLINE directly call set_cpus_allowed_ptr() on the workers and
implements CPU affinity restoration of unbound workers.  The latter is
necessary because unbound pools can now have custom cpumask and if all
CPUs in the allowed cpumask go down and then later come up, workers
may lose affinity.  This patchset makes workqueue CPU_ONLINE callback
restore CPU affinity when the first allowed CPU comes up for a pool.

This patchset contains the following five patches.

 0001-sched-replace-PF_THREAD_BOUND-with-PF_NO_SETAFFINITY.patch
 0002-workqueue-convert-worker_pool-worker_ida-to-idr-and-.patch
 0003-workqueue-relocate-rebind_workers.patch
 0004-workqueue-directly-restore-CPU-affinity-of-workers-f.patch
 0005-workqueue-restore-CPU-affinity-of-unbound-workers-on.patch

0001 doesn't belong in this series.  It was posted separately[1] and
should be routed through tip.

  wq/for-3.10 e626761691 ("workqueue: implement current_is_workqueue_rescuer()")
+ "workqueue: misc cleanups" patchset [2]
+ "workqueue: workqueue: break up workqueue_lock into multiple locks [3]

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-restore-affinity

diffstat follows.

 include/linux/sched.h       |    2
 kernel/cgroup.c             |    4
 kernel/cpuset.c             |   16 +-
 kernel/kthread.c            |    2
 kernel/sched/core.c         |    9 -
 kernel/workqueue.c          |  351 ++++++++++++++++++++++----------------------
 kernel/workqueue_internal.h |    3
 7 files changed, 198 insertions(+), 189 deletions(-)

Thanks.

--
tejun

[1] http://article.gmane.org/gmane.linux.kernel/1457229
[2] http://thread.gmane.org/gmane.linux.kernel/1456511
[3] http://thread.gmane.org/gmane.linux.kernel/1456555
