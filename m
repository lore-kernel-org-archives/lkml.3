Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaBKSgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:36:54 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58913 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaBKSgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:36:52 -0500
Date: Tue, 11 Feb 2014 12:36:24 -0600
From: Calvin Owens <jcalvinowens@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcalvinowens@gmail.com
Subject: [PATCH v4] ieee80211: Print human-readable disassoc/deauth reason
 codes
Message-ID: <20140211183624.GA2291@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
 <1391661863.30094.56.camel@joe-AO722>
 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
 <1392050359.2507.10.camel@joe-AO722>
 <20140211012523.GA2739@gmail.com>
 <1392082740.2507.49.camel@joe-AO722>
 <20140211163738.GA32043@gmail.com>
 <1392138837.2511.2.camel@joe-AO722>
 <20140211175232.GA782@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140211175232.GA782@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a function to return a descriptive string for each reason code,
and print that in addition to the numeric value in the kernel log. These
codes are easily found on popular search engines, but one is generally
not able to access the internet when dealing with wireless connectivity
issues.

Changes in v2: Refactored array of strings into switch statement.
Changes in v3: Fix style problem, use simplifying macro for switch
statement, eliminate temporary enum variable.
Changes in v4: Move new function to net/mac80211/mlme.c and make it
static, since all of its callers are there.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 net/mac80211/mlme.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 62 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fc1d824..0586d12 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2210,6 +2210,62 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	/* ignore frame -- wait for timeout */
 }
 
+#define case_WLAN(type) \
+	case WLAN_REASON_##type: return #type
+
+static const char *ieee80211_get_reason_code_string(u16 reason_code)
+{
+	switch (reason_code) {
+	case_WLAN(UNSPECIFIED);
+	case_WLAN(PREV_AUTH_NOT_VALID);
+	case_WLAN(DEAUTH_LEAVING);
+	case_WLAN(DISASSOC_DUE_TO_INACTIVITY);
+	case_WLAN(DISASSOC_AP_BUSY);
+	case_WLAN(CLASS2_FRAME_FROM_NONAUTH_STA);
+	case_WLAN(CLASS3_FRAME_FROM_NONASSOC_STA);
+	case_WLAN(DISASSOC_STA_HAS_LEFT);
+	case_WLAN(STA_REQ_ASSOC_WITHOUT_AUTH);
+	case_WLAN(DISASSOC_BAD_POWER);
+	case_WLAN(DISASSOC_BAD_SUPP_CHAN);
+	case_WLAN(INVALID_IE);
+	case_WLAN(MIC_FAILURE);
+	case_WLAN(4WAY_HANDSHAKE_TIMEOUT);
+	case_WLAN(GROUP_KEY_HANDSHAKE_TIMEOUT);
+	case_WLAN(IE_DIFFERENT);
+	case_WLAN(INVALID_GROUP_CIPHER);
+	case_WLAN(INVALID_PAIRWISE_CIPHER);
+	case_WLAN(INVALID_AKMP);
+	case_WLAN(UNSUPP_RSN_VERSION);
+	case_WLAN(INVALID_RSN_IE_CAP);
+	case_WLAN(IEEE8021X_FAILED);
+	case_WLAN(CIPHER_SUITE_REJECTED);
+	case_WLAN(DISASSOC_UNSPECIFIED_QOS);
+	case_WLAN(DISASSOC_QAP_NO_BANDWIDTH);
+	case_WLAN(DISASSOC_LOW_ACK);
+	case_WLAN(DISASSOC_QAP_EXCEED_TXOP);
+	case_WLAN(QSTA_LEAVE_QBSS);
+	case_WLAN(QSTA_NOT_USE);
+	case_WLAN(QSTA_REQUIRE_SETUP);
+	case_WLAN(QSTA_TIMEOUT);
+	case_WLAN(QSTA_CIPHER_NOT_SUPP);
+	case_WLAN(MESH_PEER_CANCELED);
+	case_WLAN(MESH_MAX_PEERS);
+	case_WLAN(MESH_CONFIG);
+	case_WLAN(MESH_CLOSE);
+	case_WLAN(MESH_MAX_RETRIES);
+	case_WLAN(MESH_CONFIRM_TIMEOUT);
+	case_WLAN(MESH_INVALID_GTK);
+	case_WLAN(MESH_INCONSISTENT_PARAM);
+	case_WLAN(MESH_INVALID_SECURITY);
+	case_WLAN(MESH_PATH_ERROR);
+	case_WLAN(MESH_PATH_NOFORWARD);
+	case_WLAN(MESH_PATH_DEST_UNREACHABLE);
+	case_WLAN(MAC_EXISTS_IN_MBSS);
+	case_WLAN(MESH_CHAN_REGULATORY);
+	case_WLAN(MESH_CHAN);
+	default: return "<INVALID>";
+	}
+}
 
 static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
@@ -2231,8 +2287,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
-		   bssid, reason_code);
+	sdata_info(sdata, "deauthenticated from %pM (Reason: %u=%s)\n",
+		   bssid, reason_code, ieee80211_get_reason_code_string(reason_code));
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
@@ -4301,8 +4357,8 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	bool report_frame = false;
 
 	sdata_info(sdata,
-		   "deauthenticating from %pM by local choice (reason=%d)\n",
-		   req->bssid, req->reason_code);
+		   "deauthenticating from %pM by local choice (Reason: %u=%s)\n",
+		   req->bssid, req->reason_code, ieee80211_get_reason_code_string(req->reason_code));
 
 	if (ifmgd->auth_data) {
 		drv_mgd_prepare_tx(sdata->local, sdata);
@@ -4348,8 +4404,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 		return -ENOLINK;
 
 	sdata_info(sdata,
-		   "disassociating from %pM by local choice (reason=%d)\n",
-		   req->bss->bssid, req->reason_code);
+		   "disassociating from %pM by local choice (Reason: %u=%s)\n",
+		   req->bss->bssid, req->reason_code, ieee80211_get_reason_code_string(req->reason_code));
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DISASSOC,
-- 
1.8.5.3

