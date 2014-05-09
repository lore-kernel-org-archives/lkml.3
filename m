Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbaEIVfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:35:47 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33364 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbaEIVbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:39 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH 02/14] cgroup: remove pointless has tasks/children test from mem_cgroup_force_empty()
Date: Fri,  9 May 2014 17:31:19 -0400
Message-Id: <1399671091-23867-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_force_empty() is used only from
mem_cgroup_force_empty_write() and tests whether the target memcg has
any tasks or children without any synchronization and then returns
-EBUSY if so.

This is just weird.  The tests don't really mean anything as tasks and
children may be added after the tests and it also makes the behavior
of the knob arbitrary because there may be lingering offline and
removed children on the children list for extended period of time -
writes to the knob can return -EBUSY for reasons completely invisible
to userland.

The knob is best-effort anyway and the broken business test doesn't
affect its operation.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a5e0417..036453a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4857,11 +4857,6 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct cgroup *cgrp = memcg->css.cgroup;
-
-	/* returns EBUSY if there is a task or if we come here twice. */
-	if (cgroup_has_tasks(cgrp) || !list_empty(&cgrp->children))
-		return -EBUSY;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
-- 
1.9.0

