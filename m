Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaGHASL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:18:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaGGXzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.10 35/53] ext4: Fix buffer double free in ext4_alloc_branch()
Date: Mon,  7 Jul 2014 16:58:20 -0700
Message-Id: <20140707235830.348237956@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/indirect.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -390,7 +390,13 @@ static int ext4_alloc_branch(handle_t *h
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


