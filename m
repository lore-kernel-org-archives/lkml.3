Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030215Ab3HBKKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:10:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847Ab3HBKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 40/99] Btrfs: re-add root to dead root list if we stop dropping it
Date: Fri,  2 Aug 2013 18:07:53 +0800
Message-Id: <20130802100231.682178366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7298,6 +7298,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	int err = 0;
 	int ret;
 	int level;
+	bool root_dropped = false;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -7473,12 +7474,22 @@ int btrfs_drop_snapshot(struct btrfs_roo
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


