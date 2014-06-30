Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaF3MIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:08:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52022 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753615AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jie Liu <jeff.liu@oracle.com>,
        Ben Myers <bpm@sgi.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 036/181] xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
Date: Mon, 30 Jun 2014 13:50:57 +0200
Message-Id: <d2ce3ef3180752eeafb02d1216aeb6a769926f42.1404128998.git.jslaby@suse.cz>
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

commit 17ec81c15fd022842f9bc947841ba9fb9eb52591 upstream.

At xfs_iext_realloc_direct(), the new_size is changed by adding
if_bytes if originally the extent records are stored at the inline
extent buffer, and we have to switch from it to a direct extent
list for those new allocated extents, this is wrong. e.g,

Create a file with three extents which was showing as following,

xfs_io -f -c "truncate 100m" /xfs/testme

for i in $(seq 0 5 10); do
	offset=$(($i * $((1 << 20))))
	xfs_io -c "pwrite $offset 1m" /xfs/testme
done

Inline
------
irec:	if_bytes	bytes_diff	new_size
1st	0		16		16
2nd	16		16		32

Switching
---------						rnew_size
3rd	32		16		48 + 32 = 80	roundup=128

In this case, the desired value of new_size should be 48, and then
it will be roundup to 64 and be assigned to rnew_size.

However, this issue has been covered by resetting the if_bytes to
the new_size which is calculated at the begnning of xfs_iext_add()
before leaving out this function, and in turn make the rnew_size
correctly again. Hence, this can not be detected via xfstestes.

This patch fix above problem and revise the new_size comments at
xfs_iext_realloc_direct() to make it more readable.  Also, fix the
comments while switching from the inline extent buffer to a direct
extent list to reflect this change.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_inode_fork.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 02f1083955bb..4fa56fcb38d1 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -1359,7 +1359,7 @@ xfs_iext_remove_indirect(
 void
 xfs_iext_realloc_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	int		new_size)	/* new size of extents */
+	int		new_size)	/* new size of extents after adding */
 {
 	int		rnew_size;	/* real new size of extents */
 
@@ -1397,13 +1397,8 @@ xfs_iext_realloc_direct(
 				rnew_size - ifp->if_real_bytes);
 		}
 	}
-	/*
-	 * Switch from the inline extent buffer to a direct
-	 * extent list. Be sure to include the inline extent
-	 * bytes in new_size.
-	 */
+	/* Switch from the inline extent buffer to a direct extent list */
 	else {
-		new_size += ifp->if_bytes;
 		if (!is_power_of_2(new_size)) {
 			rnew_size = roundup_pow_of_two(new_size);
 		}
-- 
2.0.0

