Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbaLBTWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:22:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbaLBTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luciano Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 051/121] mac80211: use secondary channel offset IE also beacons during CSA
Date: Tue,  2 Dec 2014 11:18:50 -0800
Message-Id: <1417548000-1794-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luciano Coelho <luciano.coelho@intel.com>

commit 84469a45a1bedec9918e94ab2f78c5dc0739e4a7 upstream.

If we are switching from an HT40+ to an HT40- channel (or vice-versa),
we need the secondary channel offset IE to specify what is the
post-CSA offset to be used.  This applies both to beacons and to probe
responses.

In ieee80211_parse_ch_switch_ie() we were ignoring this IE from
beacons and using the *current* HT information IE instead.  This was
causing us to use the same offset as before the switch.

Fix that by using the secondary channel offset IE also for beacons and
don't ever use the pre-switch offset.  Additionally, remove the
"beacon" argument from ieee80211_parse_ch_switch_ie(), since it's not
needed anymore.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/mesh.c        |  2 +-
 net/mac80211/mlme.c        |  2 +-
 net/mac80211/spectmgmt.c   | 18 ++++++------------
 5 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 3727941..57ac06f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -809,7 +809,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	memset(&params, 0, sizeof(params));
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
+	err = ieee80211_parse_ch_switch_ie(sdata, elems,
 					   ifibss->chandef.chan->band,
 					   sta_flags, ifibss->bssid, &csa_ie);
 	/* can't switch to destination channel, fail */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 980d863..c0bb6e4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1527,7 +1527,6 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  * ieee80211_parse_ch_switch_ie - parses channel switch IEs
  * @sdata: the sdata of the interface which has received the frame
  * @elems: parsed 802.11 elements received with the frame
- * @beacon: indicates if the frame was a beacon or probe response
  * @current_band: indicates the current band
  * @sta_flags: contains information about own capabilities and restrictions
  *	to decide which channel switch announcements can be accepted. Only the
@@ -1541,7 +1540,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
  */
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
-				 struct ieee802_11_elems *elems, bool beacon,
+				 struct ieee802_11_elems *elems,
 				 enum ieee80211_band current_band,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ba10525..5b2c192 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -882,7 +882,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	memset(&params, 0, sizeof(params));
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, band,
+	err = ieee80211_parse_ch_switch_ie(sdata, elems, band,
 					   sta_flags, sdata->vif.addr,
 					   &csa_ie);
 	if (err < 0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6c126fc..d8824f9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -998,7 +998,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	current_band = cbss->channel->band;
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
+	res = ieee80211_parse_ch_switch_ie(sdata, elems, current_band,
 					   ifmgd->flags,
 					   ifmgd->associated->bssid, &csa_ie);
 	if (res	< 0)
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 6ab0090..efeba56 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -22,7 +22,7 @@
 #include "wme.h"
 
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
-				 struct ieee802_11_elems *elems, bool beacon,
+				 struct ieee802_11_elems *elems,
 				 enum ieee80211_band current_band,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie)
@@ -91,19 +91,13 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 	}
 
-	if (!beacon && sec_chan_offs) {
+	if (sec_chan_offs) {
 		secondary_channel_offset = sec_chan_offs->sec_chan_offs;
-	} else if (beacon && ht_oper) {
-		secondary_channel_offset =
-			ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
 	} else if (!(sta_flags & IEEE80211_STA_DISABLE_HT)) {
-		/* If it's not a beacon, HT is enabled and the IE not present,
-		 * it's 20 MHz, 802.11-2012 8.5.2.6:
-		 *	This element [the Secondary Channel Offset Element] is
-		 *	present when switching to a 40 MHz channel. It may be
-		 *	present when switching to a 20 MHz channel (in which
-		 *	case the secondary channel offset is set to SCN).
-		 */
+		/* If the secondary channel offset IE is not present,
+		 * we can't know what's the post-CSA offset, so the
+		 * best we can do is use 20MHz.
+		*/
 		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 	}
 
-- 
1.9.1

