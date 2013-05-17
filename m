Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3EQHHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:07:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26606 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab3EQHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:07:01 -0400
Message-ID: <5195D6BF.3020907@huawei.com>
Date: Fri, 17 May 2013 15:05:35 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 9/9] memcg: don't need to free memcg via RCU or workqueue
References: <5195D5F8.7000609@huawei.com>
In-Reply-To: <5195D5F8.7000609@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memcg has the same life cycle with its corresponding cgroup, and
a cgroup is freed via RCU and then mem_cgroup_css_free() will be
called in a work function, so we can simply call __mem_cgroup_free()
in mem_cgroup_css_free().

This actually reverts 59927fb984de1703c67bc640c3e522d8b5276c73
("memcg: free mem_cgroup by RCU to fix oops").

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c | 51 +++++----------------------------------------------
 1 file changed, 5 insertions(+), 46 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 348126a..eb27b58 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -267,28 +267,10 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
-	union {
-		/*
-		 * the counter to account for mem+swap usage.
-		 */
-		struct res_counter memsw;
-
-		/*
-		 * rcu_freeing is used only when freeing struct mem_cgroup,
-		 * so put it into a union to avoid wasting more memory.
-		 * It must be disjoint from the css field.  It could be
-		 * in a union with the res field, but res plays a much
-		 * larger part in mem_cgroup life than memsw, and might
-		 * be of interest, even at time of free, when debugging.
-		 * So share rcu_head with the less interesting memsw.
-		 */
-		struct rcu_head rcu_freeing;
-		/*
-		 * We also need some space for a worker in deferred freeing.
-		 * By the time we call it, rcu_freeing is no longer in use.
-		 */
-		struct work_struct work_freeing;
-	};
+	/*
+	 * the counter to account for mem+swap usage.
+	 */
+	struct res_counter memsw;
 
 	/*
 	 * the counter to account for kernel memory usage.
@@ -6143,29 +6125,6 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 		vfree(memcg);
 }
 
-
-/*
- * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
- * but in process context.  The work_freeing structure is overlaid
- * on the rcu_freeing structure, which itself is overlaid on memsw.
- */
-static void free_work(struct work_struct *work)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = container_of(work, struct mem_cgroup, work_freeing);
-	__mem_cgroup_free(memcg);
-}
-
-static void free_rcu(struct rcu_head *rcu_head)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
-	INIT_WORK(&memcg->work_freeing, free_work);
-	schedule_work(&memcg->work_freeing);
-}
-
 /*
  * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
  */
@@ -6316,7 +6275,7 @@ static void mem_cgroup_css_free(struct cgroup *cont)
 
 	mem_cgroup_sockets_destroy(memcg);
 
-	call_rcu(&memcg->rcu_freeing, free_rcu);
+	__mem_cgroup_free(memcg);
 }
 
 #ifdef CONFIG_MMU
-- 
1.8.0.2
