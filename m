Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360Ab3BSSxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:53:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3BSSxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 57/81] via-rhine: Fix bugs in NAPI support.
Date: Tue, 19 Feb 2013 15:49:20 -0300
Message-Id: <1361299784-8830-58-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 559bcac35facfed49ab4f408e162971612dcfdf3 upstream.

1) rhine_tx() should use dev_kfree_skb() not dev_kfree_skb_irq()

2) rhine_slow_event_task's NAPI triggering logic is racey, it
   should just hit the interrupt mask register.  This is the
   same as commit 7dbb491878a2c51d372a8890fa45a8ff80358af1
   ("r8169: avoid NAPI scheduling delay.") made to fix the same
   problem in the r8169 driver.  From Francois Romieu.

Reported-by: Jamie Gloudon <jamie.gloudon@gmail.com>
Tested-by: Jamie Gloudon <jamie.gloudon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/via/via-rhine.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 0459c09..046526e0 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1802,7 +1802,7 @@ static void rhine_tx(struct net_device *dev)
 					 rp->tx_skbuff[entry]->len,
 					 PCI_DMA_TODEVICE);
 		}
-		dev_kfree_skb_irq(rp->tx_skbuff[entry]);
+		dev_kfree_skb(rp->tx_skbuff[entry]);
 		rp->tx_skbuff[entry] = NULL;
 		entry = (++rp->dirty_tx) % TX_RING_SIZE;
 	}
@@ -2011,11 +2011,7 @@ static void rhine_slow_event_task(struct work_struct *work)
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
-- 
1.7.9.5

