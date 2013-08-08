Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966478Ab3HHUQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:16:50 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:34558 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966423Ab3HHUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:16 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] cgroup: move cgroup->subsys[] assignment to online_css()
Date: Thu,  8 Aug 2013 16:13:45 -0400
Message-Id: <1375992831-4650-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, css (cgroup_subsys_state) lifetime is tied to that of the
associated cgroup.  With the planned unified hierarchy, css's will be
dynamically created and destroyed within the lifetime of a cgroup.  To
enable such usages, css's will be individually RCU protected instead
of being tied to the cgroup.

In preparation, this patch moves cgroup->subsys[] assignment from
init_css() to online_css().  As this means that a newly initialized
css should be remembered separately and that cgroup_css() returns NULL
between init and online, cgroup_create() is updated so that it stores
newly created css's in a local array css_ar[] and
cgroup_init/load_subsys() are updated to use local variable @css
instead of using cgroup_css().  This change also slightly simplifies
error path of cgroup_create().

While this patch changes when cgroup->subsys[] is initialized, this
change isn't visible to subsystems or userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2a93bae..06ba664 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4321,7 +4321,6 @@ static void init_css(struct cgroup_subsys_state *css, struct cgroup_subsys *ss,
 		css->flags |= CSS_ROOT;
 
 	BUG_ON(cgroup_css(cgrp, ss->subsys_id));
-	rcu_assign_pointer(cgrp->subsys[ss->subsys_id], css);
 }
 
 /* invoke ->css_online() on a new CSS and mark it online if successful */
@@ -4334,8 +4333,10 @@ static int online_css(struct cgroup_subsys_state *css)
 
 	if (ss->css_online)
 		ret = ss->css_online(css);
-	if (!ret)
+	if (!ret) {
 		css->flags |= CSS_ONLINE;
+		rcu_assign_pointer(css->cgroup->subsys[ss->subsys_id], css);
+	}
 	return ret;
 }
 
@@ -4366,6 +4367,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
+	struct cgroup_subsys_state *css_ar[CGROUP_SUBSYS_COUNT] = { };
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4433,12 +4435,11 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			err = PTR_ERR(css);
 			goto err_free_all;
 		}
+		css_ar[ss->subsys_id] = css;
 
 		err = percpu_ref_init(&css->refcnt, css_release);
-		if (err) {
-			ss->css_free(css);
+		if (err)
 			goto err_free_all;
-		}
 
 		init_css(css, ss, cgrp);
 
@@ -4469,7 +4470,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	dget(parent->dentry);
 
 	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
+		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
 
 		/* each css holds a ref to the cgroup and the parent css */
 		dget(dentry);
@@ -4507,7 +4508,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 err_free_all:
 	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
+		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
 
 		if (css) {
 			percpu_ref_cancel_init(&css->refcnt);
@@ -4789,7 +4790,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	BUG_ON(online_css(cgroup_css(cgroup_dummy_top, ss->subsys_id)));
+	BUG_ON(online_css(css));
 
 	mutex_unlock(&cgroup_mutex);
 
@@ -4893,7 +4894,7 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	ret = online_css(cgroup_css(cgroup_dummy_top, ss->subsys_id));
+	ret = online_css(css);
 	if (ret)
 		goto err_unload;
 
-- 
1.8.3.1

