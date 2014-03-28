Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaC1RmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:42:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaC1RbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 23/46] Fix uses of dma_max_pfn() when converting to a limiting address
Date: Fri, 28 Mar 2014 10:32:07 -0700
Message-Id: <20140328173137.797981871@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit e83b366487b5582274374f8226e489cb214ae5a6 upstream.

We must use a 64-bit for this, otherwise overflowed bits get lost, and
that can result in a lower than intended value set.

Fixes: 8e0cb8a1f6ac ("ARM: 7797/1: mmc: Use dma_max_pfn(dev) helper for bounce_limit calculations")
Fixes: 7d35496dd982 ("ARM: 7796/1: scsi: Use dma_max_pfn(dev) helper for bounce_limit calculations")
Tested-Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/queue.c |    2 +-
 drivers/scsi/scsi_lib.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -197,7 +197,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 	struct mmc_queue_req *mqrq_prev = &mq->mqrq[1];
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
-		limit = dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
+		limit = (u64)dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
 
 	mq->card = card;
 	mq->queue = blk_init_queue(mmc_request_fn, lock);
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1684,7 +1684,7 @@ u64 scsi_calculate_bounce_limit(struct S
 
 	host_dev = scsi_get_device(shost);
 	if (host_dev && host_dev->dma_mask)
-		bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
+		bounce_limit = (u64)dma_max_pfn(host_dev) << PAGE_SHIFT;
 
 	return bounce_limit;
 }


