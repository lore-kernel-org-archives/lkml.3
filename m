Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbaAFWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:48:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435AbaAFWmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.4 36/43] GFS2: Fix incorrect invalidation for DIO/buffered I/O
Date: Mon,  6 Jan 2014 14:39:53 -0800
Message-Id: <20140106223943.282726499@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/aops.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1012,6 +1012,7 @@ static ssize_t gfs2_direct_IO(int rw, st
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = inode->i_mapping;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder gh;
 	int rv;
@@ -1032,6 +1033,35 @@ static ssize_t gfs2_direct_IO(int rw, st
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


