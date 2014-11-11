Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaKKLPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:15:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbaKKLLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 161/170] ext4: convert do_split() to use the ERR_PTR convention
Date: Tue, 11 Nov 2014 11:08:40 +0000
Message-Id: <1415704129-12709-162-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit f8b3b59d4d561368cf8c92d50218fc0d5be7cb46 upstream.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ luis: backported to 3.16: useful for:
  6050d47adcad "ext4: bail out from make_indexed_dir() on first error" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/namei.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b30312b06084..50d9225d9e3e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1526,7 +1526,7 @@ static struct ext4_dir_entry_2* dx_pack_dirents(char *base, unsigned blocksize)
  */
 static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 			struct buffer_head **bh,struct dx_frame *frame,
-			struct dx_hash_info *hinfo, int *error)
+			struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
 	unsigned count, continued;
@@ -1548,8 +1548,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	if (IS_ERR(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
-		*error = PTR_ERR(bh2);
-		return NULL;
+		return (struct ext4_dir_entry_2 *) bh2;
 	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
@@ -1609,8 +1608,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	dxtrace(dx_show_leaf (hinfo, (struct ext4_dir_entry_2 *) data2, blocksize, 1));
 
 	/* Which block gets the new entry? */
-	if (hinfo->hash >= hash2)
-	{
+	if (hinfo->hash >= hash2) {
 		swap(*bh, bh2);
 		de = de2;
 	}
@@ -1630,8 +1628,7 @@ journal_error:
 	brelse(bh2);
 	*bh = NULL;
 	ext4_std_error(dir->i_sb, err);
-	*error = err;
-	return NULL;
+	return ERR_PTR(err);
 }
 
 int ext4_find_dest_de(struct inode *dir, struct inode *inode,
@@ -1852,8 +1849,8 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 	ext4_handle_dirty_dirent_node(handle, dir, bh);
 
-	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	if (!de) {
+	de = do_split(handle,dir, &bh, frame, &hinfo);
+	if (IS_ERR(de)) {
 		/*
 		 * Even if the block split failed, we have to properly write
 		 * out all the changes we did so far. Otherwise we can end up
@@ -1861,7 +1858,7 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		 */
 		ext4_mark_inode_dirty(handle, dir);
 		dx_release(frames);
-		return retval;
+		return PTR_ERR(de);
 	}
 	dx_release(frames);
 
@@ -2084,9 +2081,11 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			goto cleanup;
 		}
 	}
-	de = do_split(handle, dir, &bh, frame, &hinfo, &err);
-	if (!de)
+	de = do_split(handle, dir, &bh, frame, &hinfo);
+	if (IS_ERR(de)) {
+		err = PTR_ERR(de);
 		goto cleanup;
+	}
 	err = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	goto cleanup;
 
-- 
2.1.0

