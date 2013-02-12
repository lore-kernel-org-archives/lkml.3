Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab3BLVAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:00:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3BLUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/61] via-rhine: Fix bugs in NAPI support.
Date: Tue, 12 Feb 2013 12:34:55 -0800
Message-Id: <20130212203422.922466733@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 559bcac35facfed49ab4f408e162971612dcfdf3 ]

1) rhine_tx() should use dev_kfree_skb() not dev_kfree_skb_irq()

2) rhine_slow_event_task's NAPI triggering logic is racey, it
   should just hit the interrupt mask register.  This is the
   same as commit 7dbb491878a2c51d372a8890fa45a8ff80358af1
   ("r8169: avoid NAPI scheduling delay.") made to fix the same
   problem in the r8169 driver.  From Francois Romieu.

Reported-by: Jamie Gloudon <jamie.gloudon@gmail.com>
Tested-by: Jamie Gloudon <jamie.gloudon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/via/via-rhine.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1802,7 +1802,7 @@ static void rhine_tx(struct net_device *
 					 rp->tx_skbuff[entry]->len,
 					 PCI_DMA_TODEVICE);
 		}
-		dev_kfree_skb_irq(rp->tx_skbuff[entry]);
+		dev_kfree_skb(rp->tx_skbuff[entry]);
 		rp->tx_skbuff[entry] = NULL;
 		entry = (++rp->dirty_tx) % TX_RING_SIZE;
 	}
@@ -2011,11 +2011,7 @@ static void rhine_slow_event_task(struct
 	if (intr_status & IntrPCIErr)
 		netif_warn(rp, hw, dev, "PCI error\n");
 
-	napi_disable(&rp->napi);
-	rhine_irq_disable(rp);
-	/* Slow and safe. Consider __napi_schedule as a replacement ? */
-	napi_enable(&rp->napi);
-	napi_schedule(&rp->napi);
+	iowrite16(RHINE_EVENT & 0xffff, rp->base + IntrEnable);
 
 out_unlock:
 	mutex_unlock(&rp->task_lock);


