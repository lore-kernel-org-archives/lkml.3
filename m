Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3GXOa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:30:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45709 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab3GXOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jiang Liu" <jiang.liu@huawei.com>, "Jiang Liu" <liuj97@gmail.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.83008210@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [11/85] zram: avoid access beyond the zram device
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 drivers/staging/zram/zram_drv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -541,13 +541,20 @@ out:
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

