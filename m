Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3ENQkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708Ab3ENQiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:38:12 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com
Subject: [PATCH v4 13/20] Revert "ext4: fix fsx truncate failure"
Date: Tue, 14 May 2013 18:37:27 +0200
Message-Id: <1368549454-8930-14-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 189e868fa8fdca702eb9db9d8afc46b5cb9144c9.

This commit reintroduces the use of ext4_block_truncate_page() in ext4
truncate operation instead of ext4_discard_partial_page_buffers().

The statement in the commit description that the truncate operation only
zero block unaligned portion of the last page is not exactly right,
since truncate_pagecache_range() also zeroes and invalidate the unaligned
portion of the page. Then there is no need to zero and unmap it once more
and ext4_block_truncate_page() was doing the right job, although we
still need to update the buffer head containing the last block, which is
exactly what ext4_block_truncate_page() is doing.

Moreover the problem described in the commit is fixed more properly with
commit

15291164b22a357cb211b618adfef4fa82fc0de3
	jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer

This was tested on ppc64 machine with block size of 1024 bytes without
any problems.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8187c3e..34ebb62 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3937,7 +3937,6 @@ void ext4_truncate(struct inode *inode)
 	unsigned int credits;
 	handle_t *handle;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t page_len;
 
 	/*
 	 * There is a possibility that we're either freeing the inode
@@ -3981,14 +3980,8 @@ void ext4_truncate(struct inode *inode)
 		return;
 	}
 
-	if (inode->i_size % PAGE_CACHE_SIZE != 0) {
-		page_len = PAGE_CACHE_SIZE -
-			(inode->i_size & (PAGE_CACHE_SIZE - 1));
-
-		if (ext4_discard_partial_page_buffers(handle,
-				mapping, inode->i_size, page_len, 0))
-			goto out_stop;
-	}
+	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
+		ext4_block_truncate_page(handle, mapping, inode->i_size);
 
 	/*
 	 * We add the inode to the orphan list, so that if this
-- 
1.7.7.6

