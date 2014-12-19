Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaLRXxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:53:55 -0500
Received: from mailout.micron.com ([137.201.242.129]:33933 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaLRXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:53:54 -0500
Message-ID: <54936D1E.3020700@micron.com>
Date: Thu, 18 Dec 2014 16:11:10 -0800
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>
CC: <martin.k.petersen@oracle.com>
Subject: [PATCH] block: pass correct seed to integrity metadata generation
 function
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21186.003
X-TM-AS-Result: No--3.410700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seed value passed to the blk integrity metadata generation function 
was wrong depending on the device block size (interval) and how many 
blocks comprised the bvec.  This patch converts the seed to 'interval' 
units and increments it correctly for each iteration.  Tested against a
4k+8 (w/ type1 PI) sector size.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5cbd5d9..7114040 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -219,20 +219,22 @@ static int bio_integrity_process(struct bio *bio,
 	struct bvec_iter bviter;
 	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	unsigned int ret = 0;
+	unsigned int len = 0, ret = 0;
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
 		bip->bip_vec->bv_offset;
+	sector_t seed, start = bio_integrity_intervals(bi, bip_get_seed(bip));
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = bi->interval;
-	iter.seed = bip_get_seed(bip);
-	iter.prot_buf = prot_buf;
+	seed = start;
 
 	bio_for_each_segment(bv, bio, bviter) {
 		void *kaddr = kmap_atomic(bv.bv_page);
 
 		iter.data_buf = kaddr + bv.bv_offset;
 		iter.data_size = bv.bv_len;
+		iter.seed = seed;
+		iter.prot_buf = prot_buf;
 
 		ret = proc_fn(&iter);
 		if (ret) {
@@ -241,6 +243,9 @@ static int bio_integrity_process(struct bio *bio,
 		}
 
 		kunmap_atomic(kaddr);
+		len += bv.bv_len;
+		seed = start + (len / bi->interval);
+		prot_buf += bi->tuple_size;
 	}
 	return ret;
 }
