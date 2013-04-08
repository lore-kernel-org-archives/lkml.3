Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837Ab3DHGeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:34:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19944 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761255Ab3DHGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:34:19 -0400
Message-ID: <516264D6.3090100@huawei.com>
Date: Mon, 8 Apr 2013 14:33:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH 04/12] memcg, kmem: fix reference count handling on the error
 path
References: <5162648B.9070802@huawei.com>
In-Reply-To: <5162648B.9070802@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

mem_cgroup_css_online calls mem_cgroup_put if memcg_init_kmem
fails. This is not correct because only memcg_propagate_kmem takes an
additional reference while mem_cgroup_sockets_init is allowed to fail as
well (although no current implementation fails) but it doesn't take any
reference. This all suggests that it should be memcg_propagate_kmem that
should clean up after itself so this patch moves mem_cgroup_put over
there.

Unfortunately this is not that easy (as pointed out by Li Zefan) because
memcg_kmem_mark_dead marks the group dead (KMEM_ACCOUNTED_DEAD) if it
is marked active (KMEM_ACCOUNTED_ACTIVE) which is the case even if
memcg_propagate_kmem fails so the additional reference is dropped in
that case in kmem_cgroup_destroy which means that the reference would be
dropped two times.

The easiest way then would be to simply remove mem_cgrroup_put from
mem_cgroup_css_online and rely on kmem_cgroup_destroy doing the right
thing.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org> # 3.8.x
---
 mm/memcontrol.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 44cec72..e65eaac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6243,14 +6243,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-	}
 	return error;
 }
 
-- 
1.8.0.2
