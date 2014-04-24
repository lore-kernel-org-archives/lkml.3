Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaDXIyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:54:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaDXIyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Whitney <enwlinux@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/182] ext4: fix premature freeing of partial clusters split across leaf blocks
Date: Thu, 24 Apr 2014 09:50:38 +0100
Message-Id: <1398329507-5911-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

commit ad6599ab3ac98a4474544086e048ce86ec15a4d1 upstream.

Xfstests generic/311 and shared/298 fail when run on a bigalloc file
system.  Kernel error messages produced during the tests report that
blocks to be freed are already on the to-be-freed list.  When e2fsck
is run at the end of the tests, it typically reports bad i_blocks and
bad free blocks counts.

The bug that causes these failures is located in ext4_ext_rm_leaf().
Code at the end of the function frees a partial cluster if it's not
shared with an extent remaining in the leaf.  However, if all the
extents in the leaf have been removed, the code dereferences an
invalid extent pointer (off the front of the leaf) when the check for
sharing is made.  This generally has the effect of unconditionally
freeing the partial cluster, which leads to the observed failures
when the partial cluster is shared with the last extent in the next
leaf.

Fix this by attempting to free the cluster only if extents remain in
the leaf.  Any remaining partial cluster will be freed if possible
when the next leaf is processed or when leaf removal is complete.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3960bba..8a5cee9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2673,10 +2673,15 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		err = ext4_ext_correct_indexes(handle, inode, path);
 
 	/*
-	 * Free the partial cluster only if the current extent does not
-	 * reference it. Otherwise we might free used cluster.
+	 * If there's a partial cluster and at least one extent remains in
+	 * the leaf, free the partial cluster if it isn't shared with the
+	 * current extent.  If there's a partial cluster and no extents
+	 * remain in the leaf, it can't be freed here.  It can only be
+	 * freed when it's possible to determine if it's not shared with
+	 * any other extent - when the next leaf is processed or when space
+	 * removal is complete.
 	 */
-	if (*partial_cluster > 0 &&
+	if (*partial_cluster > 0 && eh->eh_entries &&
 	    (EXT4_B2C(sbi, ext4_ext_pblock(ex) + ex_ee_len - 1) !=
 	     *partial_cluster)) {
 		int flags = get_default_free_blocks_flags(inode);
-- 
1.9.1

