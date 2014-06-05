Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaFEEwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:52:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaFEEVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Ben Hutchings <ben@decadent.org.uk>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 105/214] zram: avoid access beyond the zram device
Date: Wed,  4 Jun 2014 21:17:48 -0700
Message-Id: <20140605041653.815559455@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -535,13 +535,20 @@ out:
  */
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
-	if (unlikely(
-		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
-		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
-		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
+	u64 start, end, bound;
 
+	/* unaligned request */
+	if (unlikely(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+		return 0;
+	if (unlikely(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+		return 0;
+
+	start = bio->bi_sector;
+	end = start + (bio->bi_size >> SECTOR_SHIFT);
+	bound = zram->disksize >> SECTOR_SHIFT;
+	/* out of range range */
+	if (unlikely(start >= bound || end >= bound || start > end))
 		return 0;
-	}
 
 	/* I/O request is valid */
 	return 1;


