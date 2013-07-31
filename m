Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab3GaNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:25:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46938 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759715Ab3GaNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Josef Bacik" <jbacik@fusionio.com>,
        "Alex Lyakas" <alex.btrfs@zadarastorage.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.464386024@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [55/84] Btrfs: re-add root to dead root list if we stop dropping it
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6560,6 +6560,7 @@ void btrfs_drop_snapshot(struct btrfs_ro
 	int err = 0;
 	int ret;
 	int level;
+	bool root_dropped = false;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -6709,11 +6710,21 @@ void btrfs_drop_snapshot(struct btrfs_ro
 		free_extent_buffer(root->commit_root);
 		kfree(root);
 	}
+	root_dropped = true;
 out_free:
 	btrfs_end_transaction_throttle(trans, tree_root);
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
 	return;

