Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3HWAD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 20:03:57 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42159 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab3HWADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 20:03:53 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 7/7] xfs: Defer mmap cmtime updates
Date: Thu, 22 Aug 2013 17:03:23 -0700
Message-Id: <67df6fbc92d9b92a8301b4ad72e2a760d5e662df.1377193658.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This involves a change to block_page_mkwrite.  xfs is the only user.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/buffer.c       | 7 -------
 fs/xfs/xfs_aops.c | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..408677c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2431,13 +2431,6 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
 
 	sb_start_pagefault(sb);
-
-	/*
-	 * Update file times before taking page lock. We may end up failing the
-	 * fault so this update may be superfluous but who really cares...
-	 */
-	file_update_time(vma->vm_file);
-
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	sb_end_pagefault(sb);
 	return block_page_mkwrite_return(ret);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 596ec71..aa8fbcf 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1668,6 +1668,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.readpages		= xfs_vm_readpages,
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.write_begin		= xfs_vm_write_begin,
-- 
1.8.3.1

