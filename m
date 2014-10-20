Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaJTPXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:23:17 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42361 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaJTPWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:22:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/4] mm: memcontrol: uncharge pages on swapout
Date: Mon, 20 Oct 2014 11:22:09 -0400
Message-Id: <1413818532-11042-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
References: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_swapout() is called with exclusive access to the page at
the end of the page's lifetime.  Instead of clearing the PCG_MEMSW
flag and deferring the uncharge, just do it right away.  This allows
follow-up patches to simplify the uncharge code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bea3fddb3372..7709f17347f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5799,6 +5799,7 @@ static void __init enable_swap_cgroup(void)
  */
 void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
+	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
 	unsigned short oldid;
 
@@ -5815,13 +5816,21 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 		return;
 
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEMSW), page);
+	memcg = pc->mem_cgroup;
 
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(pc->mem_cgroup));
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
+	mem_cgroup_swap_statistics(memcg, true);
 
-	pc->flags &= ~PCG_MEMSW;
-	css_get(&pc->mem_cgroup->css);
-	mem_cgroup_swap_statistics(pc->mem_cgroup, true);
+	pc->flags = 0;
+
+	if (!mem_cgroup_is_root(memcg))
+		page_counter_uncharge(&memcg->memory, 1);
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, page, -1);
+	memcg_check_events(memcg, page);
+	local_irq_enable();
 }
 
 /**
-- 
2.1.2

