Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3G3Spi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:45:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3G3Spc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 37/75] Btrfs: re-add root to dead root list if we stop dropping it
Date: Tue, 30 Jul 2013 11:44:41 -0700
Message-Id: <1375209919-1768-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit d29a9f629e009c9b90e5859bce581070fd6247fc upstream.

If we stop dropping a root for whatever reason we need to add it back to the
dead root list so that we will re-start the dropping next transaction commit.
The other case this happens is if we recover a drop because we will add a root
without adding it to the fs radix tree, so we can leak it's root and commit root
extent buffer, adding this to the dead root list makes this cleanup happen.
Thanks,

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/extent-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 17cfffd..aa8acfa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6966,6 +6966,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int err = 0;
 	int ret;
 	int level;
+	bool root_dropped = false;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -7136,12 +7137,22 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		free_extent_buffer(root->commit_root);
 		kfree(root);
 	}
+	root_dropped = true;
 out_end_trans:
 	btrfs_end_transaction_throttle(trans, tree_root);
 out_free:
 	kfree(wc);
 	btrfs_free_path(path);
 out:
+	/*
+	 * So if we need to stop dropping the snapshot for whatever reason we
+	 * need to make sure to add it back to the dead root list so that we
+	 * keep trying to do the work later.  This also cleans up roots if we
+	 * don't have it in the radix (like when we recover after a power fail
+	 * or unmount) so we don't leak memory.
+	 */
+	if (root_dropped == false)
+		btrfs_add_dead_root(root);
 	if (err)
 		btrfs_std_error(root->fs_info, err);
 	return err;
-- 
1.8.1.2

