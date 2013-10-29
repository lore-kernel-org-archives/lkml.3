Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3J2USr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:18:47 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53095 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3J2USc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:32 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 05/23] dm: Use bvec_iter for dm_bio_record()
Date: Tue, 29 Oct 2013 13:17:58 -0700
Message-Id: <1383077896-4132-6-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch doesn't itself have any functional changes, but immutable
biovecs are going to add a bi_bvec_done member to bi_iter, which will
need to be saved too here.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-bio-record.h | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 5ace48e..4f46e8e 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -28,11 +28,9 @@ struct dm_bio_vec_details {
 };
 
 struct dm_bio_details {
-	sector_t bi_sector;
 	struct block_device *bi_bdev;
-	unsigned int bi_size;
-	unsigned short bi_idx;
 	unsigned long bi_flags;
+	struct bvec_iter bi_iter;
 	struct dm_bio_vec_details bi_io_vec[BIO_MAX_PAGES];
 };
 
@@ -40,11 +38,9 @@ static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
 	unsigned i;
 
-	bd->bi_sector = bio->bi_iter.bi_sector;
 	bd->bi_bdev = bio->bi_bdev;
-	bd->bi_size = bio->bi_iter.bi_size;
-	bd->bi_idx = bio->bi_iter.bi_idx;
 	bd->bi_flags = bio->bi_flags;
+	bd->bi_iter = bio->bi_iter;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		bd->bi_io_vec[i].bv_len = bio->bi_io_vec[i].bv_len;
@@ -56,11 +52,9 @@ static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
 	unsigned i;
 
-	bio->bi_iter.bi_sector = bd->bi_sector;
 	bio->bi_bdev = bd->bi_bdev;
-	bio->bi_iter.bi_size = bd->bi_size;
-	bio->bi_iter.bi_idx = bd->bi_idx;
 	bio->bi_flags = bd->bi_flags;
+	bio->bi_iter = bd->bi_iter;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		bio->bi_io_vec[i].bv_len = bd->bi_io_vec[i].bv_len;
-- 
1.8.4.rc3

