Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab3HAVvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:51:20 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62433 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3HAVum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:42 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/23] cgroup: unexport cgroup_css()
Date: Thu,  1 Aug 2013 17:50:01 -0400
Message-Id: <1375393801-4817-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_css() no longer has any user left outside cgroup.c proper and
we don't want subsystems to grow new usages of the function.  cgroup
core should always provide the css to use to the subsystems, which
will make dynamic creation and destruction of css's across the
lifetime of a cgroup much more manageable than exposing the cgroup
directly to subsystems and let them dereference css's from it.

Make cgroup_css() a static function in cgroup.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 13 -------------
 kernel/cgroup.c        | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 28e21f9..1d81d25 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -679,19 +679,6 @@ struct cgroup_subsys_state *css_parent(struct cgroup_subsys_state *css)
 }
 
 /**
- * cgroup_css - obtain a cgroup's css for the specified subsystem
- * @cgrp: the cgroup of interest
- * @subsys_id: the subsystem of interest
- *
- * Return @cgrp's css (cgroup_subsys_state) associated with @subsys_id.
- */
-static inline struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
-						     int subsys_id)
-{
-	return cgrp->subsys[subsys_id];
-}
-
-/**
  * task_css_set_check - obtain a task's css_set with extra access conditions
  * @task: the task to obtain css_set for
  * @__c: extra condition expression to be passed to rcu_dereference_check()
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ead0088..f8739c7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -222,6 +222,19 @@ static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 
+/**
+ * cgroup_css - obtain a cgroup's css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @subsys_id: the subsystem of interest
+ *
+ * Return @cgrp's css (cgroup_subsys_state) associated with @subsys_id.
+ */
+static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
+					      int subsys_id)
+{
+	return cgrp->subsys[subsys_id];
+}
+
 /* convenient tests for these bits */
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
-- 
1.8.3.1

