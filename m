Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3A1Aig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 19:38:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46921 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3A1Aid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 19:38:33 -0500
X-AuditID: 9c930179-b7d01ae000004006-e7-5105c886a03f
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan@kernel.org>, stable@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [RESEND PATCH v5 1/4] zram: Fix deadlock bug in partial write
Date: Mon, 28 Jan 2013 09:38:23 +0900
Message-Id: <1359333506-13599-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now zram allocates new page with GFP_KERNEL in zram I/O path
if IO is partial. Unfortunately, It may cuase deadlock with
reclaim path so this patch solves the problem.

Cc: stable@vger.kernel.org
Cc: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 61fb8f1..b285b3a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -220,7 +220,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	user_mem = kmap_atomic(page);
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 	else
 		uncmem = user_mem;
 
@@ -268,7 +268,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
 		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 		if (!uncmem) {
 			pr_info("Error allocating temp memory!\n");
 			ret = -ENOMEM;
-- 
1.7.9.5

