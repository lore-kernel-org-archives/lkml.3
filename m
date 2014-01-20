Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaATMYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbaATMYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:41 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/24] GFS2: Remember directory insert point
Date: Mon, 20 Jan 2014 12:23:34 +0000
Message-Id: <1390220627-1571-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we look to see if there is enough space to add a dir
entry without allocation, we have then been repeating the
same search later when we do the actual insertion. This
patch caches the details of the location in the gfs2_diradd
structure, so that we do not have to repeat the search.

This will provide a performance improvement which will be
greater as the size of the directory increases.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 0b6be20..d5988aa 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1659,26 +1659,34 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 
 /**
  * gfs2_dir_add - Add new filename into directory
- * @dip: The GFS2 inode
- * @filename: The new name
- * @inode: The inode number of the entry
- * @type: The type of the entry
+ * @inode: The directory inode
+ * @name: The new name
+ * @nip: The GFS2 inode to be linked in to the directory
+ * @da: The directory addition info
+ *
+ * If the call to gfs2_diradd_alloc_required resulted in there being
+ * no need to allocate any new directory blocks, then it will contain
+ * a pointer to the directory entry and the bh in which it resides. We
+ * can use that without having to repeat the search. If there was no
+ * free space, then we must now create more space.
  *
  * Returns: 0 on success, error code on failure
  */
 
 int gfs2_dir_add(struct inode *inode, const struct qstr *name,
-		 const struct gfs2_inode *nip)
+		 const struct gfs2_inode *nip, struct gfs2_diradd *da)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct buffer_head *bh;
-	struct gfs2_dirent *dent;
+	struct buffer_head *bh = da->bh;
+	struct gfs2_dirent *dent = da->dent;
 	struct gfs2_leaf *leaf;
 	int error;
 
 	while(1) {
-		dent = gfs2_dirent_search(inode, name, gfs2_dirent_find_space,
-					  &bh);
+		if (da->bh == NULL) {
+			dent = gfs2_dirent_search(inode, name,
+						  gfs2_dirent_find_space, &bh);
+		}
 		if (dent) {
 			if (IS_ERR(dent))
 				return PTR_ERR(dent);
@@ -1689,6 +1697,8 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 				leaf = (struct gfs2_leaf *)bh->b_data;
 				be16_add_cpu(&leaf->lf_entries, 1);
 			}
+			da->dent = NULL;
+			da->bh = NULL;
 			brelse(bh);
 			ip->i_entries++;
 			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
@@ -2030,6 +2040,8 @@ int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name,
 	struct buffer_head *bh;
 
 	da->nr_blocks = 0;
+	da->bh = NULL;
+	da->dent = NULL;
 
 	dent = gfs2_dirent_search(inode, name, gfs2_dirent_find_space, &bh);
 	if (!dent) {
@@ -2038,7 +2050,8 @@ int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name,
 	}
 	if (IS_ERR(dent))
 		return PTR_ERR(dent);
-	brelse(bh);
+	da->bh = bh;
+	da->dent = dent;
 	return 0;
 }
 
diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index c5573e7..126c65d 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -16,9 +16,13 @@
 struct inode;
 struct gfs2_inode;
 struct gfs2_inum;
+struct buffer_head;
+struct gfs2_dirent;
 
 struct gfs2_diradd {
 	unsigned nr_blocks;
+	struct gfs2_dirent *dent;
+	struct buffer_head *bh;
 };
 
 extern struct inode *gfs2_dir_search(struct inode *dir,
@@ -27,7 +31,13 @@ extern struct inode *gfs2_dir_search(struct inode *dir,
 extern int gfs2_dir_check(struct inode *dir, const struct qstr *filename,
 			  const struct gfs2_inode *ip);
 extern int gfs2_dir_add(struct inode *inode, const struct qstr *filename,
-			const struct gfs2_inode *ip);
+			const struct gfs2_inode *ip, struct gfs2_diradd *da);
+static inline void gfs2_dir_no_add(struct gfs2_diradd *da)
+{
+	if (da->bh)
+		brelse(da->bh);
+	da->bh = NULL;
+}
 extern int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry);
 extern int gfs2_dir_read(struct inode *inode, struct dir_context *ctx,
 			 struct file_ra_state *f_ra);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index fa4624f..4acc584 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -516,7 +516,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 			goto fail_quota_locks;
 	}
 
-	error = gfs2_dir_add(&dip->i_inode, name, ip);
+	error = gfs2_dir_add(&dip->i_inode, name, ip, da);
 	if (error)
 		goto fail_end_trans;
 
@@ -579,7 +579,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct dentry *d;
 	int error;
 	u32 aflags = 0;
-	struct gfs2_diradd da;
+	struct gfs2_diradd da = { .bh = NULL, };
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return -ENAMETOOLONG;
@@ -738,6 +738,7 @@ fail_free_inode:
 	free_inode_nonrcu(inode);
 	inode = NULL;
 fail_gunlock:
+	gfs2_dir_no_add(&da);
 	gfs2_glock_dq_uninit(ghs);
 	if (inode && !IS_ERR(inode)) {
 		clear_nlink(inode);
@@ -836,7 +837,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder ghs[2];
 	struct buffer_head *dibh;
-	struct gfs2_diradd da;
+	struct gfs2_diradd da = { .bh = NULL, };
 	int error;
 
 	if (S_ISDIR(inode->i_mode))
@@ -918,7 +919,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out_end_trans;
 
-	error = gfs2_dir_add(dir, &dentry->d_name, ip);
+	error = gfs2_dir_add(dir, &dentry->d_name, ip, &da);
 	if (error)
 		goto out_brelse;
 
@@ -940,6 +941,7 @@ out_gunlock_q:
 	if (da.nr_blocks)
 		gfs2_quota_unlock(dip);
 out_gunlock:
+	gfs2_dir_no_add(&da);
 	gfs2_glock_dq(ghs + 1);
 out_child:
 	gfs2_glock_dq(ghs);
@@ -1454,7 +1456,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	if (error)
 		goto out_end_trans;
 
-	error = gfs2_dir_add(ndir, &ndentry->d_name, ip);
+	error = gfs2_dir_add(ndir, &ndentry->d_name, ip, &da);
 	if (error)
 		goto out_end_trans;
 
@@ -1467,6 +1469,7 @@ out_gunlock_q:
 	if (da.nr_blocks)
 		gfs2_quota_unlock(ndip);
 out_gunlock:
+	gfs2_dir_no_add(&da);
 	while (x--) {
 		gfs2_glock_dq(ghs + x);
 		gfs2_holder_uninit(ghs + x);
-- 
1.8.3.1

