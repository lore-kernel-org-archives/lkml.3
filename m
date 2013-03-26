Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435Ab3CZPYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410Ab3CZPYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 136/150] sfc: Detach net device when stopping queues for reconfiguration
Date: Tue, 26 Mar 2013 15:20:35 +0000
Message-Id: <1364311249-14454-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 29c69a4882641285a854d6d03ca5adbba68c0034 upstream.

We must only ever stop TX queues when they are full or the net device
is not 'ready' so far as the net core, and specifically the watchdog,
is concerned.  Otherwise, the watchdog may fire *immediately* if no
packets have been added to the queue in the last 5 seconds.

The device is ready if all the following are true:

(a) It has a qdisc
(b) It is marked present
(c) It is running
(d) The link is reported up

(a) and (c) are normally true, and must not be changed by a driver.
(d) is under our control, but fake link changes may disturb userland.
This leaves (b).  We already mark the device absent during reset
and self-test, but we need to do the same during MTU changes and ring
reallocation.  We don't need to do this when the device is brought
down because then (c) is already false.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/efx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 3d49f44..5fe7b35 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -754,6 +754,7 @@ efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 						tx_queue->txd.entries);
 	}
 
+	efx_device_detach_sync(efx);
 	efx_stop_all(efx);
 	efx_stop_interrupts(efx, true);
 
@@ -807,6 +808,7 @@ out:
 
 	efx_start_interrupts(efx, true);
 	efx_start_all(efx);
+	netif_device_attach(efx->net_dev);
 	return rc;
 
 rollback:
@@ -1601,8 +1603,12 @@ static void efx_stop_all(struct efx_nic *efx)
 	/* Flush efx_mac_work(), refill_workqueue, monitor_work */
 	efx_flush_all(efx);
 
-	/* Stop the kernel transmit interface late, so the watchdog
-	 * timer isn't ticking over the flush */
+	/* Stop the kernel transmit interface.  This is only valid if
+	 * the device is stopped or detached; otherwise the watchdog
+	 * may fire immediately.
+	 */
+	WARN_ON(netif_running(efx->net_dev) &&
+		netif_device_present(efx->net_dev));
 	netif_tx_disable(efx->net_dev);
 
 	efx_stop_datapath(efx);
@@ -1921,10 +1927,11 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	if (new_mtu > EFX_MAX_MTU)
 		return -EINVAL;
 
-	efx_stop_all(efx);
-
 	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
 
+	efx_device_detach_sync(efx);
+	efx_stop_all(efx);
+
 	mutex_lock(&efx->mac_lock);
 	/* Reconfigure the MAC before enabling the dma queues so that
 	 * the RX buffers don't overflow */
@@ -1933,6 +1940,7 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	mutex_unlock(&efx->mac_lock);
 
 	efx_start_all(efx);
+	netif_device_attach(efx->net_dev);
 	return 0;
 }
 
-- 
1.8.1.2

