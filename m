Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbaFIJOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:14:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58403 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754830AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 028/146] mac80211: fix suspend vs. association race
Date: Mon,  9 Jun 2014 10:49:23 +0200
Message-Id: <a0ed272608496dcc82ef7833fcbbf6f2ec1328e5.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c52666aef9f2dff39276eb53f15d99e2e229870f upstream.

If the association is in progress while we suspend, the
stack will be in a messed up state. Clean it before we
suspend.

This patch completes Johannes's patch:

1a1cb744de160ee70086a77afff605bbc275d291
Author: Johannes Berg <johannes.berg@intel.com>

    mac80211: fix suspend vs. authentication race

Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/mlme.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e41c477c6d9f..cd8d55c99ceb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3691,18 +3691,24 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 
 	sdata_lock(sdata);
 
-	if (ifmgd->auth_data) {
+	if (ifmgd->auth_data || ifmgd->assoc_data) {
+		const u8 *bssid = ifmgd->auth_data ?
+				ifmgd->auth_data->bss->bssid :
+				ifmgd->assoc_data->bss->bssid;
+
 		/*
-		 * If we are trying to authenticate while suspending, cfg80211
-		 * won't know and won't actually abort those attempts, thus we
-		 * need to do that ourselves.
+		 * If we are trying to authenticate / associate while suspending,
+		 * cfg80211 won't know and won't actually abort those attempts,
+		 * thus we need to do that ourselves.
 		 */
-		ieee80211_send_deauth_disassoc(sdata,
-					       ifmgd->auth_data->bss->bssid,
+		ieee80211_send_deauth_disassoc(sdata, bssid,
 					       IEEE80211_STYPE_DEAUTH,
 					       WLAN_REASON_DEAUTH_LEAVING,
 					       false, frame_buf);
-		ieee80211_destroy_auth_data(sdata, false);
+		if (ifmgd->assoc_data)
+			ieee80211_destroy_assoc_data(sdata, false);
+		if (ifmgd->auth_data)
+			ieee80211_destroy_auth_data(sdata, false);
 		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 				      IEEE80211_DEAUTH_FRAME_LEN);
 	}
-- 
1.9.3

