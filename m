Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab3GQXhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:37:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab3GQWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 012/145] zram: avoid access beyond the zram device
Date: Wed, 17 Jul 2013 15:45:44 -0700
Message-Id: <1374101277-7915-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 12a7ad3b810e77137d0caf97a6dd97591e075b30 upstream.

Function valid_io_request() should verify the entire request are within
the zram device address range. Otherwise it may cause invalid memory
access when accessing/modifying zram->meta->table[index] because the
'index' is out of range. Then it may access non-exist memory, randomly
modify memory belong to other subsystems, which is hard to track down.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zram/zram_drv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index ff2228e..62f8276 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -461,13 +461,20 @@ out:
  */
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
-	if (unlikely(
-		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
-		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
-		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
+	u64 start, end, bound;
+	
+	/* unaligned request */
+	if (unlikely(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+		return 0;
+	if (unlikely(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+		return 0;
 
+	start = bio->bi_sector;
+	end = start + (bio->bi_size >> SECTOR_SHIFT);
+	bound = zram->disksize >> SECTOR_SHIFT;
+	/* out of range range */
+	if (unlikely(start >= bound || end >= bound || start > end))
 		return 0;
-	}
 
 	/* I/O request is valid */
 	return 1;
-- 
1.8.1.2

