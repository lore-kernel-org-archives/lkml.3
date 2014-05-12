Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaELCAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:00:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34626 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbaELBmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:47 -0400
Message-Id: <20140512003202.504653342@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 045/143] ll_temac: Reset dma descriptors indexes on ndo_open
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

[ Upstream commit 7167cf0e8cd10287b7912b9ffcccd9616f382922 ]

The dma descriptors indexes are only initialized on the probe function.

If a packet is on the buffer when temac_stop is called, the dma
descriptors indexes can be left on a incorrect state where no other
package can be sent.

So an interface could be left in an usable state after ifdow/ifup.

This patch makes sure that the descriptors indexes are in a proper
status when the device is open.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ll_temac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index f2a197f..d2516dd 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -190,6 +190,12 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
 	temac_dma_out32(lp, TX_CURDESC_PTR, lp->tx_bd_p);
 
+	/* Init descriptor indexes */
+	lp->tx_bd_ci = 0;
+	lp->tx_bd_next = 0;
+	lp->tx_bd_tail = 0;
+	lp->rx_bd_ci = 0;
+
 	return 0;
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



