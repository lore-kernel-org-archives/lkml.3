Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaIZKEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:04:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbaIZJqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 102/142] xfs: don't zero partial page cache pages during O_DIRECT writes
Date: Fri, 26 Sep 2014 11:45:13 +0200
Message-Id: <a241067d53187f0b9bc06956da5f0152398a9405.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4c749ab543d0..3e0fccf54ed5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -678,7 +678,15 @@ xfs_file_dio_aio_write(
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
2.1.0

