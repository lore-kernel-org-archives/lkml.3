Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaJUQ2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:28:17 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:4406 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390AbaJUQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:28:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjAOADJxRlRbslJR/2dsb2JhbABcgw6BK7kQBQEBAQEBAQUBc5lhgRIXAX2EMC8jgRo3iEMBtROOXyyGI4ouHYQ1BZFZjAGMZIk+gUcBgjE7L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/affs/file.c: adding support to O_DIRECT
Date: Tue, 21 Oct 2014 18:28:11 +0200
Message-Id: <1413908891-6038-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on ext2_direct_IO

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 8e51085..05005bd 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -12,6 +12,7 @@
  *  affs regular file handling primitives
  */
 
+#include <linux/aio.h>
 #include "affs.h"
 
 #if PAGE_SIZE < 4096
@@ -392,6 +393,22 @@ static void affs_write_failed(struct address_space *mapping, loff_t to)
 	}
 }
 
+static ssize_t
+affs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+	       loff_t offset)
+{
+	struct file *file = iocb->ki_filp;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	size_t count = iov_iter_count(iter);
+	ssize_t ret;
+
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
+	if (ret < 0 && (rw & WRITE))
+		affs_write_failed(mapping, offset + count);
+	return ret;
+}
+
 static int affs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -418,6 +435,7 @@ const struct address_space_operations affs_aops = {
 	.writepage = affs_writepage,
 	.write_begin = affs_write_begin,
 	.write_end = generic_write_end,
+	.direct_IO = affs_direct_IO,
 	.bmap = _affs_bmap
 };
 
-- 
1.9.3

