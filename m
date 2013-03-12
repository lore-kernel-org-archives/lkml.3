Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3CLXHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:07:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3CLWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 063/100] proc: Use nd_jump_link in proc_ns_follow_link
Date: Tue, 12 Mar 2013 15:31:48 -0700
Message-Id: <20130312223129.751659372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit db04dc679bcc780ad6907943afe24a30de974a1b upstream.

Update proc_ns_follow_link to use nd_jump_link instead of just
manually updating nd.path.dentry.

This fixes the BUG_ON(nd->inode != parent->d_inode) reported by Dave
Jones and reproduced trivially with mkdir /proc/self/ns/uts/a.

Sigh it looks like the VFS change to require use of nd_jump_link
happend while proc_ns_follow_link was baking and since the common case
of proc_ns_follow_link continued to work without problems the need for
making this change was overlooked.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/namespaces.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -118,7 +118,7 @@ static void *proc_ns_follow_link(struct
 	struct super_block *sb = inode->i_sb;
 	struct proc_inode *ei = PROC_I(inode);
 	struct task_struct *task;
-	struct dentry *ns_dentry;
+	struct path ns_path;
 	void *error = ERR_PTR(-EACCES);
 
 	task = get_proc_task(inode);
@@ -128,14 +128,14 @@ static void *proc_ns_follow_link(struct
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
-	ns_dentry = proc_ns_get_dentry(sb, task, ei->ns_ops);
-	if (IS_ERR(ns_dentry)) {
-		error = ERR_CAST(ns_dentry);
+	ns_path.dentry = proc_ns_get_dentry(sb, task, ei->ns_ops);
+	if (IS_ERR(ns_path.dentry)) {
+		error = ERR_CAST(ns_path.dentry);
 		goto out_put_task;
 	}
 
-	dput(nd->path.dentry);
-	nd->path.dentry = ns_dentry;
+	ns_path.mnt = mntget(nd->path.mnt);
+	nd_jump_link(nd, &ns_path);
 	error = NULL;
 
 out_put_task:


