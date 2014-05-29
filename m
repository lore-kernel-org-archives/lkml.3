Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbaE2QQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:16:38 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33609 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbaE2QQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:16:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 08/10] mm: memcontrol: do not acquire page_cgroup lock for kmem pages
Date: Thu, 29 May 2014 12:16:00 -0400
Message-Id: <1401380162-24121-9-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmem page charging and uncharging is serialized by means of exclusive
access to the page.  Do not take the page_cgroup lock and don't set
pc->flags atomically.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f71eec597001..cd024dfb039a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3455,12 +3455,13 @@ void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
 		memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
 		return;
 	}
-
+	/*
+	 * The page is freshly allocated and not visible to any
+	 * outside callers yet.  Set up pc non-atomically.
+	 */
 	pc = lookup_page_cgroup(page);
-	lock_page_cgroup(pc);
 	pc->mem_cgroup = memcg;
-	SetPageCgroupUsed(pc);
-	unlock_page_cgroup(pc);
+	pc->flags = PCG_USED;
 }
 
 void __memcg_kmem_uncharge_pages(struct page *page, int order)
@@ -3470,19 +3471,11 @@ void __memcg_kmem_uncharge_pages(struct page *page, int order)
 
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * Fast unlocked return. Theoretically might have changed, have to
-	 * check again after locking.
-	 */
 	if (!PageCgroupUsed(pc))
 		return;
 
-	lock_page_cgroup(pc);
-	if (PageCgroupUsed(pc)) {
-		memcg = pc->mem_cgroup;
-		ClearPageCgroupUsed(pc);
-	}
-	unlock_page_cgroup(pc);
+	memcg = pc->mem_cgroup;
+	pc->flags = 0;
 
 	/*
 	 * We trust that only if there is a memcg associated with the page, it
-- 
1.9.3

