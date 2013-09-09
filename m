Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3IIOQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:16:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3IIOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:16:41 -0400
Date: Mon, 9 Sep 2013 07:16:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kerrnel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: remove vfs_follow_link
Message-ID: <20130909141641.GA27531@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a long time no filesystem has been using vfs_follow_link, and as seen
by recent filesystem submissions any new use is accidental as well.

Remove vfs_follow_link, document the replacement in
Documentation/filesystems/porting and also rename __vfs_follow_link
to match its only caller better.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 206a1bd..f089058 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -451,3 +451,7 @@ in your dentry operations instead.
 --
 [mandatory]
 	->readdir() is gone now; switch to ->iterate()
+[mandatory]
+	vfs_follow_link has been removed.  Filesystems must use nd_set_link
+	from ->follow_link for normal symlinks, or nd_jump_link for magic
+	/proc/<pid> style links.
diff --git a/fs/namei.c b/fs/namei.c
index f415c66..9419ce9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -674,7 +674,7 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
 	}
 }
 
-static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *link)
+static __always_inline int __follow_link(struct nameidata *nd, const char *link)
 {
 	int ret;
 
@@ -888,7 +888,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 	error = 0;
 	s = nd_get_link(nd);
 	if (s) {
-		error = __vfs_follow_link(nd, s);
+		error = __follow_link(nd, s);
 		if (unlikely(error))
 			put_link(nd, link, *p);
 	}
@@ -4244,11 +4244,6 @@ int generic_readlink(struct dentry *dentry, char __user *buffer, int buflen)
 	return res;
 }
 
-int vfs_follow_link(struct nameidata *nd, const char *link)
-{
-	return __vfs_follow_link(nd, link);
-}
-
 /* get the link contents into pagecache */
 static char *page_getlink(struct dentry * dentry, struct page **ppage)
 {
@@ -4360,7 +4355,6 @@ EXPORT_SYMBOL(vfs_path_lookup);
 EXPORT_SYMBOL(inode_permission);
 EXPORT_SYMBOL(unlock_rename);
 EXPORT_SYMBOL(vfs_create);
-EXPORT_SYMBOL(vfs_follow_link);
 EXPORT_SYMBOL(vfs_link);
 EXPORT_SYMBOL(vfs_mkdir);
 EXPORT_SYMBOL(vfs_mknod);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 529d871..49e71b0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2494,7 +2494,6 @@ extern const struct file_operations generic_ro_fops;
 #define special_file(m) (S_ISCHR(m)||S_ISBLK(m)||S_ISFIFO(m)||S_ISSOCK(m))
 
 extern int vfs_readlink(struct dentry *, char __user *, int, const char *);
-extern int vfs_follow_link(struct nameidata *, const char *);
 extern int page_readlink(struct dentry *, char __user *, int);
 extern void *page_follow_link_light(struct dentry *, struct nameidata *);
 extern void page_put_link(struct dentry *, struct nameidata *, void *);
