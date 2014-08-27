Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890AbaH0Pcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:32:41 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34561 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935152AbaH0Pcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:32:39 -0400
Message-ID: <53FDFA10.7040003@plexistor.com>
Date: Wed, 27 Aug 2014 18:32:32 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/5] brd: Request from fdisk 4k alignment
References: <53FDF7AD.5000709@plexistor.com>
In-Reply-To: <53FDF7AD.5000709@plexistor.com>
Content-Type: text/plain; charset=UTF-8
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
Note that blk_queue_physical_block_size() also trashes io_min, but
we can leave this one to be 512.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 83e3d22..6cc3034 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -503,10 +503,17 @@ static struct brd_device *brd_alloc(int i)
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


