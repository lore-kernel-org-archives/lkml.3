Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3LKPme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:42:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3LKPmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:42:33 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] memcg, oom: lock mem_cgroup_print_oom_info
Date: Wed, 11 Dec 2013 16:42:25 +0100
Message-Id: <1386776545-24916-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_print_oom_info uses a static buffer (memcg_name) to store the
name of the cgroup. This is not safe as pointed out by David Rientjes
because memcg oom is locked only for its hierarchy and nothing prevents
another parallel hierarchy to trigger oom as well and overwrite the
already in-use buffer.

This patch introduces oom_info_lock hidden inside mem_cgroup_print_oom_info
which is held throughout the function. It make access to memcg_name safe
and as a bonus it also prevents parallel memcg ooms to interleave their
statistics which would make the printed data hard to analyze otherwise.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 28c9221b74ea..c72b03bf9679 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1647,13 +1647,13 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
  */
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
-	struct cgroup *task_cgrp;
-	struct cgroup *mem_cgrp;
 	/*
-	 * Need a buffer in BSS, can't rely on allocations. The code relies
-	 * on the assumption that OOM is serialized for memory controller.
-	 * If this assumption is broken, revisit this code.
+	 * protects memcg_name and makes sure that parallel ooms do not
+	 * interleave
 	 */
+	static DEFINE_SPINLOCK(oom_info_lock);
+	struct cgroup *task_cgrp;
+	struct cgroup *mem_cgrp;
 	static char memcg_name[PATH_MAX];
 	int ret;
 	struct mem_cgroup *iter;
@@ -1662,6 +1662,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 	if (!p)
 		return;
 
+	spin_lock(&oom_info_lock);
 	rcu_read_lock();
 
 	mem_cgrp = memcg->css.cgroup;
@@ -1730,6 +1731,7 @@ done:
 
 		pr_cont("\n");
 	}
+	spin_unlock(&oom_info_lock);
 }
 
 /*
-- 
1.8.4.4

