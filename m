Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbbA0MvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:51:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34851 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbbA0MRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 012/126] net: ethernet: cpsw: fix hangs with interrupts
Date: Tue, 27 Jan 2015 12:15:17 +0000
Message-Id: <1422361031-19364-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/ti/cpsw.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index b988d16cd34e..869a0d43dbe5 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -726,6 +726,14 @@ static void cpsw_rx_handler(void *token, int len, int status)
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
@@ -755,8 +763,6 @@ static int cpsw_poll(struct napi_struct *napi, int budget)
 	int			num_tx, num_rx;
 
 	num_tx = cpdma_chan_process(priv->txch, 128);
-	if (num_tx)
-		cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
 
 	num_rx = cpdma_chan_process(priv->rxch, budget);
 	if (num_rx < budget) {
@@ -764,7 +770,6 @@ static int cpsw_poll(struct napi_struct *napi, int budget)
 
 		napi_complete(napi);
 		cpsw_intr_enable(priv);
-		cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
 		prim_cpsw = cpsw_get_slave_priv(priv, 0);
 		if (prim_cpsw->irq_enabled == false) {
 			prim_cpsw->irq_enabled = true;
@@ -1271,8 +1276,6 @@ static int cpsw_ndo_open(struct net_device *ndev)
 	napi_enable(&priv->napi);
 	cpdma_ctlr_start(priv->dma);
 	cpsw_intr_enable(priv);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
 
 	prim_cpsw = cpsw_get_slave_priv(priv, 0);
 	if (prim_cpsw->irq_enabled == false) {
@@ -1539,9 +1542,6 @@ static void cpsw_ndo_tx_timeout(struct net_device *ndev)
 	cpdma_chan_start(priv->txch);
 	cpdma_ctlr_int_ctrl(priv->dma, true);
 	cpsw_intr_enable(priv);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
-
 }
 
 static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
@@ -1581,9 +1581,6 @@ static void cpsw_ndo_poll_controller(struct net_device *ndev)
 	cpsw_interrupt(ndev->irq, priv);
 	cpdma_ctlr_int_ctrl(priv->dma, true);
 	cpsw_intr_enable(priv);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_RX);
-	cpdma_ctlr_eoi(priv->dma, CPDMA_EOI_TX);
-
 }
 #endif
 
-- 
2.1.4

