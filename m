Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaBMJjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:39:19 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:56934 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaBMJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:39:16 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>, stable@vger.kernel.org
Subject: [PATCH] dma: ste_dma40: don't dereference free:d descriptor
Date: Thu, 13 Feb 2014 10:39:01 +0100
Message-Id: <1392284341-11482-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that in the DMA40 driver the DMA tasklet will very
often dereference memory for a descriptor just free:d from the
DMA40 slab. Nothing happens because no other part of the driver
has yet had a chance to claim this memory, but it's really
nasty to dereference free:d memory, so let's check the flag
before the descriptor is free and store it in a bool variable.

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 00a2de957b23..bf18c786ed40 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1641,6 +1641,7 @@ static void dma_tasklet(unsigned long data)
 	struct d40_chan *d40c = (struct d40_chan *) data;
 	struct d40_desc *d40d;
 	unsigned long flags;
+	bool callback_active;
 	dma_async_tx_callback callback;
 	void *callback_param;
 
@@ -1668,6 +1669,7 @@ static void dma_tasklet(unsigned long data)
 	}
 
 	/* Callback to client */
+	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
@@ -1690,7 +1692,7 @@ static void dma_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback_active && callback)
 		callback(callback_param);
 
 	return;
-- 
1.8.5.3

