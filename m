Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3FDXBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:01:51 -0400
Received: from 1wt.eu ([62.212.114.60]:35658 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3FDWnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:06 -0400
Message-Id: <20130604172135.284097181@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 120/184] ext4: Fix fs corruption when make_indexed_dir()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 fails

From: Jan Kara <jack@suse.cz>

When make_indexed_dir() fails (e.g. because of ENOSPC) after it has
allocated block for index tree root, we did not properly mark all
changed buffers dirty.  This lead to only some of these buffers being
written out and thus effectively corrupting the directory.

Fix the issue by marking all changed data dirty even in the error
failure case.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 7ad8e4e6ae2a7c95445ee1715b1714106fb95037)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/namei.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c3b6ad0..afe3148 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1458,9 +1458,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->bh = bh;
 	bh = bh2;
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
-	if (!(de))
+	if (!de) {
+		/*
+		 * Even if the block split failed, we have to properly write
+		 * out all the changes we did so far. Otherwise we can end up
+		 * with corrupted filesystem.
+		 */
+		ext4_mark_inode_dirty(handle, dir);
+		ext4_handle_dirty_metadata(handle, dir, frame->bh);
+		ext4_handle_dirty_metadata(handle, dir, bh);
+		dx_release(frames);
 		return retval;
+	}
+	dx_release(frames);
 
 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
-- 
1.7.12.2.21.g234cd45.dirty



