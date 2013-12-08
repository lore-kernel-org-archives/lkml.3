Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3LHJ2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:28:15 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:59717 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3LHJ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:27:24 -0500
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
Subject: [PATCH v2 06/16] wl1251: configure hardware en-/decryption for monitor mode
Date: Sun,  8 Dec 2013 10:25:04 +0100
Message-Id: <1386494714-21070-7-git-send-email-pali.rohar@gmail.com>
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

Disable hardware encryption (DF_ENCRYPTION_DISABLE) and decryption
(DF_SNIFF_MODE_ENABLE) via wl1251_acx_feature_cfg while monitor interface is
present.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/acx.c    |    6 +++---
 drivers/net/wireless/ti/wl1251/acx.h    |    2 +-
 drivers/net/wireless/ti/wl1251/init.c   |    2 +-
 drivers/net/wireless/ti/wl1251/main.c   |   34 ++++++++++++++++++++++++++-----
 drivers/net/wireless/ti/wl1251/rx.c     |    2 +-
 drivers/net/wireless/ti/wl1251/tx.c     |    3 +++
 drivers/net/wireless/ti/wl1251/wl1251.h |    1 +
 7 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
index 5f4a552..1ec98e9 100644
--- a/drivers/net/wireless/ti/wl1251/acx.c
+++ b/drivers/net/wireless/ti/wl1251/acx.c
@@ -209,7 +209,7 @@ out:
 	return ret;
 }
 
-int wl1251_acx_feature_cfg(struct wl1251 *wl)
+int wl1251_acx_feature_cfg(struct wl1251 *wl, u32 data_flow_options)
 {
 	struct acx_feature_config *feature;
 	int ret;
@@ -222,8 +222,8 @@ int wl1251_acx_feature_cfg(struct wl1251 *wl)
 		goto out;
 	}
 
-	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
-	feature->data_flow_options = 0;
+	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE can be set */
+	feature->data_flow_options = data_flow_options;
 	feature->options = 0;
 
 	ret = wl1251_cmd_configure(wl, ACX_FEATURE_CFG,
diff --git a/drivers/net/wireless/ti/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
index 4444cd0..bea2e67 100644
--- a/drivers/net/wireless/ti/wl1251/acx.h
+++ b/drivers/net/wireless/ti/wl1251/acx.h
@@ -1455,7 +1455,7 @@ int wl1251_acx_wake_up_conditions(struct wl1251 *wl, u8 wake_up_event,
 int wl1251_acx_sleep_auth(struct wl1251 *wl, u8 sleep_auth);
 int wl1251_acx_fw_version(struct wl1251 *wl, char *buf, size_t len);
 int wl1251_acx_tx_power(struct wl1251 *wl, int power);
-int wl1251_acx_feature_cfg(struct wl1251 *wl);
+int wl1251_acx_feature_cfg(struct wl1251 *wl, u32 data_flow_options);
 int wl1251_acx_mem_map(struct wl1251 *wl,
 		       struct acx_header *mem_map, size_t len);
 int wl1251_acx_data_path_params(struct wl1251 *wl,
diff --git a/drivers/net/wireless/ti/wl1251/init.c b/drivers/net/wireless/ti/wl1251/init.c
index 424ce01..92de289 100644
--- a/drivers/net/wireless/ti/wl1251/init.c
+++ b/drivers/net/wireless/ti/wl1251/init.c
@@ -33,7 +33,7 @@ int wl1251_hw_init_hwenc_config(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl1251_acx_feature_cfg(wl);
+	ret = wl1251_acx_feature_cfg(wl, 0);
 	if (ret < 0) {
 		wl1251_warning("couldn't set feature config");
 		return ret;
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 0e27f1f..39a6105 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -485,6 +485,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->rssi_thold = 0;
 	wl->channel = WL1251_DEFAULT_CHANNEL;
+	wl->monitor_present = false;
 
 	wl1251_debugfs_reset(wl);
 
@@ -577,8 +578,10 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 	channel = ieee80211_frequency_to_channel(
 			conf->chandef.chan->center_freq);
 
-	wl1251_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+	wl1251_debug(DEBUG_MAC80211,
+		     "mac80211 config ch %d monitor %s psm %s power %d",
 		     channel,
+		     conf->flags & IEEE80211_CONF_MONITOR ? "on" : "off",
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
 		     conf->power_level);
 
@@ -588,6 +591,22 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (ret < 0)
 		goto out;
 
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		u32 mode;
+
+		if (conf->flags & IEEE80211_CONF_MONITOR) {
+			wl->monitor_present = true;
+			mode = DF_SNIFF_MODE_ENABLE | DF_ENCRYPTION_DISABLE;
+		} else {
+			wl->monitor_present = false;
+			mode = 0;
+		}
+
+		ret = wl1251_acx_feature_cfg(wl, mode);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	if (channel != wl->channel) {
 		wl->channel = channel;
 
@@ -804,12 +823,12 @@ static int wl1251_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl1251_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out_unlock;
-
 	switch (cmd) {
 	case SET_KEY:
+		if (wl->monitor_present) {
+			ret = -EOPNOTSUPP;
+			goto out_unlock;
+		}
 		wl_cmd->key_action = KEY_ADD_OR_REPLACE;
 		break;
 	case DISABLE_KEY:
@@ -820,6 +839,10 @@ static int wl1251_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 	}
 
+	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
 	ret = wl1251_set_key_type(wl, wl_cmd, cmd, key, addr);
 	if (ret < 0) {
 		wl1251_error("Set KEY type failed");
@@ -1520,6 +1543,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
+	wl->monitor_present = false;
 	wl->scanning = false;
 	wl->default_key = 0;
 	wl->listen_int = 1;
diff --git a/drivers/net/wireless/ti/wl1251/rx.c b/drivers/net/wireless/ti/wl1251/rx.c
index 23289d4..123c4bb 100644
--- a/drivers/net/wireless/ti/wl1251/rx.c
+++ b/drivers/net/wireless/ti/wl1251/rx.c
@@ -83,7 +83,7 @@ static void wl1251_rx_status(struct wl1251 *wl,
 
 	status->flag |= RX_FLAG_MACTIME_START;
 
-	if (desc->flags & RX_DESC_ENCRYPTION_MASK) {
+	if (!wl->monitor_present && (desc->flags & RX_DESC_ENCRYPTION_MASK)) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
 
 		if (likely(!(desc->flags & RX_DESC_DECRYPT_FAIL)))
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 28121c5..3cc82fd 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -287,6 +287,9 @@ static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
 	info = IEEE80211_SKB_CB(skb);
 
 	if (info->control.hw_key) {
+		if (unlikely(wl->monitor_present))
+			return -1;
+
 		idx = info->control.hw_key->hw_key_idx;
 		if (unlikely(wl->default_key != idx)) {
 			ret = wl1251_acx_default_key(wl, idx);
diff --git a/drivers/net/wireless/ti/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
index de9e418..45df03a 100644
--- a/drivers/net/wireless/ti/wl1251/wl1251.h
+++ b/drivers/net/wireless/ti/wl1251/wl1251.h
@@ -309,6 +309,7 @@ struct wl1251 {
 	u8 bss_type;
 	u8 listen_int;
 	int channel;
+	bool monitor_present;
 
 	void *target_mem_map;
 	struct acx_data_path_params_resp *data_path;
-- 
1.7.9.5

