Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaCaAOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:14:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vinod Koul" <vinod.koul@intel.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Linus Walleij" <linus.walleij@linaro.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.639724549@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 120/200] dma: ste_dma40: don't dereference free:d
 descriptor
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/dma/ste_dma40.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1202,6 +1202,7 @@ static void dma_tasklet(unsigned long da
 	struct d40_chan *d40c = (struct d40_chan *) data;
 	struct d40_desc *d40d;
 	unsigned long flags;
+	bool callback_active;
 	dma_async_tx_callback callback;
 	void *callback_param;
 
@@ -1225,6 +1226,7 @@ static void dma_tasklet(unsigned long da
 	}
 
 	/* Callback to client */
+	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
@@ -1249,7 +1251,7 @@ static void dma_tasklet(unsigned long da
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback_active && callback)
 		callback(callback_param);
 
 	return;

