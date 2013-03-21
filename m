Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3CUBW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:22:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:49369 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3CUBWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:22:46 -0400
Message-ID: <514A60CD.60208@huawei.com>
Date: Thu, 21 Mar 2013 09:22:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As cgroup supports rename, it's unsafe to dereference dentry->d_name
without proper vfs locks. Fix this by using cgroup_name().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---

This patch depends on "cgroup: fix cgroup_path() vs rename() race",
which has been queued for 3.10.

---
 mm/memcontrol.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53b8201..72be5c9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3217,17 +3217,16 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
 {
 	char *name;
-	struct dentry *dentry;
+
+	name = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!name)
+		return NULL;
 
 	rcu_read_lock();
-	dentry = rcu_dereference(memcg->css.cgroup->dentry);
+	snprintf(name, PAGE_SIZE, "%s(%d:%s)", s->name, memcg_cache_id(memcg),
+		 cgroup_name(memcg->css.cgroup));
 	rcu_read_unlock();
 
-	BUG_ON(dentry == NULL);
-
-	name = kasprintf(GFP_KERNEL, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), dentry->d_name.name);
-
 	return name;
 }
 
@@ -3247,7 +3246,7 @@ static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
 	if (new)
 		new->allocflags |= __GFP_KMEMCG;
 
-	kfree(name);
+	free_page((unsigned long)name);
 	return new;
 }
 
-- 
1.8.0.2
