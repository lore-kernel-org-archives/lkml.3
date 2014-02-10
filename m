Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaBJUVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:21:51 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:51031 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaBJUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:21:46 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: update cgroup_transfer_tasks() to either succeed or fail
Date: Mon, 10 Feb 2014 15:21:34 -0500
Message-Id: <1392063694-26465-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392063694-26465-1-git-send-email-tj@kernel.org>
References: <1392063694-26465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_transfer_tasks() can currently fail in the middle due to memory
allocation failure.  When that happens, the function just aborts and
returns error code and there's no way to tell how many actually got
migrated at the point of failure and or to revert the partial
migration.

Update it to use cgroup_migrate{_add_src|prepare_dst|migrate|finish}()
so that the function either succeeds or fails as a whole as long as
->can_attach() doesn't fail.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1b485df..188e624 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2809,10 +2809,28 @@ void css_task_iter_end(struct css_task_iter *it)
  */
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 {
+	LIST_HEAD(preloaded_csets);
+	struct cgrp_cset_link *link;
 	struct css_task_iter it;
 	struct task_struct *task;
-	int ret = 0;
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+
+	/* all tasks in @from are being moved, all csets are source */
+	down_read(&css_set_rwsem);
+	list_for_each_entry(link, &from->cset_links, cset_link)
+		cgroup_migrate_add_src(link->cset, to, &preloaded_csets);
+	up_read(&css_set_rwsem);
 
+	ret = cgroup_migrate_prepare_dst(to, &preloaded_csets);
+	if (ret)
+		goto out_err;
+
+	/*
+	 * Migrate tasks one-by-one until @form is empty.  This fails iff
+	 * ->can_attach() fails.
+	 */
 	do {
 		css_task_iter_start(&from->dummy_css, &it);
 		task = css_task_iter_next(&it);
@@ -2821,13 +2839,13 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 		css_task_iter_end(&it);
 
 		if (task) {
-			mutex_lock(&cgroup_mutex);
-			ret = cgroup_attach_task(to, task, false);
-			mutex_unlock(&cgroup_mutex);
+			ret = cgroup_migrate(to, task, false);
 			put_task_struct(task);
 		}
 	} while (task && !ret);
-
+out_err:
+	cgroup_migrate_finish(&preloaded_csets);
+	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
 
-- 
1.8.5.3

