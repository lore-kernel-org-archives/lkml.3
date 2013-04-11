Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab3DKU0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3DKU0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:01 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mvWkgVaIdBkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MXWJKvQgrucA:10 a=zRKbQ67AAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202550.143721907@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 024/171 ] sfc: lock TX queues when calling netif_device_detach()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0024-sfc-lock-TX-queues-when-calling-netif_device_detach.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Pieczko <dpieczko@solarflare.com>

[ Upstream commit c2f3b8e3a44b6fe9e36704e30157ebe1a88c08b1 ]

The assertion of netif_device_present() at the top of
efx_hard_start_xmit() may fail if we don't do this.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/efx.c      |    4 ++--
 drivers/net/ethernet/sfc/efx.h      |   13 +++++++++++++
 drivers/net/ethernet/sfc/selftest.c |    2 +-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 65a8d49..073fd60 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2224,7 +2224,7 @@ int efx_reset(struct efx_nic *efx, enum reset_type method)
 	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
 		   RESET_TYPE(method));
 
-	netif_device_detach(efx->net_dev);
+	efx_device_detach_sync(efx);
 	efx_reset_down(efx, method);
 
 	rc = efx->type->reset(efx, method);
@@ -2719,7 +2719,7 @@ static int efx_pm_freeze(struct device *dev)
 
 	efx->state = STATE_FINI;
 
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
index 96068d1..57dec37 100644
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
1.7.10.4


