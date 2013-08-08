Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966488Ab3HHUO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:14:28 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:44166 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966466Ab3HHUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:23 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/14] cgroup: factor out kill_css()
Date: Thu,  8 Aug 2013 16:13:49 -0400
Message-Id: <1375992831-4650-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out css ref killing from cgroup_destroy_locked() into
kill_css().  We're gonna add more to the path and the factored out
function will eventually be called from other places too.

While at it, replace open coded percpu_ref_get() with css_get() for
consistency.  This shouldn't cause any functional difference as the
function is not used for root cgroups.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 58 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index da2c8e3..da5f5c2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4592,6 +4592,36 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 }
 
 /**
+ * kill_css - destroy a css
+ * @css: css to destroy
+ *
+ * This function initiates destruction of @css by putting its base
+ * reference.  ->css_offline() will be invoked asynchronously once
+ * css_tryget() is guaranteed to fail and when the reference count reaches
+ * zero, @css will be released.
+ */
+static void kill_css(struct cgroup_subsys_state *css)
+{
+	/*
+	 * Killing would put the base ref, but we need to keep it alive
+	 * until after ->css_offline().
+	 */
+	css_get(css);
+
+	/*
+	 * cgroup core guarantees that, by the time ->css_offline() is
+	 * invoked, no new css reference will be given out via
+	 * css_tryget().  We can't simply call percpu_ref_kill() and
+	 * proceed to offlining css's because percpu_ref_kill() doesn't
+	 * guarantee that the ref is seen as killed on all CPUs on return.
+	 *
+	 * Use percpu_ref_kill_and_confirm() to get notifications as each
+	 * css is confirmed to be seen as killed on all CPUs.
+	 */
+	percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
+}
+
+/**
  * cgroup_destroy_locked - the first stage of cgroup destruction
  * @cgrp: cgroup to be destroyed
  *
@@ -4637,30 +4667,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		return -EBUSY;
 
 	/*
-	 * Block new css_tryget() by killing css refcnts.  cgroup core
-	 * guarantees that, by the time ->css_offline() is invoked, no new
-	 * css reference will be given out via css_tryget().  We can't
-	 * simply call percpu_ref_kill() and proceed to offlining css's
-	 * because percpu_ref_kill() doesn't guarantee that the ref is seen
-	 * as killed on all CPUs on return.
-	 *
-	 * Use percpu_ref_kill_and_confirm() to get notifications as each
-	 * css is confirmed to be seen as killed on all CPUs.
-	 * cgroup_destroy_css_killed() will be invoked to perform the rest
-	 * of destruction once the percpu refs of all css's are confirmed
-	 * to be killed.
+	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
+	 * will be invoked to perform the rest of destruction once the
+	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	for_each_root_subsys(cgrp->root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
-
-		/*
-		 * Killing would put the base ref, but we need to keep it
-		 * alive until after ->css_offline.
-		 */
-		percpu_ref_get(&css->refcnt);
-
-		percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn);
-	}
+	for_each_root_subsys(cgrp->root, ss)
+		kill_css(cgroup_css(cgrp, ss->subsys_id));
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
-- 
1.8.3.1

