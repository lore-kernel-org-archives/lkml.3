Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349Ab3DPS2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965306Ab3DPS1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 27/28] proc: Make the PROC_I() and PDE() macros internal to
 procfs [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:27:38 +0100
Message-ID: <20130416182738.27773.98928.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the PROC_I() and PDE() macros internal to procfs.  This means making
PDE_DATA() out of line.  This could be made more optimal by storing
PDE()->data into inode->i_private.

Also provide a __PDE_DATA() that is inline and internal to procfs.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/proc/generic.c       |    8 +++++++-
 fs/proc/internal.h      |   18 ++++++++++++++++++
 fs/proc/proc_devtree.c  |    2 +-
 include/linux/proc_fs.h |   17 ++---------------
 4 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4b48033..d95abfd 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -165,7 +165,7 @@ void proc_free_inum(unsigned int inum)
 
 static void *proc_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	nd_set_link(nd, PDE_DATA(dentry->d_inode));
+	nd_set_link(nd, __PDE_DATA(dentry->d_inode));
 	return NULL;
 }
 
@@ -637,3 +637,9 @@ void proc_remove(struct proc_dir_entry *de)
 		remove_proc_subtree(de->name, de->parent);
 }
 EXPORT_SYMBOL(proc_remove);
+
+void *PDE_DATA(const struct inode *inode)
+{
+	return __PDE_DATA(inode);
+}
+EXPORT_SYMBOL(PDE_DATA);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c529b5f..86a2406 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -84,6 +84,24 @@ struct proc_maps_private {
 
 void proc_init_inodecache(void);
 
+/*
+ * General functions
+ */
+static inline struct proc_inode *PROC_I(const struct inode *inode)
+{
+	return container_of(inode, struct proc_inode, vfs_inode);
+}
+
+static inline struct proc_dir_entry *PDE(const struct inode *inode)
+{
+	return PROC_I(inode)->pde;
+}
+
+static inline void *__PDE_DATA(const struct inode *inode)
+{
+	return PDE(inode)->data;
+}
+
 static inline struct pid *proc_pid(struct inode *inode)
 {
 	return PROC_I(inode)->pid;
diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index e0043c7..505afc9 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -41,7 +41,7 @@ static int property_proc_show(struct seq_file *m, void *v)
 
 static int property_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, property_proc_show, PDE_DATA(inode));
+	return single_open(file, property_proc_show, __PDE_DATA(inode));
 }
 
 static const struct file_operations property_proc_fops = {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index b8949b1..96ede28 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -87,6 +87,7 @@ static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
  
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
+extern void *PDE_DATA(const struct inode *);
 extern void *proc_get_parent_data(const struct inode *);
 extern const char *get_proc_name(const struct proc_dir_entry *);
 extern struct pid *get_proc_pid(const struct inode *);
@@ -116,6 +117,7 @@ static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
 	umode_t mode, struct proc_dir_entry *parent) { return NULL; }
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
+static inline void *PDE_DATA(const struct inode *inode) { return NULL; }
 static inline struct pid *get_proc_pid(const struct inode *inode) { return NULL; }
 
 #endif /* CONFIG_PROC_FS */
@@ -143,21 +145,6 @@ struct proc_inode {
 	struct inode vfs_inode;
 };
 
-static inline struct proc_inode *PROC_I(const struct inode *inode)
-{
-	return container_of(inode, struct proc_inode, vfs_inode);
-}
-
-static inline struct proc_dir_entry *PDE(const struct inode *inode)
-{
-	return PROC_I(inode)->pde;
-}
-
-static inline void *PDE_DATA(const struct inode *inode)
-{
-	return PROC_I(inode)->pde->data;
-}
-
 static inline struct proc_dir_entry *proc_net_mkdir(
 	struct net *net, const char *name, struct proc_dir_entry *parent)
 {

