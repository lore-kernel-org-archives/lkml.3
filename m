Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbaGOVjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934117AbaGOVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/198] ext4: fix zeroing of page during writeback
Date: Tue, 15 Jul 2014 14:28:47 -0700
Message-Id: <1405459868-15089-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit eeece469dedadf3918bad50ad80f4616a0064e90 upstream.

Tail of a page straddling inode size must be zeroed when being written
out due to POSIX requirement that modifications of mmaped page beyond
inode size must not be written to the file. ext4_bio_write_page() did
this only for blocks fully beyond inode size but didn't properly zero
blocks partially beyond inode size. Fix this.

The problem has been uncovered by mmap_11-4 test in openposix test suite
(part of LTP).

Reported-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Fixes: 5a0dc7365c240
Fixes: bd2d0210cf22f
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/page-io.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d84cc95..598c4c6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -422,6 +422,17 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	ClearPageError(page);
 
 	/*
+	 * Comments copied from block_write_full_page_endio:
+	 *
+	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * writepage invocation because it may be mmapped.  "A file is mapped
+	 * in multiples of the page size.  For a file that is not a multiple of
+	 * the page size, the remaining memory is zeroed when mapped, and
+	 * writes to that region are not written out to the file."
+	 */
+	if (len < PAGE_CACHE_SIZE)
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
+	/*
 	 * In the first loop we prepare and mark buffers to submit. We have to
 	 * mark all buffers in the page before submitting so that
 	 * end_page_writeback() cannot be called from ext4_bio_end_io() when IO
@@ -432,19 +443,6 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		block_start = bh_offset(bh);
 		if (block_start >= len) {
-			/*
-			 * Comments copied from block_write_full_page_endio:
-			 *
-			 * The page straddles i_size.  It must be zeroed out on
-			 * each and every writepage invocation because it may
-			 * be mmapped.  "A file is mapped in multiples of the
-			 * page size.  For a file that is not a multiple of
-			 * the  page size, the remaining memory is zeroed when
-			 * mapped, and writes to that region are not written
-			 * out to the file."
-			 */
-			zero_user_segment(page, block_start,
-					  block_start + blocksize);
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;
-- 
1.9.1

