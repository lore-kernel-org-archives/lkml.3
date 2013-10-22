Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3JVUMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 16:12:00 -0400
Received: from packetmixer.de ([83.151.30.3]:51973 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab3JVUL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 16:11:58 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Dirk Gouders <dirk@gouders.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3.12] cfg80211: fix ibss wext chandef creation
Date: Tue, 22 Oct 2013 22:02:46 +0200
Message-Id: <1382472166-19563-1-git-send-email-sw@simonwunderlich.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wext internal chandefs for ibss should be created using the
cfg80211_chandef_create() functions. Otherwise the center_freq1 field
will not be set and cfg80211_chandef_valid() will spit a warning and
report the chandef as invalid when it should be used.

Reported-by: Dirk Gouders <dirk@gouders.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ibss.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 39bff7d..a710019 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -246,7 +246,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 	/* try to find an IBSS channel if none requested ... */
 	if (!wdev->wext.ibss.chandef.chan) {
-		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		struct ieee80211_channel *new_chan = NULL;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
@@ -262,16 +262,19 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 					continue;
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
-				wdev->wext.ibss.chandef.chan = chan;
+				new_chan = chan;
 				break;
 			}
 
-			if (wdev->wext.ibss.chandef.chan)
+			if (new_chan)
 				break;
 		}
 
-		if (!wdev->wext.ibss.chandef.chan)
+		if (!new_chan)
 			return -EINVAL;
+
+		cfg80211_chandef_create(&wdev->wext.ibss.chandef, new_chan,
+					NL80211_CHAN_NO_HT);
 	}
 
 	/* don't join -- SSID is not there */
@@ -345,8 +348,8 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 		return err;
 
 	if (chan) {
-		wdev->wext.ibss.chandef.chan = chan;
-		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		cfg80211_chandef_create(&wdev->wext.ibss.chandef, chan,
+					NL80211_CHAN_NO_HT);
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
-- 
1.7.10.4

