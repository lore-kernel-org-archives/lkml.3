Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab3CDD6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:58:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616Ab3CDDoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:08 -0500
Message-Id: <20130304033714.349403510@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Lukas Czerner <lczerner@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Subject: [ 069/153] ext4: fix xattr block allocation/release with bigalloc
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 1231b3a1eb5740192aeebf5344dd6d6da000febf upstream.

Currently when new xattr block is created or released we we would call
dquot_free_block() or dquot_alloc_block() respectively, among the else
decrementing or incrementing the number of blocks assigned to the
inode by one block.

This however does not work for bigalloc file system because we always
allocate/free the whole cluster so we have to count with that in
dquot_free_block() and dquot_alloc_block() as well.

Use the clusters-to-blocks conversion EXT4_C2B() when passing number of
blocks to the dquot_alloc/free functions to fix the problem.

The problem has been revealed by xfstests #117 (and possibly others).

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -496,7 +496,7 @@ ext4_xattr_release_block(handle_t *handl
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
-		dquot_free_block(inode, 1);
+		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
 	}
@@ -785,7 +785,8 @@ inserted:
 			else {
 				/* The old block is released after updating
 				   the inode. */
-				error = dquot_alloc_block(inode, 1);
+				error = dquot_alloc_block(inode,
+						EXT4_C2B(EXT4_SB(sb), 1));
 				if (error)
 					goto cleanup;
 				error = ext4_journal_get_write_access(handle,
@@ -881,7 +882,7 @@ cleanup:
 	return error;
 
 cleanup_dquot:
-	dquot_free_block(inode, 1);
+	dquot_free_block(inode, EXT4_C2B(EXT4_SB(sb), 1));
 	goto cleanup;
 
 bad_block:


