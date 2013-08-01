Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3HAVuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:50:25 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45008 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab3HAVuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:50:23 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/23] cgroup: pin cgroup_subsys_state when opening a cgroupfs file
Date: Thu,  1 Aug 2013 17:49:48 -0400
Message-Id: <1375393801-4817-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, each file read/write operation relied on the inode
reference count pinning the cgroup and simply checked whether the
cgroup was marked dead before proceeding to invoke the per-subsystem
callback.  This was rather silly as it didn't have any synchronization
or css pinning around the check and the cgroup may be removed and all
css refs drained between the DEAD check and actual method invocation.

This patch pins the css between open() and release() so that it is
guaranteed to be alive for all file operations and remove the silly
DEAD checks from cgroup_file_read/write().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f1fc4d8..b413e22 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2270,6 +2270,17 @@ static int cgroup_sane_behavior_show(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+/* return the css for the given cgroup file */
+static struct cgroup_subsys_state *cgroup_file_css(struct cfent *cfe)
+{
+	struct cftype *cft = cfe->type;
+	struct cgroup *cgrp = __d_cgrp(cfe->dentry->d_parent);
+
+	if (cft->ss)
+		return cgrp->subsys[cft->ss->subsys_id];
+	return NULL;
+}
+
 /* A buffer size big enough for numbers or short strings */
 #define CGROUP_LOCAL_BUFFER_SIZE 64
 
@@ -2347,8 +2358,6 @@ static ssize_t cgroup_file_write(struct file *file, const char __user *buf,
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
-	if (cgroup_is_dead(cgrp))
-		return -ENODEV;
 	if (cft->write)
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->write_u64 || cft->write_s64)
@@ -2392,9 +2401,6 @@ static ssize_t cgroup_file_read(struct file *file, char __user *buf,
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
-	if (cgroup_is_dead(cgrp))
-		return -ENODEV;
-
 	if (cft->read)
 		return cft->read(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->read_u64)
@@ -2440,15 +2446,22 @@ static const struct file_operations cgroup_seqfile_operations = {
 
 static int cgroup_file_open(struct inode *inode, struct file *file)
 {
+	struct cfent *cfe = __d_cfe(file->f_dentry);
+	struct cftype *cft = __d_cft(file->f_dentry);
+	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
 	int err;
-	struct cfent *cfe;
-	struct cftype *cft;
 
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
-	cfe = __d_cfe(file->f_dentry);
-	cft = cfe->type;
+
+	/*
+	 * If the file belongs to a subsystem, pin the css.  Will be
+	 * unpinned either on open failure or release.  This ensures that
+	 * @css stays alive for all file operations.
+	 */
+	if (css && !css_tryget(css))
+		return -ENODEV;
 
 	if (cft->read_map || cft->read_seq_string) {
 		file->f_op = &cgroup_seqfile_operations;
@@ -2457,15 +2470,23 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 		err = cft->open(inode, file);
 	}
 
+	if (css && err)
+		css_put(css);
 	return err;
 }
 
 static int cgroup_file_release(struct inode *inode, struct file *file)
 {
+	struct cfent *cfe = __d_cfe(file->f_dentry);
 	struct cftype *cft = __d_cft(file->f_dentry);
+	struct cgroup_subsys_state *css = cgroup_file_css(cfe);
+	int ret = 0;
+
 	if (cft->release)
-		return cft->release(inode, file);
-	return 0;
+		ret = cft->release(inode, file);
+	if (css)
+		css_put(css);
+	return ret;
 }
 
 /*
-- 
1.8.3.1

