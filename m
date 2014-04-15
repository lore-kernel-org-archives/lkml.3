Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaDOMiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:38:15 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47413 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaDOMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:38:05 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 1/2] cfg80211: Add attributes describing prohibited channel bandwidth
Date: Tue, 15 Apr 2014 14:37:55 +0200
Message-Id: <1397565476-4348-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are frequency bands (e.g. 5.9GHz) allowing channels
with only 10 or 5 MHz bandwidth, this patch adds attributes that
allow keeping track about this information.

When channel attributes are reported to user-space, make sure to
not break old tools, i.e. if the 'split wiphy dump' is enabled,
report the extra attributes (if present) describing the bandwidth
restrictions.  If the 'split wiphy dump' is not enabled,
completely omit those channels that have flags set to either
IEEE80211_CHAN_NO_10MHZ or IEEE80211_CHAN_NO_20MHZ.

Add the check for new bandwidth restriction flags in
cfg80211_chandef_usable() to comply with the restrictions.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/chan.c          |  2 ++
 net/wireless/nl80211.c       | 13 +++++++++++++
 4 files changed, 27 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9496fe5..4e9016d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -111,6 +111,10 @@ enum ieee80211_band {
  *	restrictions.
  * @IEEE80211_CHAN_INDOOR_ONLY: see %NL80211_FREQUENCY_ATTR_INDOOR_ONLY
  * @IEEE80211_CHAN_GO_CONCURRENT: see %NL80211_FREQUENCY_ATTR_GO_CONCURRENT
+ * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
+ *	on this channel.
+ * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
+ *	on this channel.
  *
  */
 enum ieee80211_channel_flags {
@@ -125,6 +129,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
 	IEEE80211_CHAN_INDOOR_ONLY	= 1<<9,
 	IEEE80211_CHAN_GO_CONCURRENT	= 1<<10,
+	IEEE80211_CHAN_NO_20MHZ		= 1<<11,
+	IEEE80211_CHAN_NO_10MHZ		= 1<<12,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 513bfd7..0592032 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2358,6 +2358,10 @@ enum nl80211_band_attr {
  *	connected to an AP with DFS and radar detection on the UNII band (it is
  *	up to user-space, i.e., wpa_supplicant to perform the required
  *	verifications)
+ * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
+ *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
+ *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2384,6 +2388,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
 	NL80211_FREQUENCY_ATTR_INDOOR_ONLY,
 	NL80211_FREQUENCY_ATTR_GO_CONCURRENT,
+	NL80211_FREQUENCY_ATTR_NO_20MHZ,
+	NL80211_FREQUENCY_ATTR_NO_10MHZ,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c61bcdd..aee2dc2 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -616,12 +616,14 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 		width = 5;
 		break;
 	case NL80211_CHAN_WIDTH_10:
+		prohibited_flags |= IEEE80211_CHAN_NO_10MHZ;
 		width = 10;
 		break;
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
 	case NL80211_CHAN_WIDTH_20_NOHT:
+		prohibited_flags |= IEEE80211_CHAN_NO_20MHZ;
 		width = 20;
 		break;
 	case NL80211_CHAN_WIDTH_40:
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 232d15c..2f0a1b1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -567,6 +567,13 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 				   struct ieee80211_channel *chan,
 				   bool large)
 {
+	/* Some channels must be completely excluded from the
+	 * list to protect old user-space tools from breaking
+	 */
+	if (!large && chan->flags &
+	    (IEEE80211_CHAN_NO_10MHZ | IEEE80211_CHAN_NO_20MHZ))
+		return 0;
+
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_FREQ,
 			chan->center_freq))
 		goto nla_put_failure;
@@ -620,6 +627,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_GO_CONCURRENT) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_GO_CONCURRENT))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-- 
1.9.2

