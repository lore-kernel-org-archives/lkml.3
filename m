Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaI3Vh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaI3Vh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 094/103] xfs: don't zero partial page cache pages during O_DIRECT writes
Date: Tue, 30 Sep 2014 14:31:39 -0700
Message-Id: <1412112708-27356-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 85e584da3212140ee80fd047f9058bbee0bc00d5 upstream.

xfs is using truncate_pagecache_range to invalidate the page cache
during DIO reads.  This is different from the other filesystems who
only invalidate pages during DIO writes.

truncate_pagecache_range is meant to be used when we are freeing the
underlying data structs from disk, so it will zero any partial
ranges in the page.  This means a DIO read can zero out part of the
page cache page, and it is possible the page will stay in cache.

buffered reads will find an up to date page with zeros instead of
the data actually on disk.

This patch fixes things by using invalidate_inode_pages2_range
instead.  It preserves the page cache invalidation, but won't zero
any pages.

[dchinner: catch error and warn if it fails. Comment.]

Signed-off-by: Chris Mason <clm@fb.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52c91e1..5825705 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -301,7 +301,16 @@ xfs_file_aio_read(
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
 			}
-			truncate_pagecache_range(VFS_I(ip), pos, -1);
+
+			/*
+			 * Invalidate whole pages. This can return an error if
+			 * we fail to invalidate a page, but this should never
+			 * happen on XFS. Warn if it does fail.
+			 */
+			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+						pos >> PAGE_CACHE_SHIFT, -1);
+			WARN_ON_ONCE(ret);
+			ret = 0;
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
-- 
1.9.1

