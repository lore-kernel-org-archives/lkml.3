Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966576AbaCUAY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:24:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966035AbaCUAJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 78/85] bio-integrity: Fix bio_integrity_verify segment start bug
Date: Thu, 20 Mar 2014 17:10:21 -0700
Message-Id: <20140321000609.910176125@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

(Context change for v3.10.y -> v3.13.y code - nab)

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/bio-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -458,7 +458,7 @@ static int bio_integrity_verify(struct b
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
 
-	bio_for_each_segment(bv, bio, i) {
+	bio_for_each_segment_all(bv, bio, i) {
 		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;


