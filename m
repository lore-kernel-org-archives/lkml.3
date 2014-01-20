Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaATMYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbaATMYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:46 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/24] GFS2: Add hints to directory leaf blocks
Date: Mon, 20 Jan 2014 12:23:37 +0000
Message-Id: <1390220627-1571-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds four new fields to directory leaf blocks.
The intent is not to use them in the kernel itself, although
perhaps we may be able to use them as hints at some later date,
but instead to provide more information for debug/fsck use.

One new field adds a pointer to the inode to which the leaf
belongs. This can be useful if the pointer to the leaf block
has become corrupt, as it will allow us to know which inode
this block should be associated with. This field is set when
the leaf is created and never changed over its lifetime.

The second field is a "distance from the hash table" field.
The meaning is as follows:
 0  = An old leaf in which this value has not been set
 1  = This leaf is pointed to directly from the hash table
 2+ = This leaf is part of a chain, pointed to by another leaf
      block, the value gives the position in the chain.

The third and fourth fields combine to give a time stamp of
the most recent directory insertion or deletion from this
leaf block. The time stamp is not updated when a new leaf
block is chained from the current one. The code is currently
written such that the timestamp on the dir inode will match
that of the leaf block for the most recent insertion/deletion.

For backwards compatibility, any of these new fields which is
zero should be considered to be "unknown".

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index b2e5ebf..fa32655 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -834,6 +834,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	struct gfs2_leaf *leaf;
 	struct gfs2_dirent *dent;
 	struct qstr name = { .name = "" };
+	struct timespec tv = CURRENT_TIME;
 
 	error = gfs2_alloc_blocks(ip, &bn, &n, 0, NULL);
 	if (error)
@@ -850,7 +851,11 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	leaf->lf_entries = 0;
 	leaf->lf_dirent_format = cpu_to_be32(GFS2_FORMAT_DE);
 	leaf->lf_next = 0;
-	memset(leaf->lf_reserved, 0, sizeof(leaf->lf_reserved));
+	leaf->lf_inode = cpu_to_be64(ip->i_no_addr);
+	leaf->lf_dist = cpu_to_be32(1);
+	leaf->lf_nsec = cpu_to_be32(tv.tv_nsec);
+	leaf->lf_sec = cpu_to_be64(tv.tv_sec);
+	memset(leaf->lf_reserved2, 0, sizeof(leaf->lf_reserved2));
 	dent = (struct gfs2_dirent *)(leaf+1);
 	gfs2_qstr2dirent(&name, bh->b_size - sizeof(struct gfs2_leaf), dent);
 	*pbh = bh;
@@ -1612,11 +1617,31 @@ out:
 	return ret;
 }
 
+/**
+ * dir_new_leaf - Add a new leaf onto hash chain
+ * @inode: The directory
+ * @name: The name we are adding
+ *
+ * This adds a new dir leaf onto an existing leaf when there is not
+ * enough space to add a new dir entry. This is a last resort after
+ * we've expanded the hash table to max size and also split existing
+ * leaf blocks, so it will only occur for very large directories.
+ *
+ * The dist parameter is set to 1 for leaf blocks directly attached
+ * to the hash table, 2 for one layer of indirection, 3 for two layers
+ * etc. We are thus able to tell the difference between an old leaf
+ * with dist set to zero (i.e. "don't know") and a new one where we
+ * set this information for debug/fsck purposes.
+ *
+ * Returns: 0 on success, or -ve on error
+ */
+
 static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 {
 	struct buffer_head *bh, *obh;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_leaf *leaf, *oleaf;
+	u32 dist = 1;
 	int error;
 	u32 index;
 	u64 bn;
@@ -1626,6 +1651,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 	if (error)
 		return error;
 	do {
+		dist++;
 		oleaf = (struct gfs2_leaf *)obh->b_data;
 		bn = be64_to_cpu(oleaf->lf_next);
 		if (!bn)
@@ -1643,6 +1669,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 		brelse(obh);
 		return -ENOSPC;
 	}
+	leaf->lf_dist = cpu_to_be32(dist);
 	oleaf->lf_next = cpu_to_be64(bh->b_blocknr);
 	brelse(bh);
 	brelse(obh);
@@ -1679,6 +1706,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct buffer_head *bh = da->bh;
 	struct gfs2_dirent *dent = da->dent;
+	struct timespec tv;
 	struct gfs2_leaf *leaf;
 	int error;
 
@@ -1693,15 +1721,18 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			dent = gfs2_init_dirent(inode, dent, name, bh);
 			gfs2_inum_out(nip, dent);
 			dent->de_type = cpu_to_be16(IF2DT(nip->i_inode.i_mode));
+			tv = CURRENT_TIME;
 			if (ip->i_diskflags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
 				be16_add_cpu(&leaf->lf_entries, 1);
+				leaf->lf_nsec = cpu_to_be32(tv.tv_nsec);
+				leaf->lf_sec = cpu_to_be64(tv.tv_sec);
 			}
 			da->dent = NULL;
 			da->bh = NULL;
 			brelse(bh);
 			ip->i_entries++;
-			ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
+			ip->i_inode.i_mtime = ip->i_inode.i_ctime = tv;
 			if (S_ISDIR(nip->i_inode.i_mode))
 				inc_nlink(&ip->i_inode);
 			mark_inode_dirty(inode);
@@ -1752,6 +1783,7 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry)
 	const struct qstr *name = &dentry->d_name;
 	struct gfs2_dirent *dent, *prev = NULL;
 	struct buffer_head *bh;
+	struct timespec tv = CURRENT_TIME;
 
 	/* Returns _either_ the entry (if its first in block) or the
 	   previous entry otherwise */
@@ -1777,13 +1809,15 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry)
 		if (!entries)
 			gfs2_consist_inode(dip);
 		leaf->lf_entries = cpu_to_be16(--entries);
+		leaf->lf_nsec = cpu_to_be32(tv.tv_nsec);
+		leaf->lf_sec = cpu_to_be64(tv.tv_sec);
 	}
 	brelse(bh);
 
 	if (!dip->i_entries)
 		gfs2_consist_inode(dip);
 	dip->i_entries--;
-	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME;
+	dip->i_inode.i_mtime = dip->i_inode.i_ctime = tv;
 	if (S_ISDIR(dentry->d_inode->i_mode))
 		drop_nlink(&dip->i_inode);
 	mark_inode_dirty(&dip->i_inode);
diff --git a/include/uapi/linux/gfs2_ondisk.h b/include/uapi/linux/gfs2_ondisk.h
index b2de1f9..0f24c07 100644
--- a/include/uapi/linux/gfs2_ondisk.h
+++ b/include/uapi/linux/gfs2_ondisk.h
@@ -319,7 +319,16 @@ struct gfs2_leaf {
 	__be32 lf_dirent_format;	/* Format of the dirents */
 	__be64 lf_next;			/* Next leaf, if overflow */
 
-	__u8 lf_reserved[64];
+	union {
+		__u8 lf_reserved[64];
+		struct {
+			__be64 lf_inode;	/* Dir inode number */
+			__be32 lf_dist;		/* Dist from inode on chain */
+			__be32 lf_nsec;		/* Last ins/del usecs */
+			__be64 lf_sec;		/* Last ins/del in secs */
+			__u8 lf_reserved2[40];
+		};
+	};
 };
 
 /*
-- 
1.8.3.1

