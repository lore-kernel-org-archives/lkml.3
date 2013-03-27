Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3C0RmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:42:09 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:45921 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3C0Rkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:55 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 19/22] md: Immutable bvecs
Date: Wed, 27 Mar 2013 10:39:49 -0700
Message-Id: <1364405992-28424-20-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that drivers have been converted to the new bvec_iter primitives,
there's no need to trim the bvec before we submit it; and we can't trim
it once we start sharing bvecs.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/md/md.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2421ccf..8af6226 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -186,9 +186,6 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	 * the given offset and size.
 	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
 	 */
-	struct bio_vec bvec;
-	struct bvec_iter iter;
-	int sofar = 0;
 
 	size <<= 9;
 	if (offset == 0 && size == bio->bi_iter.bi_size)
@@ -199,25 +196,6 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	bio_advance(bio, offset << 9);
 
 	bio->bi_iter.bi_size = size;
-
-	/* avoid any complications with bi_idx being non-zero*/
-	if (bio->bi_iter.bi_idx) {
-		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_iter.bi_idx,
-			(bio->bi_vcnt - bio->bi_iter.bi_idx) *
-			sizeof(struct bio_vec));
-		bio->bi_vcnt -= bio->bi_iter.bi_idx;
-		bio->bi_iter.bi_idx = 0;
-	}
-	/* Make sure vcnt and last bv are not too big */
-	bio_for_each_segment(bvec, bio, iter) {
-		if (sofar + bvec.bv_len > size)
-			bvec.bv_len = size - sofar;
-		if (bvec.bv_len == 0) {
-			bio->bi_vcnt = iter.bi_idx;
-			break;
-		}
-		sofar += bvec.bv_len;
-	}
 }
 EXPORT_SYMBOL_GPL(md_trim_bio);
 
-- 
1.8.1.3

