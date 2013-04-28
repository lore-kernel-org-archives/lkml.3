Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3D1AEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 20:04:30 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:41146 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3D1AE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 20:04:28 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/2] f2fs: reorganize f2fs_vm_page_mkwrite
Date: Sun, 28 Apr 2013 09:04:18 +0900
Message-Id: <1367107458-2439-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Few things can be changed in the default mkwrite function
1) Make file_update_time at the start before acquiring any lock
2) the condition page_offset(page) >= i_size_read(inode) should be
 changed to page_offset(page) > i_size_read
3) Move wait_on_page_writeback.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/file.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5cc4dd8..dc76f9b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -63,9 +63,10 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	f2fs_put_dnode(&dn);
 	mutex_unlock_op(sbi, ilock);
 
+	file_update_time(vma->vm_file);
 	lock_page(page);
 	if (page->mapping != inode->i_mapping ||
-			page_offset(page) >= i_size_read(inode) ||
+			page_offset(page) > i_size_read(inode) ||
 			!PageUptodate(page)) {
 		unlock_page(page);
 		err = -EFAULT;
@@ -76,10 +77,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	 * check to see if the page is mapped already (no holes)
 	 */
 	if (PageMappedToDisk(page))
-		goto out;
-
-	/* fill the page */
-	wait_on_page_writeback(page);
+		goto mapped;
 
 	/* page is wholly or partially inside EOF */
 	if (((page->index + 1) << PAGE_CACHE_SHIFT) > i_size_read(inode)) {
@@ -90,7 +88,9 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
-	file_update_time(vma->vm_file);
+mapped:
+	/* fill the page */
+	wait_on_page_writeback(page);
 out:
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(err);
-- 
1.7.9.5

