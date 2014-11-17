Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaKQU7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:59:01 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:39066 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaKQU66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:58:58 -0500
Date: Mon, 17 Nov 2014 15:58:55 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3 cgroup/for-3.19] cgroup: implement cgroup_get_e_css()
Message-ID: <20141117205855.GC23126@htj.dyndns.org>
References: <20141117205652.GA23126@htj.dyndns.org>
 <20141117205734.GB23126@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117205734.GB23126@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement cgroup_get_e_css() which finds and gets the effective css
for the specified cgroup and subsystem combination.  This function
always returns a valid pinned css.  This will be used by cgroup
writeback support.

While at it, add comment to cgroup_e_css() to explain why that
function is different from cgroup_get_e_css() and has to test
cgrp->child_subsys_mask instead of cgroup_css(cgrp, ss).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -910,6 +910,8 @@ void css_task_iter_end(struct css_task_i
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
+struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
+					     struct cgroup_subsys *ss);
 struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss);
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -277,6 +277,10 @@ static struct cgroup_subsys_state *cgrou
 	if (!(cgrp->root->subsys_mask & (1 << ss->id)))
 		return NULL;
 
+	/*
+	 * This function is used while updating css associations and thus
+	 * can't test the csses directly.  Use ->child_subsys_mask.
+	 */
 	while (cgroup_parent(cgrp) &&
 	       !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ss->id)))
 		cgrp = cgroup_parent(cgrp);
@@ -284,6 +288,39 @@ static struct cgroup_subsys_state *cgrou
 	return cgroup_css(cgrp, ss);
 }
 
+/**
+ * cgroup_get_e_css - get a cgroup's effective css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @ss: the subsystem of interest
+ *
+ * Find and get the effective css of @cgrp for @ss.  The effective css is
+ * defined as the matching css of the nearest ancestor including self which
+ * has @ss enabled.  If @ss is not mounted on the hierarchy @cgrp is on,
+ * the root css is returned, so this function always returns a valid css.
+ * The returned css must be put using css_put().
+ */
+struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
+					     struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+
+	do {
+		css = cgroup_css(cgrp, ss);
+
+		if (css && css_tryget_online(css))
+			goto out_unlock;
+		cgrp = cgroup_parent(cgrp);
+	} while (cgrp);
+
+	css = init_css_set.subsys[ss->id];
+	css_get(css);
+out_unlock:
+	rcu_read_unlock();
+	return css;
+}
+
 /* convenient tests for these bits */
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
