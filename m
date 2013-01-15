Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab3AOXjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:39:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:46358 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933362Ab3AOWvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:51:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jesse Kahtava <jesse_kahtava@f-m.fm>,
        Mikko Rapeli <mikko.rapeli@iki.fi>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 087/171] mac80211: fix ibss scanning
Date: Tue, 15 Jan 2013 14:44:12 -0800
Message-Id: <20130115224319.665015971@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 34bcf71502413f8903ade93746f2d0f04b937a78 upstream.

Do not scan on no-IBSS and disabled channels in IBSS mode. Doing this
can trigger Microcode errors on iwlwifi and iwlegacy drivers.

Also rename ieee80211_request_internal_scan() function since it is only
used in IBSS mode and simplify calling it from ieee80211_sta_find_ibss().

This patch should address:
https://bugzilla.redhat.com/show_bug.cgi?id=883414
https://bugzilla.kernel.org/show_bug.cgi?id=49411

Reported-by: Jesse Kahtava <jesse_kahtava@f-m.fm>
Reported-by: Mikko Rapeli  <mikko.rapeli@iki.fi>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ibss.c        |    9 ++++-----
 net/mac80211/ieee80211_i.h |    6 +++---
 net/mac80211/scan.c        |   34 ++++++++++++++++++++++++----------
 3 files changed, 31 insertions(+), 18 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -664,8 +664,8 @@ static void ieee80211_sta_merge_ibss(str
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->name);
 
-	ieee80211_request_internal_scan(sdata,
-			ifibss->ssid, ifibss->ssid_len, NULL);
+	ieee80211_request_ibss_scan(sdata, ifibss->ssid, ifibss->ssid_len,
+				    NULL);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -772,9 +772,8 @@ static void ieee80211_sta_find_ibss(stru
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->name);
 
-		ieee80211_request_internal_scan(sdata,
-				ifibss->ssid, ifibss->ssid_len,
-				ifibss->fixed_channel ? ifibss->channel : NULL);
+		ieee80211_request_ibss_scan(sdata, ifibss->ssid,
+					    ifibss->ssid_len, chan);
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1233,9 +1233,9 @@ void ieee80211_mesh_rx_queued_mgmt(struc
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
-int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
-				    const u8 *ssid, u8 ssid_len,
-				    struct ieee80211_channel *chan);
+int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
+				const u8 *ssid, u8 ssid_len,
+				struct ieee80211_channel *chan);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 void ieee80211_scan_cancel(struct ieee80211_local *local);
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -761,9 +761,9 @@ int ieee80211_request_scan(struct ieee80
 	return res;
 }
 
-int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
-				    const u8 *ssid, u8 ssid_len,
-				    struct ieee80211_channel *chan)
+int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
+				const u8 *ssid, u8 ssid_len,
+				struct ieee80211_channel *chan)
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret = -EBUSY;
@@ -777,22 +777,36 @@ int ieee80211_request_internal_scan(stru
 
 	/* fill internal scan request */
 	if (!chan) {
-		int i, nchan = 0;
+		int i, max_n;
+		int n_ch = 0;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			if (!local->hw.wiphy->bands[band])
 				continue;
-			for (i = 0;
-			     i < local->hw.wiphy->bands[band]->n_channels;
-			     i++) {
-				local->int_scan_req->channels[nchan] =
+
+			max_n = local->hw.wiphy->bands[band]->n_channels;
+			for (i = 0; i < max_n; i++) {
+				struct ieee80211_channel *tmp_ch =
 				    &local->hw.wiphy->bands[band]->channels[i];
-				nchan++;
+
+				if (tmp_ch->flags & (IEEE80211_CHAN_NO_IBSS |
+						     IEEE80211_CHAN_DISABLED))
+					continue;
+
+				local->int_scan_req->channels[n_ch] = tmp_ch;
+				n_ch++;
 			}
 		}
 
-		local->int_scan_req->n_channels = nchan;
+		if (WARN_ON_ONCE(n_ch == 0))
+			goto unlock;
+
+		local->int_scan_req->n_channels = n_ch;
 	} else {
+		if (WARN_ON_ONCE(chan->flags & (IEEE80211_CHAN_NO_IBSS |
+						IEEE80211_CHAN_DISABLED)))
+			goto unlock;
+
 		local->int_scan_req->channels[0] = chan;
 		local->int_scan_req->n_channels = 1;
 	}


