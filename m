Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab3EGEdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:33:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3EGEZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:53 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QFDi8flBTgoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OrOGHe8RdBwA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=lzdrcP_YQHiFFln23_oA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=udt71jF_dmbvKIan:21 a=xo0A-KAgdZ-koK3I:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035854.129186966@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anders Kaseorg <andersk@mit.edu>, Johannes Berg <johannes.berg@intel.com>
Subject: [079/126] mac80211: fix cfg80211 interaction on auth/assoc request
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0079-mac80211-fix-cfg80211-interaction-on-auth-assoc-requ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b119dc06d871405fc7c3e9a73a6c987409ba639 ]

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

Cc: stable@vger.kernel.org
Reported-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/mlme.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b71d466..38727ef 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3237,8 +3237,16 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	/* prep auth_data so we don't go into idle on disassoc */
 	ifmgd->auth_data = auth_data;
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[DEAUTH_DISASSOC_LEN];
+
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_UNSPECIFIED,
+				       false, frame_buf);
+
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       sizeof(frame_buf));
+	}
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
@@ -3290,8 +3298,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	if (ifmgd->associated) {
+		u8 frame_buf[DEAUTH_DISASSOC_LEN];
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
-- 
1.7.10.4


