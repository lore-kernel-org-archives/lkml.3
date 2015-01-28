Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbbA2Cgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762217AbbA2Cga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 061/139] dm bufio: fix memleak when using a dm_buffer's inline bio
Date: Wed, 28 Jan 2015 14:20:04 -0800
Message-Id: <1422483682-15393-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 445559cdcb98a141f5de415b94fd6eaccab87e6d upstream.

When dm-bufio sets out to use the bio built into a struct dm_buffer to
issue an IO, it needs to call bio_reset after it's done with the bio
so that we can free things attached to the bio such as the integrity
payload.  Therefore, inject our own endio callback to take care of
the bio_reset after calling submit_io's end_io callback.

Test case:
1. modprobe scsi_debug delay=0 dif=1 dix=199 ato=1 dev_size_mb=300
2. Set up a dm-bufio client, e.g. dm-verity, on the scsi_debug device
3. Repeatedly read metadata and watch kmalloc-192 leak!

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-bufio.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 140be2d..93edd89 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -530,6 +530,19 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 		end_io(&b->bio, r);
 }
 
+static void inline_endio(struct bio *bio, int error)
+{
+	bio_end_io_t *end_fn = bio->bi_private;
+
+	/*
+	 * Reset the bio to free any attached resources
+	 * (e.g. bio integrity profiles).
+	 */
+	bio_reset(bio);
+
+	end_fn(bio, error);
+}
+
 static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 			   bio_end_io_t *end_io)
 {
@@ -541,7 +554,12 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
 	b->bio.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
-	b->bio.bi_end_io = end_io;
+	b->bio.bi_end_io = inline_endio;
+	/*
+	 * Use of .bi_private isn't a problem here because
+	 * the dm_buffer's inline bio is local to bufio.
+	 */
+	b->bio.bi_private = end_io;
 
 	/*
 	 * We assume that if len >= PAGE_SIZE ptr is page-aligned.
-- 
1.9.1

