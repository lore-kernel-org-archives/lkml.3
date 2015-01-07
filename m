Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbbAGCYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:24:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbbAGCSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 3.17 72/73] Btrfs: fix loop writing of async reclaim
Date: Tue,  6 Jan 2015 18:16:33 -0800
Message-Id: <20150107021559.724807638@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4343,11 +4343,21 @@ static inline int need_do_async_reclaim(
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
@@ -4380,11 +4390,12 @@ static void btrfs_async_reclaim_metadata
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
 


