Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3AXD2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:28:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44142 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3AXD2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 07/74] mac80211: fix dtim_period in hidden SSID AP association
Date: Thu, 24 Jan 2013 01:26:19 -0200
Message-Id: <1358998046-613-8-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 826262c3d23743cb032a9e1a65a0f9be75091a5e upstream.

When AP's SSID is hidden the BSS can appear several times in
cfg80211's BSS list: once with a zero-length SSID that comes
from the beacon, and once for each SSID from probe reponses.

Since the mac80211 stores its data in ieee80211_bss which
is embedded into cfg80211_bss, mac80211's data will be
duplicated too.

This becomes a problem when a driver needs the dtim_period
since this data exists only in the beacon's instance in
cfg80211 bss table which isn't the instance that is used
when associating.

Remove the DTIM period from the BSS table and track it
explicitly to avoid this problem.

Tested-by: Efi Tubul <efi.tubul@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: adjust context, no RCU locking (use same backport as the one
  for 3.7), keep printk usage instead of non-existent sdata_info in 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/ieee80211_i.h |    5 +--
 net/mac80211/mlme.c        |   73 +++++++++++++++++++++++++++++++-------------
 net/mac80211/scan.c        |   13 --------
 3 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d0b1c56..16655d6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -81,8 +81,6 @@ struct ieee80211_bss {
 	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 
-	u8 dtim_period;
-
 	bool wmm_used;
 	bool uapsd_supported;
 
@@ -129,7 +127,6 @@ enum ieee80211_bss_corrupt_data_flags {
 
 /**
  * enum ieee80211_valid_data_flags - BSS valid data flags
- * @IEEE80211_BSS_VALID_DTIM: DTIM data was gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_WMM: WMM/UAPSD data was gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_RATES: Supported rates were gathered from non-corrupt IE
  * @IEEE80211_BSS_VALID_ERP: ERP flag was gathered from non-corrupt IE
@@ -140,7 +137,6 @@ enum ieee80211_bss_corrupt_data_flags {
  * beacon/probe response.
  */
 enum ieee80211_bss_valid_data_flags {
-	IEEE80211_BSS_VALID_DTIM		= BIT(0),
 	IEEE80211_BSS_VALID_WMM			= BIT(1),
 	IEEE80211_BSS_VALID_RATES		= BIT(2),
 	IEEE80211_BSS_VALID_ERP			= BIT(3)
@@ -444,6 +440,7 @@ struct ieee80211_if_managed {
 	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 	bool broken_ap; /* AP is broken -- turn off powersave */
+	u8 dtim_period;
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
 				 ap_smps, /* smps mode AP thinks we're in */
 				 driver_smps_mode; /* smps mode request */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6d79367..4549e7e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -994,12 +994,8 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		if (beaconint_us > latency) {
 			local->ps_sdata = NULL;
 		} else {
-			struct ieee80211_bss *bss;
 			int maxslp = 1;
-			u8 dtimper;
-
-			bss = (void *)found->u.mgd.associated->priv;
-			dtimper = bss->dtim_period;
+			u8 dtimper = found->u.mgd.dtim_period;
 
 			/* If the TIM IE is invalid, pretend the value is 1 */
 			if (!dtimper)
@@ -1305,10 +1301,17 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_led_assoc(local, 1);
 
-	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		bss_conf->dtim_period = bss->dtim_period;
-	else
+	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
+		/*
+		 * If the AP is buggy we may get here with no DTIM period
+		 * known, so assume it's 1 which is the only safe assumption
+		 * in that case, although if the TIM IE is broken powersave
+		 * probably just won't work at all.
+		 */
+		bss_conf->dtim_period = sdata->u.mgd.dtim_period ?: 1;
+	} else {
 		bss_conf->dtim_period = 0;
+	}
 
 	bss_conf->assoc = 1;
 
@@ -1441,6 +1444,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
+
+	sdata->vif.bss_conf.dtim_period = 0;
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -2205,11 +2210,18 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_channel *channel;
 	bool need_ps = false;
 
-	if (sdata->u.mgd.associated &&
-	    ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) {
-		bss = (void *)sdata->u.mgd.associated->priv;
+	if ((sdata->u.mgd.associated &&
+	     ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid)) ||
+	    (sdata->u.mgd.assoc_data &&
+	     ether_addr_equal(mgmt->bssid,
+			      sdata->u.mgd.assoc_data->bss->bssid))) {
 		/* not previously set so we may need to recalc */
-		need_ps = !bss->dtim_period;
+		need_ps = sdata->u.mgd.associated && !sdata->u.mgd.dtim_period;
+
+		if (elems->tim && !elems->parse_error) {
+			struct ieee80211_tim_ie *tim_ie = elems->tim;
+			sdata->u.mgd.dtim_period = tim_ie->dtim_period;
+		}
 	}
 
 	if (elems->ds_params && elems->ds_params_len == 1)
@@ -3413,20 +3425,39 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	/* kick off associate process */
 
 	ifmgd->assoc_data = assoc_data;
+	ifmgd->dtim_period = 0;
 
 	err = ieee80211_prep_connection(sdata, req->bss, true);
 	if (err)
 		goto err_clear;
 
-	if (!bss->dtim_period &&
-	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
-		/*
-		 * Wait up to one beacon interval ...
-		 * should this be more if we miss one?
-		 */
-		printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
-		       sdata->name, ifmgd->bssid);
-		assoc_data->timeout = TU_TO_EXP_TIME(req->bss->beacon_interval);
+	if (sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
+		const u8 *beacon_ies = req->bss->beacon_ies;
+		size_t beacon_ies_len = req->bss->len_beacon_ies;
+
+		if (!beacon_ies_len) {
+			/*
+			 * Wait up to one beacon interval ...
+			 * should this be more if we miss one?
+			 */
+			printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
+			       sdata->name, ifmgd->bssid);
+			assoc_data->timeout =
+				TU_TO_EXP_TIME(req->bss->beacon_interval);
+		} else {
+			const u8 *tim_ie = cfg80211_find_ie(WLAN_EID_TIM,
+							    beacon_ies,
+							    beacon_ies_len);
+			if (tim_ie && tim_ie[1] >=
+					sizeof(struct ieee80211_tim_ie)) {
+				const struct ieee80211_tim_ie *tim;
+				tim = (void *)(tim_ie + 2);
+				ifmgd->dtim_period = tim->dtim_period;
+			}
+			assoc_data->have_beacon = true;
+			assoc_data->sent_assoc = false;
+			assoc_data->timeout = jiffies;
+		}
 	} else {
 		assoc_data->have_beacon = true;
 		assoc_data->sent_assoc = false;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fd973e5..58ac7d0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -112,19 +112,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			bss->valid_data |= IEEE80211_BSS_VALID_ERP;
 	}
 
-	if (elems->tim && (!elems->parse_error ||
-			   !(bss->valid_data & IEEE80211_BSS_VALID_DTIM))) {
-		struct ieee80211_tim_ie *tim_ie =
-			(struct ieee80211_tim_ie *)elems->tim;
-		bss->dtim_period = tim_ie->dtim_period;
-		if (!elems->parse_error)
-				bss->valid_data |= IEEE80211_BSS_VALID_DTIM;
-	}
-
-	/* If the beacon had no TIM IE, or it was invalid, use 1 */
-	if (beacon && !bss->dtim_period)
-		bss->dtim_period = 1;
-
 	/* replace old supported rates if we get new values */
 	if (!elems->parse_error ||
 	    !(bss->valid_data & IEEE80211_BSS_VALID_RATES)) {
-- 
1.7.9.5

