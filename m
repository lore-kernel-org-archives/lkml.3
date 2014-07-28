Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaG1Jbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:31:53 -0400
Received: from mx2.parallels.com ([199.115.105.18]:37831 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaG1Jbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:31:49 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <david@fromorbit.com>, <viro@zeniv.linux.org.uk>, <gthelen@google.com>,
        <mgorman@suse.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 0/6] Per-memcg slab shrinkers
Date: Mon, 28 Jul 2014 13:31:22 +0400
Message-ID: <cover.1406536261.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ It's been a long time since I sent the last version of this set, so
  I'm restarting the versioning. For those, who are interested in the
  patch set history, see https://lkml.org/lkml/2014/2/5/358 ]

Hi,

This patch set introduces per-memcg slab shrinkers support and
implements per-memcg fs (dcache, icache) shrinkers. It was initially
proposed by Glauber Costa.

The idea lying behind this is to make the list_lru structure per-memcg
and put objects relating to a particular memcg to the corresponding
list. This way, to turn a shrinker using list_lru for organizing
reclaimable objects to memcg aware one it's enough to initialize its
list_lru as memcg aware.

Please, note that even with this set, current kmemcg implementation has
serious flaws, which make it unusable in production:

 - Kmem-only reclaim, which would trigger on hitting memory.kmem.limit,
   is not implemented yet. This makes memory.kmem.limite < memory.limit
   setups unusable. We are not quite sure if we really need a separate
   knob for kmem.limit though (see the discussion at
   https://lkml.org/lkml/2014/7/16/412).

 - Since kmem cache self destruction patch set was withdrawn due to
   performance reasons (https://lkml.org/lkml/2014/7/15/361), per memcg
   kmem caches, which have objects on css offline, are still leaked. I'm
   planning to introduce a shrinker for such caches.

 - Per-memcg arrays of kmem_cache's and list_lru's can only grow and are
   never shrunk. Since the number of offline memcg's hanging around is
   practically unlimited, these arrays may become really huge and result
   in various problems even if nobody uses cgroups right now. I'm
   considering using flex_array's for those caches so that we could
   reclaim their parts on memory pressure.

That's why I still leave CONFIG_MEMCG_KMEM marked as "only for
development/testing".

The patch set is organized as follows:
 - patches 1 and 2 make list_lru and fs-private shrinker interfaces
   neater and suitable for extending towards per-memcg reclaim;
 - patch 3 introduces per-memcg slab shrinker core;
 - patch 4 makes list_lru memcg-aware and patch 5 marks dcache and
   icache shrinkers as memcg aware.
 - patch 6 extends memcg iterator to include offline css's to allow
   kmem reclaim from dead css's.

Thanks,

Vladimir Davydov (6):
  list_lru, shrinkers: introduce list_lru_shrink_{count,walk}
  fs: consolidate {nr,free}_cached_objects args in shrink_control
  vmscan: shrink slab on memcg pressure
  list_lru: add per-memcg lists
  fs: make shrinker memcg aware
  memcg: iterator: do not skip offline css

 fs/dcache.c                |   14 ++-
 fs/gfs2/main.c             |    2 +-
 fs/gfs2/quota.c            |    6 +-
 fs/inode.c                 |    7 +-
 fs/internal.h              |    7 +-
 fs/super.c                 |   45 ++++----
 fs/xfs/xfs_buf.c           |    9 +-
 fs/xfs/xfs_qm.c            |    9 +-
 fs/xfs/xfs_super.c         |    7 +-
 include/linux/fs.h         |    6 +-
 include/linux/list_lru.h   |   82 +++++++++-----
 include/linux/memcontrol.h |   64 +++++++++++
 include/linux/shrinker.h   |   10 +-
 mm/list_lru.c              |  132 +++++++++++++++++++----
 mm/memcontrol.c            |  258 ++++++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c                |   94 ++++++++++++----
 mm/workingset.c            |    9 +-
 17 files changed, 615 insertions(+), 146 deletions(-)

-- 
1.7.10.4

