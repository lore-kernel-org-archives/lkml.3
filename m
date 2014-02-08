Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaBHQkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:40:45 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:56352 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBHQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:38:36 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] cgroup: relocate cgroup_rm_cftypes()
Date: Sat,  8 Feb 2014 11:38:23 -0500
Message-Id: <1391877509-10855-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391877509-10855-1-git-send-email-tj@kernel.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cftype handling is about to be revamped.  Relocate cgroup_rm_cftypes()
above cgroup_add_cftypes() in preparation.  This is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 70 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6b96516..f718cbb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2416,6 +2416,41 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 }
 
 /**
+ * cgroup_rm_cftypes - remove an array of cftypes from a subsystem
+ * @cfts: zero-length name terminated array of cftypes
+ *
+ * Unregister @cfts.  Files described by @cfts are removed from all
+ * existing cgroups and all future cgroups won't have them either.  This
+ * function can be called anytime whether @cfts' subsys is attached or not.
+ *
+ * Returns 0 on successful unregistration, -ENOENT if @cfts is not
+ * registered.
+ */
+int cgroup_rm_cftypes(struct cftype *cfts)
+{
+	struct cftype *found = NULL;
+	struct cftype_set *set;
+
+	if (!cfts || !cfts[0].ss)
+		return -ENOENT;
+
+	cgroup_cfts_prepare();
+
+	list_for_each_entry(set, &cfts[0].ss->cftsets, node) {
+		if (set->cfts == cfts) {
+			list_del(&set->node);
+			kfree(set);
+			found = cfts;
+			break;
+		}
+	}
+
+	cgroup_cfts_commit(found, false);
+	cgroup_exit_cftypes(cfts);
+	return found ? 0 : -ENOENT;
+}
+
+/**
  * cgroup_add_cftypes - add an array of cftypes to a subsystem
  * @ss: target cgroup subsystem
  * @cfts: zero-length name terminated array of cftypes
@@ -2453,41 +2488,6 @@ int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 EXPORT_SYMBOL_GPL(cgroup_add_cftypes);
 
 /**
- * cgroup_rm_cftypes - remove an array of cftypes from a subsystem
- * @cfts: zero-length name terminated array of cftypes
- *
- * Unregister @cfts.  Files described by @cfts are removed from all
- * existing cgroups and all future cgroups won't have them either.  This
- * function can be called anytime whether @cfts' subsys is attached or not.
- *
- * Returns 0 on successful unregistration, -ENOENT if @cfts is not
- * registered.
- */
-int cgroup_rm_cftypes(struct cftype *cfts)
-{
-	struct cftype *found = NULL;
-	struct cftype_set *set;
-
-	if (!cfts || !cfts[0].ss)
-		return -ENOENT;
-
-	cgroup_cfts_prepare();
-
-	list_for_each_entry(set, &cfts[0].ss->cftsets, node) {
-		if (set->cfts == cfts) {
-			list_del(&set->node);
-			kfree(set);
-			found = cfts;
-			break;
-		}
-	}
-
-	cgroup_cfts_commit(found, false);
-	cgroup_exit_cftypes(cfts);
-	return found ? 0 : -ENOENT;
-}
-
-/**
  * cgroup_task_count - count the number of tasks in a cgroup.
  * @cgrp: the cgroup in question
  *
-- 
1.8.5.3

