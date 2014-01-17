Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaAQSMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:12:46 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57770 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaAQSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:12:07 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] cgroup: rename cgroup_subsys->subsys_id to ->id
Date: Fri, 17 Jan 2014 13:11:55 -0500
Message-Id: <1389982317-22225-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389982317-22225-1-git-send-email-tj@kernel.org>
References: <1389982317-22225-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's no longer referenced outside cgroup core, so renaming is easy.
Let's rename it for consistency & brevity.

This patch is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  4 ++--
 kernel/cgroup.c        | 18 +++++++++---------
 2 files changed, 11 insertions(+), 11 deletions(-)

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
index aace2ee..3b2fda0 100644
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
@@ -4002,7 +4002,7 @@ static int online_css(struct cgroup_subsys_state *css)
 	if (!ret) {
 		css->flags |= CSS_ONLINE;
 		css->cgroup->nr_css++;
-		rcu_assign_pointer(css->cgroup->subsys[ss->subsys_id], css);
+		rcu_assign_pointer(css->cgroup->subsys[ss->id], css);
 	}
 	return ret;
 }
@@ -4022,7 +4022,7 @@ static void offline_css(struct cgroup_subsys_state *css)
 
 	css->flags &= ~CSS_ONLINE;
 	css->cgroup->nr_css--;
-	RCU_INIT_POINTER(css->cgroup->subsys[ss->subsys_id], css);
+	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css);
 }
 
 /**
@@ -4053,7 +4053,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	init_css(css, ss, cgrp);
 
-	err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
+	err = cgroup_populate_dir(cgrp, 1 << ss->id);
 	if (err)
 		goto err_free;
 
@@ -4280,7 +4280,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
  */
 static void kill_css(struct cgroup_subsys_state *css)
 {
-	cgroup_clear_dir(css->cgroup, 1 << css->ss->subsys_id);
+	cgroup_clear_dir(css->cgroup, 1 << css->ss->id);
 
 	/*
 	 * Killing would put the base ref, but we need to keep it alive
@@ -4492,7 +4492,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	 * pointer to this state - since the subsystem is
 	 * newly registered, all tasks and hence the
 	 * init_css_set is in the subsystem's top cgroup. */
-	init_css_set.subsys[ss->subsys_id] = css;
+	init_css_set.subsys[ss->id] = css;
 
 	need_forkexit_callback |= ss->fork || ss->exit;
 
@@ -4532,14 +4532,14 @@ int __init cgroup_init_early(void)
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
1.8.4.2

