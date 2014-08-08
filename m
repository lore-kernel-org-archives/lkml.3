Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbaHHWgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:36:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaHHUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 016/259] ext4: Fix buffer double free in ext4_alloc_branch()
Date: Fri,  8 Aug 2014 13:37:19 -0700
Message-Id: <1407530482-4483-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit c5c7b8ddfbf8cb3b2291e515a34ab1b8982f5a2d upstream.

Error recovery in ext4_alloc_branch() calls ext4_forget() even for
buffer corresponding to indirect block it did not allocate. This leads
to brelse() being called twice for that buffer (once from ext4_forget()
and once from cleanup in ext4_ind_map_blocks()) leading to buffer use
count misaccounting. Eventually (but often much later because there
are other users of the buffer) we will see messages like:
VFS: brelse: Trying to free free buffer

Another manifestation of this problem is an error:
JBD2 unexpected failure: jbd2_journal_revoke: !buffer_revoked(bh);
inconsistent data on disk

The fix is easy - don't forget buffer we did not allocate. Also add an
explanatory comment because the indexing at ext4_alloc_branch() is
somewhat subtle.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/indirect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 594009f..3b91d24 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -389,7 +389,13 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	return 0;
 failed:
 	for (; i >= 0; i--) {
-		if (i != indirect_blks && branch[i].bh)
+		/*
+		 * We want to ext4_forget() only freshly allocated indirect
+		 * blocks.  Buffer for new_blocks[i-1] is at branch[i].bh and
+		 * buffer at branch[0].bh is indirect block / inode already
+		 * existing before ext4_alloc_branch() was called.
+		 */
+		if (i > 0 && i != indirect_blks && branch[i].bh)
 			ext4_forget(handle, 1, inode, branch[i].bh,
 				    branch[i].bh->b_blocknr);
 		ext4_free_blocks(handle, inode, NULL, new_blocks[i],
-- 
1.9.1

