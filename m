Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaJTPRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:17:53 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42342 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaJTPRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:17:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: micro-optimize mem_cgroup_update_page_stat()
Date: Mon, 20 Oct 2014 11:17:39 -0400
Message-Id: <1413818259-10913-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not look up the page_cgroup when the memory controller is
runtime-disabled, but do assert that the locking protocol is followed
under DEBUG_VM regardless.  Also remove the unused flags variable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 76892eb89d26..bea3fddb3372 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2177,13 +2177,14 @@ void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_stat_index idx, int val)
 {
 	struct mem_cgroup *memcg;
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	unsigned long uninitialized_var(flags);
+	struct page_cgroup *pc;
+
+	VM_BUG_ON(!rcu_read_lock_held());
 
 	if (mem_cgroup_disabled())
 		return;
 
-	VM_BUG_ON(!rcu_read_lock_held());
+	pc = lookup_page_cgroup(page);
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return;
-- 
2.1.2

