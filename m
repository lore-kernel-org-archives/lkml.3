Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaJUUWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:22:51 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42526 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbaJUUVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:21:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/4] mm: memcontrol: don't pass a NULL memcg to mem_cgroup_end_move()
Date: Tue, 21 Oct 2014 16:21:34 -0400
Message-Id: <1413922896-29042-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413922896-29042-1-git-send-email-hannes@cmpxchg.org>
References: <1413922896-29042-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_end_move() checks if the passed memcg is NULL, along with a
lengthy comment to explain why this seemingly non-sensical situation
is even possible.

Check in cancel_attach() itself whether can_attach() set up the move
context or not, it's a lot more obvious from there.  Then remove the
check and comment in mem_cgroup_end_move().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ff125d2a427..c1fe774d712a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1452,14 +1452,8 @@ static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 
 static void mem_cgroup_end_move(struct mem_cgroup *memcg)
 {
-	/*
-	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
-	 * We check NULL in callee rather than caller.
-	 */
-	if (memcg) {
-		atomic_dec(&memcg_moving);
-		atomic_dec(&memcg->moving_account);
-	}
+	atomic_dec(&memcg_moving);
+	atomic_dec(&memcg->moving_account);
 }
 
 /*
@@ -5383,7 +5377,8 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 static void mem_cgroup_cancel_attach(struct cgroup_subsys_state *css,
 				     struct cgroup_taskset *tset)
 {
-	mem_cgroup_clear_mc();
+	if (mc.to)
+		mem_cgroup_clear_mc();
 }
 
 static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
-- 
2.1.2

