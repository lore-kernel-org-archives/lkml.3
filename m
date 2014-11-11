Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaKKLOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:14:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaKKLLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 162/170] ext4: bail out from make_indexed_dir() on first error
Date: Tue, 11 Nov 2014 11:08:41 +0000
Message-Id: <1415704129-12709-163-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 6050d47adcadbb53582434d919ed7f038d936712 upstream.

When ext4_handle_dirty_dx_node() or ext4_handle_dirty_dirent_node()
fail, there's really something wrong with the fs and there's no point in
continuing further. Just return error from make_indexed_dir() in that
case. Also initialize frames array so that if we return early due to
error, dx_release() doesn't try to dereference uninitialized memory
(which could happen also due to error in do_split()).

Coverity-id: 741300
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/namei.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 50d9225d9e3e..5c0b71c734ea 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1840,31 +1840,39 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	ext4fs_dirhash(name, namelen, &hinfo);
+	memset(frames, 0, sizeof(frames));
 	frame = frames;
 	frame->entries = entries;
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
 
-	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
-	ext4_handle_dirty_dirent_node(handle, dir, bh);
+	retval = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
+	if (retval)
+		goto out_frames;	
+	retval = ext4_handle_dirty_dirent_node(handle, dir, bh);
+	if (retval)
+		goto out_frames;	
 
 	de = do_split(handle,dir, &bh, frame, &hinfo);
 	if (IS_ERR(de)) {
-		/*
-		 * Even if the block split failed, we have to properly write
-		 * out all the changes we did so far. Otherwise we can end up
-		 * with corrupted filesystem.
-		 */
-		ext4_mark_inode_dirty(handle, dir);
-		dx_release(frames);
-		return PTR_ERR(de);
+		retval = PTR_ERR(de);
+		goto out_frames;
 	}
 	dx_release(frames);
 
 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
 	return retval;
+out_frames:
+	/*
+	 * Even if the block split failed, we have to properly write
+	 * out all the changes we did so far. Otherwise we can end up
+	 * with corrupted filesystem.
+	 */
+	ext4_mark_inode_dirty(handle, dir);
+	dx_release(frames);
+	return retval;
 }
 
 /*
-- 
2.1.0

