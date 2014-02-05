Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaBEURi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:17:38 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48586 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaBEUHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 189/213] udf: Fix data corruption for files in ICB
Date: Wed, 5 Feb 2014 15:02:24 -0500
Message-ID: <1391630568-49251-190-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9c2fc0de1a6e638fe58c354a463f544f42a90a09 upstream.

When a file is stored in ICB (inode), we overwrite part of the file, and
the page containing file's data is not in page cache, we end up corrupting
file's data by overwriting them with zeros. The problem is we use
simple_write_begin() which simply zeroes parts of the page which are not
written to. The problem has been introduced by be021ee4 (udf: convert to
new aops).

Fix the problem by providing a ->write_begin function which makes the page
properly uptodate.

Reported-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/udf/file.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 4b6a46ccbf46..af6f30ac228f 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -41,20 +41,24 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-static int udf_adinicb_readpage(struct file *file, struct page *page)
+static void __udf_adinicb_readpage(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	BUG_ON(!PageLocked(page));
-
 	kaddr = kmap(page);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
 	memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr, inode->i_size);
+	memset(kaddr + inode->i_size, 0, PAGE_CACHE_SIZE - inode->i_size);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	kunmap(page);
+}
+
+static int udf_adinicb_readpage(struct file *file, struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	__udf_adinicb_readpage(page);
 	unlock_page(page);
 
 	return 0;
@@ -79,6 +83,25 @@ static int udf_adinicb_writepage(struct page *page,
 	return 0;
 }
 
+static int udf_adinicb_write_begin(struct file *file,
+			struct address_space *mapping, loff_t pos,
+			unsigned len, unsigned flags, struct page **pagep,
+			void **fsdata)
+{
+	struct page *page;
+
+	if (WARN_ON_ONCE(pos >= PAGE_CACHE_SIZE))
+		return -EIO;
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
+	if (!PageUptodate(page) && len != PAGE_CACHE_SIZE)
+		__udf_adinicb_readpage(page);
+	return 0;
+}
+
 static int udf_adinicb_write_end(struct file *file,
 			struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
@@ -101,8 +124,8 @@ const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
 	.sync_page	= block_sync_page,
-	.write_begin = simple_write_begin,
-	.write_end = udf_adinicb_write_end,
+	.write_begin	= udf_adinicb_write_begin,
+	.write_end	= udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-- 
1.8.5.2

