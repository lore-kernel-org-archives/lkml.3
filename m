Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966502Ab3HHUOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:14:31 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:38918 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966439Ab3HHUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:24 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/14] cgroup: move subsys file removal to kill_css()
Date: Thu,  8 Aug 2013 16:13:50 -0400
Message-Id: <1375992831-4650-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the planned unified hierarchy, individual css's will be created
and destroyed dynamically across the lifetime of a cgroup.  To enable
such usages, css destruction is being decoupled from cgroup
destruction.  This patch moves subsys file removal from
cgroup_destroy_locked() to kill_css().

While this changes the order of destruction operations, the changes
shouldn't be noticeable to cgroup subsystems or userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index da5f5c2..d99ec53 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4595,13 +4595,15 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
  * kill_css - destroy a css
  * @css: css to destroy
  *
- * This function initiates destruction of @css by putting its base
- * reference.  ->css_offline() will be invoked asynchronously once
- * css_tryget() is guaranteed to fail and when the reference count reaches
- * zero, @css will be released.
+ * This function initiates destruction of @css by removing cgroup interface
+ * files and putting its base reference.  ->css_offline() will be invoked
+ * asynchronously once css_tryget() is guaranteed to fail and when the
+ * reference count reaches zero, @css will be released.
  */
 static void kill_css(struct cgroup_subsys_state *css)
 {
+	cgroup_clear_dir(css->cgroup, 1 << css->ss->subsys_id);
+
 	/*
 	 * Killing would put the base ref, but we need to keep it alive
 	 * until after ->css_offline().
@@ -4699,10 +4701,10 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		cgroup_destroy_css_killed(cgrp);
 
 	/*
-	 * Clear and remove @cgrp directory.  The removal puts the base ref
-	 * but we aren't quite done with @cgrp yet, so hold onto it.
+	 * Clear the base files and remove @cgrp directory.  The removal
+	 * puts the base ref but we aren't quite done with @cgrp yet, so
+	 * hold onto it.
 	 */
-	cgroup_clear_dir(cgrp, cgrp->root->subsys_mask);
 	cgroup_addrm_files(cgrp, cgroup_base_files, false);
 	dget(d);
 	cgroup_d_remove_dir(d);
-- 
1.8.3.1

