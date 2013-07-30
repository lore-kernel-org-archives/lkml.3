Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3G3Jc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53076 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab3G3Jcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 036/106] Btrfs: fix lock leak when resuming snapshot deletion
Date: Tue, 30 Jul 2013 10:30:55 +0100
Message-Id: <1375176725-5825-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit fec386ac1428f9c0e672df952cbca5cebd4e4e2f upstream.

We aren't setting path->locks[level] when we resume a snapshot deletion which
means we won't unlock the buffer when we free the path.  This causes deadlocks
if we happen to re-allocate the block before we've evicted the extent buffer
from cache.  Thanks,

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9e99ea0..9b1dc7b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6905,6 +6905,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -6921,6 +6922,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}
-- 
1.8.3.2

