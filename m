Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaDWHNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:13:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:53839 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaDWHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:13:19 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <cl@linux-foundation.org>, <penberg@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: [PATCH -mm v3 0/3] kmemcg: simplify work-flow
Date: Wed, 23 Apr 2014 11:13:12 +0400
Message-ID: <cover.1398235153.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch-set is a part of preparations for kmemcg re-parenting. It
targets at simplifying kmemcg work-flows and synchronization.

First, it removes async per memcg cache destruction (see patches 1, 2).
Now caches are only destroyed on memcg offline. That means the caches
that are not empty on memcg offline will be leaked. However, they are
already leaked, because memcg_cache_params::nr_pages normally never
drops to 0 so the destruction work is never scheduled except
kmem_cache_shrink is called explicitly. In the future I'm planning
reaping such dead caches on vmpressure or periodically.

Second, it substitutes per memcg slab_caches_mutex's with the global
memcg_slab_mutex, which should be taken during the whole per memcg cache
creation/destruction path before the slab_mutex (see patch 3). This
greatly simplifies synchronization among various per memcg cache
creation/destruction paths.

I'm still not quite sure about the end picture, in particular I don't
know whether we should reap dead memcgs' kmem caches periodically or try
to merge them with their parents (see https://lkml.org/lkml/2014/4/20/38
for more details), but whichever way we choose, this set looks like a
reasonable change to me, because it greatly simplifies kmemcg work-flows
and eases further development.

Changes in v3:
 - rebase on top of mmotm 2014-04-22-15-20 (minor, so I preserved
   Johannes' ACKs)
Changes in v2:
 - substitute per memcg slab_caches_mutex's with the global
   memcg_slab_mutex and re-split the set.

v2: https://lkml.org/lkml/2014/4/18/42
v1: https://lkml.org/lkml/2014/4/9/298

Thanks,

Vladimir Davydov (3):
  memcg, slab: do not schedule cache destruction when last page goes
    away
  memcg, slab: merge memcg_{bind,release}_pages to
    memcg_{un}charge_slab
  memcg, slab: simplify synchronization scheme

 include/linux/memcontrol.h |   15 +--
 include/linux/slab.h       |    8 +-
 mm/memcontrol.c            |  231 +++++++++++++++-----------------------------
 mm/slab.c                  |    2 -
 mm/slab.h                  |   28 +-----
 mm/slab_common.c           |   23 ++---
 mm/slub.c                  |    2 -
 7 files changed, 93 insertions(+), 216 deletions(-)

-- 
1.7.10.4

