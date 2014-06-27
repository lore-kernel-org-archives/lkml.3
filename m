Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaF0QZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:25:12 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:42826 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaF0QZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:25:10 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC] Try multiple bandwidths when checking usable channels.
Date: Fri, 27 Jun 2014 18:24:54 +0200
Message-Id: <1403886294-713-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1403886294-713-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1403886294-713-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code checks if the 20MHz bandwidth is allowed for
particular channel -- if it is not, the channel is disabled.
This disables usage of 5/10 MHz channels.

The new approach is that there are multiple checks for one channel --
one for each bandwidth: 5, 10, 20, 40, 80, 160 MHz (when we hit a
bandwidth that is not allowed, greater bandwidths are automaticly
disabled as well).  This prevents the following scenario to happen:
The 5 MHz bandwidth channel at the very end of the band is
successfully checked which is followed by setting flags
IEEE80211_CHAN_NO_* according to the maximum bandwidth allowed by the
particular regulatory rule (which may be greater than the 5 MHz).
When someone will try to use the channel with the maximum bandwidth
allowed (e.g. 20 MHz), the resulting channel will not be in the range
of the band anymore.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h |   8 +-
 net/wireless/reg.c     | 202 +++++++++++++++++++++++++++++++------------------
 2 files changed, 137 insertions(+), 73 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e46c437..919f759 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3679,6 +3679,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @desired_bw_khz: The bandwidth of the channel in KHz we want regulatory
+ *                  information for
  *
  * Use this function to get the regulatory rule for a specific frequency on
  * a given wireless device. If the device has a specific regulatory domain
@@ -3692,9 +3694,13 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * have a regulatory rule for a frequency range in the center_freq's band.
  * See freq_in_rule_band() for our current definition of a band -- this is
  * purely subjective and right now it's 802.11 specific.
+ * -EINVAL either if the channel does not fit to any of the belonging
+ * regulatory rules OR when it would possibly fit but the requested channel
+ * bandwidth is greater than the one allowed by the regulatory rule.
  */
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq);
+					       u32 center_freq,
+					       u32 desired_bw_khz);
 
 /**
  * reg_initiator_name - map regulatory request initiator enum to name
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1afdf45..7a14b94 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -910,7 +910,7 @@ static u32 map_regdom_flags(u32 rd_flags)
 }
 
 static const struct ieee80211_reg_rule *
-freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
+freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq, u32 desired_bw_khz,
 		   const struct ieee80211_regdomain *regd)
 {
 	int i;
@@ -920,6 +920,9 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 	if (!regd)
 		return ERR_PTR(-EINVAL);
 
+	if (!desired_bw_khz)
+		desired_bw_khz = MHZ_TO_KHZ(20);
+
 	for (i = 0; i < regd->n_reg_rules; i++) {
 		const struct ieee80211_reg_rule *rr;
 		const struct ieee80211_freq_range *fr = NULL;
@@ -935,10 +938,28 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, desired_bw_khz);
+
+		/*
+		 * Even if the 'center_freq' and 'bw' do fit
+		 * we need to check if the required bandwidth makes
+		 * sense according to the maximum allowed bandwidth
+		 */
+		if (band_rule_found && bw_fits) {
+			u32 max_bandwidth_khz;
 
-		if (band_rule_found && bw_fits)
-			return rr;
+			/* Check if auto calculation requested */
+			if (rr->flags & NL80211_RRF_AUTO_BW)
+				max_bandwidth_khz =
+					reg_get_max_bandwidth(regd, rr);
+			else
+				max_bandwidth_khz = fr->max_bandwidth_khz;
+
+			if (max_bandwidth_khz > desired_bw_khz)
+				return rr;
+			else
+				return ERR_PTR(-EINVAL);
+		}
 	}
 
 	if (!band_rule_found)
@@ -948,13 +969,14 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 }
 
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq)
+					       u32 center_freq,
+					       u32 desired_bw_khz)
 {
 	const struct ieee80211_regdomain *regd;
 
 	regd = reg_get_regdomain(wiphy);
 
-	return freq_reg_info_regd(wiphy, center_freq, regd);
+	return freq_reg_info_regd(wiphy, center_freq, desired_bw_khz, regd);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -1019,11 +1041,6 @@ static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 }
 #endif
 
-/*
- * Note that right now we assume the desired channel bandwidth
- * is always 20 MHz for each individual channel (HT40 uses 20 MHz
- * per channel, the primary and the extension channel).
- */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
 			   struct ieee80211_channel *chan)
