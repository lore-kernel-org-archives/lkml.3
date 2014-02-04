Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936446AbaBDW5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:57:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163AbaBDVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 033/104] rtlwifi: Add missing code to PWDB statics routine
Date: Tue,  4 Feb 2014 13:01:36 -0800
Message-Id: <20140204210223.673479935@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit d82403a9f407217b6aed5260aa92a120e8e98310 upstream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/stats.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/wireless/rtlwifi/stats.c
+++ b/drivers/net/wireless/rtlwifi/stats.c
@@ -176,6 +176,7 @@ static void rtl_process_pwdb(struct ieee
 	struct rtl_sta_info *drv_priv = NULL;
 	struct ieee80211_sta *sta = NULL;
 	long undec_sm_pwdb;
+	long undec_sm_cck;
 
 	rcu_read_lock();
 	if (rtlpriv->mac80211.opmode != NL80211_IFTYPE_STATION)
@@ -185,12 +186,16 @@ static void rtl_process_pwdb(struct ieee
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
@@ -200,6 +205,15 @@ static void rtl_process_pwdb(struct ieee
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


