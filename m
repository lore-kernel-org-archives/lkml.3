Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaAQSMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:12:10 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34379 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaAQSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:12:03 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.14] cgroup: drop module support and cgroup_root_mutex
Date: Fri, 17 Jan 2014 13:11:51 -0500
Message-Id: <1389982317-22225-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There are only two controllers which make use of the module support -
net_cls and net_prio, both of which, non-coincidentally, aren't actual
resource controllers.  It's highly unlikely that the actual resource
controlling controllers are gonna be made modular and we aren't gonna
add more non-resource controllers either, so the value of module
support is strictly restricted to the two existing controllers.

Both controllers are fairly simple while module support in cgroup core
adds quite a bit of complexity.  Building those two controllers as
module only saves about half-page in vmlinux, which really can't
justify the additional complexity and (minute but existing) runtime
overhead.

This patchset makes net_cls and net_prio config options bool so that
they can't be built as modules and drop module support from cgroup
core, which in turn facilitates further simplification leading to
removal of cgroup_root_mutex by allowing iterating subsystems outside
the mutexes.

This patchset contains the following six patches.

 0001-cgroup-make-CONFIG_NET_CLS_CGROUP-and-CONFIG_NETPRIO.patch
 0002-cgroup-drop-module-support.patch
 0003-cgroup-clean-up-cgroup_subsys-names-and-initializati.patch
 0004-cgroup-rename-cgroup_subsys-subsys_id-to-id.patch
 0005-cgroup-update-locking-in-cgroup_show_options.patch
 0006-cgroup-remove-cgroup_root_mutex.patch

0001-0002 drop cgroup module support.

0003-0004 are cleanups.

0005-0006 remove cgroup_root_mutex.

The patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-simplify

diffstat follows.  Thanks.

 block/blk-cgroup.c             |    9
 block/blk-cgroup.h             |    2
 fs/bio.c                       |    2
 include/linux/cgroup.h         |   38 ---
 include/linux/cgroup_subsys.h  |   30 +--
 include/linux/hugetlb_cgroup.h |    2
 include/linux/memcontrol.h     |    2
 include/net/cls_cgroup.h       |    4
 include/net/netprio_cgroup.h   |    4
 kernel/cgroup.c                |  392 ++++++-----------------------------------
 kernel/cgroup_freezer.c        |    8
 kernel/cpuset.c                |   10 -
 kernel/events/core.c           |    8
 kernel/sched/core.c            |    6
 kernel/sched/cpuacct.c         |    6
 mm/hugetlb_cgroup.c            |    9
 mm/memcontrol.c                |   22 +-
 net/Kconfig                    |    2
 net/core/netprio_cgroup.c      |   37 ---
 net/ipv4/tcp_memcontrol.c      |    2
 net/sched/Kconfig              |    2
 net/sched/cls_cgroup.c         |   30 ---
 security/device_cgroup.c       |    8
 23 files changed, 132 insertions(+), 503 deletions(-)

--
tejun
