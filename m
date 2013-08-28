Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3H1VEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:04:07 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52623 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3H1VEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:04:04 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] cgroup: factor out cgroup_subsys_state creation into create_css()
Date: Wed, 28 Aug 2013 17:03:47 -0400
Message-Id: <1377723829-22814-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377723829-22814-1-git-send-email-tj@kernel.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all opertations to create a css (cgroup_subsys_state) are
collected into a single loop in cgroup_create(), it's easy to factor
it out into its own function.  Factor out css creation into
create_css().  This makes the code easier to follow and will enable
decoupling css creation from cgroup creation which is necessary for
the planned unified hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 107 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 63 insertions(+), 44 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 20cd24b..cd53b49 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4385,6 +4385,68 @@ static void offline_css(struct cgroup_subsys_state *css)
 	RCU_INIT_POINTER(css->cgroup->subsys[ss->subsys_id], css);
 }
 
+/**
+ * create_css - create a cgroup_subsys_state
+ * @cgrp: the cgroup new css will be associated with
+ * @ss: the subsys of new css
+ *
+ * Create a new css associated with @cgrp - @ss pair.  On success, the new
+ * css is online and installed in @cgrp with all interface files created.
+ * Returns 0 on success, -errno on failure.
+ */
+static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
+{
+	struct cgroup *parent = cgrp->parent;
+	struct cgroup_subsys_state *css;
+	int err;
+
+	lockdep_assert_held(&cgrp->dentry->d_inode->i_mutex);
+	lockdep_assert_held(&cgroup_mutex);
+
+	css = ss->css_alloc(cgroup_css(parent, ss));
+	if (IS_ERR(css))
+		return PTR_ERR(css);
+
+	err = percpu_ref_init(&css->refcnt, css_release);
+	if (err)
+		goto err_free;
+
+	init_css(css, ss, cgrp);
+
+	if (ss->use_id) {
+		err = alloc_css_id(css);
+		if (err)
+			goto err_free;
+	}
+
+	err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
+	if (err)
+		goto err_free;
+
+	err = online_css(css);
+	if (err)
+		goto err_free;
+
+	dget(cgrp->dentry);
+	css_get(css->parent);
+
+	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
+	    parent->parent) {
+		pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
+			   current->comm, current->pid, ss->name);
+		if (!strcmp(ss->name, "memory"))
+			pr_warning("cgroup: \"memory\" requires setting use_hierarchy to 1 on the root.\n");
+		ss->warned_broken_hierarchy = true;
+	}
+
+	return 0;
+
+err_free:
+	percpu_ref_cancel_init(&css->refcnt);
+	ss->css_free(css);
+	return err;
+}
+
 /*
  * cgroup_create - create a cgroup
  * @parent: cgroup that will be parent of the new cgroup
@@ -4396,7 +4458,6 @@ static void offline_css(struct cgroup_subsys_state *css)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
-	struct cgroup_subsys_state *css = NULL;
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4487,47 +4548,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	/* let's create and online css's */
 	for_each_root_subsys(root, ss) {
-		css = ss->css_alloc(cgroup_css(parent, ss));
-		if (IS_ERR(css)) {
-			err = PTR_ERR(css);
-			css = NULL;
-			goto err_destroy;
-		}
-
-		err = percpu_ref_init(&css->refcnt, css_release);
-		if (err)
-			goto err_destroy;
-
-		init_css(css, ss, cgrp);
-
-		if (ss->use_id) {
-			err = alloc_css_id(css);
-			if (err)
-				goto err_destroy;
-		}
-
-		err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
-		if (err)
-			goto err_destroy;
-
-		err = online_css(css);
+		err = create_css(cgrp, ss);
 		if (err)
 			goto err_destroy;
-
-		dget(dentry);
-		css_get(css->parent);
-
-		/* mark it consumed for error path */
-		css = NULL;
-
-		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
-		    parent->parent) {
-			pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
-				   current->comm, current->pid, ss->name);
-			if (!strcmp(ss->name, "memory"))
-				pr_warning("cgroup: \"memory\" requires setting use_hierarchy to 1 on the root.\n");
-			ss->warned_broken_hierarchy = true;
-		}
 	}
 
 	mutex_unlock(&cgroup_mutex);
@@ -4548,10 +4571,6 @@ err_free_cgrp:
 	return err;
 
 err_destroy:
-	if (css) {
-		percpu_ref_cancel_init(&css->refcnt);
-		css->ss->css_free(css);
-	}
 	cgroup_destroy_locked(cgrp);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&dentry->d_inode->i_mutex);
-- 
1.8.3.1

