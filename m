Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3H1VEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:04:49 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:59672 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3H1VED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:04:03 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] cgroup: combine css handling loops in cgroup_create()
Date: Wed, 28 Aug 2013 17:03:46 -0400
Message-Id: <1377723829-22814-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377723829-22814-1-git-send-email-tj@kernel.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that css operations in cgroup_create() are back-to-back, there
isn't much point in allocating css's in one loop and onlining them in
another.  Merge the two loops so that a css is allocated and onlined
on each iteration.

css_ar[] is no longer necessary and replaced with a single pointer.
This also simplifies the error handling path.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d41ddab..20cd24b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4396,7 +4396,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
-	struct cgroup_subsys_state *css_ar[CGROUP_SUBSYS_COUNT] = { };
+	struct cgroup_subsys_state *css = NULL;
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4485,15 +4485,14 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	if (err)
 		goto err_destroy;
 
+	/* let's create and online css's */
 	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css;
-
 		css = ss->css_alloc(cgroup_css(parent, ss));
 		if (IS_ERR(css)) {
 			err = PTR_ERR(css);
+			css = NULL;
 			goto err_destroy;
 		}
-		css_ar[ss->subsys_id] = css;
 
 		err = percpu_ref_init(&css->refcnt, css_release);
 		if (err)
@@ -4506,11 +4505,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			if (err)
 				goto err_destroy;
 		}
-	}
-
-	/* creation succeeded, notify subsystems */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
 
 		err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
 		if (err)
@@ -4520,12 +4514,11 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		if (err)
 			goto err_destroy;
 
-		/* each css holds a ref to the cgroup's dentry and parent css */
 		dget(dentry);
 		css_get(css->parent);
 
 		/* mark it consumed for error path */
-		css_ar[ss->subsys_id] = NULL;
+		css = NULL;
 
 		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 		    parent->parent) {
@@ -4555,13 +4548,9 @@ err_free_cgrp:
 	return err;
 
 err_destroy:
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
-
-		if (css) {
-			percpu_ref_cancel_init(&css->refcnt);
-			ss->css_free(css);
-		}
+	if (css) {
+		percpu_ref_cancel_init(&css->refcnt);
+		css->ss->css_free(css);
 	}
 	cgroup_destroy_locked(cgrp);
 	mutex_unlock(&cgroup_mutex);
-- 
1.8.3.1

