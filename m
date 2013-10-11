Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab3JKKy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:54:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab3JKKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 065/100] ll_temac: Reset dma descriptors indexes on ndo_open
Date: Fri, 11 Oct 2013 11:41:35 +0100
Message-Id: <1381488130-30235-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

commit 7167cf0e8cd10287b7912b9ffcccd9616f382922 upstream.

The dma descriptors indexes are only initialized on the probe function.

If a packet is on the buffer when temac_stop is called, the dma
descriptors indexes can be left on a incorrect state where no other
package can be sent.

So an interface could be left in an usable state after ifdow/ifup.

This patch makes sure that the descriptors indexes are in a proper
status when the device is open.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1eaf712..26e487b 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -308,6 +308,12 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
 	lp->dma_out(lp, TX_CURDESC_PTR, lp->tx_bd_p);
 
+	/* Init descriptor indexes */
+	lp->tx_bd_ci = 0;
+	lp->tx_bd_next = 0;
+	lp->tx_bd_tail = 0;
+	lp->rx_bd_ci = 0;
+
 	return 0;
 
 out:
-- 
1.8.3.2

