Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaEBQR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:17:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43855 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaEBPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 080/151] mac80211: fix suspend vs. authentication race
Date: Fri,  2 May 2014 08:37:48 -0700
Message-Id: <1399045139-4531-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 1a1cb744de160ee70086a77afff605bbc275d291 upstream.

Since Stanislaw's patch removing the quiescing code, mac80211 had
a race regarding suspend vs. authentication: as cfg80211 doesn't
track authentication attempts, it can't abort them. Therefore the
attempts may be kept running while suspending, which can lead to
all kinds of issues, in at least some cases causing an error in
iwlmvm firmware.

Fix this by aborting the authentication attempt when suspending.

Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 26 ++++++++++++++++++++++++++
 net/mac80211/pm.c          | 14 +++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4aea4e7..1fc9190 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1346,6 +1346,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 				  __le16 fc, bool acked);
+void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 90ee798..4eef5fd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3487,6 +3487,32 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 }
 
 #ifdef CONFIG_PM
+void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+	sdata_lock(sdata);
+
+	if (ifmgd->auth_data) {
+		/*
+		 * If we are trying to authenticate while suspending, cfg80211
+		 * won't know and won't actually abort those attempts, thus we
+		 * need to do that ourselves.
+		 */
+		ieee80211_send_deauth_disassoc(sdata,
+					       ifmgd->auth_data->bss->bssid,
+					       IEEE80211_STYPE_DEAUTH,
+					       WLAN_REASON_DEAUTH_LEAVING,
+					       false, frame_buf);
+		ieee80211_destroy_auth_data(sdata, false);
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+				      IEEE80211_DEAUTH_FRAME_LEN);
+	}
+
+	sdata_unlock(sdata);
+}
+
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 3401262..efb510e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -101,10 +101,18 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces that were created in the driver */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata) ||
-		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		    sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		if (!ieee80211_sdata_running(sdata))
 			continue;
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			continue;
+		case NL80211_IFTYPE_STATION:
+			ieee80211_mgd_quiesce(sdata);
+			break;
+		default:
+			break;
+		}
 
 		drv_remove_interface(local, sdata);
 	}
-- 
1.9.1

