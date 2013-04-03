Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139Ab3DCJNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:13:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39398 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab3DCJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:13:50 -0400
Message-ID: <515BF2B1.9060909@huawei.com>
Date: Wed, 3 Apr 2013 17:13:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <linux-mm@kvack.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC][PATCH 6/7] memcg: don't need to get a reference to the parent
References: <515BF233.6070308@huawei.com>
In-Reply-To: <515BF233.6070308@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup core guarantees it's always safe to access the parent.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ad576e8..45129cd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6124,12 +6124,8 @@ static void mem_cgroup_get(struct mem_cgroup *memcg)
 
 static void __mem_cgroup_put(struct mem_cgroup *memcg, int count)
 {
-	if (atomic_sub_and_test(count, &memcg->refcnt)) {
-		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	if (atomic_sub_and_test(count, &memcg->refcnt))
 		call_rcu(&memcg->rcu_freeing, free_rcu);
-		if (parent)
-			mem_cgroup_put(parent);
-	}
 }
 
 static void mem_cgroup_put(struct mem_cgroup *memcg)
@@ -6229,14 +6225,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 		res_counter_init(&memcg->res, &parent->res);
 		res_counter_init(&memcg->memsw, &parent->memsw);
 		res_counter_init(&memcg->kmem, &parent->kmem);
-
-		/*
-		 * We increment refcnt of the parent to ensure that we can
-		 * safely access it on res_counter_charge/uncharge.
-		 * This refcnt will be decremented when freeing this
-		 * mem_cgroup(see mem_cgroup_put).
-		 */
-		mem_cgroup_get(parent);
 	} else {
 		res_counter_init(&memcg->res, NULL);
 		res_counter_init(&memcg->memsw, NULL);
-- 
1.8.0.2
