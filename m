Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3CZXPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:15:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3CZXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:01:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 11/49] sfc: Do not attempt to flush queues if DMA is disabled
Date: Tue, 26 Mar 2013 16:01:08 -0700
Message-Id: <20130326225840.756292811@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stuart Hodgson <smhodgson@solarflare.com>

[ Upstream commit 3dca9d2dc285faf1910d405b65df845cab061356 ]

efx_nic_fatal_interrupt() disables DMA before scheduling a reset.
After this, we need not and *cannot* flush queues.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sfc/efx.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

--- a/drivers/net/sfc/efx.c
+++ b/drivers/net/sfc/efx.c
@@ -651,25 +651,30 @@ static void efx_fini_channels(struct efx
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


