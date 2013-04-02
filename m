Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3DBUGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:06:44 -0400
Received: from [66.162.12.4] ([66.162.12.4]:44519 "EHLO hancock.steeleye.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761092Ab3DBUGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:06:42 -0400
X-Greylist: delayed 1521 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 16:06:42 EDT
From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] nbd: increase default and max request sizes
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <belczyk@bsd.krakow.pl>
X-Mailer: mail (GNU Mailutils 2.2)
Message-Id: <20130402194120.54043222C0@clements>
Date: Tue,  2 Apr 2013 15:41:20 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch raises the default max request size for nbd to 128KB (from 127KB)
to get it 4KB aligned. This patch also allows the max request size to be
increased (via /sys/block/nbd<x>/queue/max_sectors_kb) to 32MB.

The patch makes nbd network traffic more efficient by:
- reducing request fragmentation (4KB alignment)
- reducing the number of requests (fewer round trips, less network overhead)

Especially in high latency networks, larger request size can make a dramatic
difference in performance.

From: Michal Belczyk <belczyk@bsd.krakow.pl>
Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 nbd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7fecc78..037288e 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -856,6 +856,8 @@ static int __init nbd_init(void)
 		disk->queue->limits.discard_granularity = 512;
 		disk->queue->limits.max_discard_sectors = UINT_MAX;
 		disk->queue->limits.discard_zeroes_data = 0;
+		blk_queue_max_hw_sectors(disk->queue, 65536);
+		disk->queue->limits.max_sectors = 256;
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
