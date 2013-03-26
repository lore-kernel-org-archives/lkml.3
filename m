Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3CZR6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:58:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3CZRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:08 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wGUhFPy7REwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1PUdoCbTWg0A:10 a=J1Y8HTJGAAAA:8 a=pGLkceISAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=4N9Db7Z2_RYA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173603.269078549@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jamie Gloudon <jamie.gloudon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 21/86] via-rhine: Fix bugs in NAPI support.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0021-via-rhine-Fix-bugs-in-NAPI-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
1.7.10.4


