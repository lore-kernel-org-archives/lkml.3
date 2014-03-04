Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbaCDUHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:07:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaCDUFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 3.10 91/97] dma: ste_dma40: dont dereference free:d descriptor
Date: Tue,  4 Mar 2014 12:04:44 -0800
Message-Id: <20140304200348.998982794@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1587,6 +1587,7 @@ static void dma_tasklet(unsigned long da
 	struct d40_chan *d40c = (struct d40_chan *) data;
 	struct d40_desc *d40d;
 	unsigned long flags;
+	bool callback_active;
 	dma_async_tx_callback callback;
 	void *callback_param;
 
@@ -1614,6 +1615,7 @@ static void dma_tasklet(unsigned long da
 	}
 
 	/* Callback to client */
+	callback_active = !!(d40d->txd.flags & DMA_PREP_INTERRUPT);
 	callback = d40d->txd.callback;
 	callback_param = d40d->txd.callback_param;
 
@@ -1636,7 +1638,7 @@ static void dma_tasklet(unsigned long da
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
 
-	if (callback && (d40d->txd.flags & DMA_PREP_INTERRUPT))
+	if (callback_active && callback)
 		callback(callback_param);
 
 	return;


