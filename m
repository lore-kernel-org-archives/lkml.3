Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3CYBQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34065 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373Ab3CYBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:13 -0400
Message-Id: <20130325010528.935774864@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 047/104] sfc: Detach net device when stopping queues for  reconfiguration
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

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 29c69a4882641285a854d6d03ca5adbba68c0034 ]

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/efx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 34e51f3..5d5a05f 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -719,6 +719,7 @@ efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	unsigned i;
 	int rc;
 
+	efx_device_detach_sync(efx);
 	efx_stop_all(efx);
 	efx_fini_channels(efx);
 
@@ -762,6 +763,7 @@ out:
 
 	efx_init_channels(efx);
 	efx_start_all(efx);
+	netif_device_attach(efx->net_dev);
 	return rc;
 
 rollback:
@@ -1530,8 +1532,12 @@ static void efx_stop_all(struct efx_nic *efx)
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
 	if (efx_dev_registered(efx)) {
 		netif_tx_stop_all_queues(efx->net_dev);
 		netif_tx_lock_bh(efx->net_dev);
@@ -1832,10 +1838,11 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	if (new_mtu > EFX_MAX_MTU)
 		return -EINVAL;
 
-	efx_stop_all(efx);
-
 	netif_dbg(efx, drv, efx->net_dev, "changing MTU to %d\n", new_mtu);
 
+	efx_device_detach_sync(efx);
+	efx_stop_all(efx);
+
 	efx_fini_channels(efx);
 
 	mutex_lock(&efx->mac_lock);
@@ -1848,6 +1855,7 @@ static int efx_change_mtu(struct net_device *net_dev, int new_mtu)
 	efx_init_channels(efx);
 
 	efx_start_all(efx);
+	netif_device_attach(efx->net_dev);
 	return rc;
 }
 


