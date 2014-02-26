Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBZPF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:05:26 -0500
Received: from relay.parallels.com ([195.214.232.42]:59633 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaBZPFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:05:24 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm 00/12] kmemcg reparenting
Date: Wed, 26 Feb 2014 19:05:05 +0400
Message-ID: <cover.1393423762.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During my recent attempt to push kmemcg shrinkers, I was pointed out
that current kmemcg implementation has a serious design flaw - it lacks
reparenting. Currently each memcg cache holds a css ref to its memcg and
does not let it go until the cache is emptied. Although this approach is
simple, it leads to memcgs hanging around for quite a long time after
the death, which is ugly. Building something on top of that is
unacceptable. So this patch set targets on implementing reparenting for
kmemcg charges.

[ for more details see the discussion thread:
  https://lkml.org/lkml/2014/2/11/623 ]

It is based on top of 3.14.0-rc4-mmotm and organized as follows:
 - Patches 1-3 fix some nasty races in kmemcg implementation. I could
   not let them live any longer, because they touch the code I'm going
   to modify.
 - Patches 4-6 prepare memcg_cache_params for reparenting.
 - Patch 7 rework slab charging making it easier to track and therefore
   reparent kmem charges, and patches 8-10 kill the old charging code.
 - Patch 11 introduces kmemcg reparenting.
 - Patch 12 is for slub. It fixes sysfs naming clashes that can arise
   due to reparented caches.

Please note that this patch set does not resolve all kmemcg-related
issues - there are still plenty of them (e.g. "dangling" caches), but it
is already big enough so I guess I'll address them later when this one
is committed (if it will be committed at all, of course).

Many thanks to Johannes Weiner, who proposed the idea and kindly
outlined basic design principles.

Thanks,

Vladimir Davydov (12):
  memcg: flush cache creation works before memcg cache destruction
  memcg: fix race in memcg cache destruction path
  memcg: fix root vs memcg cache destruction race
  memcg: move slab caches list/mutex init to memcg creation
  memcg: add pointer from memcg_cache_params to cache
  memcg: keep all children of each root cache on a list
  memcg: rework slab charging
  memcg: do not charge kmalloc_large allocations
  fork: do not charge thread_info to kmemcg
  memcg: kill GFP_KMEMCG and stuff
  memcg: reparent slab on css offline
  slub: make sure all memcg caches have unique names on sysfs

 include/linux/gfp.h             |    5 -
 include/linux/memcontrol.h      |  133 ++-------
 include/linux/slab.h            |   15 +-
 include/linux/thread_info.h     |    2 -
 include/trace/events/gfpflags.h |    1 -
 kernel/fork.c                   |    4 +-
 mm/memcontrol.c                 |  587 +++++++++++++++++----------------------
 mm/page_alloc.c                 |   35 ---
 mm/slab.c                       |   47 ++--
 mm/slab.h                       |   17 +-
 mm/slab_common.c                |  100 +++++--
 mm/slub.c                       |   88 ++++--
 12 files changed, 470 insertions(+), 564 deletions(-)

-- 
1.7.10.4

