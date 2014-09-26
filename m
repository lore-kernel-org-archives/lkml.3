Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaIZKGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:06:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbaIZJq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/142] xfs: don't zero partial page cache pages during O_DIRECT writes
Date: Fri, 26 Sep 2014 11:45:14 +0200
Message-Id: <e00641c38e767943d0cc426063e0f562d6b259cc.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <clm@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3e0fccf54ed5..d56b136e68fe 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -299,7 +299,16 @@ xfs_file_aio_read(
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
2.1.0

