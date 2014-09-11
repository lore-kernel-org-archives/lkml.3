Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaIKOaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:30:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49305 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbaIKOat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:30:49 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 2/4] mac80211: Use different EDCA config for OCB
Date: Thu, 11 Sep 2014 16:30:20 +0200
Message-Id: <1410445822-6559-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p specifies different EDCA parameters
for the OCB mode.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/mac80211/util.c | 27 ++++++++++++++++++++++-----
 net/mac80211/wme.c  |  4 ++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3eb4151..cac57eb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1073,6 +1073,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int ac;
 	bool use_11b, enable_qos;
+	bool is_ocb; /* Use another EDCA parameters if dot11OCBEnabled is true */
 	int aCWmin, aCWmax;
 
 	if (!local->ops->conf_tx)
@@ -1097,6 +1098,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	 */
 	enable_qos = (sdata->vif.type != NL80211_IFTYPE_STATION);
 
+	is_ocb = (sdata->vif.type == NL80211_IFTYPE_OCB);
+
 	/* Set defaults according to 802.11-2007 Table 7-37 */
 	aCWmax = 1023;
 	if (use_11b)
@@ -1118,7 +1121,10 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				qparam.cw_max = aCWmax;
 				qparam.cw_min = aCWmin;
 				qparam.txop = 0;
-				qparam.aifs = 7;
+				if (is_ocb)
+					qparam.aifs = 9;
+				else
+					qparam.aifs = 7;
 				break;
 			/* never happens but let's not leave undefined */
 			default:
@@ -1126,21 +1132,32 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				qparam.cw_max = aCWmax;
 				qparam.cw_min = aCWmin;
 				qparam.txop = 0;
-				qparam.aifs = 3;
+				if (is_ocb)
+					qparam.aifs = 6;
+				else
+					qparam.aifs = 3;
 				break;
 			case IEEE80211_AC_VI:
 				qparam.cw_max = aCWmin;
 				qparam.cw_min = (aCWmin + 1) / 2 - 1;
-				if (use_11b)
+				if (is_ocb)
+					qparam.txop = 0;
+				else if (use_11b)
 					qparam.txop = 6016/32;
 				else
 					qparam.txop = 3008/32;
-				qparam.aifs = 2;
+
+				if (is_ocb)
+					qparam.aifs = 3;
+				else
+					qparam.aifs = 2;
 				break;
 			case IEEE80211_AC_VO:
 				qparam.cw_max = (aCWmin + 1) / 2 - 1;
 				qparam.cw_min = (aCWmin + 1) / 4 - 1;
-				if (use_11b)
+				if (is_ocb)
+					qparam.txop = 0;
+				else if (use_11b)
 					qparam.txop = 3264/32;
 				else
 					qparam.txop = 1504/32;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 3b87398..456fa1c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -139,6 +139,10 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_ADHOC:
 		ra = skb->data;
 		break;
+	case NL80211_IFTYPE_OCB:
+		/* all stations are required to support WME */
+		qos = true;
+		break;
 	default:
 		break;
 	}
-- 
2.0.0.rc4

