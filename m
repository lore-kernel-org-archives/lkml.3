Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339Ab3DBHfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:35:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:23097 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3DBHfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:35:54 -0400
Message-ID: <515A8A40.6020406@huawei.com>
Date: Tue, 2 Apr 2013 15:35:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH] memcg: don't do cleanup manually if mem_cgroup_css_online()
 fails
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memcg_init_kmem() returns -errno when a memcg is being created,
mem_cgroup_css_online() will decrement memcg and its parent's refcnt,
(but strangely there's no mem_cgroup_put() for mem_cgroup_get() called
in memcg_propagate_kmem()).

But then cgroup core will call mem_cgroup_css_free() to do cleanup...

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 mm/memcontrol.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e80504e..e927fc6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6247,16 +6247,7 @@ mem_cgroup_css_online(struct cgroup *cont)
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
-	}
+
 	return error;
 }
 
-- 
1.8.0.2

