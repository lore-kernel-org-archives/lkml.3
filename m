Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaHDOPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:15:17 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:53128 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaHDOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:15:15 -0400
Date: Mon, 4 Aug 2014 10:15:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: [GIT PULL] cgroup changes for v3.17-rc1
Message-ID: <20140804141511.GC26230@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Mostly changes to get the v2 interface ready.  The core features are
mostly ready now and I think it's reasonable to expect to drop the
devel mask in one or two devel cycles at least for a subset of
controllers.

* cgroup added a controller dependency mechanism so that block cgroup
  can depend on memory cgroup.  This will be used to finally support
  IO provisioning on the writeback traffic, which is currently being
  implemented.

* The v2 interface now uses a separate table so that the interface
  files for the new interface are explicitly declared in one place.
  Each controller will explicitly review and add the files for the new
  interface.

* cpuset is getting ready for the hierarchical behavior which is in
  the similar style with other controllers so that an ancestor's
  configuration change doesn't change the descendants' configurations
  irreversibly and processes aren't silently migrated when a CPU or
  node goes down.

All the changes are to the new interface and no behavior changed for
the multiple hierarchies.

Thanks.

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17

for you to fetch changes up to a13812683f1118ee4deed88d8d9bc2c268358b2e:

  cpuset: fix the WARN_ON() in update_nodemasks_hier() (2014-07-30 11:26:58 -0400)

----------------------------------------------------------------
Li Zefan (13):
      cpuset: add cs->effective_cpus and cs->effective_mems
      cpuset: update cpuset->effective_{cpus,mems} at hotplug
      cpuset: update cs->effective_{cpus, mems} when config changes
      cpuset: inherit ancestor's masks if effective_{cpus, mems} becomes empty
      cpuset: use effective cpumask to build sched domains
      cpuset: initialize top_cpuset's configured masks at mount
      cpuset: apply cs->effective_{cpus,mems}
      cpuset: make cs->{cpus, mems}_allowed as user-configured masks
      cpuset: refactor cpuset_hotplug_update_tasks()
      cpuset: enable onlined cpu/node in effective masks
      cpuset: allow writing offlined masks to cpuset.cpus/mems
      cpuset: export effective masks to userspace
      cpuset: fix the WARN_ON() in update_nodemasks_hier()

Tejun Heo (16):
      cgroup: reorganize cgroup_subtree_control_write()
      cgroup: introduce cgroup->subtree_control
      cgroup: make interface files visible iff enabled on cgroup->subtree_control
      cgroup: implement cgroup_subsys->css_reset()
      cgroup: implement cgroup_subsys->depends_on
      blkcg, memcg: make blkcg depend on memcg on the default hierarchy
      cgroup: remove CGRP_ROOT_OPTION_MASK
      cgroup: make interface file "cgroup.sane_behavior" legacy-only
      cgroup: remove sane_behavior support on non-default hierarchies
      cgroup: clean up sane_behavior handling
      cgroup: split cgroup_base_files[] into cgroup_{dfl|legacy}_base_files[]
      cgroup: rename cgroup_subsys->base_cftypes to ->legacy_cftypes
      cgroup: replace cgroup_add_cftypes() with cgroup_add_legacy_cftypes()
      cgroup: distinguish the default and legacy hierarchies when handling cftypes
      cgroup: make CFTYPE_ONLY_ON_DFL and CFTYPE_NO_ internal to cgroup core
      cgroup: initialize cgrp_dfl_root_inhibit_ss_mask from !->dfl_files test

 Documentation/cgroups/cgroups.txt           |  14 +
 Documentation/cgroups/unified-hierarchy.txt |  35 +-
 block/blk-cgroup.c                          |  13 +-
 block/blk-throttle.c                        |   6 +-
 include/linux/cgroup.h                      | 165 ++++-----
 kernel/cgroup.c                             | 453 +++++++++++++++++--------
 kernel/cgroup_freezer.c                     |   2 +-
 kernel/cpuset.c                             | 500 +++++++++++++++++-----------
 kernel/sched/core.c                         |   2 +-
 kernel/sched/cpuacct.c                      |   2 +-
 mm/hugetlb_cgroup.c                         |   5 +-
 mm/memcontrol.c                             |  37 +-
 net/core/netclassid_cgroup.c                |   2 +-
 net/core/netprio_cgroup.c                   |   2 +-
 net/ipv4/tcp_memcontrol.c                   |   2 +-
 security/device_cgroup.c                    |   2 +-
 16 files changed, 806 insertions(+), 436 deletions(-)

-- 
tejun
