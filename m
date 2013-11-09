Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab3KIWik (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 17:38:40 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51282 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3KIWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 17:38:36 -0500
Date: Sun, 10 Nov 2013 07:38:31 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup changes for v3.13-rc1
Message-ID: <20131109223831.GC24275@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

Not too much activity this time around.  css_id is finally killed and
a minor update to device_cgroup; however, the pull request does lead
to a conflict in mm/memcontrol.c between the following two commits.

  b862783594847 ("memcg: stop using css id")
  bb4cc1a8b5eaf ("revert "memcg: get rid of soft-limit tree infrastructure"")

The former removes free_css_id() call from __mem_cgroup_free() and the
latter restores mem_cgroup_remove_from_trees() right above it leading
to context conflict.  The conflict looks like

  static void __mem_cgroup_free(struct mem_cgroup *memcg)
  {
	  int node;
	  size_t size = memcg_size();

  <<<<<<< HEAD
	  mem_cgroup_remove_from_trees(memcg);
	  free_css_id(&mem_cgroup_subsys, &memcg->css);

  =======
  >>>>>>> 73ba353471e0b692f398f3d63018b7f46ccf1d3e
	  for_each_node(node)
		  free_mem_cgroup_per_zone_info(memcg, node);

	  free_percpu(memcg->stat);

and can be resolved like the following.

  static void __mem_cgroup_free(struct mem_cgroup *memcg)
  {
	  int node;
	  size_t size = memcg_size();

	  mem_cgroup_remove_from_trees(memcg);

	  for_each_node(node)
		  free_mem_cgroup_per_zone_info(memcg, node);

	  free_percpu(memcg->stat);

The changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.13

for you to fetch changes up to 73ba353471e0b692f398f3d63018b7f46ccf1d3e:

  device_cgroup: remove can_attach (2013-10-24 06:56:56 -0400)

Just in case, the test merge is available in the following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-3.13

Thanks.

----------------------------------------------------------------
Li Zefan (5):
      memcg: convert to use cgroup_is_descendant()
      memcg: convert to use cgroup id
      memcg: fail to create cgroup if the cgroup id is too big
      memcg: stop using css id
      cgroup: kill css_id

Serge Hallyn (1):
      device_cgroup: remove can_attach

 include/linux/cgroup.h   |  37 -------
 kernel/cgroup.c          | 248 +----------------------------------------------
 mm/memcontrol.c          |  67 +++++++------
 security/device_cgroup.c |  11 ---
 4 files changed, 41 insertions(+), 322 deletions(-)

-- 
tejun
