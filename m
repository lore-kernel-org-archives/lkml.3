Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaHFLf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:35:56 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:63928 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaHFLfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:35:55 -0400
Message-ID: <53E21317.7080403@plexistor.com>
Date: Wed, 06 Aug 2014 14:35:51 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/4] brd: Request from fdisk 4k alignment
References: <53E21125.9080308@plexistor.com>
In-Reply-To: <53E21125.9080308@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Because of the direct_access() API which returns a PFN. partitions
better start on 4K boundary, else offset ZERO of a partition will
not be aligned and blk_direct_access() will fail the call.

By setting blk_queue_physical_block_size(PAGE_SIZE) we can communicate
this to fdisk and friends.
Note that blk_queue_physical_block_size() also trashes io_min, but
we can leave this one to be 512.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 9673704..514cfe1 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -495,10 +495,17 @@ static struct brd_device *brd_alloc(int i)
 	brd->brd_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!brd->brd_queue)
 		goto out_free_dev;
+
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
 	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
+	/* This is so fdisk will align partitions on 4k, because of
+	 * direct_access API needing 4k alignment, returning a PFN
+	 */
+	blk_queue_physical_block_size(brd->brd_queue, PAGE_SIZE);
+	brd->brd_queue->limits.io_min = 512; /* Don't use the accessor */
+
 	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
 	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
 	brd->brd_queue->limits.discard_zeroes_data = 1;
-- 
1.9.3


