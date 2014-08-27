Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbaH0Pw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:52:56 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:38931 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935357AbaH0Pwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:52:54 -0400
Subject: [PATCH 1/2] fs: merge I/O error prints into one line
To: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        relliott@beardog.cce.hp.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, elliott@hp.com, scameron@beardog.cce.hp.com
From: Robert Elliott <elliott@hp.com>
Date: Wed, 27 Aug 2014 10:51:59 -0500
Message-ID: <20140827155159.32144.97539.stgit@beardog.cce.hp.com>
In-Reply-To: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
References: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buffer.c uses two printk calls to print these messages:
[67353.422338] Buffer I/O error on device sdr, logical block 212868488
[67353.422338] lost page write due to I/O error on sdr

In a busy system, they may be interleaved with other prints,
losing the context for the second message.  Merge them into
one line with one printk call so the prints are atomic.

Also, differentiate between async page writes, sync page writes, and
async page reads.

Also, shorten "device" to "dev" to match the block layer prints:
[67353.467906] blk_update_request: critical target error, dev sdr, sector
1707107328

Also, use %llu rather than %Lu.

Resulting prints look like:
[ 1356.437006] blk_update_request: critical target error, dev sdr, sector 1719693992
[ 1361.383522] quiet_error: 659876 callbacks suppressed
[ 1361.385816] Buffer I/O error on dev sdr, logical block 256902912, lost async page write
[ 1361.385819] Buffer I/O error on dev sdr, logical block 256903644, lost async page write

Signed-off-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 fs/buffer.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8f05111..c6cb0ee 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -137,12 +137,12 @@ static int quiet_error(struct buffer_head *bh)
 }
 
 
-static void buffer_io_error(struct buffer_head *bh)
+static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
 	char b[BDEVNAME_SIZE];
-	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
+	printk(KERN_ERR "Buffer I/O error on dev %s, logical block %llu%s\n",
 			bdevname(bh->b_bdev, b),
-			(unsigned long long)bh->b_blocknr);
+			(unsigned long long)bh->b_blocknr, msg);
 }
 
 /*
@@ -177,17 +177,11 @@ EXPORT_SYMBOL(end_buffer_read_sync);
 
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!quiet_error(bh)) {
-			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-				       bdevname(bh->b_bdev, b));
-		}
+		if (!quiet_error(bh))
+			buffer_io_error(bh, ", lost sync page write");
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
 	}
@@ -305,7 +299,7 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 	} else {
 		clear_buffer_uptodate(bh);
 		if (!quiet_error(bh))
-			buffer_io_error(bh);
+			buffer_io_error(bh, ", async page read");
 		SetPageError(page);
 	}
 
@@ -353,7 +347,6 @@ still_busy:
  */
 void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
 	unsigned long flags;
 	struct buffer_head *first;
 	struct buffer_head *tmp;
@@ -365,12 +358,8 @@ void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!quiet_error(bh)) {
-			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-			       bdevname(bh->b_bdev, b));
-		}
+		if (!quiet_error(bh))
+			buffer_io_error(bh, ", lost async page write");
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);

