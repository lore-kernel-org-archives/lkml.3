Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3IPMzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:55:00 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:55447 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IPMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Eric Van Hensbergen <ericvh@gmail.com>,
        Sage Weil <sage@inktank.com>, Steve French <sfrench@samba.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 01/11] vfs: improve i_op->atomic_open() documentation
Date: Mon, 16 Sep 2013 14:51:55 +0200
Message-Id: <1379335925-30858-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix documentation of ->atomic_open() and related functions: finish_open()
and finish_no_open().  Also add details that seem to be unclear and a
source of bugs (some of which are fixed in the following series).

Cc-ing maintainers of all filesystems implementing ->atomic_open().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Sage Weil <sage@inktank.com>
Cc: Steve French <sfrench@samba.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 Documentation/filesystems/vfs.txt | 14 +++++++-------
 fs/open.c                         | 21 ++++++++++++++++++---
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index f93a882..deb48b5 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -359,11 +359,9 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*update_time)(struct inode *, struct timespec *, int);
-	int (*atomic_open)(struct inode *, struct dentry *,
+	int (*atomic_open)(struct inode *, struct dentry *, struct file *,
+			unsigned open_flag, umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
-} ____cacheline_aligned;
-				struct file *, unsigned open_flag,
-				umode_t create_mode, int *opened);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -470,9 +468,11 @@ otherwise noted.
   	method the filesystem can look up, possibly create and open the file in
   	one atomic operation.  If it cannot perform this (e.g. the file type
   	turned out to be wrong) it may signal this by returning 1 instead of
-  	usual 0 or -ve .  This method is only called if the last
-  	component is negative or needs lookup.  Cached positive dentries are
-  	still handled by f_op->open().
+	usual 0 or -ve .  This method is only called if the last component is
+	negative or needs lookup.  Cached positive dentries are still handled by
+	f_op->open().  If the file was created, the FILE_CREATED flag should be
+	set in "opened".  In case of O_EXCL the method must only succeed if the
+	file didn't exist and hence FILE_CREATED shall always be set on success.
 
   tmpfile: called in the end of O_TMPFILE open().  Optional, equivalent to
 	atomically creating, opening and unlinking a file in given directory.
diff --git a/fs/open.c b/fs/open.c
index 2a731b0..d420331 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -744,14 +744,24 @@ cleanup_file:
 
 /**
  * finish_open - finish opening a file
- * @od: opaque open data
+ * @file: file pointer
  * @dentry: pointer to dentry
  * @open: open callback
+ * @opened: state of open
  *
  * This can be used to finish opening a file passed to i_op->atomic_open().
  *
  * If the open callback is set to NULL, then the standard f_op->open()
  * filesystem callback is substituted.
+ *
+ * NB: the dentry reference is _not_ consumed.  If, for example, the dentry is
+ * the return value of d_splice_alias(), then the caller needs to perform dput()
+ * on it after finish_open().
+ *
+ * On successful return @file is a fully instantiated open file.  After this, if
+ * an error occurs in ->atomic_open(), it needs to clean up with fput().
+ *
+ * Returns zero on success or -errno if the open failed.
  */
 int finish_open(struct file *file, struct dentry *dentry,
 		int (*open)(struct inode *, struct file *),
@@ -772,11 +782,16 @@ EXPORT_SYMBOL(finish_open);
 /**
  * finish_no_open - finish ->atomic_open() without opening the file
  *
- * @od: opaque open data
+ * @file: file pointer
  * @dentry: dentry or NULL (as returned from ->lookup())
  *
  * This can be used to set the result of a successful lookup in ->atomic_open().
- * The filesystem's atomic_open() method shall return NULL after calling this.
+ *
+ * NB: unlike finish_open() this function does consume the dentry reference and
+ * the caller need not dput() it.
+ *
+ * Returns "1" which must be the return value of ->atomic_open() after having
+ * called this function.
  */
 int finish_no_open(struct file *file, struct dentry *dentry)
 {
-- 
1.8.1.4

