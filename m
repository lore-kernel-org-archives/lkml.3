Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaDAJQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaDAJQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:12 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/29] GFS2: Add meta readahead field in directory entries
Date: Tue,  1 Apr 2014 10:15:17 +0100
Message-Id: <1396343741-1524-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of this new field in the directory entry is to
allow a subsequent lookup to know how many blocks, which
are contiguous with the inode, contain metadata which relates
to the inode. This will then allow the issuing of a single
read to read these blocks, rather than reading the inode
first, and then issuing a second read for the metadata.

This only works under some fairly strict conditions, since
we do not have back pointers from inodes to directory entries
we must ensure that the blocks referenced in this way will
always belong to the inode.

This rules out being able to use this system for indirect
blocks, as these can change as a result of truncate/rewrite.

So the idea here is to restrict this to xattr blocks only
for the time being. For most inodes, that means only a
single block. Also, when using ACLs and/or SELinux or
other LSMs, these will be added at inode creation time
so that they will be contiguous with the inode on disk and
also will almost always be needed when we read the inode in
for permissions checks.

Once an xattr block for an inode is allocated, it will never
change until the inode is deallocated.

This patch adds the new field, a further patch will add the
readahead in due course.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index fa32655..ffcfdd1 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1684,6 +1684,14 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 	return 0;
 }
 
+static u16 gfs2_inode_ra_len(const struct gfs2_inode *ip)
+{
+	u64 where = ip->i_no_addr + 1;
+	if (ip->i_eattr == where)
+		return 1;
+	return 0;
+}
+
 /**
  * gfs2_dir_add - Add new filename into directory
  * @inode: The directory inode
@@ -1721,6 +1729,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			dent = gfs2_init_dirent(inode, dent, name, bh);
 			gfs2_inum_out(nip, dent);
 			dent->de_type = cpu_to_be16(IF2DT(nip->i_inode.i_mode));
+			dent->de_rahead = cpu_to_be16(gfs2_inode_ra_len(nip));
 			tv = CURRENT_TIME;
 			if (ip->i_diskflags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
diff --git a/include/uapi/linux/gfs2_ondisk.h b/include/uapi/linux/gfs2_ondisk.h
index 3100208..db3fdd0 100644
--- a/include/uapi/linux/gfs2_ondisk.h
+++ b/include/uapi/linux/gfs2_ondisk.h
@@ -304,7 +304,13 @@ struct gfs2_dirent {
 	__be16 de_rec_len;
 	__be16 de_name_len;
 	__be16 de_type;
-	__u8 __pad[14];
+	union {
+		__u8 __pad[14];
+		struct {
+			__be16 de_rahead;
+			__u8 pad2[12];
+		};
+	};
 };
 
 /*
-- 
1.8.3.1

