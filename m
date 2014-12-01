Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaLAQX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:23:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbaLAQXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:23:25 -0500
Date: Mon, 1 Dec 2014 11:23:24 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm-bufio: fix memleak when using a dm_buffer's
 inline bio
In-Reply-To: <20141126014515.GE10050@birch.djwong.org>
Message-ID: <alpine.LRH.2.02.1412011117180.27118@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141126014515.GE10050@birch.djwong.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Nov 2014, Darrick J. Wong wrote:

> When dm-bufio sets out to use the bio built into a struct dm_buffer to
> issue an IO, it needs to call bio_reset after it's done with the bio
> so that we can free things attached to the bio such as the integrity
> payload.  Therefore, inject our own endio callback to take care of
> the bio_reset after calling submit_io's end_io callback.
> 
> Test case:
> 1. modprobe scsi_debug delay=0 dif=1 dix=199 ato=1 dev_size_mb=300
> 2. Set up a dm-bufio client, e.g. dm-verity, on the scsi_debug device
> 3. Repeatedly read metadata and watch kmalloc-192 leak!
> 
> Fix is against 3.18-rc6.
> 
> +/* Reset the bio to free attached bio integrity profiles when we're done */
> +static void inline_endio(struct bio *bio, int error)
> +{
> +	bio_end_io_t *end_fn;
> +
> +	end_fn = bio->bi_private;
> +	end_fn(bio, error);
> +	bio_reset(bio);
> +}

This is wrong - when end_fn clears the B_READING or B_WRITING flag, the 
buffer may be freed by the background cleanup - so bio_reset may be 
modifying freed memory here. We need to call bio_reset before end_fn.



From: Mikulas Patocka <mpatocka@redhat.com>

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
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-3.18-rc6/drivers/md/dm-bufio.c
===================================================================
--- linux-3.18-rc6.orig/drivers/md/dm-bufio.c	2014-12-01 14:52:35.000000000 +0100
+++ linux-3.18-rc6/drivers/md/dm-bufio.c	2014-12-01 14:52:37.000000000 +0100
@@ -565,6 +565,18 @@ static void use_dmio(struct dm_buffer *b
 		end_io(&b->bio, r);
 }
 
+static void inline_endio(struct bio *bio, int error)
+{
+	bio_end_io_t *end_fn = bio->bi_private;
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
@@ -576,7 +588,12 @@ static void use_inline_bio(struct dm_buf
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
