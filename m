Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3DACja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:39:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59999 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3DACj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:39:29 -0400
Message-ID: <5158F344.9020509@huawei.com>
Date: Mon, 1 Apr 2013 10:39:00 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memcg: avoid accessing memcg after releasing reference
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This might cause use-after-free bug.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---

found when reading the code.

---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8ec501c..6391046 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3186,12 +3186,12 @@ void memcg_release_cache(struct kmem_cache *s)
 
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
