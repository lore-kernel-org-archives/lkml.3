Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaFWNDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:03:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaFWND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 05/93] mac80211: fix suspend vs. association race
Date: Mon, 23 Jun 2014 14:01:44 +0100
Message-Id: <1403528592-2163-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/mlme.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aa7823fb73b5..60485cad6936 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3681,18 +3681,24 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 
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
1.9.1

