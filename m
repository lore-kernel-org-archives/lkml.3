Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbbAGCpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:45:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbbAGCHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.14 14/52] dm bufio: fix memleak when using a dm_buffers inline bio
Date: Tue,  6 Jan 2015 18:06:42 -0800
Message-Id: <20150107020557.383773357@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-bufio.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -532,6 +532,19 @@ static void use_dmio(struct dm_buffer *b
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
@@ -543,7 +556,12 @@ static void use_inline_bio(struct dm_buf
 	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
 	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
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


