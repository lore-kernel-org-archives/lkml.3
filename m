Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbaE3Q4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:56:40 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47270 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbaE3Q4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:56:37 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC 1/4] cfg80211: Add channel flags limiting availability to OCB mode only
Date: Fri, 30 May 2014 18:56:21 +0200
Message-Id: <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IEEE 802.11p operates in its own 5.9GHz band. When there will
be a record for the 5.9GHz band in the regulatory daemon,
it must be limited to the OCB mode only -- using the newly
added flags.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/nl80211.c       | 3 +++
 net/wireless/reg.c           | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c7169b..6722ab2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -115,6 +115,7 @@ enum ieee80211_band {
  *	on this channel.
  * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
  *	on this channel.
+ * @IEEE80211_CHAN_OCB_ONLY: only OCB is allowed on this channel.
  *
  */
 enum ieee80211_channel_flags {
@@ -131,6 +132,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_GO_CONCURRENT	= 1<<10,
 	IEEE80211_CHAN_NO_20MHZ		= 1<<11,
 	IEEE80211_CHAN_NO_10MHZ		= 1<<12,
+	IEEE80211_CHAN_OCB_ONLY         = 1<<13,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 406010d..970c5df 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2362,6 +2362,8 @@ enum nl80211_band_attr {
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
  *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_OCB_ONLY: no other than OCB networks are
+ *	permitted on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2390,6 +2392,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_GO_CONCURRENT,
 	NL80211_FREQUENCY_ATTR_NO_20MHZ,
 	NL80211_FREQUENCY_ATTR_NO_10MHZ,
+	NL80211_FREQUENCY_ATTR_OCB_ONLY,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -2558,6 +2561,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
  *	base on contiguous rules and wider channels will be allowed to cross
  *	multiple contiguous/overlapping frequency ranges.
+ * @NL80211_RRF_OCB_ONLY: no other than OCB is allowed
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2570,6 +2574,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_IR		= 1<<7,
 	__NL80211_RRF_NO_IBSS		= 1<<8,
 	NL80211_RRF_AUTO_BW		= 1<<11,
+	NL80211_RRF_OCB_ONLY            = 1<<12,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f1b18f2..c766c31 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -633,6 +633,9 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_OCB_ONLY) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_OCB_ONLY))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e78f532..74e41f7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -906,6 +906,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_NO_OFDM;
 	if (rd_flags & NL80211_RRF_NO_OUTDOOR)
 		channel_flags |= IEEE80211_CHAN_INDOOR_ONLY;
+	if (rd_flags & NL80211_RRF_OCB_ONLY)
+		channel_flags |= IEEE80211_CHAN_OCB_ONLY;
 	return channel_flags;
 }
 
-- 
2.0.0.rc4

