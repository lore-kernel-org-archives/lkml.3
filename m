Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaC1Cnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:43:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49608 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbaC1ClR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:41:17 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] cgroup: reorganize css_task_iter
Date: Thu, 27 Mar 2014 22:40:54 -0400
Message-Id: <1395974461-12735-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorganizes css_task_iter so that adding effective css
support is easier.

* s/->cset_link/->cset_pos/ and s/->task/->task_pos/ for consistency

* ->origin_css is used to determine whether the iteration reached the
  last css_set.  Replace it with explicit ->cset_head so that
  css_advance_task_iter() doesn't have to know the termination
  condition directly.

* css_task_iter_next() currently assumes that it's walking list of
  cgrp_cset_link and reaches into the current cset through the current
  link to determine the termination conditions for task walking.  As
  this won't always be true for effective css walking, add
  ->tasks_head and ->mg_tasks_head and use them to control task
  walking so that css_task_iter_next() doesn't have to know how
  css_sets are being walked.

This patch doesn't make any behavior changes.  The iteration logic
stays unchanged after the patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  9 ++++++---
 kernel/cgroup.c        | 33 +++++++++++++++++----------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e902eee..6bbe143 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -842,9 +842,12 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 
 /* A css_task_iter should be treated as an opaque object */
 struct css_task_iter {
-	struct cgroup_subsys_state	*origin_css;
-	struct list_head		*cset_link;
-	struct list_head		*task;
+	struct list_head		*cset_pos;
+	struct list_head		*cset_head;
+
+	struct list_head		*task_pos;
+	struct list_head		*tasks_head;
+	struct list_head		*mg_tasks_head;
 };
 
 void css_task_iter_start(struct cgroup_subsys_state *css,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9d2d6ef..318b6a2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2839,27 +2839,30 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
  */
 static void css_advance_task_iter(struct css_task_iter *it)
 {
-	struct list_head *l = it->cset_link;
+	struct list_head *l = it->cset_pos;
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
 
 	/* Advance to the next non-empty css_set */
 	do {
 		l = l->next;
-		if (l == &it->origin_css->cgroup->cset_links) {
-			it->cset_link = NULL;
+		if (l == it->cset_head) {
+			it->cset_pos = NULL;
 			return;
 		}
 		link = list_entry(l, struct cgrp_cset_link, cset_link);
 		cset = link->cset;
 	} while (list_empty(&cset->tasks) && list_empty(&cset->mg_tasks));
 
-	it->cset_link = l;
+	it->cset_pos = l;
 
 	if (!list_empty(&cset->tasks))
-		it->task = cset->tasks.next;
+		it->task_pos = cset->tasks.next;
 	else
-		it->task = cset->mg_tasks.next;
+		it->task_pos = cset->mg_tasks.next;
+
+	it->tasks_head = &cset->tasks;
+	it->mg_tasks_head = &cset->mg_tasks;
 }
 
 /**
@@ -2885,8 +2888,8 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 
 	down_read(&css_set_rwsem);
 
-	it->origin_css = css;
-	it->cset_link = &css->cgroup->cset_links;
+	it->cset_pos = &css->cgroup->cset_links;
+	it->cset_head = it->cset_pos;
 
 	css_advance_task_iter(it);
 }
@@ -2902,12 +2905,10 @@ void css_task_iter_start(struct cgroup_subsys_state *css,
 struct task_struct *css_task_iter_next(struct css_task_iter *it)
 {
 	struct task_struct *res;
-	struct list_head *l = it->task;
-	struct cgrp_cset_link *link = list_entry(it->cset_link,
-					struct cgrp_cset_link, cset_link);
+	struct list_head *l = it->task_pos;
 
 	/* If the iterator cg is NULL, we have no tasks */
-	if (!it->cset_link)
+	if (!it->cset_pos)
 		return NULL;
 	res = list_entry(l, struct task_struct, cg_list);
 
@@ -2918,13 +2919,13 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 	 */
 	l = l->next;
 
-	if (l == &link->cset->tasks)
-		l = link->cset->mg_tasks.next;
+	if (l == it->tasks_head)
+		l = it->mg_tasks_head->next;
 
-	if (l == &link->cset->mg_tasks)
+	if (l == it->mg_tasks_head)
 		css_advance_task_iter(it);
 	else
-		it->task = l;
+		it->task_pos = l;
 
 	return res;
 }
-- 
1.8.5.3

