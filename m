Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaCEOpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:45:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbaCEOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 43/62] dma: ste_dma40: don't dereference free:d descriptor
Date: Wed,  5 Mar 2014 14:36:47 +0000
Message-Id: <1394030226-26652-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit e9baa9d9d520fb0e24cca671e430689de2d4a4b2 upstream.

It appears that in the DMA40 driver the DMA tasklet will very
often dereference memory for a descriptor just free:d from the
DMA40 slab. Nothing happens because no other part of the driver
has yet had a chance to claim this memory, but it's really
nasty to dereference free:d memory, so let's check the flag
before the descriptor is free and store it in a bool variable.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/ste_dma40.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index aec952f..b138bc4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1412,6 +1412,7 @@ static void dma_tasklet(unsigned long data)
 	struct d40_chan *d40c = (struct d40_chan *) data;
 	struct d40_desc *d40d;
 	unsigned long flags;
+	bool callback_active;
 	dma_async_tx_callback callback;
 	void *callback_param;
 
@@ -1435,6 +1436,7 @@ static void dma_tasklet(unsigned long data)
 	}
 
 	/* Callback to client */
+	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
@@ -1459,7 +1461,7 @@ static void dma_tasklet(unsigned long data)
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback_active && callback)
 		callback(callback_param);
 
 	return;
-- 
1.9.0

