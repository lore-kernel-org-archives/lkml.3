Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaGHThy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:37:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592AbaGHTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Xiaoguang Wang" <wangxg.fnst@cn.fujitsu.com>,
        "Jan Kara" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.232483747@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 020/125] ext4: fix zeroing of page during writeback
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - block_end was used instead of block_start + blocksize]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/page-io.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -386,24 +386,24 @@ int ext4_bio_write_page(struct ext4_io_s
 	set_page_writeback(page);
 	ClearPageError(page);
 
+	/*
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
+
 	for (bh = head = page_buffers(page), block_start = 0;
 	     bh != head || !block_start;
 	     block_start = block_end, bh = bh->b_this_page) {
 
 		block_end = block_start + blocksize;
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
-			zero_user_segment(page, block_start, block_end);
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;

