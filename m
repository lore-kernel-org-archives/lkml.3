Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbbA1EYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:03 -0500
Received: from mail.kernel.org ([198.145.29.136]:40512 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977AbbA1EX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:58 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 121/177] ext4: bail out from make_indexed_dir() on first error
Date: Wed, 28 Jan 2015 12:09:39 +0800
Message-Id: <1422418236-12852-212-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4:
 - adjust context
 - replace ext4_handle_dirty_{dx,dirent}_node() with
   ext4_handle_dirty_metadata()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/ext4/namei.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c6dd936..dc58523 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1421,31 +1421,38 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	ext4fs_dirhash(name, namelen, &hinfo);
+	memset(frames, 0, sizeof(frames));
 	frame = frames;
 	frame->entries = entries;
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
 
-	ext4_handle_dirty_metadata(handle, dir, frame->bh);
-	ext4_handle_dirty_metadata(handle, dir, bh);
+	retval = ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	if (retval)
+		goto out_frames;
+	retval = ext4_handle_dirty_metadata(handle, dir, bh);
+	if (retval)
+		goto out_frames;
 
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
 	if (!de) {
-		/*
-		 * Even if the block split failed, we have to properly write
-		 * out all the changes we did so far. Otherwise we can end up
-		 * with corrupted filesystem.
-		 */
-		ext4_mark_inode_dirty(handle, dir);
-		dx_release(frames);
-		return retval;
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
1.9.1

