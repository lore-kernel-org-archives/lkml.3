Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3JCERb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:17:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3JCER1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:17:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 11/57] bcache: Fix flushes in writeback mode
Date: Wed,  2 Oct 2013 21:08:37 -0700
Message-Id: <20131003040637.379052155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit c0f04d88e46d14de51f4baebb6efafb7d59e9f96 upstream.

In writeback mode, when we get a cache flush we need to make sure we
issue a flush to the backing device.

The code for sending down an extra flush was wrong - by cloning the bio
we were probably getting flags that didn't make sense for a bare flush,
and also the old code was firing for FUA bios, for which we don't need
to send a flush to the backing device.

This was causing data corruption somehow - the mechanism was never
determined, but this patch fixes it for the users that were seeing it.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/request.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -997,14 +997,17 @@ static void request_write(struct cached_
 	} else {
 		bch_writeback_add(dc);
 
-		if (s->op.flush_journal) {
+		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
-			s->op.cache_bio = bio_clone_bioset(bio, GFP_NOIO,
-							   dc->disk.bio_split);
+			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
+							     dc->disk.bio_split);
 
-			bio->bi_size = 0;
-			bio->bi_vcnt = 0;
-			closure_bio_submit(bio, cl, s->d);
+			flush->bi_rw	= WRITE_FLUSH;
+			flush->bi_bdev	= bio->bi_bdev;
+			flush->bi_end_io = request_endio;
+			flush->bi_private = cl;
+
+			closure_bio_submit(flush, cl, s->d);
 		} else {
 			s->op.cache_bio = bio;
 		}


