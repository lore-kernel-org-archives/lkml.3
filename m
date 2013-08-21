Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3HUIlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:41:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49702 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3HUIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:41:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.20
Date: Wed, 21 Aug 2013 09:41:17 +0100
Message-Id: <1377074477-31306-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377074477-31306-1-git-send-email-luis.henriques@canonical.com>
References: <1377074477-31306-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index fa278f9..4fdc06d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .19
+EXTRAVERSION = .20
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 82374de..e2b25eb 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5351,7 +5351,7 @@ il_mac_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changes & BSS_CHANGED_ASSOC) {
 		D_MAC80211("ASSOC %d\n", bss_conf->assoc);
 		if (bss_conf->assoc) {
-			il->timestamp = bss_conf->last_tsf;
+			il->timestamp = bss_conf->sync_tsf;
 
 			if (!il_is_rfkill(il))
 				il->ops->post_associate(il);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index b1100b2..d09529c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1463,7 +1463,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			priv->timestamp = bss_conf->last_tsf;
+			priv->timestamp = bss_conf->sync_tsf;
 			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		} else {
 			/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index e7361d9..49a63e9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -102,7 +102,7 @@ void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
 
 	/* Update the AID, this is needed for dynamic PS support */
 	rt2x00dev->aid = bss_conf->assoc ? bss_conf->aid : 0;
-	rt2x00dev->last_beacon = bss_conf->last_tsf;
+	rt2x00dev->last_beacon = bss_conf->sync_tsf;
 
 	/* Update global beacon interval time, this is needed for PS support */
 	rt2x00dev->beacon_int = bss_conf->beacon_int;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 82942da..e248a61 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -233,8 +233,10 @@ enum ieee80211_rssi_event {
  *	valid in station mode only while @assoc is true and if also
  *	requested by %IEEE80211_HW_NEED_DTIM_PERIOD (cf. also hw conf
  *	@ps_dtim_period)
- * @last_tsf: last beacon's/probe response's TSF timestamp (could be old
+ * @sync_tsf: last beacon's/probe response's TSF timestamp (could be old
  *	as it may have been received during scanning long ago)
+ * @sync_device_ts: the device timestamp corresponding to the sync_tsf,
+ *	the driver/device can use this to calculate synchronisation
  * @beacon_int: beacon interval
  * @assoc_capability: capabilities taken from assoc resp
  * @basic_rates: bitmap of basic rates, each bit stands for an
@@ -281,7 +283,8 @@ struct ieee80211_bss_conf {
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
-	u64 last_tsf;
+	u64 sync_tsf;
+	u32 sync_device_ts;
 	u32 basic_rates;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	u16 ht_operation_mode;
@@ -696,6 +699,8 @@ enum mac80211_rx_flags {
  *
  * @mactime: value in microseconds of the 64-bit Time Synchronization Function
  * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
+ * @device_timestamp: arbitrary timestamp for the device, mac80211 doesn't use
+ *	it but can store it and pass it back to the driver for synchronisation
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
  * @signal: signal strength when receiving this frame, either in dBm, in dB or
@@ -709,6 +714,7 @@ enum mac80211_rx_flags {
  */
 struct ieee80211_rx_status {
 	u64 mactime;
+	u32 device_timestamp;
 	enum ieee80211_band band;
 	int freq;
 	int signal;
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..ce51547 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -306,7 +306,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(u8, dtimper)
 		__field(u16, bcnint)
 		__field(u16, assoc_cap)
-		__field(u64, timestamp)
+		__field(u64, sync_tsf)
+		__field(u32, sync_device_ts)
 		__field(u32, basic_rates)
 		__field(u32, changed)
 		__field(bool, enable_beacon)
@@ -325,7 +326,8 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->dtimper = info->dtim_period;
 		__entry->bcnint = info->beacon_int;
 		__entry->assoc_cap = info->assoc_capability;
-		__entry->timestamp = info->last_tsf;
+		__entry->sync_tsf = info->sync_tsf;
+		__entry->sync_device_ts = info->sync_device_ts;
 		__entry->basic_rates = info->basic_rates;
 		__entry->enable_beacon = info->enable_beacon;
 		__entry->ht_operation_mode = info->ht_operation_mode;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1d025ca..38ba70e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -81,6 +81,8 @@ struct ieee80211_bss {
 	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 
+	u32 device_ts;
+
 	bool wmm_used;
 	bool uapsd_supported;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4549e7e..ffca767 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1280,11 +1280,6 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
-	/* set timing information */
-	bss_conf->beacon_int = cbss->beacon_interval;
-	bss_conf->last_tsf = cbss->tsf;
-
-	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 		cbss->capability, bss->has_erp_value, bss->erp_value);
 
@@ -3173,9 +3168,15 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 		memcpy(ifmgd->bssid, cbss->bssid, ETH_ALEN);
 
-		/* tell driver about BSSID and basic rates */
+		/* set timing information */
+		sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
+		sdata->vif.bss_conf.sync_tsf = cbss->tsf;
+		sdata->vif.bss_conf.sync_device_ts = bss->device_ts;
+
+		/* tell driver about BSSID, basic rates and timing */
 		ieee80211_bss_info_change_notify(sdata,
-			BSS_CHANGED_BSSID | BSS_CHANGED_BASIC_RATES);
+			BSS_CHANGED_BSSID | BSS_CHANGED_BASIC_RATES |
+			BSS_CHANGED_BEACON_INT);
 
 		if (assoc)
 			sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index bb456ac..b73ce0a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -83,13 +83,14 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 
 	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, channel,
 					 mgmt, len, signal, GFP_ATOMIC);
-
 	if (!cbss)
 		return NULL;
 
 	cbss->free_priv = ieee80211_rx_bss_free;
 	bss = (void *)cbss->priv;
 
+	bss->device_ts = rx_status->device_timestamp;
+
 	if (elems->parse_error) {
 		if (beacon)
 			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
