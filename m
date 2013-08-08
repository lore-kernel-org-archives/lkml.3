Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966396Ab3HHUOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:14:11 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:46841 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966362Ab3HHUOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:08 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/14] cgroup: add cgroup_subsys_state->parent
Date: Thu,  8 Aug 2013 16:13:40 -0400
Message-Id: <1375992831-4650-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the planned unified hierarchy, css's (cgroup_subsys_state) will
be RCU protected and allowed to be attached and detached dynamically
over the course of a cgroup's lifetime.  This means that css's will
stay accessible after being detached from its cgroup - the matching
pointer in cgroup->subsys[] cleared - for ref draining and RCU grace
period.

cgroup core still wants to guarantee that the parent css is never
destroyed before its children and css_parent() always returns the
parent regardless of the state of the child css as long as it's
accessible.

This patch makes css's hold onto their parents and adds css->parent so
that the parent css is never detroyed before its children and can be
determined without consulting the cgroups.

cgroup->dummy_css is also updated to point to the parent dummy_css;
however, it doesn't need to worry about object lifetime as the parent
cgroup is already pinned by the child.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 13 ++++---------
 kernel/cgroup.c        | 18 +++++++++++++++---
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 12d66fe..8a5dc91 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -75,6 +75,9 @@ struct cgroup_subsys_state {
 	/* reference count - access via css_[try]get() and css_put() */
 	struct percpu_ref refcnt;
 
+	/* the parent css */
+	struct cgroup_subsys_state *parent;
+
 	unsigned long flags;
 	/* ID for this css, if possible */
 	struct css_id __rcu *id;
@@ -666,15 +669,7 @@ struct cgroup_subsys {
 static inline
 struct cgroup_subsys_state *css_parent(struct cgroup_subsys_state *css)
 {
-	struct cgroup *parent_cgrp = css->cgroup->parent;
-
-	if (!parent_cgrp)
-		return NULL;
-
-	if (css->ss)
-		return parent_cgrp->subsys[css->ss->subsys_id];
-	else
-		return &parent_cgrp->dummy_css;
+	return css->parent;
 }
 
 /**
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0b28097..5c6dd7e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4264,6 +4264,9 @@ static void css_free_work_fn(struct work_struct *work)
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 
+	if (css->parent)
+		css_put(css->parent);
+
 	cgroup_dput(css->cgroup);
 }
 
@@ -4290,8 +4293,12 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 	css->ss = ss;
 	css->flags = 0;
 	css->id = NULL;
-	if (cgrp == cgroup_dummy_top)
+
+	if (cgrp->parent)
+		css->parent = cgroup_css(cgrp->parent, ss->subsys_id);
+	else
 		css->flags |= CSS_ROOT;
+
 	BUG_ON(cgroup_css(cgrp, ss->subsys_id));
 	cgrp->subsys[ss->subsys_id] = css;
 }
@@ -4388,6 +4395,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	cgrp->dentry = dentry;
 
 	cgrp->parent = parent;
+	cgrp->dummy_css.parent = &parent->dummy_css;
 	cgrp->root = parent->root;
 
 	if (notify_on_release(parent))
@@ -4436,9 +4444,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
 
-	/* each css holds a ref to the cgroup's dentry */
-	for_each_root_subsys(root, ss)
+	/* each css holds a ref to the cgroup's dentry and the parent css */
+	for_each_root_subsys(root, ss) {
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
+
 		dget(dentry);
+		percpu_ref_get(&css->parent->refcnt);
+	}
 
 	/* hold a ref to the parent's dentry */
 	dget(parent->dentry);
-- 
1.8.3.1

