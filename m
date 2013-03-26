Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965429Ab3CZPbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:31:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385Ab3CZPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 130/150] sfc: lock TX queues when calling netif_device_detach()
Date: Tue, 26 Mar 2013 15:20:29 +0000
Message-Id: <1364311249-14454-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Pieczko <dpieczko@solarflare.com>

commit c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1 upstream.

The assertion of netif_device_present() at the top of
efx_hard_start_xmit() may fail if we don't do this.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/efx.c      |  5 ++---
 drivers/net/ethernet/sfc/efx.h      | 13 +++++++++++++
 drivers/net/ethernet/sfc/selftest.c |  2 +-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 16c4634..3d49f44 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2224,7 +2224,7 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
 		   RESET_TYPE(method));
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 	efx_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
@@ -2718,8 +2718,7 @@ static int efx_pm_freeze(struct device *dev)
 	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
 
 	efx->state = STATE_FINI;
-
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	efx_stop_all(efx);
 	efx_stop_interrupts(efx, false);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 70755c9..320cf7b 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -162,4 +162,17 @@ extern void efx_link_status_changed(struct efx_nic *efx);
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
index 5f5b160..4a51ea3 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -721,7 +721,7 @@ int efx_selftest(struct efx_nic *efx, struct efx_self_tests *tests,
 	/* Detach the device so the kernel doesn't transmit during the
 	 * loopback test and the watchdog timeout doesn't fire.
 	 */
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 
 	if (efx->type->test_chip) {
 		rc_reset = efx->type->test_chip(efx, tests);
-- 
1.8.1.2

