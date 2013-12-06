Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab3LFU3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:29:24 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:55658 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab3LFU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:28:02 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, vdavydov@parallels.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cgroup: combine css handling loops in cgroup_create()
Date: Fri,  6 Dec 2013 15:27:49 -0500
Message-Id: <1386361672-27791-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386361672-27791-1-git-send-email-tj@kernel.org>
References: <1386361672-27791-1-git-send-email-tj@kernel.org>
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
Acked-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 30a2670..39e2295 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4084,7 +4084,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
-	struct cgroup_subsys_state *css_ar[CGROUP_SUBSYS_COUNT] = { };
+	struct cgroup_subsys_state *css = NULL;
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4173,26 +4173,20 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
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
 			goto err_destroy;
 
 		init_css(css, ss, cgrp);
-	}
-
-	/* creation succeeded, notify subsystems */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
 
 		err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
 		if (err)
@@ -4202,12 +4196,11 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
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
@@ -4237,13 +4230,9 @@ err_free_cgrp:
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
1.8.4.2

