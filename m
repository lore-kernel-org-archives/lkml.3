Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3IMPUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:20:05 -0400
Received: from relay.parallels.com ([195.214.232.42]:38131 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3IMPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:20:03 -0400
Subject: [PATCH 1/2] fuse: wait for writeback in fuse_file_fallocate() -v3
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, xemul@parallels.com
Date: Fri, 13 Sep 2013 19:19:54 +0400
Message-ID: <20130913151928.11415.44205.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 fs/fuse/file.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d409dea..f9f07c4 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2484,8 +2484,15 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 
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
@@ -2520,11 +2527,8 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
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

