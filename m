Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbaLLGgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:36:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51937 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759316AbaLLGQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.175009887@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 099/164] ext4: bail out from make_indexed_dir() on
 first error
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - We have ext4_handle_dirty_metadata() not
   ext4_handle_dirty_{dx,dirent}_node()]
 - do_split() returns errors by reference not with ERR_PTR()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1408,31 +1408,38 @@ static int make_indexed_dir(handle_t *ha
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

