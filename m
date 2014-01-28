Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaA1XoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:44:08 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49549 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaA1XoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:44:06 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET v2 cgroup/for-3.15] cgroup: drop module support and cgroup_root_mutex
Date: Tue, 28 Jan 2014 18:43:55 -0500
Message-Id: <1390952641-15950-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take.  Changes from the last take[L] are

* Updated to reflect changes in fe1217c4f3f7 ("net: net_cls: move
  cgroupfs classid handling into core").

* Rebased on top of the current linus#master + some cgroup fix
  patches.

There's only one controller which makes use of the module support -
net_prio, which, non-coincidentally, isn't an actual resource
controller.  It's highly unlikely that the actual resource controlling
controllers are gonna be made modular and we aren't gonna add more
non-resource controllers either, so the value of module support is
strictly restricted to the particular controller.

The controller is fairly simple while module support in cgroup core
adds quite a bit of complexity.  Building the one controller as module
only saves less than half-page in vmlinux, which really can't justify
the additional complexity and (minute but existing) runtime overhead.

This patchset makes net_prio config options bool so that it can't be
built as modules and drops module support from cgroup core, which in
turn facilitates further simplification leading to removal of
cgroup_root_mutex by allowing iterating subsystems outside the
mutexes.

This patchset contains the following six patches.

 0001-cgroup-make-CONFIG_CGROUP_NET_PRIO-bool-and-drop-unn.patch
 0002-cgroup-drop-module-support.patch
 0003-cgroup-clean-up-cgroup_subsys-names-and-initializati.patch
 0004-cgroup-rename-cgroup_subsys-subsys_id-to-id.patch
 0005-cgroup-update-locking-in-cgroup_show_options.patch
 0006-cgroup-remove-cgroup_root_mutex.patch

0001-0002 drop cgroup module support.

0003-0004 are cleanups.

0005-0006 remove cgroup_root_mutex.

The patchset is on top of

  linus#master 54c0a4b46150 ("Merge branch 'akpm' (incoming from Andrew)")
+ [1] [PATCHSET cgroup/for-3.14-fixes] cgroup: four misc fixes
+ [2] [PATCH] arm, pm, vmpressure: add missing slab.h includes

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-simplify

diffstat follows.  Thanks.

 block/blk-cgroup.c             |    9
 block/blk-cgroup.h             |    2
 fs/bio.c                       |    2
 include/linux/cgroup.h         |   38 ---
 include/linux/cgroup_subsys.h  |   30 +--
 include/linux/hugetlb_cgroup.h |    2
 include/linux/memcontrol.h     |    2
 include/net/cls_cgroup.h       |    2
 include/net/netprio_cgroup.h   |   17 -
 kernel/cgroup.c                |  394 ++++++-----------------------------------
 kernel/cgroup_freezer.c        |    8
 kernel/cpuset.c                |   10 -
 kernel/events/core.c           |    8
 kernel/sched/core.c            |    6
 kernel/sched/cpuacct.c         |    6
 mm/hugetlb_cgroup.c            |    9
 mm/memcontrol.c                |   22 +-
 net/Kconfig                    |    2
 net/core/netclassid_cgroup.c   |   13 -
 net/core/netprio_cgroup.c      |   37 ---
 net/ipv4/tcp_memcontrol.c      |    2
 security/device_cgroup.c       |    8
 22 files changed, 128 insertions(+), 501 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/g/<1389982317-22225-1-git-send-email-tj@kernel.org>
[1] http://lkml.kernel.org/g/<1390923125-4369-1-git-send-email-tj@kernel.org>
[2] http://lkml.kernel.org/g/<20140128221922.GC16060@mtj.dyndns.org>
