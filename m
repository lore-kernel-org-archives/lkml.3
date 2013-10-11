Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab3JKT6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:58:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3JKTlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [ 072/135] fuse: wait for writeback in fuse_file_fallocate()
Date: Fri, 11 Oct 2013 12:39:13 -0700
Message-Id: <20131011193953.107582886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Patlasov <MPatlasov@parallels.com>

commit bde52788bdb755b9e4b75db6c434f30e32a0ca0b upstream.

The patch fixes a race between mmap-ed write and fallocate(PUNCH_HOLE):

1) An user makes a page dirty via mmap-ed write.
2) The user performs fallocate(2) with mode == PUNCH_HOLE|KEEP_SIZE
   and <offset, size> covering the page.
3) Before truncate_pagecache_range call from fuse_file_fallocate,
   the page goes to write-back. The page is fully processed by fuse_writepage
   (including end_page_writeback on the page), but fuse_flush_writepages did
   nothing because fi->writectr < 0.
4) truncate_pagecache_range is called and fuse_file_fallocate is finishing
   by calling fuse_release_nowrite. The latter triggers processing queued
   write-back request which will write stale data to the hole soon.

Changed in v2 (thanks to Brian for suggestion):
 - Do not truncate page cache until FUSE_FALLOCATE succeeded. Otherwise,
   we can end up in returning -ENOTSUPP while user data is already punched
   from page cache. Use filemap_write_and_wait_range() instead.
Changed in v3 (thanks to Miklos for suggestion):
 - fuse_wait_on_writeback() is prone to livelocks; use fuse_set_nowrite()
   instead. So far as we need a dirty-page barrier only, fuse_sync_writes()
   should be enough.
 - rebased to for-linus branch of fuse.git

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2484,8 +2484,15 @@ static long fuse_file_fallocate(struct f
 
 	if (lock_inode) {
 		mutex_lock(&inode->i_mutex);
-		if (mode & FALLOC_FL_PUNCH_HOLE)
-			fuse_set_nowrite(inode);
+		if (mode & FALLOC_FL_PUNCH_HOLE) {
+			loff_t endbyte = offset + length - 1;
+			err = filemap_write_and_wait_range(inode->i_mapping,
+							   offset, endbyte);
+			if (err)
+				goto out;
+
+			fuse_sync_writes(inode);
+		}
 	}
 
 	req = fuse_get_req_nopages(fc);
@@ -2520,11 +2527,8 @@ static long fuse_file_fallocate(struct f
 	fuse_invalidate_attr(inode);
 
 out:
-	if (lock_inode) {
-		if (mode & FALLOC_FL_PUNCH_HOLE)
-			fuse_release_nowrite(inode);
+	if (lock_inode)
 		mutex_unlock(&inode->i_mutex);
-	}
 
 	return err;
 }


