Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaJVN2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:28:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaJVN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:28:47 -0400
Date: Wed, 22 Oct 2014 09:28:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Edward Thornber <thornber@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 8/18] block copy: use merge_bvec_fn for copies
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1410220928060.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use merge_bvec_fn to make sure that copies do not split internal
boundaries of device mapper devices.

There is no possibility to split a copy bio (splitting would complicate
the design significantly), so we must use merge_bvec_fn to make sure that
the bios have appropriate size for the device mapper stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-lib.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

Index: linux-3.16-rc5/block/blk-lib.c
===================================================================
--- linux-3.16-rc5.orig/block/blk-lib.c	2014-07-15 15:27:51.000000000 +0200
+++ linux-3.16-rc5/block/blk-lib.c	2014-07-15 15:27:59.000000000 +0200
@@ -369,6 +369,31 @@ static void bio_copy_end_io(struct bio *
 	}
 }
 
+static unsigned blkdev_copy_merge(struct block_device *bdev,
+				  struct request_queue *q, unsigned long bi_rw,
+				  sector_t sector, unsigned n)
+{
+	if (!q->merge_bvec_fn) {
+		return n;
+	} else {
+		unsigned m;
+		struct bvec_merge_data bvm = {
+			.bi_bdev = bdev,
+			.bi_sector = sector,
+			.bi_size = 0,
+			.bi_rw = bi_rw,
+		};
+		struct bio_vec vec = {
+			.bv_page = NULL,
+			.bv_len = likely(n <= UINT_MAX >> 9) ? n << 9 : UINT_MAX & ~511U,
+			.bv_offset = 0,
+		};
+		m = q->merge_bvec_fn(q, &bvm, &vec);
+		m >>= 9;
+		return min(m, n);
+	}
+}
+
 /**
  * blkdev_issue_copy - queue a copy same operation
  * @src_bdev:	source blockdev
@@ -424,6 +449,18 @@ int blkdev_issue_copy(struct block_devic
 		struct bio_copy *bc;
 		unsigned chunk = (unsigned)min(nr_sects, (sector_t)max_copy_sectors);
 
+		chunk = blkdev_copy_merge(src_bdev, sq, READ | REQ_COPY, src_sector, chunk);
+		if (!chunk) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		chunk = blkdev_copy_merge(dst_bdev, dq, WRITE | REQ_COPY, dst_sector, chunk);
+		if (!chunk) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
 		bc = kmalloc(sizeof(struct bio_copy), gfp_mask);
 		if (!bc) {
 			ret = -ENOMEM;

