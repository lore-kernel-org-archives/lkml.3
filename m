Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaF1SPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:15:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbaF1Rvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:51:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.15 044/139] ext4: fix zeroing of page during writeback
Date: Sat, 28 Jun 2014 10:46:45 -0700
Message-Id: <20140628174607.440286617@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/page-io.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -422,6 +422,17 @@ int ext4_bio_write_page(struct ext4_io_s
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
@@ -432,19 +443,6 @@ int ext4_bio_write_page(struct ext4_io_s
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


