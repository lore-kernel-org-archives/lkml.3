Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3CZWwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:52:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3CZWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 21/72] sfc: lock TX queues when calling netif_device_detach()
Date: Tue, 26 Mar 2013 15:51:04 -0700
Message-Id: <20130326224921.902473798@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Daniel Pieczko <dpieczko@solarflare.com>

[ Upstream commit c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1 ]

The assertion of netif_device_present() at the top of
efx_hard_start_xmit() may fail if we don't do this.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[bwh: Backported to 3.4: adjust context]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/efx.c      |    4 ++--
 drivers/net/ethernet/sfc/efx.h      |   13 +++++++++++++
 drivers/net/ethernet/sfc/selftest.c |    2 +-
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2224,7 +2224,7 @@ int efx_reset(struct efx_nic *efx, enum
 	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
 		   RESET_TYPE(method));
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 	efx_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
@@ -2718,7 +2718,7 @@ static int efx_pm_freeze(struct device *
 
 	efx->state = STATE_FINI;
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	efx_stop_all(efx);
 	efx_stop_interrupts(efx, false);
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -162,4 +162,17 @@ extern void efx_link_status_changed(stru
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
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -735,7 +735,7 @@ int efx_selftest(struct efx_nic *efx, st
 	/* Detach the device so the kernel doesn't transmit during the
 	 * loopback test and the watchdog timeout doesn't fire.
 	 */
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	mutex_lock(&efx->mac_lock);
 	if (efx->loopback_modes) {


