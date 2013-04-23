Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3DWVxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:53:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3DWVxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anders Kaseorg <andersk@mit.edu>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 27/42] mac80211: fix cfg80211 interaction on auth/assoc request
Date: Tue, 23 Apr 2013 14:52:25 -0700
Message-Id: <20130423215208.263507544@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7b119dc06d871405fc7c3e9a73a6c987409ba639 upstream.

If authentication (or association with FT) is requested by
userspace, mac80211 currently doesn't tell cfg80211 that it
disconnected from the AP. That leaves inconsistent state:
cfg80211 thinks it's connected while mac80211 thinks it's
not. Typically this won't last long, as soon as mac80211
reports the new association to cfg80211 the old one goes
away. If, however, the new authentication or association
doesn't succeed, then cfg80211 will forever think the old
one still exists and will refuse attempts to authenticate
or associate with the AP it thinks it's connected to.

Anders reported that this leads to it taking a very long
time to reconnect to a network, or never even succeeding.
I tested this with an AP hacked to never respond to auth
frames, and one that works, and with just those two the
system never recovers because one won't work and cfg80211
thinks it's connected to the other so refuses connections
to it.

To fix this, simply make mac80211 tell cfg80211 when it is
no longer connected to the old AP, while authenticating or
associating to a new one.

Reported-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3723,8 +3723,16 @@ int ieee80211_mgd_auth(struct ieee80211_
 	/* prep auth_data so we don't go into idle on disassoc */
 	ifmgd->auth_data = auth_data;
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
@@ -3783,8 +3791,16 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;


