Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaBEUXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:23:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:55460 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaBEUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 172/213] ext4: Fix fs corruption when make_indexed_dir() fails
Date: Wed, 5 Feb 2014 15:02:07 -0500
Message-ID: <1391630568-49251-173-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7ad8e4e6ae2a7c95445ee1715b1714106fb95037 upstream.

When make_indexed_dir() fails (e.g. because of ENOSPC) after it has
allocated block for index tree root, we did not properly mark all
changed buffers dirty.  This lead to only some of these buffers being
written out and thus effectively corrupting the directory.

Fix the issue by marking all changed data dirty even in the error
failure case.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/namei.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2f31631935ba..caa3c77f1743 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1452,9 +1452,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
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
1.8.5.2

