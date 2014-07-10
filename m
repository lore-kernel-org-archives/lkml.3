Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaGJM17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:27:59 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:45846 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaGJM15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:27:57 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH] mac80211: Parse IEEE80211_RADIOTAP_RATE on TX
Date: Thu, 10 Jul 2014 14:27:41 +0200
Message-Id: <1404995261-6626-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for parsing radiotap field IEEE80211_RADIOTAP_RATE
for transmitted frames. Use the provided datarate value in
info->control.rates[] array so it will be used for transmission.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
This feature is essential for Transmit Datarate Control (TDC)
in future implementation of IEEE 802.11-2012 "Wireless Access
for the Vehicular Environment" support.


 include/net/mac80211.h |  2 ++
 net/mac80211/rate.c    |  4 ++++
 net/mac80211/tx.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9ce5cb1..7ba8faa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -549,11 +549,13 @@ enum mac80211_tx_info_flags {
  *
  * @IEEE80211_TX_CTRL_PORT_CTRL_PROTO: this frame is a port control
  *	protocol frame (e.g. EAP)
+ * @IEEE80211_TX_CTRL_USERRATE: Fixed datarate set by the user
  *
  * These flags are used in tx_info->control.flags.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
+	IEEE80211_TX_CTRL_USERRATE		= BIT(1),
 };
 
 /*
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 8fdadfd..1111dee 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -673,6 +673,10 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		priv_sta = sta->rate_ctrl_priv;
 	}
 
+	if ((info->flags & IEEE80211_TX_CTL_INJECTED) &&
+	    (info->control.flags & IEEE80211_TX_CTRL_USERRATE))
+		return;
+
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		info->control.rates[i].idx = -1;
 		info->control.rates[i].flags = 0;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 865bdaf..2099c70 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1541,7 +1541,11 @@ static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
+	int rate;
 	u16 txflags;
+	int i, j;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
@@ -1592,6 +1596,45 @@ static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
 				info->flags |= IEEE80211_TX_CTL_NO_ACK;
 			break;
 
+		case IEEE80211_RADIOTAP_RATE:
+			if (!(*iterator.this_arg))
+				break;
+
+			rate = 0;
+			sdata = vif_to_sdata(info->control.vif);
+			sband = sdata->wdev.wiphy->bands[info->band];
+			for (i = 0; i < sband->n_bitrates; i++) {
+				/* Radiotap datarate: Units of 500 Kbps
+				 * ieee80211_rate.bitrate: Units of 100 Kbps
+				 */
+				if ((sband->bitrates[i].bitrate * 2) ==
+				    ((*iterator.this_arg) * 10)) {
+					rate = i;
+					break;
+				}
+			}
+
+			if (!rate)
+				break;
+
+			info->flags |= IEEE80211_TX_CTRL_USERRATE;
+
+			for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+				if (info->control.rates[i].idx < 0)
+					break;
+
+				/* Rate masking supports only legacy
+				 * rates for now
+				 */
+				if (info->control.rates[i].flags &
+				    IEEE80211_TX_RC_MCS)
+					continue;
+
+				for (j = 0; j < sband->n_bitrates; j++)
+					info->control.rates[i].idx = rate;
+			}
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
-- 
2.0.0.rc4

