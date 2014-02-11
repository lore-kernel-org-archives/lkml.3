Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaBKBZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:25:55 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62492 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaBKBZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:25:52 -0500
Date: Mon, 10 Feb 2014 19:25:23 -0600
From: Calvin Owens <jcalvinowens@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>, Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcalvinowens@gmail.com
Subject: [PATCH v2] ieee80211: Print human-readable disassoc/deauth reason
 codes
Message-ID: <20140211012523.GA2739@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
 <1391661863.30094.56.camel@joe-AO722>
 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
 <1392050359.2507.10.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392050359.2507.10.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a function to return a descriptive string for each reason code,
and print that instead of the numeric value in the kernel log. These
codes are easily found on popular search engines, but one is generally
not able to access the internet when dealing with wireless connectivity
issues.

Changes since v1: Refactored array of strings into switch statement,
print numeric code in addition to string.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 include/net/mac80211.h | 10 +++++++++
 net/mac80211/main.c    | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mlme.c    | 12 +++++------
 3 files changed, 71 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4ab2fb..d18acfe 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2971,6 +2971,16 @@ struct ieee80211_ops {
  */
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops);
+/**
+ * ieee80211_get_reason_code_string - Get human readable reason code
+ *
+ * This function returns a string describing the @reason_code.
+ *
+ * @reason_code: Reason code
+ *
+ * Return: Human readable reason string, or "<INVALID>"
+ */
+const char *ieee80211_get_reason_code_string(u16 reason_code);
 
 /**
  * ieee80211_register_hw - Register hardware device
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d767cfb..3c52a81 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -743,6 +743,61 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 	return 0;
 }
 
+const char *ieee80211_get_reason_code_string(u16 reason_code)
+{
+	enum ieee80211_reasoncode r = reason_code;
+	switch(r) {
+	case WLAN_REASON_UNSPECIFIED: return "UNSPECIFIED";
+	case WLAN_REASON_PREV_AUTH_NOT_VALID: return "PREV_AUTH_NOT_VALID";
+	case WLAN_REASON_DEAUTH_LEAVING: return "DEAUTH_LEAVING";
+	case WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY: return "DISASSOC_DUE_TO_INACTIVITY";
+	case WLAN_REASON_DISASSOC_AP_BUSY: return "DISASSOC_AP_BUSY";
+	case WLAN_REASON_CLASS2_FRAME_FROM_NONAUTH_STA: return "CLASS2_FRAME_FROM_NONAUTH_STA";
+	case WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA: return "CLASS3_FRAME_FROM_NONASSOC_STA";
+	case WLAN_REASON_DISASSOC_STA_HAS_LEFT: return "DISASSOC_STA_HAS_LEFT";
+	case WLAN_REASON_STA_REQ_ASSOC_WITHOUT_AUTH: return "STA_REQ_ASSOC_WITHOUT_AUTH";
+	case WLAN_REASON_DISASSOC_BAD_POWER: return "DISASSOC_BAD_POWER";
+	case WLAN_REASON_DISASSOC_BAD_SUPP_CHAN: return "DISASSOC_BAD_SUPP_CHAN";
+	case WLAN_REASON_INVALID_IE: return "INVALID_IE";
+	case WLAN_REASON_MIC_FAILURE: return "MIC_FAILURE";
+	case WLAN_REASON_4WAY_HANDSHAKE_TIMEOUT: return "4WAY_HANDSHAKE_TIMEOUT";
+	case WLAN_REASON_GROUP_KEY_HANDSHAKE_TIMEOUT: return "GROUP_KEY_HANDSHAKE_TIMEOUT";
+	case WLAN_REASON_IE_DIFFERENT: return "IE_DIFFERENT";
+	case WLAN_REASON_INVALID_GROUP_CIPHER: return "INVALID_GROUP_CIPHER";
+	case WLAN_REASON_INVALID_PAIRWISE_CIPHER: return "INVALID_PAIRWISE_CIPHER";
+	case WLAN_REASON_INVALID_AKMP: return "INVALID_AKMP";
+	case WLAN_REASON_UNSUPP_RSN_VERSION: return "UNSUPP_RSN_VERSION";
+	case WLAN_REASON_INVALID_RSN_IE_CAP: return "INVALID_RSN_IE_CAP";
+	case WLAN_REASON_IEEE8021X_FAILED: return "IEEE8021X_FAILED";
+	case WLAN_REASON_CIPHER_SUITE_REJECTED: return "CIPHER_SUITE_REJECTED";
+	case WLAN_REASON_DISASSOC_UNSPECIFIED_QOS: return "DISASSOC_UNSPECIFIED_QOS";
+	case WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH: return "DISASSOC_QAP_NO_BANDWIDTH";
+	case WLAN_REASON_DISASSOC_LOW_ACK: return "DISASSOC_LOW_ACK";
+	case WLAN_REASON_DISASSOC_QAP_EXCEED_TXOP: return "DISASSOC_QAP_EXCEED_TXOP";
+	case WLAN_REASON_QSTA_LEAVE_QBSS: return "QSTA_LEAVE_QBSS";
+	case WLAN_REASON_QSTA_NOT_USE: return "QSTA_NOT_USE";
+	case WLAN_REASON_QSTA_REQUIRE_SETUP: return "QSTA_REQUIRE_SETUP";
+	case WLAN_REASON_QSTA_TIMEOUT: return "QSTA_TIMEOUT";
+	case WLAN_REASON_QSTA_CIPHER_NOT_SUPP: return "QSTA_CIPHER_NOT_SUPP";
+	case WLAN_REASON_MESH_PEER_CANCELED: return "MESH_PEER_CANCELED";
+	case WLAN_REASON_MESH_MAX_PEERS: return "MESH_MAX_PEERS";
+	case WLAN_REASON_MESH_CONFIG: return "MESH_CONFIG";
+	case WLAN_REASON_MESH_CLOSE: return "MESH_CLOSE";
+	case WLAN_REASON_MESH_MAX_RETRIES: return "MESH_MAX_RETRIES";
+	case WLAN_REASON_MESH_CONFIRM_TIMEOUT: return "MESH_CONFIRM_TIMEOUT";
+	case WLAN_REASON_MESH_INVALID_GTK: return "MESH_INVALID_GTK";
+	case WLAN_REASON_MESH_INCONSISTENT_PARAM: return "MESH_INCONSISTENT_PARAM";
+	case WLAN_REASON_MESH_INVALID_SECURITY: return "MESH_INVALID_SECURITY";
+	case WLAN_REASON_MESH_PATH_ERROR: return "MESH_PATH_ERROR";
+	case WLAN_REASON_MESH_PATH_NOFORWARD: return "MESH_PATH_NOFORWARD";
+	case WLAN_REASON_MESH_PATH_DEST_UNREACHABLE: return "MESH_PATH_DEST_UNREACHABLE";
+	case WLAN_REASON_MAC_EXISTS_IN_MBSS: return "MAC_EXISTS_IN_MBSS";
+	case WLAN_REASON_MESH_CHAN_REGULATORY: return "MESH_CHAN_REGULATORY";
+	case WLAN_REASON_MESH_CHAN: return "MESH_CHAN";
+	default: return "<INVALID>";
+	}
+}
+
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fc1d824..5dec202 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2231,8 +2231,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
-		   bssid, reason_code);
+	sdata_info(sdata, "deauthenticated from %pM (Reason: %u=%s)\n",
+		   bssid, reason_code, ieee80211_get_reason_code_string(reason_code));
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
@@ -4301,8 +4301,8 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	bool report_frame = false;
 
 	sdata_info(sdata,
-		   "deauthenticating from %pM by local choice (reason=%d)\n",
-		   req->bssid, req->reason_code);
+		   "deauthenticating from %pM by local choice (Reason: %u=%s)\n",
+		   req->bssid, req->reason_code, ieee80211_get_reason_code_string(req->reason_code));
 
 	if (ifmgd->auth_data) {
 		drv_mgd_prepare_tx(sdata->local, sdata);
@@ -4348,8 +4348,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
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

