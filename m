Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaFEAmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaFDXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 035/228] mac80211: fix suspend vs. association race
Date: Wed,  4 Jun 2014 16:21:04 -0700
Message-Id: <20140604232349.197549348@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3511,18 +3511,24 @@ void ieee80211_mgd_quiesce(struct ieee80
 
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


