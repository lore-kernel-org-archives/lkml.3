Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbaIOUTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:19:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaIOTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:46:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.14 094/114] xfs: dont zero partial page cache pages during O_DIRECT write
Date: Mon, 15 Sep 2014 12:26:34 -0700
Message-Id: <20140915192644.365447556@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/xfs/xfs_file.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -302,7 +302,16 @@ xfs_file_aio_read(
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


