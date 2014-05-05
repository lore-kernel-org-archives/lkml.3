Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaEEMuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41021 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 41/50] ext4: fix premature freeing of partial clusters split across leaf blocks
Date: Mon,  5 May 2014 14:43:23 +0200
Message-Id: <1eccbcabcd88d6a110080fdd5c9bf46173d940b5.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/extents.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d9c53f12a4d9..8dd96591b2f8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2762,10 +2762,15 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
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
1.9.2

