Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab3HHCfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:35:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:37893 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab3HHCfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:35:38 -0400
Message-ID: <520303B7.2060701@huawei.com>
Date: Thu, 8 Aug 2013 10:34:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH v5 4/5] memcg: stop using css id
References: <52030346.4050003@huawei.com> <520303A6.1050801@huawei.com>
In-Reply-To: <520303A6.1050801@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now memcg uses cgroup id instead of css id. Update some comments and
set mem_cgroup_subsys->use_id to 0.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c0bb83c..1864ba7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -599,16 +599,11 @@ static void disarm_sock_keys(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * This will be the memcg's index in each cache's ->memcg_params->memcg_caches.
- * There are two main reasons for not using the css_id for this:
- *  1) this works better in sparse environments, where we have a lot of memcgs,
- *     but only a few kmem-limited. Or also, if we have, for instance, 200
- *     memcgs, and none but the 200th is kmem-limited, we'd have to have a
- *     200 entry array for that.
- *
- *  2) In order not to violate the cgroup API, we would like to do all memory
- *     allocation in ->create(). At that point, we haven't yet allocated the
- *     css_id. Having a separate index prevents us from messing with the cgroup
- *     core for this
+ * The main reason for not using cgroup id for this:
+ *  this works better in sparse environments, where we have a lot of memcgs,
+ *  but only a few kmem-limited. Or also, if we have, for instance, 200
+ *  memcgs, and none but the 200th is kmem-limited, we'd have to have a
+ *  200 entry array for that.
  *
  * The current size of the caches array is stored in
  * memcg_limited_groups_array_size.  It will double each time we have to
@@ -623,14 +618,14 @@ int memcg_limited_groups_array_size;
  * cgroups is a reasonable guess. In the future, it could be a parameter or
  * tunable, but that is strictly not necessary.
  *
- * MAX_SIZE should be as large as the number of css_ids. Ideally, we could get
+ * MAX_SIZE should be as large as the number of cgrp_ids. Ideally, we could get
  * this constant directly from cgroup, but it is understandable that this is
  * better kept as an internal representation in cgroup.c. In any case, the
- * css_id space is not getting any smaller, and we don't have to necessarily
+ * cgrp_id space is not getting any smaller, and we don't have to necessarily
  * increase ours as well if it increases.
  */
 #define MEMCG_CACHES_MIN_SIZE 4
-#define MEMCG_CACHES_MAX_SIZE 65535
+#define MEMCG_CACHES_MAX_SIZE MEM_CGROUP_ID_MAX
 
 /*
  * A lot of the calls to the cache allocation functions are expected to be
@@ -6019,8 +6014,6 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 	int node;
 	size_t size = memcg_size();
 
-	free_css_id(&mem_cgroup_subsys, &memcg->css);
-
 	for_each_node(node)
 		free_mem_cgroup_per_zone_info(memcg, node);
 
@@ -6802,7 +6795,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
 	.bind = mem_cgroup_bind,
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
-	.use_id = 1,
 };
 
 #ifdef CONFIG_MEMCG_SWAP
-- 
1.8.0.2
