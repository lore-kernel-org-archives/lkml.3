Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbaIOUve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:51:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaIOTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.16 135/158] xfs: dont zero partial page cache pages during O_DIRECT writes
Date: Mon, 15 Sep 2014 12:26:14 -0700
Message-Id: <20140915192546.927541028@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_file.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -634,7 +634,15 @@ xfs_file_dio_aio_write(
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


