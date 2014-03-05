Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaCEO0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbaCEO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 091/131] bio-integrity: Fix bio_integrity_verify segment start bug
Date: Wed,  5 Mar 2014 14:23:35 +0000
Message-Id: <1394029455-23128-92-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 5837c80e870bc3b12ac6a98cdc9ce7a9522a8fb6 upstream.

This patch addresses a bug in bio_integrity_verify() code that has
been causing DIF READ verify operations to be silently skipped.

The issue is that bio->bi_idx will have been incremented within
bio_advance() code in the normal blk_update_request() ->
req_bio_endio() completion path, and bio_integrity_verify() is
using bio_for_each_segment() which starts the bio segment walk
at the current bio->bi_idx.

So instead use bio_for_each_segment_all() to always start the bio
segment walk from zero, regardless of the current bio->bi_idx
value after bio_advance() has been called.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ luis: backported to 3.11: used Nicholas's backport to v3.10.y+ ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/bio-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8dccf73..433c3b8 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -458,7 +458,7 @@ static int bio_integrity_verify(struct bio *bio)
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
-	bio_for_each_segment(bv, bio, i) {
+	bio_for_each_segment_all(bv, bio, i) {
 		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
-- 
1.9.0

