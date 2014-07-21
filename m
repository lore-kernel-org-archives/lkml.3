Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaGULrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:47:40 -0400
Received: from mx2.parallels.com ([199.115.105.18]:57588 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaGULrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:47:32 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <hannes@cmpxchg.org>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 0/6] memcg: release memcg_cache_id on css offline
Date: Mon, 21 Jul 2014 15:47:10 +0400
Message-ID: <cover.1405941342.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently memcg_cache_id (mem_cgroup->kmemcg_id), which is used for
indexing memcg_caches arrays, is released only on css free. As a result,
offline css, whose number is actually limited only by amount of free
RAM, will occupy slots in these arrays making them grow larger and
larger even if there's only a few kmem active memory cgroups out there.

This patch set makes memcg release memcg_cache_id on css offline. This
way the memcg_caches arrays size will be limited by the number of alive
kmem-active memory cgroups, which is much better.

The work is actually done in patch 6 while patches 1-5 only prepare
memcg and slab subsystems to this change.

Thanks,

Vladimir Davydov (6):
  slub: remove kmemcg id from create_unique_id
  slab: use mem_cgroup_id for per memcg cache naming
  memcg: make memcg_cache_id static
  memcg: add pointer to owner cache to memcg_cache_params
  memcg: keep all children of each root cache on a list
  memcg: release memcg_cache_id on css offline

 include/linux/memcontrol.h |    9 +---
 include/linux/slab.h       |    7 ++-
 mm/memcontrol.c            |  112 +++++++++++++++++++++++++++-----------------
 mm/slab.c                  |   40 +++++++++-------
 mm/slab_common.c           |   44 ++++++++---------
 mm/slub.c                  |   45 +++++++++---------
 6 files changed, 140 insertions(+), 117 deletions(-)

-- 
1.7.10.4

