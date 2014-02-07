Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaBGLso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41613 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBGLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/233] rtlwifi: Redo register save locations
Date: Fri,  7 Feb 2014 11:44:26 +0000
Message-Id: <1391773652-25214-48-git-send-email-luis.henriques@canonical.com>
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

commit b9a758a8c905fc59e783ae91ad645452d877ea88 upstream.

The initial USB driver did not use some register save locations in the
private data storage. To save some memory, a union was used to overlay these
variables with USB I/O components. In an update of the gain-control code,
these register save locations are now needed for USB drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/wifi.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 224cf61..e576a927 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1035,6 +1035,7 @@ struct rtl_ht_agg {
 
 struct rssi_sta {
 	long undec_sm_pwdb;
+	long undec_sm_cck;
 };
 
 struct rtl_tid_data {
@@ -1325,8 +1326,10 @@ struct fast_ant_training {
 struct rtl_dm {
 	/*PHY status for Dynamic Management */
 	long entry_min_undec_sm_pwdb;
+	long undec_sm_cck;
 	long undec_sm_pwdb;	/*out dm */
 	long entry_max_undec_sm_pwdb;
+	s32 ofdm_pkt_cnt;
 	bool dm_initialgain_enable;
 	bool dynamic_txpower_enable;
 	bool current_turbo_edca;
@@ -1341,6 +1344,7 @@ struct rtl_dm {
 	bool inform_fw_driverctrldm;
 	bool current_mrc_switch;
 	u8 txpowercount;
+	u8 powerindex_backup[6];
 
 	u8 thermalvalue_rxgain;
 	u8 thermalvalue_iqk;
@@ -1352,7 +1356,9 @@ struct rtl_dm {
 	bool done_txpower;
 	u8 dynamic_txhighpower_lvl;	/*Tx high power level */
 	u8 dm_flag;		/*Indicate each dynamic mechanism's status. */
+	u8 dm_flag_tmp;
 	u8 dm_type;
+	u8 dm_rssi_sel;
 	u8 txpower_track_control;
 	bool interrupt_migration;
 	bool disable_tx_int;
@@ -1951,6 +1957,7 @@ struct dig_t {
 	u8 pre_ccastate;
 	u8 cur_ccasate;
 	u8 large_fa_hit;
+	u8 dig_dynamic_min;
 	u8 forbidden_igi;
 	u8 dig_state;
 	u8 dig_highpwrstate;
@@ -2031,22 +2038,15 @@ struct rtl_priv {
 	struct dig_t dm_digtable;
 	struct ps_t dm_pstable;
 
-	/* section shared by individual drivers */
-	union {
-		struct {	/* data buffer pointer for USB reads */
-			__le32 *usb_data;
-			int usb_data_index;
-			bool initialized;
-		};
-		struct {	/* section for 8723ae */
-			bool reg_init;	/* true if regs saved */
-			u32 reg_874;
-			u32 reg_c70;
-			u32 reg_85c;
-			u32 reg_a74;
-			bool bt_operation_on;
-		};
-	};
+	u32 reg_874;
+	u32 reg_c70;
+	u32 reg_85c;
+	u32 reg_a74;
+	bool reg_init;	/* true if regs saved */
+	bool bt_operation_on;
+	__le32 *usb_data;
+	int usb_data_index;
+	bool initialized;
 	bool enter_ps;	/* true when entering PS */
 	u8 rate_mask[5];
 
-- 
1.8.3.2

