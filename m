Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3HAWYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:24:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39860 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3HAWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:24:41 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Chris Ball <cjb@laptop.org>
Subject: [PATCH RFC 50/51] ARM: 7797/1: mmc: Use dma_max_pfn(dev) helper for
 bounce_limit calculations
Message-Id: <E1V51I6-0006uj-TS@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:24:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA bounce limit is the maximum direct DMA'able memory beyond which
bounce buffers has to be used to perform dma operations. MMC queue layr
relies on dma_mask but its calculation is based on max_*pfn which
don't have uniform meaning across architectures. So make use of
dma_max_pfn() which is expected to return the DMAable maximum pfn
value across architectures.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/mmc/card/queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index fa9632e..357bbc5 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -15,6 +15,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -196,7 +197,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
-		limit = *mmc_dev(host)->dma_mask;
+		limit = dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
 
 	mq->card = card;
 	mq->queue = blk_init_queue(mmc_request_fn, lock);
-- 
1.7.4.4

