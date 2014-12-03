Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaLCPUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:20:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34223 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbaLCPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:20:50 -0500
Date: Wed, 3 Dec 2014 08:20:40 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block core regression fix for 3.18
Message-ID: <20141203152022.GA4640@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-03_07:2014-12-03,2014-12-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.40203429263875e-14 kscore.compositescore=0
 circleOfTrustscore=33.2965958620397 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412030144
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Single fix for a regression introduced in this development cycle, where
dm on top of dif/dix is broken. From Darrick Wong.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Darrick J. Wong (1):
      block: fix regression where bio_integrity_process uses wrong bio_vec iterator

 block/bio-integrity.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 0984232e429f..5cbd5d9ea61d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -216,9 +216,10 @@ static int bio_integrity_process(struct bio *bio,
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_iter iter;
-	struct bio_vec *bv;
+	struct bvec_iter bviter;
+	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	unsigned int i, ret = 0;
+	unsigned int ret = 0;
 	void *prot_buf = page_address(bip->bip_vec->bv_page) +
 		bip->bip_vec->bv_offset;
 
@@ -227,11 +228,11 @@ static int bio_integrity_process(struct bio *bio,
 	iter.seed = bip_get_seed(bip);
 	iter.prot_buf = prot_buf;
 
-	bio_for_each_segment_all(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page);
+	bio_for_each_segment(bv, bio, bviter) {
+		void *kaddr = kmap_atomic(bv.bv_page);
 
-		iter.data_buf = kaddr + bv->bv_offset;
-		iter.data_size = bv->bv_len;
+		iter.data_buf = kaddr + bv.bv_offset;
+		iter.data_size = bv.bv_len;
 
 		ret = proc_fn(&iter);
 		if (ret) {

-- 
Jens Axboe

