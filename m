Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaCHB3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:29:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaCHBHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 3.4 41/99] dma: ste_dma40: dont dereference free:d descriptor
Date: Fri,  7 Mar 2014 17:07:37 -0800
Message-Id: <20140308010612.928817719@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/ste_dma40.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1409,6 +1409,7 @@ static void dma_tasklet(unsigned long da
 	struct d40_chan *d40c = (struct d40_chan *) data;
 	struct d40_desc *d40d;
 	unsigned long flags;
+	bool callback_active;
 	dma_async_tx_callback callback;
 	void *callback_param;
 
@@ -1432,6 +1433,7 @@ static void dma_tasklet(unsigned long da
 	}
 
 	/* Callback to client */
+	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
@@ -1456,7 +1458,7 @@ static void dma_tasklet(unsigned long da
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback_active && callback)
 		callback(callback_param);
 
 	return;


