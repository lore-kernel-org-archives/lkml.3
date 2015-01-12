Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbbALSbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:31:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbbALSa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 199/216] Btrfs: fix loop writing of async reclaim
Date: Mon, 12 Jan 2015 18:29:37 +0000
Message-Id: <1421087394-2712-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 25ce459c1af138f95a3fd318461193397ebb825b upstream.

One of my tests shows that when we really don't have space to reclaim via
flush_space and also run out of space, this async reclaim work loops on adding
itself into the workqueue and keeps writing something to disk according to
iostat's results, and these writes mainly comes from commit_transaction which
writes super_block.  This's unacceptable as it can be bad to disks, especially
memeory storages.

This adds a check to avoid the above situation.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: Alexander E. Patrakov <patrakov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent-tree.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47121133f4d8..58f014a2bba1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4349,11 +4349,21 @@ static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
 }
 
 static int btrfs_need_do_async_reclaim(struct btrfs_space_info *space_info,
-				       struct btrfs_fs_info *fs_info)
+				       struct btrfs_fs_info *fs_info,
+				       int flush_state)
 {
 	u64 used;
 
 	spin_lock(&space_info->lock);
+	/*
+	 * We run out of space and have not got any free space via flush_space,
+	 * so don't bother doing async reclaim.
+	 */
+	if (flush_state > COMMIT_TRANS && space_info->full) {
+		spin_unlock(&space_info->lock);
+		return 0;
+	}
+
 	used = space_info->bytes_used + space_info->bytes_reserved +
 	       space_info->bytes_pinned + space_info->bytes_readonly +
 	       space_info->bytes_may_use;
@@ -4386,11 +4396,12 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 		flush_space(fs_info->fs_root, space_info, to_reclaim,
 			    to_reclaim, flush_state);
 		flush_state++;
-		if (!btrfs_need_do_async_reclaim(space_info, fs_info))
+		if (!btrfs_need_do_async_reclaim(space_info, fs_info,
+						 flush_state))
 			return;
 	} while (flush_state <= COMMIT_TRANS);
 
-	if (btrfs_need_do_async_reclaim(space_info, fs_info))
+	if (btrfs_need_do_async_reclaim(space_info, fs_info, flush_state))
 		queue_work(system_unbound_wq, work);
 }
 
-- 
2.1.4

