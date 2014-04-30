Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbaD3NWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:22:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758864AbaD3NWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:22:32 -0400
From: Jan Moskyto Matejka <mq@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark@einon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH v2] [linux-next] [staging] rtl8821ae: fixed defined-not-used warning
Date: Wed, 30 Apr 2014 15:22:17 +0200
Message-Id: <1398864137-22128-1-git-send-email-mq@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <20140430125120.GG24832@moskyto.dyndns.org>
References: <20140430125120.GG24832@moskyto.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by cleaning up BT_AUTO_REPORT_ONLY_8192E_2ANT
(always set to 0, never used as constant)

halbtc8192e2ant_iswifi_status_changed was called only from the unused code

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
---
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.c  | 43 ----------------------
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.h  |  2 -
 2 files changed, 45 deletions(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
index 81706f4..d238179 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
@@ -503,38 +503,6 @@ static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static bool halbtc8192e2ant_iswifi_status_changed(struct btc_coexist *btcoexist)
-{
-	static bool pre_wifi_busy;
-	static bool pre_under_4way, pre_bt_hson;
-	bool wifi_busy = false, under_4way = false, bt_hson = false;
-	bool wifi_connected = false;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-			   &wifi_connected);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
-			   &under_4way);
-
-	if (wifi_connected) {
-		if (wifi_busy != pre_wifi_busy) {
-			pre_wifi_busy = wifi_busy;
-			return true;
-		}
-		if (under_4way != pre_under_4way) {
-			pre_under_4way = under_4way;
-			return true;
-		}
-		if (bt_hson != pre_bt_hson) {
-			pre_bt_hson = bt_hson;
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -3833,9 +3801,6 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 		   "0x774(lp rx[31:16]/tx[15:0])",
 		   coex_sta->low_priority_rx, coex_sta->low_priority_tx);
 	CL_PRINTF(cli_buf);
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
-	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
-#endif
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -4011,14 +3976,12 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			 * do nothing here. */
 		}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
 		if ((coex_sta->bt_info_ext & BIT4)) {
 			/* BT auto report already enabled, do nothing */
 		} else {
 			halbtc8192e2ant_bt_autoreport(btcoexist, FORCE_EXEC,
 						      true);
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan */
@@ -4148,14 +4111,8 @@ void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist)
 			  "************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
 	halbtc8192e2ant_querybt_info(btcoexist);
 	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
 	halbtc8192e2ant_monitor_bt_enable_disable(btcoexist);
-#else
-	if (halbtc8192e2ant_iswifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust)
-		halbtc8192e2ant_run_coexist_mechanism(btcoexist);
-#endif
 }
 
diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
index 6d109edb..416d3dda 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
@@ -1,8 +1,6 @@
 /*****************************************************************
  *   The following is for 8192E 2Ant BT Co-exist definition
  *****************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8192E_2ANT			0
-
 #define	BT_INFO_8192E_2ANT_B_FTP			BIT7
 #define	BT_INFO_8192E_2ANT_B_A2DP			BIT6
 #define	BT_INFO_8192E_2ANT_B_HID			BIT5
-- 
1.8.4.5

