Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3IXGTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:19:37 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64906 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3IXGTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:19:16 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 11/11] bcache: Fix flushes in writeback mode
Date: Mon, 23 Sep 2013 23:17:36 -0700
Message-Id: <1380003456-19938-12-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In writeback mode, when we get a cache flush we need to make sure we
issue a flush to the backing device.

The code for sending down an extra flush was wrong - by cloning the bio
we were probably getting flags that didn't make sense for a bare flush,
and also the old code was firing for FUA bios, for which we don't need
to send a flush to the backing device.

This was causing data corruption somehow - the mechanism was never
determined, but this patch fixes it for the users that were seeing it.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/request.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 786a1a4..71eb233 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -997,14 +997,17 @@ static void request_write(struct cached_dev *dc, struct search *s)
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
-- 
1.8.4.rc3

