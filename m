Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbaF3MKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:10:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52006 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jie Liu <jeff.liu@oracle.com>,
        Ben Myers <bpm@sgi.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/181] xfs: don't perform discard if the given range length is less than block size
Date: Mon, 30 Jun 2014 13:51:05 +0200
Message-Id: <7a244136936f105d353eab16e2583f0bd418c927.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f9fd0135610084abef6867d984e9951c3099950d upstream.

For discard operation, we should return EINVAL if the given range length
is less than a block size, otherwise it will go through the file system
to discard data blocks as the end range might be evaluated to -1, e.g,
/xfs7: 9811378176 bytes were trimmed

This issue can be triggered via xfstests/generic/288.

Also, it seems to get the request queue pointer via bdev_get_queue()
instead of the hard code pointer dereference is not a bad thing.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_discard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 45560ee1a4ba..19d9fd6caf8c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -158,7 +158,7 @@ xfs_ioc_trim(
 	struct xfs_mount		*mp,
 	struct fstrim_range __user	*urange)
 {
-	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
+	struct request_queue	*q = bdev_get_queue(mp->m_ddev_targp->bt_bdev);
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
 	xfs_daddr_t		start, end, minlen;
@@ -181,7 +181,8 @@ xfs_ioc_trim(
 	 * matter as trimming blocks is an advisory interface.
 	 */
 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
-	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
+	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)) ||
+	    range.len < mp->m_sb.sb_blocksize)
 		return -XFS_ERROR(EINVAL);
 
 	start = BTOBB(range.start);
-- 
2.0.0

