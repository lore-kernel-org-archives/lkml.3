Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaDET5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:57:49 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:9446 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbaDET5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:57:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnwGAJhfQFNXQ7ZB/2dsb2JhbABYgwbFJIEUF3SCUxMcIxiBAiQTh30BzlqOcYQ/AQOOXYl9AZI/gzI7
Date: Sat, 5 Apr 2014 21:57:37 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1] fs/affs/file.c: Remove unnecessary function parameters
Message-Id: <20140405215737.085f0bb24de824582ac76350@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-affs_do_readpage_ofs is always called with from = 0 ie reading from page->index
-File parameter is never used

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/file.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 8669b6e..fd168ef 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -498,34 +498,36 @@ affs_getemptyblk_ino(struct inode *inode, int block)
 }
 
 static int
-affs_do_readpage_ofs(struct file *file, struct page *page, unsigned from, unsigned to)
+affs_do_readpage_ofs(struct page *page, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh;
 	char *data;
+	unsigned pos = 0;
 	u32 bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("AFFS: read_page(%u, %ld, %d, %d)\n", (u32)inode->i_ino, page->index, from, to);
-	BUG_ON(from > to || to > PAGE_CACHE_SIZE);
+	pr_debug("AFFS: read_page(%u, %ld, 0, %d)\n", (u32)inode->i_ino,
+		 page->index, to);
+	BUG_ON(to > PAGE_CACHE_SIZE);
 	kmap(page);
 	data = page_address(page);
 	bsize = AFFS_SB(sb)->s_data_blksize;
-	tmp = (page->index << PAGE_CACHE_SHIFT) + from;
+	tmp = page->index << PAGE_CACHE_SHIFT;
 	bidx = tmp / bsize;
 	boff = tmp % bsize;
 
-	while (from < to) {
+	while (pos < to) {
 		bh = affs_bread_ino(inode, bidx, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
-		tmp = min(bsize - boff, to - from);
-		BUG_ON(from + tmp > to || tmp > bsize);
-		memcpy(data + from, AFFS_DATA(bh) + boff, tmp);
+		tmp = min(bsize - boff, to - pos);
+		BUG_ON(pos + tmp > to || tmp > bsize);
+		memcpy(data + pos, AFFS_DATA(bh) + boff, tmp);
 		affs_brelse(bh);
 		bidx++;
-		from += tmp;
+		pos += tmp;
 		boff = 0;
 	}
 	flush_dcache_page(page);
@@ -615,7 +617,7 @@ affs_readpage_ofs(struct file *file, struct page *page)
 		memset(page_address(page) + to, 0, PAGE_CACHE_SIZE - to);
 	}
 
-	err = affs_do_readpage_ofs(file, page, 0, to);
+	err = affs_do_readpage_ofs(page, to);
 	if (!err)
 		SetPageUptodate(page);
 	unlock_page(page);
@@ -651,7 +653,7 @@ static int affs_write_begin_ofs(struct file *file, struct address_space *mapping
 		return 0;
 
 	/* XXX: inefficient but safe in the face of short writes */
-	err = affs_do_readpage_ofs(file, page, 0, PAGE_CACHE_SIZE);
+	err = affs_do_readpage_ofs(page, PAGE_CACHE_SIZE);
 	if (err) {
 		unlock_page(page);
 		page_cache_release(page);
-- 
1.8.4.5

