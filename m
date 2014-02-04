Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935939AbaBDW36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:29:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588AbaBDVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 031/133] rtlwifi: Redo register save locations
Date: Tue,  4 Feb 2014 13:07:12 -0800
Message-Id: <20140204210737.910112427@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit b9a758a8c905fc59e783ae91ad645452d877ea88 upstream.

The initial USB driver did not use some register save locations in the
private data storage. To save some memory, a union was used to overlay these
variables with USB I/O components. In an update of the gain-control code,
these register save locations are now needed for USB drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/wifi.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

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
 


