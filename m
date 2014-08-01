Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaHAN3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:29:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:10863 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbaHAN3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="scan'208";a="578740172"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, willy@linux.intel.com,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v9 20/22] ext4: Avoid lock inversion between i_mmap_mutex and transaction start
Date: Fri,  1 Aug 2014 09:27:36 -0400
Message-Id: <b153961fec89926502fbe24c571a5dc2172d9a5e.1406897885.git.willy@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1406897885.git.willy@linux.intel.com>
References: <cover.1406897885.git.willy@linux.intel.com>
In-Reply-To: <cover.1406897885.git.willy@linux.intel.com>
References: <cover.1406897885.git.willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

When DAX is enabled, it uses i_mmap_mutex as a protection against
truncate during page fault. This inevitably forces i_mmap_mutex to rank
outside of a transaction start and thus we have to avoid calling
pagecache purging operations when transaction is started.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/inode.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8a06473..494a864 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3631,13 +3631,19 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-	/* Now release the pages again to reduce race window */
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+
+	/*
+	 * Now release the pages again to reduce race window. This has to happen
+	 * outside of a transaction to avoid lock inversion on i_mmap_mutex
+	 * when DAX is enabled.
+	 */
 	if (last_block_offset > first_block_offset)
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
-
-	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	goto out_dio;
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
-- 
2.0.1

