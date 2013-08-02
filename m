Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3HBKSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:18:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3HBKSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:18:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Lyakas <alex.btrfs@zadarastorage.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 17/39] Btrfs: fix lock leak when resuming snapshot deletion
Date: Fri,  2 Aug 2013 18:18:27 +0800
Message-Id: <20130802101459.260385063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit fec386ac1428f9c0e672df952cbca5cebd4e4e2f upstream.

We aren't setting path->locks[level] when we resume a snapshot deletion which
means we won't unlock the buffer when we free the path.  This causes deadlocks
if we happen to re-allocate the block before we've evicted the extent buffer
from cache.  Thanks,

Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6903,6 +6903,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 		while (1) {
 			btrfs_tree_lock(path->nodes[level]);
 			btrfs_set_lock_blocking(path->nodes[level]);
+			path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
 
 			ret = btrfs_lookup_extent_info(trans, root,
 						path->nodes[level]->start,
@@ -6919,6 +6920,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 				break;
 
 			btrfs_tree_unlock(path->nodes[level]);
+			path->locks[level] = 0;
 			WARN_ON(wc->refs[level] != 1);
 			level--;
 		}


