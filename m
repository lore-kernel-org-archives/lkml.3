Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762879Ab3DCIyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:54:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762838Ab3DCIyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:54:03 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: [PATCH 2/2] memcg, kmem: clean up reference count handling on the error path
Date: Wed,  3 Apr 2013 10:53:54 +0200
Message-Id: <1364979234-16427-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364979234-16427-1-git-send-email-mhocko@suse.cz>
References: <20130403085056.GD14384@dhcp22.suse.cz>
 <1364979234-16427-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 mm/memcontrol.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6de6d70..65b2850 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6417,14 +6417,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 
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
1.7.10.4

