Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaJXKiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:38:05 -0400
Received: from mx2.parallels.com ([199.115.105.18]:39962 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaJXKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:38:00 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm v2 0/9] Per memcg slab shrinkers
Date: Fri, 24 Oct 2014 14:37:31 +0400
Message-ID: <cover.1414145862.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kmem accounting of memcg is unusable now, because it lacks slab shrinker
support. That means when we hit the limit we will get ENOMEM w/o any
chance to recover. What we should do then is to call shrink_slab, which
would reclaim old inode/dentry caches from this cgroup. This is what
this patch set is intended to do.

Basically, it does two things. First, it introduces the notion of
per-memcg slab shrinker. A shrinker that wants to reclaim objects per
cgroup should mark itself as SHRINKER_MEMCG_AWARE. Then it will be
passed the memory cgroup to scan from in shrink_control->memcg. For such
shrinkers shrink_slab iterates over the whole cgroup subtree under the
target cgroup and calls the shrinker for each kmem-active memory cgroup.

Secondly, this patch set makes the list_lru structure per-memcg. It's
done transparently to list_lru users - everything they have to do is to
tell list_lru_init that they want memcg-aware list_lru. Then the
list_lru will automatically distribute objects among per-memcg lists
basing on which cgroup the object is accounted to. This way to make FS
shrinkers (icache, dcache) memcg-aware we only need to make them use
memcg-aware list_lru, and this is what this patch set does.

As before, this patch set only enables per-memcg kmem reclaim when the
pressure goes from memory.limit, not from memory.kmem.limit. Handling
memory.kmem.limit is going to be tricky due to GFP_NOFS allocations, it
will probably require a sort of soft limit to work properly. I'm leaving
this for future work.

The main difference in v2 is that I got rid of reparenting of list_lrus.
Thanks to Johannes' and Tejun's efforts mem_cgroup_iter now iterates
over all memory cgroups including dead ones, so dangling offline cgroups
whose css is pinned by kmem allocations is no longer a problem - they
will be eventually reaped by memory pressure. OTOH, this allowed to
simplify the patch set significantly. Nevertheless, if we want
reparenting one day, it won't cause any problems to implement it on top.
Another differences in v2 include:

 - Rebased on top of v3.18-rc1-mmotm-2014-10-23-16-26
 - Simplified handling of the list of all list_lrus
 - Improved comments and function names
 - Fix leak on the list_lru_init error path
 - Fix list_lru_destroy crash on uninitialized zeroed object

v1 can be found at https://lkml.org/lkml/2014/9/21/64

The patch set is organized as follows:

 - Patches 1-3 implement per-memcg shrinker core with patches 1 and 2
   preparing list_lru users for upcoming changes and patch 3 tuning
   shrink_slab.

 - Patches 4 and 5 cleanup handling of max memcg_cache_id in the memcg
   core.

 - Patch 6 gets rid of the useless list_lru->active_nodes, and patch 7
   links all list_lrus to a list, which is required by memcg.

 - Patch 8 adds per-memcg lrus to the list_lru structure, and finally
   patch 9 marks fs shrinkers as memcg aware.

Reviews are more than welcome.

Thanks,

Vladimir Davydov (9):
  list_lru: introduce list_lru_shrink_{count,walk}
  fs: consolidate {nr,free}_cached_objects args in shrink_control
  vmscan: shrink slab on memcg pressure
  memcg: rename some cache id related variables
  memcg: add rwsem to sync against memcg_caches arrays relocation
  list_lru: get rid of ->active_nodes
  list_lru: organize all list_lrus to list
  list_lru: introduce per-memcg lists
  fs: make shrinker memcg aware

 fs/dcache.c                |   14 +-
 fs/gfs2/quota.c            |    6 +-
 fs/inode.c                 |    7 +-
 fs/internal.h              |    7 +-
 fs/super.c                 |   44 +++---
 fs/xfs/xfs_buf.c           |    7 +-
 fs/xfs/xfs_qm.c            |    7 +-
 fs/xfs/xfs_super.c         |    7 +-
 include/linux/fs.h         |    6 +-
 include/linux/list_lru.h   |   72 +++++++--
 include/linux/memcontrol.h |   53 ++++++-
 include/linux/shrinker.h   |   10 +-
 mm/list_lru.c              |  361 ++++++++++++++++++++++++++++++++++++++++----
 mm/memcontrol.c            |  117 +++++++++++---
 mm/slab_common.c           |   14 +-
 mm/vmscan.c                |   87 ++++++++---
 mm/workingset.c            |    6 +-
 17 files changed, 678 insertions(+), 147 deletions(-)

-- 
1.7.10.4

