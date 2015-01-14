Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbbANTpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:45:01 -0500
Received: from mailout.micron.com ([137.201.242.129]:21712 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbANTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:44:59 -0500
Message-ID: <54B6C7E4.6010002@micron.com>
Date: Wed, 14 Jan 2015 11:47:48 -0800
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: <martin.petersen@oracle.com>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: pass correct prot_buf pointer to integrity metadata
 processing function
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21250.001
X-TM-AS-Result: No--2.044900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prot_buf pointer passed to the generate/verify functions is 
incorrect for the second and subsequent range, making it impossible 
to verify the guard tag.  The patch correctly increments the prot_buf 
pointer by the tuple size for each pass.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5cbd5d9..c7cbf60 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -226,13 +226,13 @@ static int bio_integrity_process(struct bio *bio,
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = bi->interval;
 	iter.seed = bip_get_seed(bip);
-	iter.prot_buf = prot_buf;
 
 	bio_for_each_segment(bv, bio, bviter) {
 		void *kaddr = kmap_atomic(bv.bv_page);
 
 		iter.data_buf = kaddr + bv.bv_offset;
 		iter.data_size = bv.bv_len;
+		iter.prot_buf = prot_buf;
 
 		ret = proc_fn(&iter);
 		if (ret) {
@@ -241,6 +241,7 @@ static int bio_integrity_process(struct bio *bio,
 		}
 
 		kunmap_atomic(kaddr);
+		prot_buf += bi->tuple_size;
 	}
 	return ret;
 }
