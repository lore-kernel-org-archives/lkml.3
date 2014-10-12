Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaJLFIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 01:08:41 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:53050 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaJLFIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 01:08:39 -0400
Date: Sun, 12 Oct 2014 00:08:41 -0500
From: Eric Biggers <ebiggers3@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs/namei.c: Misuse of sequence counts?
Message-ID: <20141012050841.GD24463@zzz>
References: <20141011225808.GA20777@zzz>
 <20141012001259.GM7996@ZenIV.linux.org.uk>
 <20141012040142.GB24463@zzz>
 <20141012043737.GO7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012043737.GO7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch for reference (untested):

diff --git a/fs/namei.c b/fs/namei.c
index a7b05bf..84704e4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -649,17 +649,15 @@ static __always_inline void set_root(struct nameidata *nd)
 
 static int link_path_walk(const char *, struct nameidata *);
 
-static __always_inline unsigned set_root_rcu(struct nameidata *nd)
+static __always_inline void set_root_rcu(struct nameidata *nd)
 {
 	struct fs_struct *fs = current->fs;
-	unsigned seq, res;
+	unsigned seq;
 
 	do {
 		seq = read_seqcount_begin(&fs->seq);
 		nd->root = fs->root;
-		res = __read_seqcount_begin(&nd->root.dentry->d_seq);
 	} while (read_seqcount_retry(&fs->seq, seq));
-	return res;
 }
 
 static void path_put_conditional(struct path *path, struct nameidata *nd)
@@ -1854,11 +1852,21 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
 		if (flags & LOOKUP_RCU) {
+			struct fs_struct *fs = current->fs;
+			unsigned seq;
+
 			rcu_read_lock();
-			nd->seq = set_root_rcu(nd);
+
+			do {
+				seq = read_seqcount_begin(&fs->seq);
+				nd->root = fs->root;
+				nd->inode = nd->root.dentry->d_inode;
+				nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
+			} while (read_seqcount_retry(&fs->seq, seq));
 		} else {
 			set_root(nd);
 			path_get(&nd->root);
+			nd->inode = nd->root.dentry->d_inode;
 		}
 		nd->path = nd->root;
 	} else if (dfd == AT_FDCWD) {
@@ -1871,10 +1879,12 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			do {
 				seq = read_seqcount_begin(&fs->seq);
 				nd->path = fs->pwd;
+				nd->inode = nd->path.dentry->d_inode;
 				nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			} while (read_seqcount_retry(&fs->seq, seq));
 		} else {
 			get_fs_pwd(current->fs, &nd->path);
+			nd->inode = nd->path.dentry->d_inode;
 		}
 	} else {
 		/* Caller must check execute permissions on the starting path component */
@@ -1894,6 +1904,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 
 		nd->path = f.file->f_path;
+		nd->inode = file_inode(f.file);
 		if (flags & LOOKUP_RCU) {
 			if (f.flags & FDPUT_FPUT)
 				*fp = f.file;
@@ -1904,16 +1915,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			fdput(f);
 		}
 	}
-
-	nd->inode = nd->path.dentry->d_inode;
-	if (!(flags & LOOKUP_RCU))
-		return 0;
-	if (likely(!read_seqcount_retry(&nd->path.dentry->d_seq, nd->seq)))
-		return 0;
-	if (!(nd->flags & LOOKUP_ROOT))
-		nd->root.mnt = NULL;
-	rcu_read_unlock();
-	return -ECHILD;
+	return 0;
 }
 
 static inline int lookup_last(struct nameidata *nd, struct path *path)
