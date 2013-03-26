Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3CZXXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:23:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3CZWwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 15/72] sfc: Do not attempt to flush queues if DMA is disabled
Date: Tue, 26 Mar 2013 15:50:58 -0700
Message-Id: <20130326224921.306382136@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stuart Hodgson <smhodgson@solarflare.com>

[ Upstream commit 3dca9d2dc285faf1910d405b65df845cab061356 ]

efx_nic_fatal_interrupt() disables DMA before scheduling a reset.
After this, we need not and *cannot* flush queues.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/efx.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -656,25 +656,30 @@ static void efx_stop_datapath(struct efx
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


