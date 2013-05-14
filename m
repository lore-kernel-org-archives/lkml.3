Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab3ENWai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 18:30:38 -0400
Received: from mailout.micron.com ([137.201.242.129]:49149 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3ENWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 18:30:37 -0400
Message-ID: <5192BB62.7090509@micron.com>
Date: Tue, 14 May 2013 15:32:02 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, <asamymuthupa@micron.com>,
        <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: Correctly handle bio->bi_idx != 0 conditions
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19866.002
X-TM-AS-Result: No-6.800100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stacking drivers may append bvecs to existing bio's, resulting
in non-zero bi_idx conditions.  This patch counts the loops of
bio_for_each_segment() rather than inheriting the bi_idx value
to pass as a segment count to the hardware submission routine.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
diff --git a/drivers/block/mtip32xx/mtip32xx.c
b/drivers/block/mtip32xx/mtip32xx.c
index 847107e..7c77ae1 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3863,7 +3863,7 @@ static void mtip_make_request(struct request_queue
*queue, struct bio *bio)
 	struct driver_data *dd = queue->queuedata;
 	struct scatterlist *sg;
 	struct bio_vec *bvec;
-	int nents = 0;
+	int i, nents = 0;
 	int tag = 0, unaligned = 0;

 	if (unlikely(dd->dd_flag & MTIP_DDF_STOP_IO)) {
@@ -3921,11 +3921,12 @@ static void mtip_make_request(struct
request_queue *queue, struct bio *bio)
 		}

 		/* Create the scatter list for this bio. */
-		bio_for_each_segment(bvec, bio, nents) {
+		bio_for_each_segment(bvec, bio, i) {
 			sg_set_page(&sg[nents],
 					bvec->bv_page,
 					bvec->bv_len,
 					bvec->bv_offset);
+			nents++;
 		}

 		/* Issue the read/write. */
