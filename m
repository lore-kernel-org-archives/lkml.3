Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaATM2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbaATMYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:49 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/24] GFS2: No need to invalidate pages for a dio read
Date: Mon, 20 Jan 2014 12:23:39 +0000
Message-Id: <1390220627-1571-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently fixed the writeback of pages prior to performing
direct i/o, however the initial fix was perhaps a bit heavy
handed. There is no need to invalidate pages if the direct i/o
is only a read, since they will be identical to what has been
flushed to disk anyway.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index cf858da..49436fa 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1032,8 +1032,9 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 			unmap_shared_mapping_range(ip->i_inode.i_mapping, offset, len);
 		rv = filemap_write_and_wait_range(mapping, lstart, end);
 		if (rv)
-			return rv;
-		truncate_inode_pages_range(mapping, lstart, end);
+			goto out;
+		if (rw == WRITE)
+			truncate_inode_pages_range(mapping, lstart, end);
 	}
 
 	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-- 
1.8.3.1

