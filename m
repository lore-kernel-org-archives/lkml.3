Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966427Ab3HHUOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:14:16 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:51539 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966392Ab3HHUOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:11 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] cgroup: make cgroup_file_open() rcu_read_lock() around cgroup_css() and add cfent->css
Date: Thu,  8 Aug 2013 16:13:42 -0400
Message-Id: <1375992831-4650-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the planned unified hierarchy, each css (cgroup_subsys_state) will
be RCU protected so that it can be created and destroyed individually
while allowing RCU accesses, and cgroup_css() will soon require either
holding cgroup_mutex or RCU read lock.

This patch updates cgroup_file_open() such that it acquires the
associated css under rcu_read_lock().  While cgroup_file_css() usages
in other file operations are safe due to the reference from open,
cgroup_css() wouldn't know that and will still trigger warnings.  It'd
be cleanest to store the acquired css in file->prvidate_data for
further file operations but that's already used by seqfile.  This
patch instead adds cfent->css to cache the associated css.  Note that
while this field is initialized during cfe init, it should only be
considered valid while the file is open.

This patch doesn't change visible behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 48 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cbb6314..d63beff 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -117,6 +117,7 @@ struct cfent {
 	struct list_head		node;
 	struct dentry			*dentry;
 	struct cftype			*type;
+	struct cgroup_subsys_state	*css;
 
 	/* file xattrs */
 	struct simple_xattrs		xattrs;
@@ -2301,17 +2302,6 @@ static int cgroup_sane_behavior_show(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-/* return the css for the given cgroup file */
-static struct cgroup_subsys_state *cgroup_file_css(struct cfent *cfe)
-{
-	struct cftype *cft = cfe->type;
-	struct cgroup *cgrp = __d_cgrp(cfe->dentry->d_parent);
-
-	if (cft->ss)
-		return cgroup_css(cgrp, cft->ss->subsys_id);
-	return &cgrp->dummy_css;
-}
-
 /* A buffer size big enough for numbers or short strings */
 #define CGROUP_LOCAL_BUFFER_SIZE 64
 
@@ -2388,7 +2378,7 @@ static ssize_t cgroup_file_write(struct file *file, const char __user *buf,
 {
 	struct cfent *cfe = __d_cfe(file->f_dentry);
 	struct cftype *cft = __d_cft(file->f_dentry);
-	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
+	struct cgroup_subsys_state *css = cfe->css;
 
 	if (cft->write)
 		return cft->write(css, cft, file, buf, nbytes, ppos);
@@ -2430,7 +2420,7 @@ static ssize_t cgroup_file_read(struct file *file, char __user *buf,
 {
 	struct cfent *cfe = __d_cfe(file->f_dentry);
 	struct cftype *cft = __d_cft(file->f_dentry);
-	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
+	struct cgroup_subsys_state *css = cfe->css;
 
 	if (cft->read)
 		return cft->read(css, cft, file, buf, nbytes, ppos);
@@ -2456,7 +2446,7 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
 {
 	struct cfent *cfe = m->private;
 	struct cftype *cft = cfe->type;
-	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
+	struct cgroup_subsys_state *css = cfe->css;
 
 	if (cft->read_map) {
 		struct cgroup_map_cb cb = {
@@ -2479,7 +2469,8 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 {
 	struct cfent *cfe = __d_cfe(file->f_dentry);
 	struct cftype *cft = __d_cft(file->f_dentry);
-	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
+	struct cgroup *cgrp = __d_cgrp(cfe->dentry->d_parent);
+	struct cgroup_subsys_state *css;
 	int err;
 
 	err = generic_file_open(inode, file);
@@ -2491,7 +2482,18 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 	 * unpinned either on open failure or release.  This ensures that
 	 * @css stays alive for all file operations.
 	 */
-	if (css->ss && !css_tryget(css))
+	rcu_read_lock();
+	if (cft->ss) {
+		css = cgroup_css(cgrp, cft->ss->subsys_id);
+		if (!css_tryget(css))
+			css = NULL;
+	} else {
+		css = &cgrp->dummy_css;
+	}
+	rcu_read_unlock();
+
+	/* css should match @cfe->css, see cgroup_add_file() for details */
+	if (!css || WARN_ON_ONCE(css != cfe->css))
 		return -ENODEV;
 
 	if (cft->read_map || cft->read_seq_string) {
@@ -2510,7 +2512,7 @@ static int cgroup_file_release(struct inode *inode, struct file *file)
 {
 	struct cfent *cfe = __d_cfe(file->f_dentry);
 	struct cftype *cft = __d_cft(file->f_dentry);
-	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
+	struct cgroup_subsys_state *css = cfe->css;
 	int ret = 0;
 
 	if (cft->release)
@@ -2772,6 +2774,18 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 	dentry->d_fsdata = cfe;
 	simple_xattrs_init(&cfe->xattrs);
 
+	/*
+	 * cfe->css is used by read/write/close to determine the associated
+	 * css.  file->private_data would be a better place but that's
+	 * already used by seqfile.  Note that open will use the usual
+	 * cgroup_css() and css_tryget() to acquire the css and this
+	 * caching doesn't affect css lifetime management.
+	 */
+	if (cft->ss)
+		cfe->css = cgroup_css(cgrp, cft->ss->subsys_id);
+	else
+		cfe->css = &cgrp->dummy_css;
+
 	mode = cgroup_file_mode(cft);
 	error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
 	if (!error) {
-- 
1.8.3.1

