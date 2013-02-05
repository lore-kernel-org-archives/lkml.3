Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3BEWKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48024 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab3BEWKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 42/93] mac80211: synchronize scan off/on-channel and PS states
Date: Tue,  5 Feb 2013 20:06:31 -0200
Message-Id: <1360102042-10732-43-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit aacde9ee45225f7e0b90960f479aef83c66bfdc0 upstream.

Since:

commit b23b025fe246f3acc2988eb6d400df34c27cb8ae
Author: Ben Greear <greearb@candelatech.com>
Date:   Fri Feb 4 11:54:17 2011 -0800

    mac80211: Optimize scans on current operating channel.

we do not disable PS while going back to operational channel (on
ieee80211_scan_state_suspend) and deffer that until scan finish.
But since we are allowed to send frames, we can send a frame to AP
without PM bit set, so disable PS on AP side. Then when we switch
to off-channel (in ieee80211_scan_state_resume) we do not enable PS.
Hence we are off-channel with PS disabled, frames are not buffered
by AP.

To fix remove offchannel_ps_disable argument and always enable PS when
going off-channel and disable it when going on-channel, like it was
before.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: adjust context, and patch extra ieee80211_offchannel_return/
  ieee80211_offchannel_stop_vifs calls in ieee80211_work_work (also
  drop change to ieee80211_sw_roc_work, which didn't exist yet) ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/offchannel.c  |   17 ++++++-----------
 net/mac80211/scan.c        |   15 +++++----------
 net/mac80211/work.c        |    4 ++--
 4 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 16655d6..1d025ca 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1283,10 +1283,8 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable);
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable);
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
+void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
 
 /* interface handling */
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 935aa4b..c22f074 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -103,8 +103,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable)
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -129,8 +128,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
-			if (offchannel_ps_enable &&
-			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
+			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata, true);
 		}
@@ -138,8 +136,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable)
+void ieee80211_offchannel_return(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -152,11 +149,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			continue;
 
 		/* Tell AP we're back */
-		if (offchannel_ps_disable &&
-		    sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.associated)
-				ieee80211_offchannel_ps_disable(sdata);
-		}
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    sdata->u.mgd.associated)
+			ieee80211_offchannel_ps_disable(sdata);
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			/*
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 58ac7d0..bb456ac 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -302,7 +302,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return(local);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -347,7 +347,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	ieee80211_offchannel_stop_vifs(local, true);
+	ieee80211_offchannel_stop_vifs(local);
 
 	ieee80211_configure_filter(local);
 
@@ -666,12 +666,8 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 	local->scan_channel = NULL;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	/*
-	 * Re-enable vifs and beaconing.  Leave PS
-	 * in off-channel state..will put that back
-	 * on-channel at the end of scanning.
-	 */
-	ieee80211_offchannel_return(local, false);
+	/* disable PS */
+	ieee80211_offchannel_return(local);
 
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */
@@ -681,8 +677,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	/* PS already is in off-channel mode */
-	ieee80211_offchannel_stop_vifs(local, false);
+	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
 		drv_flush(local, false);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index b2650a9..67c739c 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -150,7 +150,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		}
 
 		if (!started && !local->tmp_channel) {
-			ieee80211_offchannel_stop_vifs(local, true);
+			ieee80211_offchannel_stop_vifs(local);
 
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
@@ -222,7 +222,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		local->tmp_channel = NULL;
 		ieee80211_hw_config(local, 0);
 
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return(local);
 
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
-- 
1.7.9.5

