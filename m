Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbaDBNcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:32:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45937 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaDBNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:32:05 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 1/4] cfg80211: Add attributes describing prohibited channel bandwidth
Date: Wed,  2 Apr 2014 15:31:52 +0200
Message-Id: <1396445515-5808-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1396445515-5808-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
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

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b1f84b0..f5ecd6c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -109,6 +109,10 @@ enum ieee80211_band {
  *	channel as the control or any of the secondary channels.
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
+ * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
+ *     on this channel.
+ * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
+ *     on this channel.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -120,6 +124,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
+	IEEE80211_CHAN_NO_20MHZ		= 1<<9,
+	IEEE80211_CHAN_NO_10MHZ		= 1<<10,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..0748026 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2304,6 +2304,10 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2322,6 +2326,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_NO_20MHZ,
+	NL80211_FREQUENCY_ATTR_NO_10MHZ,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4fe2e6e..c62c572 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -563,6 +563,13 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
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
@@ -606,6 +613,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
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
1.9.1

