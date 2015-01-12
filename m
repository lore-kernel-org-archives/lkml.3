Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbbALS7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:59:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58057 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbbALS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 132/216] cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers
Date: Mon, 12 Jan 2015 18:28:30 +0000
Message-Id: <1421087394-2712-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Malinen <jouni@qca.qualcomm.com>

commit 08f6f147773b23b765b94633a8eaa82e7defcf4c upstream.

The VHT supported channel width field is a two bit integer, not a
bitfield. cfg80211_chandef_usable() was interpreting it incorrectly and
ended up rejecting 160 MHz channel width if the driver indicated support
for both 160 and 80+80 MHz channels.

Fixes: 3d9d1d6656a73 ("nl80211/cfg80211: support VHT channel configuration")
       (however, no real drivers had 160 MHz support it until 3.16)
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/chan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 992b34070bcb..0add995d5bae 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -601,7 +601,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 {
 	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap;
-	u32 width, control_freq;
+	u32 width, control_freq, cap;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return false;
@@ -641,7 +641,8 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
@@ -652,7 +653,9 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_160:
 		if (!vht_cap->vht_supported)
 			return false;
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
+		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
 		prohibited_flags |= IEEE80211_CHAN_NO_160MHZ;
 		width = 160;
-- 
2.1.4

