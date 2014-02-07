Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaBGLs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41660 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbaBGLsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/233] rtlwifi: Add missing code to PWDB statics routine
Date: Fri,  7 Feb 2014 11:44:34 +0000
Message-Id: <1391773652-25214-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit d82403a9f407217b6aed5260aa92a120e8e98310 upstream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/stats.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/stats.c b/drivers/net/wireless/rtlwifi/stats.c
index 8ed3174..4f083fc 100644
--- a/drivers/net/wireless/rtlwifi/stats.c
+++ b/drivers/net/wireless/rtlwifi/stats.c
@@ -176,6 +176,7 @@ static void rtl_process_pwdb(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
 	struct rtl_sta_info *drv_priv = NULL;
 	struct ieee80211_sta *sta = NULL;
 	long undec_sm_pwdb;
+	long undec_sm_cck;
 
 	rcu_read_lock();
 	if (rtlpriv->mac80211.opmode != NL80211_IFTYPE_STATION)
@@ -185,12 +186,16 @@ static void rtl_process_pwdb(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
 	if (sta) {
 		drv_priv = (struct rtl_sta_info *) sta->drv_priv;
 		undec_sm_pwdb = drv_priv->rssi_stat.undec_sm_pwdb;
+		undec_sm_cck = drv_priv->rssi_stat.undec_sm_cck;
 	} else {
 		undec_sm_pwdb = rtlpriv->dm.undec_sm_pwdb;
+		undec_sm_cck = rtlpriv->dm.undec_sm_cck;
 	}
 
 	if (undec_sm_pwdb < 0)
 		undec_sm_pwdb = pstatus->rx_pwdb_all;
+	if (undec_sm_cck < 0)
+		undec_sm_cck = pstatus->rx_pwdb_all;
 	if (pstatus->rx_pwdb_all > (u32) undec_sm_pwdb) {
 		undec_sm_pwdb = (((undec_sm_pwdb) *
 		      (RX_SMOOTH_FACTOR - 1)) +
@@ -200,6 +205,15 @@ static void rtl_process_pwdb(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
 		undec_sm_pwdb = (((undec_sm_pwdb) * (RX_SMOOTH_FACTOR - 1)) +
 		     (pstatus->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
 	}
+	if (pstatus->rx_pwdb_all > (u32) undec_sm_cck) {
+		undec_sm_cck = (((undec_sm_pwdb) *
+		      (RX_SMOOTH_FACTOR - 1)) +
+		     (pstatus->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+		undec_sm_cck = undec_sm_cck + 1;
+	} else {
+		undec_sm_pwdb = (((undec_sm_cck) * (RX_SMOOTH_FACTOR - 1)) +
+		     (pstatus->rx_pwdb_all)) / (RX_SMOOTH_FACTOR);
+	}
 
 	if (sta) {
 		drv_priv->rssi_stat.undec_sm_pwdb = undec_sm_pwdb;
-- 
1.8.3.2

