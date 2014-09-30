Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaI3VjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaI3VjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Chinner <dchinner@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/103] xfs: don't zero partial page cache pages during O_DIRECT writes
Date: Tue, 30 Sep 2014 14:31:40 -0700
Message-Id: <1412112708-27356-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 834ffca6f7e345a79f6f2e2d131b0dfba8a4b67a upstream.

Similar to direct IO reads, direct IO writes are using
truncate_pagecache_range to invalidate the page cache. This is
incorrect due to the sub-block zeroing in the page cache that
truncate_pagecache_range() triggers.

This patch fixes things by using invalidate_inode_pages2_range
instead.  It preserves the page cache invalidation, but won't zero
any pages.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/xfs/xfs_file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5825705..d86a7eb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -689,7 +689,15 @@ xfs_file_dio_aio_write(
 						    pos, -1);
 		if (ret)
 			goto out;
-		truncate_pagecache_range(VFS_I(ip), pos, -1);
+		/*
+		 * Invalidate whole pages. This can return an error if
+		 * we fail to invalidate a page, but this should never
+		 * happen on XFS. Warn if it does fail.
+		 */
+		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+						pos >> PAGE_CACHE_SHIFT, -1);
+		WARN_ON_ONCE(ret);
+		ret = 0;
 	}
 
 	/*
-- 
1.9.1

