Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbaKNAtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:49:04 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42915 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964816AbaKNAtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:49:02 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Karam Lee <karam.lee@lge.com>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH] zram: rely on the bi_end_io for zram_rw_page fails
Date: Fri, 14 Nov 2014 09:49:07 +0900
Message-Id: <1415926147-9023-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I tested zram, I found processes got segfaulted.
The reason was zram_rw_page doesn't make the page dirty
again when swap write failed, and even it doesn't return
error by [1].

If error by zram internal happens, zram_rw_page should return
non-zero without calling page_endio.
It causes resubmit the IO with bio so that it ends up calling
bio->bi_end_io.

The reason is zram could be used for a block device for FS and
swap, which they uses different bio complete callback, which
works differently. So, we should rely on the bio I/O complete
handler rather than zram_bvec_rw itself in case of I/O fail.

This patch fixes the segfault issue as well one [1]'s
mentioned

[1] zram: make rw_page opeartion return 0

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Karam Lee <karam.lee@lge.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 4b4f4dbc3cfd..0e0650feab2a 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -978,12 +978,10 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 out_unlock:
 	up_read(&zram->init_lock);
 out:
-	page_endio(page, rw, err);
+	if (unlikely(err))
+		return err;
 
-	/*
-	 * Return 0 prevents I/O fallback trial caused by rw_page fail
-	 * and upper layer can handle this IO error via page error.
-	 */
+	page_endio(page, rw, 0);
 	return 0;
 }
 
-- 
2.0.0

