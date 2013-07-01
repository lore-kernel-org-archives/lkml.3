Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3GAJ77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:59:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab3GAJ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/12] GFS2: Only do one directory search on create
Date: Mon,  1 Jul 2013 10:33:09 +0100
Message-Id: <1372671195-3472-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creation of a new inode requires a directory search in order to ensure
that we are not trying to create an inode with the same name as an
existing one. This was hidden away inside the create_ok() function.

In the case that there was an existing inode, and a lookup can be
substituted for a create (which is the case with regular files
when the O_EXCL flag is not in use) then we were doing a second
lookup in order to return the inode.

This patch merges these two lookups into one. This can be done by
passing a flag to gfs2_dir_search() to tell it to just return -EEXIST
in the cases where we don't actually want to look up the inode.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index b631c90..f0c7052 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1555,9 +1555,9 @@ out:
 
 /**
  * gfs2_dir_search - Search a directory
- * @dip: The GFS2 inode
- * @filename:
- * @inode:
+ * @dip: The GFS2 dir inode
+ * @name: The name we are looking up
+ * @fail_on_exist: Fail if the name exists rather than looking it up
  *
  * This routine searches a directory for a file or another directory.
  * Assumes a glock is held on dip.
@@ -1565,22 +1565,25 @@ out:
  * Returns: errno
  */
 
-struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name)
+struct inode *gfs2_dir_search(struct inode *dir, const struct qstr *name,
+			      bool fail_on_exist)
 {
 	struct buffer_head *bh;
 	struct gfs2_dirent *dent;
-	struct inode *inode;
+	u64 addr, formal_ino;
+	u16 dtype;
 
 	dent = gfs2_dirent_search(dir, name, gfs2_dirent_find, &bh);
 	if (dent) {
 		if (IS_ERR(dent))
 			return ERR_CAST(dent);
-		inode = gfs2_inode_lookup(dir->i_sb, 
-				be16_to_cpu(dent->de_type),
-				be64_to_cpu(dent->de_inum.no_addr),
-				be64_to_cpu(dent->de_inum.no_formal_ino), 0);
+		dtype = be16_to_cpu(dent->de_type);
+		addr = be64_to_cpu(dent->de_inum.no_addr);
+		formal_ino = be64_to_cpu(dent->de_inum.no_formal_ino);
 		brelse(bh);
-		return inode;
+		if (fail_on_exist)
+			return ERR_PTR(-EEXIST);
+		return gfs2_inode_lookup(dir->i_sb, dtype, addr, formal_ino, 0);
 	}
 	return ERR_PTR(-ENOENT);
 }
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 98c960b..d3f2738 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -18,7 +18,8 @@ struct gfs2_inode;
 struct gfs2_inum;
 
 extern struct inode *gfs2_dir_search(struct inode *dir,
-				     const struct qstr *filename);
+				     const struct qstr *filename,
+				     bool fail_on_exist);
 extern int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
 			  const struct gfs2_inode *ip);
 extern int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 5fbb8df..ede16ae 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -313,7 +313,7 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 			goto out;
 	}
 
-	inode = gfs2_dir_search(dir, name);
+	inode = gfs2_dir_search(dir, name, false);
 	if (IS_ERR(inode))
 		error = PTR_ERR(inode);
 out:
@@ -346,17 +346,6 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 	if (!dip->i_inode.i_nlink)
 		return -ENOENT;
 
-	error = gfs2_dir_check(&dip->i_inode, name, NULL);
-	switch (error) {
-	case -ENOENT:
-		error = 0;
-		break;
-	case 0:
-		return -EEXIST;
-	default:
-		return error;
-	}
-
 	if (dip->i_entries == (u32)-1)
 		return -EFBIG;
 	if (S_ISDIR(mode) && dip->i_inode.i_nlink == (u32)-1)
@@ -584,14 +573,18 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail;
 
 	error = create_ok(dip, name, mode);
-	if ((error == -EEXIST) && S_ISREG(mode) && !excl) {
-		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
+	if (error)
+		goto fail_gunlock;
+
+	inode = gfs2_dir_search(dir, &dentry->d_name, !S_ISREG(mode) || excl);
+	error = PTR_ERR(inode);
+	if (!IS_ERR(inode)) {
 		gfs2_glock_dq_uninit(ghs);
 		d_instantiate(dentry, inode);
-		return PTR_RET(inode);
-	}
-	if (error)
+		return 0;
+	} else if (error != -ENOENT) {
 		goto fail_gunlock;
+	}
 
 	arq = error = gfs2_diradd_alloc_required(dir, name);
 	if (error < 0)
-- 
1.7.4

