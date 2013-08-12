Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3HLNkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:40:35 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:55160 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab3HLNkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:40:32 -0400
Date: Mon, 12 Aug 2013 09:40:28 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/14] cgroup: reorganize css init / exit paths
Message-ID: <20130812134028.GB15892@htj.dyndns.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
 <1375992831-4650-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375992831-4650-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css (cgroup_subsys_state) lifetime management is about to be
restructured.  In prepartion, make the following mostly trivial
changes.

* init_cgroup_css() is renamed to init_css() so that it's consistent
  with other css handling functions.

* alloc_css_id(), online_css() and offline_css() updated to take @css
  instead of cgroups and subsys IDs.

This patch doesn't make any functional changes.

v2: v1 merged two for_each_root_subsys() loops in cgroup_create() but
    Li Zefan pointed out that it breaks error path.  Dropped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
This causes some offset warnings for later patches but nothing patch
can't handle.  The git branch is updated accordingly.

Thanks.

 kernel/cgroup.c |   50 +++++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -838,8 +838,7 @@ static struct backing_dev_info cgroup_ba
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
-static int alloc_css_id(struct cgroup_subsys *ss,
-			struct cgroup *parent, struct cgroup *child);
+static int alloc_css_id(struct cgroup_subsys_state *child_css);
 
 static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
 {
@@ -4308,9 +4307,8 @@ static void css_release(struct percpu_re
 	schedule_work(&css->destroy_work);
 }
 
-static void init_cgroup_css(struct cgroup_subsys_state *css,
-			       struct cgroup_subsys *ss,
-			       struct cgroup *cgrp)
+static void init_css(struct cgroup_subsys_state *css, struct cgroup_subsys *ss,
+		     struct cgroup *cgrp)
 {
 	css->cgroup = cgrp;
 	css->ss = ss;
@@ -4327,9 +4325,9 @@ static void init_cgroup_css(struct cgrou
 }
 
 /* invoke ->css_online() on a new CSS and mark it online if successful */
-static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
+static int online_css(struct cgroup_subsys_state *css)
 {
-	struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
+	struct cgroup_subsys *ss = css->ss;
 	int ret = 0;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -4342,9 +4340,9 @@ static int online_css(struct cgroup_subs
 }
 
 /* if the CSS is online, invoke ->css_offline() on it and mark it offline */
-static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
+static void offline_css(struct cgroup_subsys_state *css)
 {
-	struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
+	struct cgroup_subsys *ss = css->ss;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -4442,10 +4440,10 @@ static long cgroup_create(struct cgroup
 			goto err_free_all;
 		}
 
-		init_cgroup_css(css, ss, cgrp);
+		init_css(css, ss, cgrp);
 
 		if (ss->use_id) {
-			err = alloc_css_id(ss, parent, cgrp);
+			err = alloc_css_id(css);
 			if (err)
 				goto err_free_all;
 		}
@@ -4480,7 +4478,9 @@ static long cgroup_create(struct cgroup
 
 	/* creation succeeded, notify subsystems */
 	for_each_root_subsys(root, ss) {
-		err = online_css(ss, cgrp);
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss->subsys_id);
+
+		err = online_css(css);
 		if (err)
 			goto err_destroy;
 
@@ -4700,7 +4700,7 @@ static void cgroup_offline_fn(struct wor
 	 * initate destruction.
 	 */
 	for_each_root_subsys(cgrp->root, ss)
-		offline_css(ss, cgrp);
+		offline_css(cgroup_css(cgrp, ss->subsys_id));
 
 	/*
 	 * Put the css refs from cgroup_destroy_locked().  Each css holds
@@ -4778,7 +4778,7 @@ static void __init cgroup_init_subsys(st
 	css = ss->css_alloc(cgroup_css(cgroup_dummy_top, ss->subsys_id));
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
-	init_cgroup_css(css, ss, cgroup_dummy_top);
+	init_css(css, ss, cgroup_dummy_top);
 
 	/* Update the init_css_set to contain a subsys
 	 * pointer to this state - since the subsystem is
@@ -4793,7 +4793,7 @@ static void __init cgroup_init_subsys(st
 	 * need to invoke fork callbacks here. */
 	BUG_ON(!list_empty(&init_task.tasks));
 
-	BUG_ON(online_css(ss, cgroup_dummy_top));
+	BUG_ON(online_css(cgroup_css(cgroup_dummy_top, ss->subsys_id)));
 
 	mutex_unlock(&cgroup_mutex);
 
@@ -4866,8 +4866,8 @@ int __init_or_module cgroup_load_subsys(
 	ss->root = &cgroup_dummy_root;
 
 	/* our new subsystem will be attached to the dummy hierarchy. */
-	init_cgroup_css(css, ss, cgroup_dummy_top);
-	/* init_idr must be after init_cgroup_css because it sets css->id. */
+	init_css(css, ss, cgroup_dummy_top);
+	/* init_idr must be after init_css() because it sets css->id. */
 	if (ss->use_id) {
 		ret = cgroup_init_idr(ss, css);
 		if (ret)
@@ -4897,7 +4897,7 @@ int __init_or_module cgroup_load_subsys(
 	}
 	write_unlock(&css_set_lock);
 
-	ret = online_css(ss, cgroup_dummy_top);
+	ret = online_css(cgroup_css(cgroup_dummy_top, ss->subsys_id));
 	if (ret)
 		goto err_unload;
 
@@ -4936,7 +4936,7 @@ void cgroup_unload_subsys(struct cgroup_
 
 	mutex_lock(&cgroup_mutex);
 
-	offline_css(ss, cgroup_dummy_top);
+	offline_css(cgroup_css(cgroup_dummy_top, ss->subsys_id));
 
 	if (ss->use_id)
 		idr_destroy(&ss->idr);
@@ -5588,20 +5588,16 @@ static int __init_or_module cgroup_init_
 	return 0;
 }
 
-static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
-			struct cgroup *child)
+static int alloc_css_id(struct cgroup_subsys_state *child_css)
 {
-	int subsys_id, i, depth = 0;
-	struct cgroup_subsys_state *parent_css, *child_css;
+	struct cgroup_subsys_state *parent_css = css_parent(child_css);
 	struct css_id *child_id, *parent_id;
+	int i, depth;
 
-	subsys_id = ss->subsys_id;
-	parent_css = cgroup_css(parent, subsys_id);
-	child_css = cgroup_css(child, subsys_id);
 	parent_id = rcu_dereference_protected(parent_css->id, true);
 	depth = parent_id->depth + 1;
 
-	child_id = get_new_cssid(ss, depth);
+	child_id = get_new_cssid(child_css->ss, depth);
 	if (IS_ERR(child_id))
 		return PTR_ERR(child_id);
 
