Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab3JQDA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:00:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:4337 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab3JQDA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:00:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,511,1378882800"; 
   d="scan'208";a="420376074"
Date: Thu, 17 Oct 2013 07:37:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131017020745.GA14013@intel.com>
References: <1381940926-25564-1-git-send-email-vinod.koul@intel.com>
 <1381940926-25564-2-git-send-email-vinod.koul@intel.com>
 <Pine.LNX.4.64.1310162028340.22648@axis700.grange>
 <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:45:48AM -0700, Dan Williams wrote:
> On Wed, Oct 16, 2013 at 11:29 AM, Guennadi Liakhovetski
> >
> > Doesn't this break kernel compilation for a total of 27 commits? Or am I
> > missing anything?
> 
> Yes, I think at the start DMA_COMPLETE should just be a alias for
> DMA_SUCCESS, then after all the driver renames are in delete
> DMA_SUCCESS.
Oops, taht was bad of me. ffixes in v2 and sending patch 29 for removal case

--

>From 7768309422a1345d32857974fe8b57805adfd561 Mon Sep 17 00:00:00 2001
From: Vinod Koul <vinod.koul@intel.com>
Date: Wed, 16 Oct 2013 13:29:02 +0530
Subject: [PATCH] dmaengine: use DMA_COMPLETE for dma completion status

the DMA_SUCCESS is a misnomer as dmaengine indicates the transfer is complete and
gives no guarantee of the transfer success. Hence we should use DMA_COMPLTE
instead of DMA_SUCCESS

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/dmaengine.c   |    2 +-
 include/linux/dmaengine.h |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9162ac8..81d8765 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -1062,7 +1062,7 @@ dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 	unsigned long dma_sync_wait_timeout = jiffies + msecs_to_jiffies(5000);
 
 	if (!tx)
-		return DMA_SUCCESS;
+		return DMA_COMPLETE;
 
 	while (tx->cookie == -EBUSY) {
 		if (time_after_eq(jiffies, dma_sync_wait_timeout)) {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0bc7275..683c380 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -45,16 +45,17 @@ static inline int dma_submit_error(dma_cookie_t cookie)
 
 /**
  * enum dma_status - DMA transaction status
- * @DMA_SUCCESS: transaction completed successfully
+ * @DMA_COMPLETE: transaction completed
  * @DMA_IN_PROGRESS: transaction not yet processed
  * @DMA_PAUSED: transaction is paused
  * @DMA_ERROR: transaction failed
  */
 enum dma_status {
-	DMA_SUCCESS,
+	DMA_COMPLETE,
 	DMA_IN_PROGRESS,
 	DMA_PAUSED,
 	DMA_ERROR,
+	DMA_SUCCESS,
 };
 
 /**
@@ -979,10 +980,10 @@ static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
 {
 	if (last_complete <= last_used) {
 		if ((cookie <= last_complete) || (cookie > last_used))
-			return DMA_SUCCESS;
+			return DMA_COMPLETE;
 	} else {
 		if ((cookie <= last_complete) && (cookie > last_used))
-			return DMA_SUCCESS;
+			return DMA_COMPLETE;
 	}
 	return DMA_IN_PROGRESS;
 }
@@ -1013,11 +1014,11 @@ static inline struct dma_chan *dma_find_channel(enum dma_transaction_type tx_typ
 }
 static inline enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
 {
-	return DMA_SUCCESS;
+	return DMA_COMPLETE;
 }
 static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
 {
-	return DMA_SUCCESS;
+	return DMA_COMPLETE;
 }
 static inline void dma_issue_pending_all(void)
 {
-- 
1.7.0.4

-- 
