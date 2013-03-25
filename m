Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3CYBWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:22:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34099 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256Ab3CYBQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:29 -0400
Message-Id: <20130325010528.239480390@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Stuart Hodgson <smhodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 040/104] sfc: Do not attempt to flush queues if DMA is disabled
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hodgson <smhodgson@solarflare.com>

[ Upstream commit 3dca9d2dc285faf1910d405b65df845cab061356 ]

efx_nic_fatal_interrupt() disables DMA before scheduling a reset.
After this, we need not and *cannot* flush queues.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/efx.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a6611f1..aa20047 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -650,25 +650,30 @@ static void efx_fini_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
+	struct pci_dev *dev = efx->pci_dev;
 	int rc;
 
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->port_enabled);
 
-	rc = efx_nic_flush_queues(efx);
-	if (rc && EFX_WORKAROUND_7803(efx)) {
-		/* Schedule a reset to recover from the flush failure. The
-		 * descriptor caches reference memory we're about to free,
-		 * but falcon_reconfigure_mac_wrapper() won't reconnect
-		 * the MACs because of the pending reset. */
-		netif_err(efx, drv, efx->net_dev,
-			  "Resetting to recover from flush failure\n");
-		efx_schedule_reset(efx, RESET_TYPE_ALL);
-	} else if (rc) {
-		netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
-	} else {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "successfully flushed all queues\n");
+	/* Only perform flush if dma is enabled */
+	if (dev->is_busmaster) {
+		rc = efx_nic_flush_queues(efx);
+
+		if (rc && EFX_WORKAROUND_7803(efx)) {
+			/* Schedule a reset to recover from the flush failure. The
+			 * descriptor caches reference memory we're about to free,
+			 * but falcon_reconfigure_mac_wrapper() won't reconnect
+			 * the MACs because of the pending reset. */
+			netif_err(efx, drv, efx->net_dev,
+				  "Resetting to recover from flush failure\n");
+			efx_schedule_reset(efx, RESET_TYPE_ALL);
+		} else if (rc) {
+			netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
+		} else {
+			netif_dbg(efx, drv, efx->net_dev,
+				  "successfully flushed all queues\n");
+		}
 	}
 
 	efx_for_each_channel(channel, efx) {


