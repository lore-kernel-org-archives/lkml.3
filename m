Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3B1PCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:02:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3B1Ot4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lukas Czerner <lczerner@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 099/139] ext4: fix xattr block allocation/release with bigalloc
Date: Thu, 28 Feb 2013 14:44:09 +0000
Message-Id: <1362062689-2567-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/xattr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 3390680..1d261e6 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -554,7 +554,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		error = ext4_handle_dirty_xattr_block(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
-		dquot_free_block(inode, 1);
+		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
 		ea_bdebug(bh, "refcount now=%d; releasing",
 			  le32_to_cpu(BHDR(bh)->h_refcount));
 	}
@@ -843,7 +843,8 @@ inserted:
 			else {
 				/* The old block is released after updating
 				   the inode. */
-				error = dquot_alloc_block(inode, 1);
+				error = dquot_alloc_block(inode,
+						EXT4_C2B(EXT4_SB(sb), 1));
 				if (error)
 					goto cleanup;
 				error = ext4_journal_get_write_access(handle,
@@ -940,7 +941,7 @@ cleanup:
 	return error;
 
 cleanup_dquot:
-	dquot_free_block(inode, 1);
+	dquot_free_block(inode, EXT4_C2B(EXT4_SB(sb), 1));
 	goto cleanup;
 
 bad_block:
-- 
1.8.1.2

