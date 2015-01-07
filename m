Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbbAGQJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:09:42 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:54039 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAGQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:09:40 -0500
Message-ID: <54AD5A42.5040404@plexistor.com>
Date: Wed, 07 Jan 2015 18:09:38 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/4 v4] brd: Request from fdisk 4k alignment
References: <54AD5893.9040701@plexistor.com>
In-Reply-To: <54AD5893.9040701@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

Because of the direct_access() API which returns a PFN. partitions
better start on 4K boundary, else offset ZERO of a partition will
not be aligned and blk_direct_access() will fail the call.

By setting blk_queue_physical_block_size(PAGE_SIZE) we can communicate
this to fdisk and friends.

The call to blk_queue_physical_block_size() is harmless and will
not affect the Kernel behavior in any way. It is only for
communication to user-mode.

before this patch running fdisk on a default size brd of 4M
the first sector offered is 34 (BAD), but after this patch it
will be 40, ie 8 sectors aligned. Also when entering some random
partition sizes the next partition-start sector is offered 8 sectors
aligned after this patch. (Please note that with fdisk the user
can still enter bad values, only the offered default values will
be correct)

Note that with bdev-size > 4M fdisk will try to align on a 1M
boundary (above first-sector will be 2048), in any case.

CC: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index a7463c959..c01b921 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -486,10 +486,19 @@ static struct brd_device *brd_alloc(int i)
 	brd->brd_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!brd->brd_queue)
 		goto out_free_dev;
+
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
+	/* This is so fdisk will align partitions on 4k, because of
+	 * direct_access API needing 4k alignment, returning a PFN
+	 * (This is only a problem on very small devices <= 4M,
+	 *  otherwise fdisk will align on 1M. Regardless this call
+	 *  is harmless)
+	 */
+	blk_queue_physical_block_size(brd->brd_queue, PAGE_SIZE);
+
 	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
 	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
 	brd->brd_queue->limits.discard_zeroes_data = 1;
-- 
1.9.3


