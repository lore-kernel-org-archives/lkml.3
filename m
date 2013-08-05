Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3HEToT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:44:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58030 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3HEToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:44:16 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-mm@kvack.org, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 3/3] ext4: Implement willwrite for the delalloc case
Date: Mon,  5 Aug 2013 12:44:01 -0700
Message-Id: <e7408a082b42ce17872eebf8f59f44252ef63abb.1375729665.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1375729665.git.luto@amacapital.net>
References: <cover.1375729665.git.luto@amacapital.net>
In-Reply-To: <cover.1375729665.git.luto@amacapital.net>
References: <cover.1375729665.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/ext4/ext4.h  |  2 ++
 fs/ext4/file.c  |  1 +
 fs/ext4/inode.c | 22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b577e45..be7308a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2103,6 +2103,8 @@ extern int ext4_block_zero_page_range(handle_t *handle,
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern long ext4_willwrite(struct vm_area_struct *vma,
+			   unsigned long start, unsigned long end);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6f4cc56..159226f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -201,6 +201,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 static const struct vm_operations_struct ext4_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite   = ext4_page_mkwrite,
+	.willwrite	= ext4_willwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba33c67..c49e36b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5101,3 +5101,25 @@ out:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
+
+long ext4_willwrite(struct vm_area_struct *vma,
+		    unsigned long start, unsigned long end)
+{
+	int ret = 0;
+	struct file *file = vma->vm_file;
+	struct inode *inode = file_inode(file);
+	int retries = 0;
+
+	/* We only support the delalloc case */
+	if (test_opt(inode->i_sb, DELALLOC) &&
+	    !ext4_should_journal_data(inode) &&
+	    !ext4_nonda_switch(inode->i_sb)) {
+		do {
+			ret = block_willwrite(vma, start, end,
+					      ext4_da_get_block_prep);
+		} while (ret == -ENOSPC &&
+		       ext4_should_retry_alloc(inode->i_sb, &retries));
+	}
+
+	return ret;
+}
-- 
1.8.3.1

