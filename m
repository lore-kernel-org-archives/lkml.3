Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbbA2J6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:58:11 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44785 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758598AbbA2JC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/176] net: ethernet: cpsw: fix hangs with interrupts
Date: Wed, 28 Jan 2015 15:28:42 +0100
Message-Id: <8e2aaf56683302f62e6e5bd5dc793deaca0076c2.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7ce67a38f799d1fb332f672b117efbadedaa5352 upstream.

The CPSW IP implements pulse-signaled interrupts. Due to
that we must write a correct, pre-defined value to the
CPDMA_MACEOIVECTOR register so the controller generates
a pulse on the correct IRQ line to signal the End Of
Interrupt.

The way the driver is written today, all four IRQ lines
are requested using the same IRQ handler and, because of
that, we could fall into situations where a TX IRQ fires
but we tell the controller that we ended an RX IRQ (or
vice-versa). This situation triggers an IRQ storm on the
reserved IRQ 127 of INTC which will in turn call ack_bad_irq()
which will, then, print a ton of:

	unexpected IRQ trap at vector 00

In order to fix the problem, we are moving all calls to
cpdma_ctlr_eoi() inside the IRQ handler and making sure
we *always* write the correct value to the CPDMA_MACEOIVECTOR
register. Note that the algorithm assumes that IRQ numbers and
value-to-be-written-to-EOI are proportional, meaning that a
write of value 0 would trigger an EOI pulse for the RX_THRESHOLD
Interrupt and that's the IRQ number sitting in the 0-th index
of our irqs_table array.

This, however, is safe at least for current implementations of
CPSW so we will refrain from making the check smarter (and, as
a side-effect, slower) until we actually have a platform where
IRQ lines are swapped.

This patch has been tested for several days with AM335x- and
AM437x-based platforms. AM57x was left out because there are
still pending patches to enable ethernet in mainline for that
platform. A read of the TRM confirms the statement on previous
paragraph.

Reported-by: Yegor Yefremov <yegorslists@googlemail.com>
Fixes: 510a1e7 (drivers: net: davinci_cpdma: acknowledge interrupt properly)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/ti/cpsw.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 498e808391a9..d7a98d08abd2 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -639,6 +639,14 @@ void cpsw_rx_handler(void *token, int len, int status)
 static irqreturn_t cpsw_interrupt(int irq, void *dev_id)
 {
 	struct cpsw_priv *priv = dev_id;
+	int value = irq - priv->irqs_table[0];
+
+	/* NOTICE: Ending IRQ here. The trick with the 'value' variable above
+	 * is to make sure we will always write the correct value to the EOI
+	 * register. Namely 0 for RX_THRESH Interrupt, 1 for RX Interrupt, 2
+	 * for TX Interrupt and 3 for MISC Interrupt.
+	 */
+	cpdma_ctlr_eoi(priv->dma, value);
 
 	cpsw_intr_disable(priv);
 	if (priv->irq_enabled == true) {
@@ -668,8 +676,6 @@ static int cpsw_poll(struct napi_struct *napi, int budget)
 	int			num_tx, num_rx;
 
 	num_tx = cpdma_chan_process(priv->txch, 128);
-	if (num_tx)
-		cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
 
 	num_rx = cpdma_chan_process(priv->rxch, budget);
 	if (num_rx < budget) {
@@ -677,7 +683,6 @@ static int cpsw_poll(struct napi_struct *napi, int budget)
 
 		napi_complete(napi);
 		cpsw_intr_enable(priv);
-		cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
 		prim_cpsw = cpsw_get_slave_priv(priv, 0);
 		if (prim_cpsw->irq_enabled == false) {
 			prim_cpsw->irq_enabled = true;
@@ -1165,8 +1170,6 @@ static int cpsw_ndo_open(struct net_device *ndev)
 	napi_enable(&priv->napi);
 	cpdma_ctlr_start(priv->dma);
 	cpsw_intr_enable(priv);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
 
 	if (priv->data.dual_emac)
 		priv->slaves[priv->emac_port].open_stat = true;
@@ -1416,9 +1419,6 @@ static void cpsw_ndo_tx_timeout(struct net_device *ndev)
 	cpdma_chan_start(priv->txch);
 	cpdma_ctlr_int_ctrl(priv->dma, true);
 	cpsw_intr_enable(priv);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
-
 }
 
 static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
@@ -1464,9 +1464,6 @@ static void cpsw_ndo_poll_controller(struct net_device *ndev)
 	cpsw_interrupt(ndev->irq, priv);
 	cpdma_ctlr_int_ctrl(priv->dma, true);
 	cpsw_intr_enable(priv);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
-
 }
 #endif
 
-- 
2.2.2

