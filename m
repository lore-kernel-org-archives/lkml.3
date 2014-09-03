Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaICVlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:41:24 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:49432 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaICVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:41:23 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/4] staging: et131x: Remove dead code in isr
Date: Wed,  3 Sep 2014 22:40:54 +0100
Message-Id: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter reports:
The patch c2ebf58ba089: "staging: et131x: Implement NAPI support"
from Aug 21, 2014, leads to the following static checker warning:

        drivers/staging/et131x/et131x.c:4004 et131x_isr()
        warn: we tested 'status' before and it was 'true'

We don't actually need the dead code, as we're now using NAPI to
handle enabling interrupts - but we do need to enable interrupts if
NAPI is not scheduled - so enable interrupts if this is the case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 1037d93..7a1df8a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3793,6 +3793,7 @@ static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
 static irqreturn_t et131x_isr(int irq, void *dev_id)
 {
 	bool handled = true;
+	bool enable_interrupts = true;
 	struct net_device *netdev = (struct net_device *)dev_id;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct address_map __iomem *iomem = adapter->regs;
@@ -3802,6 +3803,7 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 
 	if (!netif_device_present(netdev)) {
 		handled = false;
+		enable_interrupts = false;
 		goto out;
 	}
 
@@ -3847,8 +3849,10 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		status &= ~ET_INTR_WATCHDOG;
 	}
 
-	if (status & (ET_INTR_RXDMA_XFR_DONE | ET_INTR_TXDMA_ISR))
+	if (status & (ET_INTR_RXDMA_XFR_DONE | ET_INTR_TXDMA_ISR)) {
+		enable_interrupts = false;
 		napi_schedule(&adapter->napi);
+	}
 
 	status &= ~(ET_INTR_TXDMA_ISR | ET_INTR_RXDMA_XFR_DONE);
 
@@ -4001,16 +4005,10 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 		 */
 	}
 
-	if (!status) {
-		/* This interrupt has in some way been "handled" by
-		 * the ISR. Either it was a spurious Rx interrupt, or
-		 * it was a Tx interrupt that has been filtered by
-		 * the ISR.
-		 */
+out:
+	if (enable_interrupts)
 		et131x_enable_interrupts(adapter);
-	}
 
-out:
 	return IRQ_RETVAL(handled);
 }
 
@@ -4257,7 +4255,7 @@ static void et131x_multicast(struct net_device *netdev)
 }
 
 /* et131x_tx - The handler to tx a packet on the device */
-static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 {
 	int status = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
-- 
2.1.0

