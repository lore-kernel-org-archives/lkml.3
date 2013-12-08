Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161146Ab3LHJ31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:29:27 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62218 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3LHJ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:27:29 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 10/16] wl1251: enable tx path in monitor mode if necessary for packet injection
Date: Sun,  8 Dec 2013 10:25:08 +0100
Message-Id: <1386494714-21070-11-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

If necessary enable the tx path in monitor mode for packet injection using
the JOIN command with BSS_TYPE_STA_BSS and zero BSSID.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c   |    5 +++++
 drivers/net/wireless/ti/wl1251/tx.c     |   25 +++++++++++++++++++++++++
 drivers/net/wireless/ti/wl1251/wl1251.h |    1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index b6f11b8..bb6e873 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -487,6 +487,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->rssi_thold = 0;
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->monitor_present = false;
+	wl->joined = false;
 
 	wl1251_debugfs_reset(wl);
 
@@ -546,6 +547,7 @@ static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 	wl1251_debug(DEBUG_MAC80211, "mac80211 remove interface");
 	wl->vif = NULL;
+	memset(wl->bssid, 0, ETH_ALEN);
 	mutex_unlock(&wl->mutex);
 }
 
@@ -624,6 +626,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * at firmware level.
 		 */
 		if (wl->vif == NULL) {
+			wl->joined = false;
 			ret = wl1251_cmd_data_path_rx(wl, wl->channel, 1);
 		} else {
 			ret = wl1251_join(wl, wl->bss_type, wl->channel,
@@ -1612,7 +1615,9 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->monitor_present = false;
+	wl->joined = false;
 	wl->scanning = false;
+	wl->bss_type = MAX_BSS_TYPE;
 	wl->default_key = 0;
 	wl->listen_int = 1;
 	wl->rx_counter = 0;
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 3cc82fd..216334d 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -28,6 +28,7 @@
 #include "tx.h"
 #include "ps.h"
 #include "io.h"
+#include "event.h"
 
 static bool wl1251_tx_double_buffer_busy(struct wl1251 *wl, u32 data_out_count)
 {
@@ -277,6 +278,26 @@ static void wl1251_tx_trigger(struct wl1251 *wl)
 		TX_STATUS_DATA_OUT_COUNT_MASK;
 }
 
+static void enable_tx_for_packet_injection(struct wl1251 *wl)
+{
+	int ret;
+
+	ret = wl1251_cmd_join(wl, BSS_TYPE_STA_BSS, wl->channel,
+			      wl->beacon_int, wl->dtim_period);
+	if (ret < 0) {
+		wl1251_warning("join failed");
+		return;
+	}
+
+	ret = wl1251_event_wait(wl, JOIN_EVENT_COMPLETE_ID, 100);
+	if (ret < 0) {
+		wl1251_warning("join timeout");
+		return;
+	}
+
+	wl->joined = true;
+}
+
 /* caller must hold wl->mutex */
 static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
 {
@@ -298,6 +319,10 @@ static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
 		}
 	}
 
+	/* Enable tx path in monitor mode for packet injection */
+	if ((wl->vif == NULL) && !wl->joined)
+		enable_tx_for_packet_injection(wl);
+
 	ret = wl1251_tx_path_status(wl);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/ti/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
index 93c18d2..89f07f6 100644
--- a/drivers/net/wireless/ti/wl1251/wl1251.h
+++ b/drivers/net/wireless/ti/wl1251/wl1251.h
@@ -311,6 +311,7 @@ struct wl1251 {
 	u8 listen_int;
 	int channel;
 	bool monitor_present;
+	bool joined;
 
 	void *target_mem_map;
 	struct acx_data_path_params_resp *data_path;
-- 
1.7.9.5

