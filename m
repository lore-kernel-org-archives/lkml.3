Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3CAUK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:10:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3CATpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [ 52/77] ext4: fix xattr block allocation/release with bigalloc
Date: Fri,  1 Mar 2013 11:44:37 -0800
Message-Id: <20130301194357.475924140@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -549,7 +549,7 @@ ext4_xattr_release_block(handle_t *handl
 		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
-		dquot_free_block(inode, 1);
+		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
 	}
@@ -832,7 +832,8 @@ inserted:
 			else {
 				/* The old block is released after updating
 				   the inode. */
-				error = dquot_alloc_block(inode, 1);
+				error = dquot_alloc_block(inode,
+						EXT4_C2B(EXT4_SB(sb), 1));
 				if (error)
 					goto cleanup;
 				error = ext4_journal_get_write_access(handle,
@@ -929,7 +930,7 @@ cleanup:
 	return error;
 
 cleanup_dquot:
-	dquot_free_block(inode, 1);
+	dquot_free_block(inode, EXT4_C2B(EXT4_SB(sb), 1));
 	goto cleanup;
 
 bad_block:


