Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaKDV0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:26:41 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:9187 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaKDV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:26:40 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcOAEZDWVRbsl9p/2dsb2JhbABagw6BLLp/BgEBAQEBBQF0miiBJBcBAQEBAX2EMC8jgRo3iEUBu3uPBSyGN4pZHYQ1BZF3jBCMd4lYgUcBgjE8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH V2 linux-next] fs/affs/file.c: adding support to O_DIRECT
Date: Tue,  4 Nov 2014 22:26:30 +0100
Message-Id: <1415136390-3892-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on ext2_direct_IO

Tested with O_DIRECT file open and sysbench/mariadb with 1%
written queries improvement (update_non_index test) on a volume
created with mkaffs.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: Adding test results (suggested by Andrew Morton)

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

