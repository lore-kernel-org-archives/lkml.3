Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaE2G0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:26:15 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42070 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbaE2G0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:26:14 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] CMA: correct unlock target
Date: Thu, 29 May 2014 15:29:18 +0900
Message-Id: <1401344958-3790-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'cma: Remove potential deadlock situation' introduces per cma area mutex
for bitmap management. It is good, but there is one mistake. When we
can't find appropriate area in bitmap, we release cma_mutex global lock
rather than cma->lock and this is a bug. So fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 6f6bffc..83969f8 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -331,7 +331,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
 		pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
 						    start, count, mask);
 		if (pageno >= cma->count) {
-			mutex_unlock(&cma_mutex);
+			mutex_unlock(&cma->lock);
 			break;
 		}
 		bitmap_set(cma->bitmap, pageno, count);
-- 
1.7.9.5

