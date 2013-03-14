Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab3CNKnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:43:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3CNKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josef Bacik <jbacik@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 72/88] Btrfs: account for orphan inodes properly during cleanup
Date: Thu, 14 Mar 2013 10:36:05 +0000
Message-Id: <1363257381-15900-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 925396ecf251432d6d0f703a6cfd0cb9e651d936 upstream.

Dave sent me a panic where we were doing the orphan cleanup and panic'ed
trying to release our reservation from the orphan block rsv.  The reason for
this is because our orphan block rsv had been free'd out from underneath us
because the transaction commit found that there were no orphan inodes
according to its count and decided to free it.  This is incorrect so make
sure we inc the orphan inodes count so the accounting is all done properly.
This would also cause the warning in the orphan commit code normally if you
had any orphans to cleanup as they would only decrement the orphan count so
you'd get a negative orphan count which could cause problems during runtime.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a7d1921..fadf1c3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2433,6 +2433,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 */
 		set_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			&BTRFS_I(inode)->runtime_flags);
+		atomic_inc(&root->orphan_inodes);
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
-- 
1.8.1.2

