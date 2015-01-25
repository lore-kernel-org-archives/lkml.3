Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbbAYTc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:32:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbbAYSIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 13/50] cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers
Date: Sun, 25 Jan 2015 10:07:03 -0800
Message-Id: <20150125180703.309387531@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/chan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -338,7 +338,7 @@ bool cfg80211_chandef_usable(struct wiph
 {
 	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap;
-	u32 width, control_freq;
+	u32 width, control_freq, cap;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return false;
@@ -370,7 +370,8 @@ bool cfg80211_chandef_usable(struct wiph
 			return false;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
@@ -381,7 +382,9 @@ bool cfg80211_chandef_usable(struct wiph
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


