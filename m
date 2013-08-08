Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966470Ab3HHUOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:14:22 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:58639 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966439Ab3HHUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:18 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] cgroup: bounce cgroup_subsys_state ref kill confirmation to a work item
Date: Thu,  8 Aug 2013 16:13:46 -0400
Message-Id: <1375992831-4650-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css (cgroup_subsys_state) offlining, which requires process context,
will be moved to ref kill confirmation.  In preparation, bounce
css_killed handling through css->destroy_work.

css_ref_killed_fn() is renamed to css_killed_ref_fn() so that it's
consistent with the new css_killed_work_fn().

This patch adds an additional work item bouncing but doesn't change
the actual logic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 06ba664..88b1095 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4551,12 +4551,27 @@ static void cgroup_css_killed(struct cgroup *cgrp)
 	schedule_work(&cgrp->destroy_work);
 }
 
-static void css_ref_killed_fn(struct percpu_ref *ref)
+/*
+ * This is called when the refcnt of a css is confirmed to be killed.
+ * css_tryget() is now guaranteed to fail.
+ */
+static void css_killed_work_fn(struct work_struct *work)
+{
+	struct cgroup_subsys_state *css =
+		container_of(work, struct cgroup_subsys_state, destroy_work);
+	struct cgroup *cgrp = css->cgroup;
+
+	cgroup_css_killed(cgrp);
+}
+
+/* css kill confirmation processing requires process context, bounce */
+static void css_killed_ref_fn(struct percpu_ref *ref)
 {
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	cgroup_css_killed(css->cgroup);
+	INIT_WORK(&css->destroy_work, css_killed_work_fn);
+	schedule_work(&css->destroy_work);
 }
 
 /**
@@ -4630,7 +4645,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		percpu_ref_get(&css->refcnt);
 
 		atomic_inc(&cgrp->css_kill_cnt);
-		percpu_ref_kill_and_confirm(&css->refcnt, css_ref_killed_fn);
+		percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
 	}
 	cgroup_css_killed(cgrp);
 
-- 
1.8.3.1

