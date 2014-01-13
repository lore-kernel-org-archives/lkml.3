Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaAMOor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:44:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaAMO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 63/96] GFS2: Fix incorrect invalidation for DIO/buffered I/O
Date: Mon, 13 Jan 2014 14:24:26 +0000
Message-Id: <1389623099-18783-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit dfd11184d894cd0a92397b25cac18831a1a6a5bc upstream.

In patch 209806aba9d540dde3db0a5ce72307f85f33468f we allowed
local deferred locks to be granted against a cached exclusive
lock. That opened up a corner case which this patch now
fixes.

The solution to the problem is to check whether we have cached
pages each time we do direct I/O and if so to unmap, flush
and invalidate those pages. Since the glock state machine
normally does that for us, mostly the code will be a no-op.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/aops.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index e80a464..0111060 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1011,6 +1011,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = inode->i_mapping;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder gh;
 	int rv;
@@ -1031,6 +1032,35 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
+	/*
+	 * Now since we are holding a deferred (CW) lock at this point, you
+	 * might be wondering why this is ever needed. There is a case however
+	 * where we've granted a deferred local lock against a cached exclusive
+	 * glock. That is ok provided all granted local locks are deferred, but
+	 * it also means that it is possible to encounter pages which are
+	 * cached and possibly also mapped. So here we check for that and sort
+	 * them out ahead of the dio. The glock state machine will take care of
+	 * everything else.
+	 *
+	 * If in fact the cached glock state (gl->gl_state) is deferred (CW) in
+	 * the first place, mapping->nr_pages will always be zero.
+	 */
+	if (mapping->nrpages) {
+		loff_t lstart = offset & (PAGE_CACHE_SIZE - 1);
+		loff_t len = iov_length(iov, nr_segs);
+		loff_t end = PAGE_ALIGN(offset + len) - 1;
+
+		rv = 0;
+		if (len == 0)
+			goto out;
+		if (test_and_clear_bit(GIF_SW_PAGED, &ip->i_flags))
+			unmap_shared_mapping_range(ip->i_inode.i_mapping, offset, len);
+		rv = filemap_write_and_wait_range(mapping, lstart, end);
+		if (rv)
+			return rv;
+		truncate_inode_pages_range(mapping, lstart, end);
+	}
+
 	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, gfs2_get_block_direct,
 				  NULL, NULL, 0);
-- 
1.8.3.2

