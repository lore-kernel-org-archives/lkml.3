Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3CYBQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab3CYBQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:26 -0400
Message-Id: <20130325010528.514110743@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:07 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Pieczko <dpieczko@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 043/104] sfc: lock TX queues when calling netif_device_detach()
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

From: Daniel Pieczko <dpieczko@solarflare.com>

[ Upstream commit c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1 ]

The assertion of netif_device_present() at the top of
efx_hard_start_xmit() may fail if we don't do this.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/efx.c      |  4 ++--
 drivers/net/ethernet/sfc/efx.h      | 13 +++++++++++++
 drivers/net/ethernet/sfc/selftest.c |  2 +-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index aa20047..34e51f3 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2137,7 +2137,7 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
 		   RESET_TYPE(method));
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 	efx_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
@@ -2585,7 +2585,7 @@ static int efx_pm_freeze(struct device *dev)
 
 	efx->state = STATE_FINI;
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	efx_stop_all(efx);
 	efx_fini_channels(efx);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 1355245..55e72af 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -149,4 +149,17 @@ extern void efx_link_status_changed(struct efx_nic *efx);
 extern void efx_link_set_advertising(struct efx_nic *efx, u32);
 extern void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
 
+static inline void efx_device_detach_sync(struct efx_nic *efx)
+{
+	struct net_device *dev = efx->net_dev;
+
+	/* Lock/freeze all TX queues so that we can be sure the
+	 * TX scheduler is stopped when we're done and before
+	 * netif_device_present() becomes false.
+	 */
+	netif_tx_lock(dev);
+	netif_device_detach(dev);
+	netif_tx_unlock(dev);
+}
+
 #endif /* EFX_EFX_H */
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 822f6c2..4907885 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -698,7 +698,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 	/* Detach the device so the kernel doesn't transmit during the
 	 * loopback test and the watchdog timeout doesn't fire.
 	 */
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	mutex_lock(&efx->mac_lock);
 	if (efx->loopback_modes) {


