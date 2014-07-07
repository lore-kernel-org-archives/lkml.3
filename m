Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaGGMAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:00:30 -0400
Received: from mx2.parallels.com ([199.115.105.18]:32807 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaGGMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:00:28 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 0/8] memcg: reparent kmem on css offline
Date: Mon, 7 Jul 2014 16:00:05 +0400
Message-ID: <cover.1404733720.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set introduces re-parenting of kmem charges on memcg css
offline. The idea lying behind it is very simple - instead of pointing
from kmem objects (kmem caches, non-slab kmem pages) directly to the
memcg which they are charged against, we make them point to a proxy
object, mem_cgroup_kmem_context, which, in turn, points to the memcg
which it belongs to. As a result on memcg offline, it's enough to only
re-parent the memcg's mem_cgroup_kmem_context.

Note, reparented kmem contexts will hang around until there is at least
one object accounted to them, but since they are small (especially
comparing to struct mem_cgroup), it's no big deal.

Reviews are appreciated.

Thanks,

Vladimir Davydov (8):
  memcg: add pointer from memcg_cache_params to owner cache
  memcg: keep all children of each root cache on a list
  slab: guarantee unique kmem cache naming
  slub: remove kmemcg id from create_unique_id
  memcg: rework non-slab kmem pages charge path
  memcg: introduce kmem context
  memcg: move some kmem definitions upper
  memcg: reparent kmem context on memcg offline

 include/linux/memcontrol.h |   88 ++++-----
 include/linux/mm_types.h   |    6 +
 include/linux/slab.h       |   17 +-
 mm/memcontrol.c            |  468 +++++++++++++++++++++-----------------------
 mm/page_alloc.c            |   22 ++-
 mm/slab.c                  |   40 ++--
 mm/slab_common.c           |   64 ++++--
 mm/slub.c                  |   45 ++---
 8 files changed, 382 insertions(+), 368 deletions(-)

-- 
1.7.10.4

