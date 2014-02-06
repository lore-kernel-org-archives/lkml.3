Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaBFBpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:45:18 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48060 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaBFBpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:45:16 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Calvin Owens" <jcalvinowens@gmail.com>
Subject: [PATCH] ieee80211: Print human-readable disassoc/deauth reason codes
Date: Wed,  5 Feb 2014 19:44:48 -0600
Message-Id: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a function to return a descriptive string for each reason code,
and print that instead of the numeric value in the kernel log. These
codes are easily found on popular search engines, but one is generally
not able to access the internet when dealing with wireless connectivity
issues.

On x86_64, this patch only enlarges the kernel binary by 489 bytes.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 include/net/mac80211.h | 11 +++++++++
 net/mac80211/main.c    | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mlme.c    | 12 ++++-----
 3 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f4ab2fb..5983b25 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2973,6 +2973,17 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops);
 
 /**
+ * ieee80211_get_reason_code_string - Get human readable reason code
+ *
+ * This function returns a string describing the @reason_code.
+ *
+ * @reason_code: Reason code we want a human readable string for
+ *
+ * Return: Human readable reason string, or "(INVALID)"
+ */
+const char *ieee80211_get_reason_code_string(u16 reason_code);
+
+/**
  * ieee80211_register_hw - Register hardware device
  *
  * You must call this function before any other functions in
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d767cfb..a1eb3ab 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -743,6 +743,72 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 	return 0;
 }
 
+static const char *reason_code_strings[49] = {
+	"(RESERVED)",
+	"UNSPECIFIED",
+	"PREV_AUTH_NOT_VALID",
+	"DEAUTH_LEAVING",
+	"DISASSOC_DUE_TO_INACTIVITY",
+	"DISASSOC_AP_BUSY",
+	"CLASS2_FRAME_FROM_NONAUTH_STA",
+	"CLASS3_FRAME_FROM_NONASSOC_STA",
+	"DISASSOC_STA_HAS_LEFT",
+	"STA_REQ_ASSOC_WITHOUT_AUTH",
+	"DISASSOC_BAD_POWER",
+	"DISASSOC_BAD_SUPP_CHAN",
+	"(RESERVED)",
+	"INVALID_IE",
+	"MIC_FAILURE",
+	"4WAY_HANDSHAKE_TIMEOUT",
+	"GROUP_KEY_HANDSHAKE_TIMEOUT",
+	"IE_DIFFERENT",
+	"INVALID_GROUP_CIPHER",
+	"INVALID_PAIRWISE_CIPHER",
+	"INVALID_AKMP",
+	"UNSUPP_RSN_VERSION",
+	"INVALID_RSN_IE_CAP",
+	"IEEE8021X_FAILED",
+	"CIPHER_SUITE_REJECTED", /* 24 */
+	"DISASSOC_UNSPECIFIED_QOS", /* 32 (25) */
+	"DISASSOC_QAP_NO_BANDWIDTH",
+	"DISASSOC_LOW_ACK",
+	"DISASSOC_QAP_EXCEED_TXOP",
+	"QSTA_LEAVE_QBSS",
+	"QSTA_NOT_USE",
+	"QSTA_REQUIRE_SETUP",
+	"QSTA_TIMEOUT",
+	"QSTA_CIPHER_NOT_SUPP", /* 45 (33) */
+	"MESH_PEER_CANCELED", /* 52 (34) */
+	"MESH_MAX_PEERS",
+	"MESH_CONFIG",
+	"MESH_CLOSE",
+	"MESH_MAX_RETRIES",
+	"MESH_CONFIRM_TIMEOUT",
+	"MESH_INVALID_GTK",
+	"MESH_INCONSISTENT_PARAM",
+	"MESH_INVALID_SECURITY",
+	"MESH_PATH_ERROR",
+	"MESH_PATH_NOFORWARD",
+	"MESH_PATH_DEST_UNREACHABLE",
+	"MAC_EXISTS_IN_MBSS",
+	"MESH_CHAN_REGULATORY",
+	"MESH_CHAN" /* 66 (48) */
+};
+
+const char *ieee80211_get_reason_code_string(u16 reason_code)
+{
+	if (reason_code <= 24)
+		return reason_code_strings[reason_code];
+	else if (reason_code >= 32 && reason_code <= 39)
+		return reason_code_strings[reason_code - 7];
+	else if (reason_code == 45)
+		return reason_code_strings[33];
+	else if (reason_code >= 52 && reason_code <= 66)
+		return reason_code_strings[reason_code - 18];
+	else
+		return "(INVALID)";
+}
+
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fc1d824..74e4585 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2231,8 +2231,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
-		   bssid, reason_code);
+	sdata_info(sdata, "deauthenticated from %pM (reason: %s)\n",
+		   bssid, ieee80211_get_reason_code_string(reason_code));
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
@@ -4301,8 +4301,8 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	bool report_frame = false;
 
 	sdata_info(sdata,
-		   "deauthenticating from %pM by local choice (reason=%d)\n",
-		   req->bssid, req->reason_code);
+		   "deauthenticating from %pM by local choice (reason: %s)\n",
+		   req->bssid, ieee80211_get_reason_code_string(req->reason_code));
 
 	if (ifmgd->auth_data) {
 		drv_mgd_prepare_tx(sdata->local, sdata);
@@ -4348,8 +4348,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 		return -ENOLINK;
 
 	sdata_info(sdata,
-		   "disassociating from %pM by local choice (reason=%d)\n",
-		   req->bss->bssid, req->reason_code);
+		   "disassociating from %pM by local choice (reason: %s)\n",
+		   req->bss->bssid, ieee80211_get_reason_code_string(req->reason_code));
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
 	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DISASSOC,
-- 
1.8.5.3

