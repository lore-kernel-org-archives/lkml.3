Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab3DPS0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935351Ab3DPS0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 05/28] proc: Uninline pid_delete_dentry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:26:14 +0100
Message-ID: <20130416182614.27773.81183.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uninline pid_delete_dentry() as it's only used by three function pointers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/base.c     |    9 +++++++++
 fs/proc/internal.h |   14 +++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 593e7c5..f2637c9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1621,6 +1621,15 @@ int pid_revalidate(struct dentry *dentry, unsigned int flags)
 	return 0;
 }
 
+int pid_delete_dentry(const struct dentry *dentry)
+{
+	/* Is the task we represent dead?
+	 * If so, then don't put the dentry on the lru list,
+	 * kill it immediately.
+	 */
+	return !proc_pid(dentry->d_inode)->tasks[PIDTYPE_PID].first;
+}
+
 const struct dentry_operations pid_dentry_operations =
 {
 	.d_revalidate	= pid_revalidate,
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 4b13417..aaf2dd8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -114,15 +114,6 @@ static inline int task_dumpable(struct task_struct *task)
 	return 0;
 }
 
-static inline int pid_delete_dentry(const struct dentry * dentry)
-{
-	/* Is the task we represent dead?
-	 * If so, then don't put the dentry on the lru list,
-	 * kill it immediately.
-	 */
-	return !proc_pid(dentry->d_inode)->tasks[PIDTYPE_PID].first;
-}
-
 static inline unsigned name_to_int(struct dentry *dentry)
 {
 	const char *name = dentry->d_name.name;
@@ -145,6 +136,11 @@ out:
 	return ~0U;
 }
 
+/*
+ * base.c
+ */
+extern int pid_delete_dentry(const struct dentry *);
+
 struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *ino,
 		struct dentry *dentry);
 int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,

