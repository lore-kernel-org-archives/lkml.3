Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaF3MIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:08:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52007 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jie Liu <jeff.liu@oracle.com>,
        Ben Myers <bpm@sgi.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 042/181] xfs: fix the extent count when allocating an new indirection array entry
Date: Mon, 30 Jun 2014 13:51:03 +0200
Message-Id: <ce5094bc87fd27feaa0180ae202dd055b24a6af0.1404128998.git.jslaby@suse.cz>
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

commit bb86d21cba22a045b09d11b71decf5ca7c3d5def upstream.

At xfs_iext_add(), if extent(s) are being appended to the last page in
the indirection array and the new extent(s) don't fit in the page, the
number of extents(erp->er_extcount) in a new allocated entry should be
the minimum value between count and XFS_LINEAR_EXTS, instead of count.

For now, there is no existing test case can demonstrates a problem with
the er_extcount being set incorrectly here, but it obviously like a bug.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_inode_fork.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 4fa56fcb38d1..6829134de253 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -1031,15 +1031,14 @@ xfs_iext_add(
 		 * the next index needed in the indirection array.
 		 */
 		else {
-			int	count = ext_diff;
+			uint	count = ext_diff;
 
 			while (count) {
 				erp = xfs_iext_irec_new(ifp, erp_idx);
-				erp->er_extcount = count;
-				count -= MIN(count, (int)XFS_LINEAR_EXTS);
-				if (count) {
+				erp->er_extcount = min(count, XFS_LINEAR_EXTS);
+				count -= erp->er_extcount;
+				if (count)
 					erp_idx++;
-				}
 			}
 		}
 	}
-- 
2.0.0

