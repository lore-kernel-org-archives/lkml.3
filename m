Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3LXETV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 23:19:21 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:42506 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3LXETT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 23:19:19 -0500
Message-ID: <1387858826.5567.236.camel@haakon3.risingtidesystems.com>
Subject: bio_integrity_verify() bug causing READ verify to be silently
 skipped
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 23 Dec 2013 20:20:26 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin & Co,

So after playing with the mainline DIF client against an initial WIP
target DIF support patch, I've started hitting a bug in
bio_integrity_verify() that causes READ verify logic to be silently
skipped for both WIP target and existing scsi_debug DIF code.

The issue is with the scsi_end_request() -> blk_end_request() completion
path, where eventually blk_update_request() -> req_bio_endio() ->
bio_advance() is called to increment bio->bi_idx to a non-zero value.

Given that bio_integrity_verify() is using bio_for_each_segment(), the
loop starts from the updated bio->bi_idx, and not a zero value, which
ends up skipping individual bio segment calls to bi->verify_fn().

The following patch changes bio_integrity_verify() to use
bio_for_each_segment_all() instead of bio_for_each_segment() to ensure
that the segment walk always starts from zero, regardless of the current
bio->bi_idx value after bio_advance().

Note this bug has been observed with v3.13-rc3 code, and I haven't yet
looked back to figure out when this bug was first introduced..  Any
ideas..?

Interestingly enough, the scsi-mq alpha code does not suffer from this
bug, as blk_end_request() is never called from scsi_mq_end_request() ->
blk_mq_end_io() completion path code.

Thank you,

--nab

>From 32242942edca095e8dd126cb1408f2842340773e Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 24 Dec 2013 04:00:24 +0000
Subject: [PATCH] bio-integrity: Fix bio_integrity_verify segment start bug

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
---
 fs/bio-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index fc60b31..f1d5cde 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -450,7 +450,7 @@ static int bio_integrity_verify(struct bio *bio)
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
-	bio_for_each_segment(bv, bio, i) {
+	bio_for_each_segment_all(bv, bio, i) {
 		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
-- 
1.7.10.4

