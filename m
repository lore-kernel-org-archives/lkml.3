Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935464AbaH0PxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:53:00 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:22866 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935357AbaH0Pw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:52:57 -0400
Subject: [PATCH 2/2] fs: clarify rate limit suppressed buffer I/O errors
To: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        relliott@beardog.cce.hp.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, elliott@hp.com, scameron@beardog.cce.hp.com
From: Robert Elliott <elliott@hp.com>
Date: Wed, 27 Aug 2014 10:52:05 -0500
Message-ID: <20140827155205.32144.32960.stgit@beardog.cce.hp.com>
In-Reply-To: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
References: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When quiet_error applies rate limiting to buffer_io_error calls, what the
they apply to is unclear because the name is so generic, particularly
if the messages are interleaved with others:

[ 1936.063572] quiet_error: 664293 callbacks suppressed
[ 1936.065297] Buffer I/O error on dev sdr, logical block 257429952, lost async page write
[ 1936.067814] Buffer I/O error on dev sdr, logical block 257429953, lost async page write

Also, the function uses printk_ratelimit(), although printk.h includes a
comment advising "Please don't use... Instead use printk_ratelimited()."

Change buffer_io_error to check the BH_Quiet bit itself, drop the
printk_ratelimit call, and print using printk_ratelimited.

This makes the messages look like:

[  387.208839] buffer_io_error: 676394 callbacks suppressed
[  387.210693] Buffer I/O error on dev sdr, logical block 211291776, lost async page write
[  387.213432] Buffer I/O error on dev sdr, logical block 211291777, lost async page write

Signed-off-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 fs/buffer.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c6cb0ee..3710a68 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -128,19 +128,13 @@ __clear_page_buffers(struct page *page)
 	page_cache_release(page);
 }
 
-
-static int quiet_error(struct buffer_head *bh)
-{
-	if (!test_bit(BH_Quiet, &bh->b_state) && printk_ratelimit())
-		return 0;
-	return 1;
-}
-
-
 static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_ERR "Buffer I/O error on dev %s, logical block %llu%s\n",
+
+	if (!test_bit(BH_Quiet, &bh->b_state))
+		printk_ratelimited(KERN_ERR
+			"Buffer I/O error on dev %s, logical block %llu%s\n",
 			bdevname(bh->b_bdev, b),
 			(unsigned long long)bh->b_blocknr, msg);
 }
@@ -180,8 +174,7 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!quiet_error(bh))
-			buffer_io_error(bh, ", lost sync page write");
+		buffer_io_error(bh, ", lost sync page write");
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
 	}
@@ -298,8 +291,7 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 		set_buffer_uptodate(bh);
 	} else {
 		clear_buffer_uptodate(bh);
-		if (!quiet_error(bh))
-			buffer_io_error(bh, ", async page read");
+		buffer_io_error(bh, ", async page read");
 		SetPageError(page);
 	}
 
@@ -358,8 +350,7 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!quiet_error(bh))
-			buffer_io_error(bh, ", lost async page write");
+		buffer_io_error(bh, ", lost async page write");
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);

