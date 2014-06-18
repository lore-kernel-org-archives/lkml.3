Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaFRUlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:41:20 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:37571 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647AbaFRUlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:41:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 10/13] mm: memcontrol: remove ordering between pc->mem_cgroup and PageCgroupUsed
Date: Wed, 18 Jun 2014 16:40:42 -0400
Message-Id: <1403124045-24361-11-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a write barrier between setting pc->mem_cgroup and
PageCgroupUsed, which was added to allow LRU operations to lookup the
memcg LRU list of a page without acquiring the page_cgroup lock.

But ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new
rule"), pages are ensured to be off-LRU while charging, so nobody else
is changing LRU state while pc->mem_cgroup is being written, and there
are no read barriers anymore.

Remove the unnecessary write barrier.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d2b8429002c0..199bd50359ad 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2795,14 +2795,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 	}
 
 	pc->mem_cgroup = memcg;
-	/*
-	 * We access a page_cgroup asynchronously without lock_page_cgroup().
-	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
-	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
-	 * before USED bit, we need memory barrier here.
-	 * See mem_cgroup_add_lru_list(), etc.
-	 */
-	smp_wmb();
 	SetPageCgroupUsed(pc);
 
 	if (lrucare) {
@@ -3483,7 +3475,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		pc = head_pc + i;
 		pc->mem_cgroup = memcg;
-		smp_wmb();/* see __commit_charge() */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
-- 
2.0.0

