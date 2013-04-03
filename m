Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762986Ab3DCJPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:15:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47739 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760803Ab3DCJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:15:10 -0400
Message-ID: <515BF2E3.4000605@huawei.com>
Date: Wed, 3 Apr 2013 17:14:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <linux-mm@kvack.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC][PATCH 7/7] memcg: kill memcg refcnt
References: <515BF233.6070308@huawei.com>
In-Reply-To: <515BF233.6070308@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memcg has the same life cycle as the corresponding cgroup.
Kill the useless refcnt.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 45129cd..9714a16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -297,8 +297,6 @@ struct mem_cgroup {
 	bool		oom_lock;
 	atomic_t	under_oom;
 
-	atomic_t	refcnt;
-
 	int	swappiness;
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
@@ -501,9 +499,6 @@ enum res_type {
  */
 static DEFINE_MUTEX(memcg_create_mutex);
 
-static void mem_cgroup_get(struct mem_cgroup *memcg);
-static void mem_cgroup_put(struct mem_cgroup *memcg);
-
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
 {
@@ -6117,22 +6112,6 @@ static void free_rcu(struct rcu_head *rcu_head)
 	schedule_work(&memcg->work_freeing);
 }
 
-static void mem_cgroup_get(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->refcnt);
-}
-
-static void __mem_cgroup_put(struct mem_cgroup *memcg, int count)
-{
-	if (atomic_sub_and_test(count, &memcg->refcnt))
-		call_rcu(&memcg->rcu_freeing, free_rcu);
-}
-
-static void mem_cgroup_put(struct mem_cgroup *memcg)
-{
-	__mem_cgroup_put(memcg, 1);
-}
-
 /*
  * Returns the parent mem_cgroup in memcgroup hierarchy with hierarchy enabled.
  */
@@ -6192,7 +6171,6 @@ mem_cgroup_css_alloc(struct cgroup *cont)
 
 	memcg->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&memcg->oom_notify);
-	atomic_set(&memcg->refcnt, 1);
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
 	spin_lock_init(&memcg->move_lock);
@@ -6279,7 +6257,7 @@ static void mem_cgroup_css_free(struct cgroup *cont)
 
 	mem_cgroup_sockets_destroy(memcg);
 
-	mem_cgroup_put(memcg);
+	call_rcu(&memcg->rcu_freeing, free_rcu);
 }
 
 #ifdef CONFIG_MMU
-- 
1.8.0.2
