Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaDOMiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:38:19 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40303 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaDOMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:38:07 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 2/2] cfg80211: Use 5MHz bandwidth by default when checking usable channels
Date: Tue, 15 Apr 2014 14:37:56 +0200
Message-Id: <1397565476-4348-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code checks if the 20MHz bandwidth is allowed for
particular channel -- if it is not, the channel is disabled.
Since we need to use 5/10 MHz channels, this code is modified in
the way that the default bandwidth to check is 5MHz. If the
maximum bandwidth allowed by the channel is smaller than 5MHz,
the channel is disabled. Otherwise the channel is used and the
flags are set according to the bandwidth allowed by the channel.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/wireless/reg.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9d32633..3f3bc2e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -927,7 +927,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(5));
 
 		if (band_rule_found && bw_fits)
 			return rr;
@@ -1011,10 +1011,10 @@ static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 }
 #endif
 
-/*
- * Note that right now we assume the desired channel bandwidth
- * is always 20 MHz for each individual channel (HT40 uses 20 MHz
- * per channel, the primary and the extension channel).
+/* Find an ieee80211_reg_rule such that a 5MHz channel with frequency
+ * @chan->center_freq fits there.
+ * If there is no such reg_rule, disable the channel, otherwise set the
+ * flags corresponding to the bandwidths allowed in the particular reg_rule
  */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
@@ -1075,8 +1075,12 @@ static void handle_channel(struct wiphy *wiphy,
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
+	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags = IEEE80211_CHAN_NO_10MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
@@ -1510,8 +1514,12 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
+	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags = IEEE80211_CHAN_NO_10MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-- 
1.9.2