@@ -1035,41 +1052,75 @@ static void handle_channel(struct wiphy *wiphy,
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr = get_last_request();
 	const struct ieee80211_regdomain *regd;
-	u32 max_bandwidth_khz;
+	bool check_greater_bw = 1;
+	int bw;
 
 	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
 	flags = chan->orig_flags;
 
-	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
-	if (IS_ERR(reg_rule)) {
-		/*
-		 * We will disable all channels that do not match our
-		 * received regulatory rule unless the hint is coming
-		 * from a Country IE and the Country IE had no information
-		 * about a band. The IEEE 802.11 spec allows for an AP
-		 * to send only a subset of the regulatory rules allowed,
-		 * so an AP in the US that only supports 2.4 GHz may only send
-		 * a country IE with information for the 2.4 GHz band
-		 * while 5 GHz is still supported.
-		 */
-		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-		    PTR_ERR(reg_rule) == -ERANGE)
-			return;
+	/* Check for 5, 10, 20, 40, 80, 160 bandwidths */
+	for (bw = 5; bw < 160 && check_greater_bw; bw *= 2) {
+		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
+					 MHZ_TO_KHZ(bw));
 
-		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
-		    request_wiphy && request_wiphy == wiphy &&
-		    request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
-			REG_DBG_PRINT("Disabling freq %d MHz for good\n",
-				      chan->center_freq);
-			chan->orig_flags |= IEEE80211_CHAN_DISABLED;
-			chan->flags = chan->orig_flags;
-		} else {
-			REG_DBG_PRINT("Disabling freq %d MHz\n",
-				      chan->center_freq);
-			chan->flags |= IEEE80211_CHAN_DISABLED;
+		if (IS_ERR(reg_rule) && (PTR_ERR(reg_rule) == -EINVAL)) {
+			/*
+			 * Set BW limiting flags for any channel but the
+			 * 5MHz one -- if the 5MHz BW does not fit, the whole
+			 * channel is disabled
+			 */
+			switch (bw) {
+			case 5:
+				break;
+			case 10:
+				bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+			case 20:
+				bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+			case 40:
+				bw_flags |= IEEE80211_CHAN_NO_HT40;
+			case 80:
+				bw_flags |= IEEE80211_CHAN_NO_80MHZ;
+			case 160:
+				bw_flags |= IEEE80211_CHAN_NO_160MHZ;
+				check_greater_bw = 0;
+			}
+
+			if (!check_greater_bw)
+				break;
+		}
+
+		if (IS_ERR(reg_rule)) {
+
+			/*
+			 * We will disable all channels that do not match our
+			 * received regulatory rule unless the hint is coming
+			 * from a Country IE and the Country IE had no information
+			 * about a band. The IEEE 802.11 spec allows for an AP
+			 * to send only a subset of the regulatory rules allowed,
+			 * so an AP in the US that only supports 2.4 GHz may only send
+			 * a country IE with information for the 2.4 GHz band
+			 * while 5 GHz is still supported.
+			 */
+			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+			    PTR_ERR(reg_rule) == -ERANGE)
+				return;
+
+			if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
+			    request_wiphy && request_wiphy == wiphy &&
+			    request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
+				REG_DBG_PRINT("Disabling freq %d MHz for good\n",
+					      chan->center_freq);
+				chan->orig_flags |= IEEE80211_CHAN_DISABLED;
+				chan->flags = chan->orig_flags;
+			} else {
+				REG_DBG_PRINT("Disabling freq %d MHz\n",
+					      chan->center_freq);
+				chan->flags |= IEEE80211_CHAN_DISABLED;
+			}
+
+			return;
 		}
-		return;
 	}
 
 	regd = reg_get_regdomain(wiphy);
@@ -1078,18 +1129,6 @@ static void handle_channel(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-	max_bandwidth_khz = freq_range->max_bandwidth_khz;
-	/* Check if auto calculation requested */
-	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
-
-	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
-		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
-
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
@@ -1495,17 +1534,48 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
-	u32 max_bandwidth_khz;
+	bool check_greater_bw = 1;
+	int bw;
 
-	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-				      regd);
+	/* Check for 5, 10, 20, 40, 80, 160 bandwidths */
+	for (bw = 5; bw < 160 && check_greater_bw; bw *= 2) {
+		reg_rule = freq_reg_info_regd(wiphy,
+					      MHZ_TO_KHZ(chan->center_freq),
+					      MHZ_TO_KHZ(bw), regd);
 
-	if (IS_ERR(reg_rule)) {
-		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
-			      chan->center_freq);
-		chan->orig_flags |= IEEE80211_CHAN_DISABLED;
-		chan->flags = chan->orig_flags;
-		return;
+		if (IS_ERR(reg_rule) && (PTR_ERR(reg_rule) == -EINVAL)) {
+			/*
+			 * Set BW limiting flags for any channel but the
+			 * 5MHz one -- if the 5MHz BW does not fit, the whole
+			 * channel is disabled
+			 */
+			switch (bw) {
+			case 5:
+				break;
+			case 10:
+				bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+			case 20:
+				bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+			case 40:
+				bw_flags |= IEEE80211_CHAN_NO_HT40;
+			case 80:
+				bw_flags |= IEEE80211_CHAN_NO_80MHZ;
+			case 160:
+				bw_flags |= IEEE80211_CHAN_NO_160MHZ;
+				check_greater_bw = 0;
+			}
+
+			if (!check_greater_bw)
+				break;
+		}
+
+		if (IS_ERR(reg_rule)) {
+			REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
+				      chan->center_freq);
+			chan->orig_flags |= IEEE80211_CHAN_DISABLED;
+			chan->flags = chan->orig_flags;
+			return;
+		}
 	}
 
 	chan_reg_rule_print_dbg(regd, chan, reg_rule);
@@ -1513,18 +1583,6 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-	max_bandwidth_khz = freq_range->max_bandwidth_khz;
-	/* Check if auto calculation requested */
-	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
-
-	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
-		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
-
 	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
 	chan->max_reg_power = chan->max_power =
-- 
2.0.0.rc4

