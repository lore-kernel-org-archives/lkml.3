Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991Ab3DHGeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:34:04 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19726 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932829Ab3DHGeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:34:02 -0400
Message-ID: <516264AF.1040906@huawei.com>
Date: Mon, 8 Apr 2013 14:33:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 02/12] memcg: avoid accessing memcg after releasing reference
References: <5162648B.9070802@huawei.com>
In-Reply-To: <5162648B.9070802@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might cause use-after-free bug.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e054ac0..2364f4e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3192,12 +3192,12 @@ void memcg_release_cache(struct kmem_cache *s)
 
 	root = s->memcg_params->root_cache;
 	root->memcg_params->memcg_caches[id] = NULL;
-	mem_cgroup_put(memcg);
 
 	mutex_lock(&memcg->slab_caches_mutex);
 	list_del(&s->memcg_params->list);
 	mutex_unlock(&memcg->slab_caches_mutex);
 
+	mem_cgroup_put(memcg);
 out:
 	kfree(s->memcg_params);
 }
-- 
1.8.0.2
