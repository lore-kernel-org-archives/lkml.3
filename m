Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3AXD2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:28:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3AXD16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:27:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 05/74] mac80211: fix ibss scanning
Date: Thu, 24 Jan 2013 01:26:17 -0200
Message-Id: <1358998046-613-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/ibss.c        |    9 ++++-----
 net/mac80211/ieee80211_i.h |    6 +++---
 net/mac80211/scan.c        |   34 ++++++++++++++++++++++++----------
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 980b4f4..374d5b4 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -665,8 +665,8 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->name);
 
-	ieee80211_request_internal_scan(sdata,
-			ifibss->ssid, ifibss->ssid_len, NULL);
+	ieee80211_request_ibss_scan(sdata, ifibss->ssid, ifibss->ssid_len,
+				    NULL);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -773,9 +773,8 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->name);
 
-		ieee80211_request_internal_scan(sdata,
-				ifibss->ssid, ifibss->ssid_len,
-				ifibss->fixed_channel ? ifibss->channel : NULL);
+		ieee80211_request_ibss_scan(sdata, ifibss->ssid,
+					    ifibss->ssid_len, chan);
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 98dab42..d0b1c56 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1257,9 +1257,9 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
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
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 169da07..fd973e5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -817,9 +817,9 @@ int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
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
@@ -833,22 +833,36 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 
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
-- 
1.7.9.5

