Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaIHLii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:38:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:31121 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaIHLif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:38:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="599616623"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, huang.ying.caritas@gmail.com
Subject: [PATCH] f2fs: Fix recover when nid of non-inode dnode < nid of inode
Date: Mon,  8 Sep 2014 19:38:26 +0800
Message-Id: <1410176306-1689-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For fsync, if the nid of a non-inode dnode < nid of inode and the
inode is not checkpointed.  The non-inode dnode may be written before
inode.  So in find_fsync_dnodes, f2fs_iget will fail, cause the
recovery fail.

Usually, inode will be allocated before non-inode dnode, so the nid of
inode < nid of non-inode dnode.  But it is possible for the reverse.
For example, because of alloc_nid_failed.

This is fixed via ignoring non-inode dnode before inode dnode in
find_fsync_dnodes.

The patch was tested via allocating nid reversely via a debugging
patch, that is, from big number to small number.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/recovery.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -172,8 +172,8 @@ static int find_fsync_dnodes(struct f2fs
 			if (IS_INODE(page) && is_dent_dnode(page))
 				set_inode_flag(F2FS_I(entry->inode),
 							FI_INC_LINK);
-		} else {
-			if (IS_INODE(page) && is_dent_dnode(page)) {
+		} else if (IS_INODE(page)) {
+			if (is_dent_dnode(page)) {
 				err = recover_inode_page(sbi, page);
 				if (err)
 					break;
@@ -193,7 +193,8 @@ static int find_fsync_dnodes(struct f2fs
 				break;
 			}
 			list_add_tail(&entry->list, head);
-		}
+		} else
+			goto next;
 		entry->blkaddr = blkaddr;
 
 		err = recover_inode(entry->inode, page);
