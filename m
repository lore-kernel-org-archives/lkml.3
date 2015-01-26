Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbbAZUnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:43:11 -0500
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:49582 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932113AbbAZUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:43:04 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:2:41:355:379:541:599:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4049:4118:4321:4385:5007:6119:6261:7875:7903:8660:9163:9592:10004:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13148:13161:13229:13230:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soap23_8eab6d8c97034
X-Filterd-Recvd-Size: 7762
Date: Mon, 26 Jan 2015 15:42:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126154259.5e650d32@gandalf.local.home>
In-Reply-To: <20150126193049.GN29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 19:30:49 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> You are still fighting an inconvenient API, but now it's not debugfs one -
> it's your copy thereof.  Why not give your instances/ an inode_operations
> of its own?  One with ->mkdir() and ->rmdir(), leaving all other directories
> as-is.  That way you don't need the secondary methods at all.  And sure,
> debugfs_create_dir() grabs ->i_mutex on parent, making you drop that in
> your ->mkdir() if you want to call it.  But now you are not talking to it -
> just to your own code, where you are free to change the calling conventions,
> making it caller's responsibility to get that ->i_mutex.  The same goes for
> the rmdir side...

The vfs layer grabs the i_mutex, which needs to be dropped. I was
hoping to keep the dropping of the i_mutex within the tracefs code and
not have the tracing code worry about it. I still will need to add
i_private to hold this info.

But that said, I could clean it up a little be having a
tracefs_create_instance_dir(), which does all the work within the
tracefs code. The caller would pass in the functions to be called by
that.

Like this patch applied on top of my current series:

-- Steve

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index c7eb4c58579e..13e17bf677f4 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -50,6 +50,11 @@ static const struct file_operations tracefs_file_operations = {
 	.llseek =	noop_llseek,
 };
 
+struct tracefs_dir_ops {
+	int (*mkdir)(const char *name);
+	int (*rmdir)(const char *name);
+};
+
 static char *get_dname(struct dentry *dentry)
 {
 	const char *dname;
@@ -67,13 +72,10 @@ static char *get_dname(struct dentry *dentry)
 
 static int tracefs_syscall_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode)
 {
-	const struct tracefs_dir_ops *ops = inode ? inode->i_private : NULL;
+	const struct tracefs_dir_ops *ops = inode->i_private;
 	char *name;
 	int ret;
 
-	if (!ops)
-		return -EPERM;
-
 	name = get_dname(dentry);
 	if (!name)
 		return -ENOMEM;
@@ -98,9 +100,6 @@ static int tracefs_syscall_rmdir(struct inode *inode, struct dentry *dentry)
 	char *name;
 	int ret;
 
-	if (!ops)
-		return -EPERM;
-
 	name = get_dname(dentry);
 	if (!name)
 		return -ENOMEM;
@@ -317,16 +316,6 @@ static struct file_system_type trace_fs_type = {
 };
 MODULE_ALIAS_FS("tracefs");
 
-void tracefs_add_dir_ops(struct dentry *dentry, const struct tracefs_dir_ops *ops)
-{
-	struct inode *inode = dentry->d_inode;
-
-	if (!inode)
-		return;
-
-	inode->i_private = (void *)ops;
-}
-
 static struct dentry *start_creating(const char *name, struct dentry *parent)
 {
 	struct dentry *dentry;
@@ -425,6 +414,31 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	return end_creating(dentry);
 }
 
+static struct dentry *__create_dir(const char *name, struct dentry *parent,
+				   const struct inode_operations *ops)
+{
+	struct dentry *dentry = start_creating(name, parent);
+	struct inode *inode;
+
+	if (IS_ERR(dentry))
+		return NULL;
+
+	inode = tracefs_get_inode(dentry->d_sb);
+	if (unlikely(!inode))
+		return failed_creating(dentry);
+
+	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	inode->i_op = ops;
+	inode->i_fop = &simple_dir_operations;
+
+	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	inc_nlink(inode);
+	d_instantiate(dentry, inode);
+	inc_nlink(dentry->d_parent->d_inode);
+	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
+	return end_creating(dentry);
+}
+
 /**
  * tracefs_create_dir - create a directory in the tracefs filesystem
  * @name: a pointer to a string containing the name of the directory to
@@ -444,26 +458,30 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
  */
 struct dentry *tracefs_create_dir(const char *name, struct dentry *parent)
 {
-	struct dentry *dentry = start_creating(name, parent);
-	struct inode *inode;
+	return __create_dir(name, parent, &simple_dir_inode_operations);
+}
 
-	if (IS_ERR(dentry))
+struct dentry *tracefs_create_instance_dir(const char *name, struct dentry *parent,
+					  int (*mkdir)(const char *name),
+					  int (*rmdir)(const char *name))
+{
+	struct tracefs_dir_ops *dir_ops;
+	struct dentry *dentry;
+
+	dir_ops = kmalloc(sizeof(*dir_ops), GFP_KERNEL);
+	if (!dir_ops)
 		return NULL;
 
-	inode = tracefs_get_inode(dentry->d_sb);
-	if (unlikely(!inode))
-		return failed_creating(dentry);
+	dir_ops->mkdir = mkdir;
+	dir_ops->rmdir = mkdir;
 
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
-	inode->i_op = &tracefs_dir_inode_operations;
-	inode->i_fop = &simple_dir_operations;
+	dentry = __create_dir(name, parent, &tracefs_dir_inode_operations);
+	if (!dentry)
+		return NULL;
 
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
-	d_instantiate(dentry, inode);
-	inc_nlink(dentry->d_parent->d_inode);
-	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
-	return end_creating(dentry);
+	dentry->d_inode->i_private = (void *)dir_ops;
+
+	return dentry;
 }
 
 static inline int tracefs_positive(struct dentry *dentry)
diff --git a/include/linux/tracefs.h b/include/linux/tracefs.h
index d142b1f9d453..5b727a17beee 100644
--- a/include/linux/tracefs.h
+++ b/include/linux/tracefs.h
@@ -34,12 +34,9 @@ struct dentry *tracefs_create_dir(const char *name, struct dentry *parent);
 void tracefs_remove(struct dentry *dentry);
 void tracefs_remove_recursive(struct dentry *dentry);
 
-struct tracefs_dir_ops {
-	int (*mkdir)(const char *name);
-	int (*rmdir)(const char *name);
-};
-
-void tracefs_add_dir_ops(struct dentry *dentry, const struct tracefs_dir_ops *ops);
+struct dentry *tracefs_create_instance_dir(const char *name, struct dentry *parent,
+					   int (*mkdir)(const char *name),
+					   int (*rmdir)(const char *name));
 
 bool tracefs_initialized(void);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c555027c8aaf..2047501dcd16 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6445,18 +6445,13 @@ static int instance_rmdir(const char *name)
 	return ret;
 }
 
-static const struct tracefs_dir_ops instance_dir_ops = {
-	.mkdir		= instance_mkdir,
-	.rmdir		= instance_rmdir,
-};
-
 static __init void create_trace_instances(struct dentry *d_tracer)
 {
-	trace_instance_dir = tracefs_create_dir("instances", d_tracer);
+	trace_instance_dir = tracefs_create_instance_dir("instances", d_tracer,
+							 instance_mkdir,
+							 instance_rmdir);
 	if (WARN_ON(!trace_instance_dir))
 		return;
-
-	tracefs_add_dir_ops(trace_instance_dir, &instance_dir_ops);
 }
 
 static void
