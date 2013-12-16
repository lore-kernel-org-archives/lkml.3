Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LPMRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:17:17 -0500
Received: from relay.parallels.com ([195.214.232.42]:56249 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3LPMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:17:14 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <dchinner@redhat.com>, <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>, <glommer@openvz.org>,
        <glommer@gmail.com>
Subject: [PATCH v14 00/18] kmemcg shrinkers
Date: Mon, 16 Dec 2013 16:16:49 +0400
Message-ID: <cover.1387193771.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 14th iteration of Glauber Costa's patch-set implementing slab
shrinking on memcg pressure. The main idea is to make the list_lru structure
used by most FS shrinkers per-memcg. When adding or removing an element from a
list_lru, we use the page information to figure out which memcg it belongs to
and relay it to the appropriate list. This allows scanning kmem objects
accounted to different memcgs independently.

Please note that this patch-set implements slab shrinking only when we hit the
user memory limit so that kmem allocations will still fail if we are below the
user memory limit, but close to the kmem limit. I am going to fix this in a
separate patch-set, but currently it is only worthwhile setting the kmem limit
to be greater than the user mem limit just to enable per-memcg slab accounting
and reclaim.

The patch-set is based on top of Linux-3.13-rc4 and organized as follows:
 - patches 1-11 prepare vmscan, memcontrol, list_lru to kmemcg reclaim;
 - patches 12, 13 implement the kmemcg reclaim core;
 - patch 14 makes the list_lru struct per-memcg and patch 15 marks the
   super_block shrinker as memcg-aware;
 - patches 16-18 slightly improve memcontrol behavior regarding mem reclaim.

Changes in v14:
 - do not change list_lru interface, introduce new shrink functions instead;
 - remove NUMA awareness from per-memcg LRUs;
 - improve synchronization between list_lru creation and kmemcg activation;
 - various small fixes/improvements and code cleanup.

Previous iterations of this patch-set can be found here:
 - https://lkml.org/lkml/2013/12/9/103 (v13)
 - https://lkml.org/lkml/2013/12/2/141 (v12)
 - https://lkml.org/lkml/2013/11/25/214 (v11)

Thanks.

Glauber Costa (7):
  memcg: make cache index determination more robust
  memcg: consolidate callers of memcg_cache_id
  memcg: move initialization to memcg creation
  vmscan: take at least one pass with shrinkers
  vmpressure: in-kernel notifications
  memcg: reap dead memcgs upon global memory pressure
  memcg: flush memcg items upon memcg destruction

Vladimir Davydov (11):
  memcg: make for_each_mem_cgroup macros public
  memcg: remove KMEM_ACCOUNTED_ACTIVATED flag
  memcg: rework memcg_update_kmem_limit synchronization
  list_lru, shrinkers: introduce list_lru_shrink_{count,walk}
  fs: consolidate {nr,free}_cached_objects args in shrink_control
  vmscan: move call to shrink_slab() to shrink_zones()
  vmscan: remove shrink_control arg from do_try_to_free_pages()
  vmscan: call NUMA-unaware shrinkers irrespective of nodemask
  vmscan: shrink slab on memcg pressure
  list_lru: add per-memcg lists
  fs: make shrinker memcg aware

 fs/dcache.c                |   14 +-
 fs/gfs2/quota.c            |    6 +-
 fs/inode.c                 |    7 +-
 fs/internal.h              |    7 +-
 fs/super.c                 |   34 ++-
 fs/xfs/xfs_buf.c           |    7 +-
 fs/xfs/xfs_qm.c            |    7 +-
 fs/xfs/xfs_super.c         |    7 +-
 include/linux/fs.h         |    6 +-
 include/linux/list_lru.h   |  112 +++++++--
 include/linux/memcontrol.h |   50 ++++
 include/linux/shrinker.h   |   10 +-
 include/linux/vmpressure.h |    5 +
 mm/list_lru.c              |  257 +++++++++++++++++--
 mm/memcontrol.c            |  584 ++++++++++++++++++++++++++++++++------------
 mm/vmpressure.c            |   53 +++-
 mm/vmscan.c                |  170 ++++++++-----
 17 files changed, 1017 insertions(+), 319 deletions(-)

-- 
1.7.10.4

