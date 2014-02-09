Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaBINyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:54:12 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:41955 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaBINxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:18 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/16] cgroup: remove cgroup_taskset_cur_css() and cgroup_taskset_size()
Date: Sun,  9 Feb 2014 08:52:42 -0500
Message-Id: <1391953964-22088-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two functions don't have any users left.  Remove them along with
cgroup_taskset->cur_cgrp.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  3 ---
 kernel/cgroup.c        | 30 ------------------------------
 2 files changed, 33 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 3c67883..21887b6 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -526,9 +526,6 @@ bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 struct cgroup_taskset;
 struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset);
 struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
-struct cgroup_subsys_state *cgroup_taskset_cur_css(struct cgroup_taskset *tset,
-						   int subsys_id);
-int cgroup_taskset_size(struct cgroup_taskset *tset);
 
 /**
  * cgroup_taskset_for_each - iterate cgroup_taskset
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ac78311..0108753 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1645,7 +1645,6 @@ struct cgroup_taskset {
 	struct flex_array	*tc_array;
 	int			tc_array_len;
 	int			idx;
-	struct cgroup		*cur_cgrp;
 };
 
 /**
@@ -1660,7 +1659,6 @@ struct task_struct *cgroup_taskset_first(struct cgroup_taskset *tset)
 		tset->idx = 0;
 		return cgroup_taskset_next(tset);
 	} else {
-		tset->cur_cgrp = tset->single.cgrp;
 		return tset->single.task;
 	}
 }
@@ -1681,39 +1679,11 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset)
 		return NULL;
 
 	tc = flex_array_get(tset->tc_array, tset->idx++);
-	tset->cur_cgrp = tc->cgrp;
 	return tc->task;
 }
 EXPORT_SYMBOL_GPL(cgroup_taskset_next);
 
 /**
- * cgroup_taskset_cur_css - return the matching css for the current task
- * @tset: taskset of interest
- * @subsys_id: the ID of the target subsystem
- *
- * Return the css for the current (last returned) task of @tset for
- * subsystem specified by @subsys_id.  This function must be preceded by
- * either cgroup_taskset_first() or cgroup_taskset_next().
- */
-struct cgroup_subsys_state *cgroup_taskset_cur_css(struct cgroup_taskset *tset,
-						   int subsys_id)
-{
-	return cgroup_css(tset->cur_cgrp, cgroup_subsys[subsys_id]);
-}
-EXPORT_SYMBOL_GPL(cgroup_taskset_cur_css);
-
-/**
- * cgroup_taskset_size - return the number of tasks in taskset
- * @tset: taskset of interest
- */
-int cgroup_taskset_size(struct cgroup_taskset *tset)
-{
-	return tset->tc_array ? tset->tc_array_len : 1;
-}
-EXPORT_SYMBOL_GPL(cgroup_taskset_size);
-
-
-/**
  * cgroup_task_migrate - move a task from one cgroup to another.
  * @old_cgrp; the cgroup @tsk is being migrated from
  * @tsk: the task being migrated
-- 
1.8.5.3

