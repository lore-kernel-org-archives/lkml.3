Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3G3Spf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:45:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3G3Spc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 36/75] Btrfs: fix lock leak when resuming snapshot deletion
Date: Tue, 30 Jul 2013 11:44:40 -0700
Message-Id: <1375209919-1768-3-git-send-email-kamal@canonical.com>
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

commit fec386ac1428f9c0e672df952cbca5cebd4e4e2f upstream.

We aren't setting path->locks[level] when we resume a snapshot deletion which
means we won't unlock the buffer when we free the path.  This causes deadlocks
if we happen to re-allocate the block before we've evicted the extent buffer
from cache.  Thanks,

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d170412..17cfffd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7023,6 +7023,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -7039,6 +7040,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}
-- 
1.8.1.2

