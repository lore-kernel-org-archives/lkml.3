Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaBGLrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:47:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaBGLrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 007/233] sfc: Stop/re-start PTP when stopping/starting the datapath.
Date: Fri,  7 Feb 2014 11:43:46 +0000
Message-Id: <1391773652-25214-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Rames <arames@solarflare.com>

commit 2ea4dc28a5bcec408e01a8772763871638a5ec79 upstream.

This disables PTP when we bring the interface down to avoid getting
unmatched RX timestamp events, and tries to re-enable it when bringing
the interface up.

[bwh: Make efx_ptp_stop() safe on Falcon. Introduce
 efx_ptp_{start,stop}_datapath() functions; we'll expand them later.]

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[ luis: backported to 3.11:
  - adjusted context
  - added 'extern' to declarations in nic.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/efx.c |  4 ++++
 drivers/net/ethernet/sfc/nic.h |  2 ++
 drivers/net/ethernet/sfc/ptp.c | 30 +++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c729688..b059ae8 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -695,6 +695,8 @@ static void efx_start_datapath(struct efx_nic *efx)
 		WARN_ON(channel->rx_pkt_n_frags);
 	}
 
+	efx_ptp_start_datapath(efx);
+
 	if (netif_device_present(efx->net_dev))
 		netif_tx_wake_all_queues(efx->net_dev);
 }
@@ -710,6 +712,8 @@ static void efx_stop_datapath(struct efx_nic *efx)
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->port_enabled);
 
+	efx_ptp_stop_datapath(efx);
+
 	/* Only perform flush if dma is enabled */
 	if (dev->is_busmaster && efx->state != STATE_RECOVERY) {
 		rc = efx_nic_flush_queues(efx);
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index d63c299..22bc2ac 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -259,6 +259,8 @@ extern void efx_ptp_get_ts_info(struct efx_nic *efx,
 extern bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
 extern int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
 extern void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev);
+extern void efx_ptp_start_datapath(struct efx_nic *efx);
+extern void efx_ptp_stop_datapath(struct efx_nic *efx);
 
 extern const struct efx_nic_type falcon_a1_nic_type;
 extern const struct efx_nic_type falcon_b0_nic_type;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index e7d7010..b24d3be 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -794,9 +794,14 @@ fail:
 static int efx_ptp_stop(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-	int rc = efx_ptp_disable(efx);
 	struct list_head *cursor;
 	struct list_head *next;
+	int rc;
+
+	if (ptp == NULL)
+		return 0;
+
+	rc = efx_ptp_disable(efx);
 
 	if (ptp->rxfilter_installed) {
 		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
@@ -821,6 +826,13 @@ static int efx_ptp_stop(struct efx_nic *efx)
 	return rc;
 }
 
+static int efx_ptp_restart(struct efx_nic *efx)
+{
+	if (efx->ptp_data && efx->ptp_data->enabled)
+		return efx_ptp_start(efx);
+	return 0;
+}
+
 static void efx_ptp_pps_worker(struct work_struct *work)
 {
 	struct efx_ptp_data *ptp =
@@ -1118,7 +1130,7 @@ static int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
 {
 	if ((enable_wanted != efx->ptp_data->enabled) ||
 	    (enable_wanted && (efx->ptp_data->mode != new_mode))) {
-		int rc;
+		int rc = 0;
 
 		if (enable_wanted) {
 			/* Change of mode requires disable */
@@ -1135,7 +1147,8 @@ static int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
 			 * succeed.
 			 */
 			efx->ptp_data->mode = new_mode;
-			rc = efx_ptp_start(efx);
+			if (netif_running(efx->net_dev))
+				rc = efx_ptp_start(efx);
 			if (rc == 0) {
 				rc = efx_ptp_synchronize(efx,
 							 PTP_SYNC_ATTEMPTS * 2);
@@ -1508,3 +1521,14 @@ void efx_ptp_probe(struct efx_nic *efx)
 		efx->extra_channel_type[EFX_EXTRA_CHANNEL_PTP] =
 			&efx_ptp_channel_type;
 }
+
+void efx_ptp_start_datapath(struct efx_nic *efx)
+{
+	if (efx_ptp_restart(efx))
+		netif_err(efx, drv, efx->net_dev, "Failed to restart PTP.\n");
+}
+
+void efx_ptp_stop_datapath(struct efx_nic *efx)
+{
+	efx_ptp_stop(efx);
+}
-- 
1.8.3.2

