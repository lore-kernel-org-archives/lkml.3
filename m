Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762403AbaGRN51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:57:27 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17449 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965332AbaGRNJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 109/170] ext4: Fix buffer double free in ext4_alloc_branch()
Date: Fri, 18 Jul 2014 14:11:54 +0200
Message-Id: <d1eec904d07f7afa42bc3ad7ebb20e43d1d4b7f8.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/indirect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 594009f5f523..3b91d240da4d 100644
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
2.0.0

