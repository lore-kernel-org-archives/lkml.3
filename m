Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3BANKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:10:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:44740 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473Ab3BANKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:10:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 32/89] mac80211: synchronize scan off/on-channel and PS states
Date: Fri,  1 Feb 2013 14:07:47 +0100
Message-Id: <20130201130209.809912787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ieee80211_i.h |    6 ++----
 net/mac80211/offchannel.c  |   19 +++++++------------
 net/mac80211/scan.c        |   15 +++++----------
 3 files changed, 14 insertions(+), 26 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1279,10 +1279,8 @@ int ieee80211_request_sched_scan_stop(st
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable);
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable);
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
+void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
 void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -102,8 +102,7 @@ static void ieee80211_offchannel_ps_disa
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
-				    bool offchannel_ps_enable)
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -131,8 +130,7 @@ void ieee80211_offchannel_stop_vifs(stru
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
-			if (offchannel_ps_enable &&
-			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
+			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
 		}
@@ -140,8 +138,7 @@ void ieee80211_offchannel_stop_vifs(stru
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool offchannel_ps_disable)
+void ieee80211_offchannel_return(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -157,11 +154,9 @@ void ieee80211_offchannel_return(struct
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
@@ -381,7 +376,7 @@ void ieee80211_sw_roc_work(struct work_s
 			local->tmp_channel = NULL;
 			ieee80211_hw_config(local, 0);
 
-			ieee80211_offchannel_return(local, true);
+			ieee80211_offchannel_return(local);
 		}
 
 		ieee80211_recalc_idle(local);
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -310,7 +310,7 @@ static void __ieee80211_scan_completed(s
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		ieee80211_offchannel_return(local);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -355,7 +355,7 @@ static int ieee80211_start_sw_scan(struc
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	ieee80211_offchannel_stop_vifs(local, true);
+	ieee80211_offchannel_stop_vifs(local);
 
 	ieee80211_configure_filter(local);
 
@@ -680,12 +680,8 @@ static void ieee80211_scan_state_suspend
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
@@ -695,8 +691,7 @@ static void ieee80211_scan_state_suspend
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	/* PS already is in off-channel mode */
-	ieee80211_offchannel_stop_vifs(local, false);
+	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
 		drv_flush(local, false);


