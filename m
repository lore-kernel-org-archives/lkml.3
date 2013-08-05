Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3HERIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:08:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46679 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3HERIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:08:39 -0400
Date: Mon, 5 Aug 2013 13:08:34 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] cgroup: make __cgroup_from_dentry() and
 __cgroup_dput() global
Message-ID: <20130805170834.GA23751@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375632446-2581-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb06a03636eb8477ea034780c37463a086112115 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 5 Aug 2013 12:00:23 -0400

cgroup_event will no longer be supported as cgroup generic mechanism
and be moved to memcg.  To enable the relocation, implement and expose
__cgroup_from_dentry() which combines cgroup file dentry -> croup
mapping and cft discovery, and prefix cgroup_dput() with __ and make
it global.

These functions exist and are exported only to enable moving
cgroup_event implementation to memcg and shouldn't grow any new users
and thus the __ prefix.

This patch is pure reorganization and doesn't introduce any functional
difference.

v2: The original patch had EXPORT_SYMBOL_GPL() for the two functions
    because I for some reason thought that memcg could be built as
    module.  Removed as suggested by Li Zefan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  4 ++++
 kernel/cgroup.c        | 29 +++++++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 30d6ec4..2ac1021 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -923,6 +923,10 @@ bool css_is_ancestor(struct cgroup_subsys_state *cg,
 unsigned short css_id(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
+/* do not add new users of the following two functions */
+struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp);
+void __cgroup_dput(struct cgroup *cgrp);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1b87e2b..568d031 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2661,14 +2661,16 @@ static struct dentry *cgroup_lookup(struct inode *dir, struct dentry *dentry, un
 	return NULL;
 }
 
-/*
- * Check if a file is a control file
- */
-static inline struct cftype *__file_cft(struct file *file)
+/* do not add new users */
+struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp)
 {
-	if (file_inode(file)->i_fop != &cgroup_file_operations)
-		return ERR_PTR(-EINVAL);
-	return __d_cft(file->f_dentry);
+	if (!dentry->d_inode ||
+	    dentry->d_inode->i_op != &cgroup_file_inode_operations)
+		return NULL;
+
+	if (cftp)
+		*cftp = __d_cft(dentry);
+	return __d_cgrp(dentry->d_parent);
 }
 
 static int cgroup_create_file(struct dentry *dentry, umode_t mode,
@@ -3953,7 +3955,7 @@ static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
  *
  * That's why we hold a reference before dput() and drop it right after.
  */
-static void cgroup_dput(struct cgroup *cgrp)
+void __cgroup_dput(struct cgroup *cgrp)
 {
 	struct super_block *sb = cgrp->root->sb;
 
@@ -3983,7 +3985,7 @@ static void cgroup_event_remove(struct work_struct *work)
 
 	eventfd_ctx_put(event->eventfd);
 	kfree(event);
-	cgroup_dput(cgrp);
+	__cgroup_dput(cgrp);
 }
 
 /*
@@ -4095,9 +4097,9 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 	if (ret < 0)
 		goto out_put_cfile;
 
-	event->cft = __file_cft(cfile);
-	if (IS_ERR(event->cft)) {
-		ret = PTR_ERR(event->cft);
+	cgrp_cfile = __cgroup_from_dentry(cfile->f_dentry, &event->cft);
+	if (!cgrp_cfile) {
+		ret = -EINVAL;
 		goto out_put_cfile;
 	}
 
@@ -4105,7 +4107,6 @@ static int cgroup_write_event_control(struct cgroup_subsys_state *css,
 	 * The file to be monitored must be in the same cgroup as
 	 * cgroup.event_control is.
 	 */
-	cgrp_cfile = __d_cgrp(cfile->f_dentry->d_parent);
 	if (cgrp_cfile != cgrp) {
 		ret = -EINVAL;
 		goto out_put_cfile;
@@ -4272,7 +4273,7 @@ static void css_dput_fn(struct work_struct *work)
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, dput_work);
 
-	cgroup_dput(css->cgroup);
+	__cgroup_dput(css->cgroup);
 }
 
 static void css_release(struct percpu_ref *ref)
-- 
1.8.3.1

