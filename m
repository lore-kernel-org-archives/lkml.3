Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaITO1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:47 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54154 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaITO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/13] staging: rtl8188eu: Rework function odm_HWAntDiv()
Date: Sat, 20 Sep 2014 19:55:57 +0530
Message-Id: <1411223160-17292-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Rename CamelCase function name and local variables.
 Remove unnecessary debugging messages.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |   78 +++++++++++++-------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 95bcc0a..4e390d9 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -272,53 +272,51 @@ void rtl88eu_dm_ant_sel_statistics(struct odm_dm_struct *dm_odm,
 	}
 }
 
-static void odm_HWAntDiv(struct odm_dm_struct *dm_odm)
+static void rtl88eu_dm_hw_ant_div(struct odm_dm_struct *dm_odm)
 {
-	u32	i, MinRSSI = 0xFF, AntDivMaxRSSI = 0, MaxRSSI = 0, LocalMinRSSI, LocalMaxRSSI;
-	u32	Main_RSSI, Aux_RSSI;
-	u8	RxIdleAnt = 0, TargetAnt = 7;
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
-	struct rtw_dig *pDM_DigTable = &dm_odm->DM_DigTable;
-	struct sta_info *pEntry;
+	struct rtw_dig *dig_table = &dm_odm->DM_DigTable;
+	struct sta_info *entry;
+	u32 i, min_rssi = 0xFF, ant_div_max_rssi = 0, max_rssi = 0;
+	u32 local_min_rssi,local_max_rssi;
+	u32 main_rssi, aux_rssi;
+	u8 RxIdleAnt = 0, target_ant = 7;
 
 	for (i = 0; i < ODM_ASSOCIATE_ENTRY_NUM; i++) {
-		pEntry = dm_odm->pODM_StaInfo[i];
-		if (IS_STA_VALID(pEntry)) {
+		entry = dm_odm->pODM_StaInfo[i];
+		if (IS_STA_VALID(entry)) {
 			/* 2 Caculate RSSI per Antenna */
-			Main_RSSI = (dm_fat_tbl->MainAnt_Cnt[i] != 0) ? (dm_fat_tbl->MainAnt_Sum[i]/dm_fat_tbl->MainAnt_Cnt[i]) : 0;
-			Aux_RSSI = (dm_fat_tbl->AuxAnt_Cnt[i] != 0) ? (dm_fat_tbl->AuxAnt_Sum[i]/dm_fat_tbl->AuxAnt_Cnt[i]) : 0;
-			TargetAnt = (Main_RSSI >= Aux_RSSI) ? MAIN_ANT : AUX_ANT;
-			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
-				     ("MacID=%d, MainAnt_Sum=%d, MainAnt_Cnt=%d\n",
-				     i, dm_fat_tbl->MainAnt_Sum[i],
-				     dm_fat_tbl->MainAnt_Cnt[i]));
-			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
-				     ("MacID=%d, AuxAnt_Sum=%d, AuxAnt_Cnt=%d\n",
-				     i, dm_fat_tbl->AuxAnt_Sum[i], dm_fat_tbl->AuxAnt_Cnt[i]));
-			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
-				     ("MacID=%d, Main_RSSI= %d, Aux_RSSI= %d\n",
-				     i, Main_RSSI, Aux_RSSI));
-			/* 2 Select MaxRSSI for DIG */
-			LocalMaxRSSI = (Main_RSSI > Aux_RSSI) ? Main_RSSI : Aux_RSSI;
-			if ((LocalMaxRSSI > AntDivMaxRSSI) && (LocalMaxRSSI < 40))
-				AntDivMaxRSSI = LocalMaxRSSI;
-			if (LocalMaxRSSI > MaxRSSI)
-				MaxRSSI = LocalMaxRSSI;
+			main_rssi = (dm_fat_tbl->MainAnt_Cnt[i] != 0) ?
+				     (dm_fat_tbl->MainAnt_Sum[i]/dm_fat_tbl->MainAnt_Cnt[i]) : 0;
+			aux_rssi = (dm_fat_tbl->AuxAnt_Cnt[i] != 0) ?
+				    (dm_fat_tbl->AuxAnt_Sum[i]/dm_fat_tbl->AuxAnt_Cnt[i]) : 0;
+			target_ant = (main_rssi >= aux_rssi) ? MAIN_ANT : AUX_ANT;
+			/* 2 Select max_rssi for DIG */
+			local_max_rssi = (main_rssi > aux_rssi) ?
+					  main_rssi : aux_rssi;
+			if ((local_max_rssi > ant_div_max_rssi) &&
+			    (local_max_rssi < 40))
+				ant_div_max_rssi = local_max_rssi;
+			if (local_max_rssi > max_rssi)
+				max_rssi = local_max_rssi;
 
 			/* 2 Select RX Idle Antenna */
-			if ((dm_fat_tbl->RxIdleAnt == MAIN_ANT) && (Main_RSSI == 0))
-				Main_RSSI = Aux_RSSI;
-			else if ((dm_fat_tbl->RxIdleAnt == AUX_ANT) && (Aux_RSSI == 0))
-				Aux_RSSI = Main_RSSI;
-
-			LocalMinRSSI = (Main_RSSI > Aux_RSSI) ? Aux_RSSI : Main_RSSI;
-			if (LocalMinRSSI < MinRSSI) {
-				MinRSSI = LocalMinRSSI;
-				RxIdleAnt = TargetAnt;
+			if ((dm_fat_tbl->RxIdleAnt == MAIN_ANT) &&
+			    (main_rssi == 0))
+				main_rssi = aux_rssi;
+			else if ((dm_fat_tbl->RxIdleAnt == AUX_ANT) &&
+				 (aux_rssi == 0))
+				aux_rssi = main_rssi;
+
+			local_min_rssi = (main_rssi > aux_rssi) ?
+					  aux_rssi : main_rssi;
+			if (local_min_rssi < min_rssi) {
+				min_rssi = local_min_rssi;
+				RxIdleAnt = target_ant;
 			}
 			/* 2 Select TRX Antenna */
 			if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-				update_tx_ant_88eu(dm_odm, TargetAnt, i);
+				update_tx_ant_88eu(dm_odm, target_ant, i);
 		}
 		dm_fat_tbl->MainAnt_Sum[i] = 0;
 		dm_fat_tbl->AuxAnt_Sum[i] = 0;
@@ -329,8 +327,8 @@ static void odm_HWAntDiv(struct odm_dm_struct *dm_odm)
 	/* 2 Set RX Idle Antenna */
 	rtl88eu_dm_update_rx_idle_ant(dm_odm, RxIdleAnt);
 
-	pDM_DigTable->AntDiv_RSSI_max = AntDivMaxRSSI;
-	pDM_DigTable->RSSI_max = MaxRSSI;
+	dig_table->AntDiv_RSSI_max = ant_div_max_rssi;
+	dig_table->RSSI_max = max_rssi;
 }
 
 void ODM_AntennaDiversity_88E(struct odm_dm_struct *dm_odm)
@@ -363,7 +361,7 @@ void ODM_AntennaDiversity_88E(struct odm_dm_struct *dm_odm)
 		}
 	}
 	if ((dm_odm->AntDivType == CG_TRX_HW_ANTDIV) || (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV))
-		odm_HWAntDiv(dm_odm);
+		rtl88eu_dm_hw_ant_div(dm_odm);
 }
 
 /* 3============================================================ */
-- 
1.7.10.4

