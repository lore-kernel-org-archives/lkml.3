Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbaEIVeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:34:03 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55956 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbaEIVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:47 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/14] cgroup: link all cgroup_subsys_states in their sibling lists
Date: Fri,  9 May 2014 17:31:24 -0400
Message-Id: <1399671091-23867-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, while all csses have ->children and ->sibling, only the
self csses of cgroups make use of them.  This patch makes all other
csses to link themselves on the sibling lists too.  This will be used
to update css iteration.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3d6c0aa..6930b78 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4137,19 +4137,21 @@ static void css_release_work_fn(struct work_struct *work)
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
+	mutex_lock(&cgroup_mutex);
+
+	list_del_rcu(&css->sibling);
+
 	if (ss) {
 		/* css release path */
 		cgroup_idr_remove(&ss->css_idr, css->id);
 	} else {
 		/* cgroup release path */
-		mutex_lock(&cgroup_mutex);
-		list_del_rcu(&cgrp->self.sibling);
-		mutex_unlock(&cgroup_mutex);
-
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
 	}
 
+	mutex_unlock(&cgroup_mutex);
+
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
@@ -4229,12 +4231,13 @@ static void offline_css(struct cgroup_subsys_state *css)
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
+	struct cgroup_subsys_state *parent_css = cgroup_css(parent, ss);
 	struct cgroup_subsys_state *css;
 	int err;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	css = ss->css_alloc(cgroup_css(parent, ss));
+	css = ss->css_alloc(parent_css);
 	if (IS_ERR(css))
 		return PTR_ERR(css);
 
@@ -4254,11 +4257,12 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 		goto err_free_id;
 
 	/* @css is ready to be brought online now, make it visible */
+	list_add_tail_rcu(&css->sibling, &parent_css->children);
 	cgroup_idr_replace(&ss->css_idr, css, css->id);
 
 	err = online_css(css);
 	if (err)
-		goto err_clear_dir;
+		goto err_list_del;
 
 	if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 	    cgroup_parent(parent)) {
@@ -4271,7 +4275,8 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	return 0;
 
-err_clear_dir:
+err_list_del:
+	list_del_rcu(&css->sibling);
 	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
 err_free_id:
 	cgroup_idr_remove(&ss->css_idr, css->id);
-- 
1.9.0

