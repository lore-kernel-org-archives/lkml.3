Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbbASLYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:24:09 -0500
Received: from mx2.parallels.com ([199.115.105.18]:35970 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbASLXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:23:39 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "Tejun Heo" <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm v2 0/7] memcg: release kmemcg_id on css offline
Date: Mon, 19 Jan 2015 14:23:18 +0300
Message-ID: <cover.1421664712.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's one thing about kmemcg implementation that's bothering me. It's
about arrays holding per-memcg data (e.g. kmem_cache->memcg_params->
memcg_caches). On kmalloc or list_lru_{add,del} we want to quickly
lookup the copy of kmem_cache or list_lru corresponding to the current
cgroup. Currently, we hold all per-memcg caches/lists in an array
indexed by mem_cgroup->kmemcg_id. This allows us to lookup quickly, and
that's nice, but the arrays can grow indefinitely, because we reserve
slots for all cgroups, including offlined, and this is disastrous and
must be fixed.

There are several ways to fix this issue [1], but it seems the best we
can do is to free kmemcg_id on css offline (solution #2). The idea is
that we actually only need kmemcg_id on kmem cache allocations, in order
to lookup the kmem cache copy corresponding to the allocating memory
cgroup, while it is never used of kmem frees. We do rely on kmemcg_id
being unique for each cgroup in some places, but they are easy to fix.
And regarding per memcg list_lru, which are indexed by kmemcg_id, we can
easily reparent them - it is as simple as splicing lists. This patch set
therefore implements this approach.

It is organized as follows:
 - Currently, sl[AU]b core relies on kmemcg_id being unique per
   kmem_cache. Patches 1-4 fix that.
 - Patch 5 makes memcg_cache_params->memcg_caches entries released on
   css offline.
 - Patch 6 alters the list_lru API a bit to facilitate reparenting.
 - Patch 7 implements per memcg list_lru reparenting on css offline.
   After list_lrus have been reparented, there's no need to keep
   kmemcg_id any more, so we can free it on css offline.

Changes in v2:
 - rebase on top of v3.19-rc4-mmotm-2015-01-16-15-50
 - release css->id after css_free to avoid kmem cache name clashes

v1: https://lkml.org/lkml/2015/1/16/285

[1] https://lkml.org/lkml/2015/1/13/107

Thanks,

Vladimir Davydov (7):
  slab: embed memcg_cache_params to kmem_cache
  slab: link memcg caches of the same kind into a list
  cgroup: release css->id after css_free
  slab: use css id for naming per memcg caches
  memcg: free memcg_caches slot on css offline
  list_lru: add helpers to isolate items
  memcg: reparent list_lrus and free kmemcg_id on css offline

 fs/dcache.c              |   21 +++---
 fs/gfs2/quota.c          |    5 +-
 fs/inode.c               |    8 +--
 fs/xfs/xfs_buf.c         |    6 +-
 fs/xfs/xfs_qm.c          |    5 +-
 include/linux/list_lru.h |   12 +++-
 include/linux/slab.h     |   31 +++++----
 include/linux/slab_def.h |    2 +-
 include/linux/slub_def.h |    2 +-
 kernel/cgroup.c          |   10 ++-
 mm/list_lru.c            |   65 ++++++++++++++++--
 mm/memcontrol.c          |   86 ++++++++++++++++++-----
 mm/slab.c                |   13 ++--
 mm/slab.h                |   65 +++++++++++-------
 mm/slab_common.c         |  172 +++++++++++++++++++++++++++-------------------
 mm/slub.c                |   24 +++----
 mm/workingset.c          |    3 +-
 17 files changed, 343 insertions(+), 187 deletions(-)

-- 
1.7.10.4

