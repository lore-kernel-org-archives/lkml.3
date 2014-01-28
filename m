Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaA1Xo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:44:56 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38492 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaA1XoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:44:12 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: rename cgroup_subsys->subsys_id to ->id
Date: Tue, 28 Jan 2014 18:43:59 -0500
Message-Id: <1390952641-15950-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390952641-15950-1-git-send-email-tj@kernel.org>
References: <1390952641-15950-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's no longer referenced outside cgroup core, so renaming is easy.
Let's rename it for consistency & brevity.

This patch is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  4 ++--
 kernel/cgroup.c        | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index cd6611e..198c7fc 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -548,7 +548,7 @@ int cgroup_taskset_size(struct cgroup_taskset *tset);
 	     (task) = cgroup_taskset_next((tset)))			\
 		if (!(skip_css) ||					\
 		    cgroup_taskset_cur_css((tset),			\
-			(skip_css)->ss->subsys_id) != (skip_css))
+			(skip_css)->ss->id) != (skip_css))
 
 /*
  * Control Group subsystem type.
@@ -592,7 +592,7 @@ struct cgroup_subsys {
 	bool warned_broken_hierarchy;
 
 	/* the following two fields are initialized automtically during boot */
-	int subsys_id;
+	int id;
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6734cfa..c753300 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -198,7 +198,7 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss)
 {
 	if (ss)
-		return rcu_dereference_check(cgrp->subsys[ss->subsys_id],
+		return rcu_dereference_check(cgrp->subsys[ss->id],
 					     lockdep_is_held(&cgroup_mutex));
 	else
 		return &cgrp->dummy_css;
@@ -3968,7 +3968,7 @@ static void css_release(struct percpu_ref *ref)
 	struct cgroup_subsys_state *css =
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
-	rcu_assign_pointer(css->cgroup->subsys[css->ss->subsys_id], NULL);
+	rcu_assign_pointer(css->cgroup->subsys[css->ss->id], NULL);
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 }
 
@@ -4000,7 +4000,7 @@ static int online_css(struct cgroup_subsys_state *css)
 	if (!ret) {
 		css->flags |= CSS_ONLINE;
 		css->cgroup->nr_css++;
-		rcu_assign_pointer(css->cgroup->subsys[ss->subsys_id], css);
+		rcu_assign_pointer(css->cgroup->subsys[ss->id], css);
 	}
 	return ret;
 }
@@ -4020,7 +4020,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	css->flags &= ~CSS_ONLINE;
 	css->cgroup->nr_css--;
-	RCU_INIT_POINTER(css->cgroup->subsys[ss->subsys_id], css);
+	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css);
 }
 
 /**
@@ -4051,7 +4051,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	init_css(css, ss, cgrp);
 
-	err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
+	err = cgroup_populate_dir(cgrp, 1 << ss->id);
 	if (err)
 		goto err_free;
 
@@ -4282,7 +4282,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
  */
 static void kill_css(struct cgroup_subsys_state *css)
 {
-	cgroup_clear_dir(css->cgroup, 1 << css->ss->subsys_id);
+	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
 
 	/*
 	 * Killing would put the base ref, but we need to keep it alive
@@ -4486,7 +4486,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * pointer to this state - since the subsystem is
 	 * newly registered, all tasks and hence the
 	 * init_css_set is in the subsystem's top cgroup. */
-	init_css_set.subsys[ss->subsys_id] = css;
+	init_css_set.subsys[ss->id] = css;
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
@@ -4526,14 +4526,14 @@ int __init cgroup_init_early(void)
 	list_add(&init_cgrp_cset_link.cgrp_link, &init_css_set.cgrp_links);
 
 	for_each_subsys(ss, i) {
-		WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->subsys_id,
+		WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->id,
 		     "invalid cgroup_subsys %d:%s css_alloc=%p css_free=%p name:id=%d:%s\n",
 		     i, cgroup_subsys_name[i], ss->css_alloc, ss->css_free,
-		     ss->subsys_id, ss->name);
+		     ss->id, ss->name);
 		WARN(strlen(cgroup_subsys_name[i]) > MAX_CGROUP_TYPE_NAMELEN,
 		     "cgroup_subsys_name %s too long\n", cgroup_subsys_name[i]);
 
-		ss->subsys_id = i;
+		ss->id = i;
 		ss->name = cgroup_subsys_name[i];
 
 		if (ss->early_init)
-- 
1.8.5.3

