Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3IKG5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:57:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IKG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:56:45 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=7T-zYNeqU1gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QPzPuoYzAmsA:10 a=vpVRfoo1AAAA:8 a=VwQbUJbxAAAA:8 a=ASTB1Uf0AAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=0yVQzcu7H6MA:10 a=pDhNVk4yl4oA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042908.486052404@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [097/251] Btrfs: re-add root to dead root list if we stop dropping it
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0097-Btrfs-re-add-root-to-dead-root-list-if-we-stop-dropp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

[ Upstream commit d29a9f629e009c9b90e5859bce581070fd6247fc ]

If we stop dropping a root for whatever reason we need to add it back to the
dead root list so that we will re-start the dropping next transaction commit.
The other case this happens is if we recover a drop because we will add a root
without adding it to the fs radix tree, so we can leak it's root and commit root
extent buffer, adding this to the dead root list makes this cleanup happen.
Thanks,

Cc: stable@vger.kernel.org
Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/btrfs/extent-tree.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dcfce2a..3b09565 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6950,6 +6950,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	int err = 0;
 	int ret;
 	int level;
+	bool root_dropped = false;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -7120,12 +7121,22 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
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
1.7.10.4


