Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaHJOp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:45:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60915 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHJOpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:45:23 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/22] staging: rtl8188eu: Cleanup and simplify RF configuration code
Date: Sun, 10 Aug 2014 20:14:16 +0530
Message-Id: <1407681875-2611-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup and consolidate RF configuration related code in
HalHWImg8188E_RF.c file.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |  269 ++++++++++++--------
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |   14 -
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |    9 -
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |   96 -------
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   10 +-
 .../staging/rtl8188eu/include/HalHWImg8188E_RF.h   |   30 ---
 drivers/staging/rtl8188eu/include/odm_HWConfig.h   |    4 -
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    1 -
 drivers/staging/rtl8188eu/include/phy.h            |    1 +
 drivers/staging/rtl8188eu/include/rtl8188e_rf.h    |    1 -
 10 files changed, 161 insertions(+), 274 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_RF.h

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
index 17c6411..2648840 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
@@ -20,38 +20,36 @@
 
 #include "odm_precomp.h"
 
-#include <rtw_iol.h>
+#include <phy.h>
 
-static bool CheckCondition(const u32  Condition, const u32  Hex)
+static bool check_condition(struct adapter *adapt, const u32  condition)
 {
-	u32 _board     = (Hex & 0x000000FF);
-	u32 _interface = (Hex & 0x0000FF00) >> 8;
-	u32 _platform  = (Hex & 0x00FF0000) >> 16;
-	u32 cond = Condition;
+	struct odm_dm_struct *odm = &GET_HAL_DATA(adapt)->odmpriv;
+	u32 _board = odm->BoardType;
+	u32 _platform = odm->SupportPlatform;
+	u32 _interface = odm->SupportInterface;
+	u32 cond = condition;
 
-	if (Condition == 0xCDCDCDCD)
+	if (condition == 0xCDCDCDCD)
 		return true;
 
-	cond = Condition & 0x000000FF;
+	cond = condition & 0x000000FF;
 	if ((_board == cond) && cond != 0x00)
 		return false;
 
-	cond = Condition & 0x0000FF00;
+	cond = condition & 0x0000FF00;
 	cond = cond >> 8;
 	if ((_interface & cond) == 0 && cond != 0x07)
 		return false;
 
-	cond = Condition & 0x00FF0000;
+	cond = condition & 0x00FF0000;
 	cond = cond >> 16;
 	if ((_platform & cond) == 0 && cond != 0x0F)
 		return false;
 	return true;
 }
 
-
-/******************************************************************************
-*                           RadioA_1T.TXT
-******************************************************************************/
+/* RadioA_1T.TXT */
 
 static u32 Array_RadioA_1T_8188E[] = {
 		0x000, 0x00030000,
@@ -155,115 +153,166 @@ static u32 Array_RadioA_1T_8188E[] = {
 		0x000, 0x00033E60,
 };
 
-enum HAL_STATUS ODM_ReadAndConfig_RadioA_1T_8188E(struct odm_dm_struct *pDM_Odm)
+#define READ_NEXT_PAIR(v1, v2, i)	\
+do {								\
+	i += 2; v1 = array[i];			\
+	v2 = array[i+1];				\
+} while (0)
+
+#define RFREG_OFFSET_MASK 0xfffff
+#define B3WIREADDREAALENGTH 0x400
+#define B3WIREDATALENGTH 0x800
+#define BRFSI_RFENV 0x10
+
+static void rtl_rfreg_delay(struct adapter *adapt, enum rf_radio_path rfpath,u32 addr, u32 mask, u32 data)
 {
-	#define READ_NEXT_PAIR(v1, v2, i) do	\
-		 { i += 2; v1 = Array[i];	\
-		 v2 = Array[i+1]; } while (0)
-
-	u32     hex         = 0;
-	u32     i           = 0;
-	u8     platform    = pDM_Odm->SupportPlatform;
-	u8     interfaceValue   = pDM_Odm->SupportInterface;
-	u8     board       = pDM_Odm->BoardType;
-	u32     ArrayLen    = sizeof(Array_RadioA_1T_8188E)/sizeof(u32);
-	u32    *Array       = Array_RadioA_1T_8188E;
-	bool		biol = false;
-	struct adapter *Adapter =  pDM_Odm->Adapter;
-	struct xmit_frame *pxmit_frame = NULL;
-	u8 bndy_cnt = 1;
-	enum HAL_STATUS rst = HAL_STATUS_SUCCESS;
-
-	hex += board;
-	hex += interfaceValue << 8;
-	hex += platform << 16;
-	hex += 0xFF000000;
-	biol = rtw_IOL_applied(Adapter);
-
-	if (biol) {
-		pxmit_frame = rtw_IOL_accquire_xmit_frame(Adapter);
-		if (pxmit_frame == NULL) {
-			pr_info("rtw_IOL_accquire_xmit_frame failed\n");
-			return HAL_STATUS_FAILURE;
-		}
+	if (addr == 0xfe) {
+		mdelay(50);
+	} else if (addr == 0xfd) {
+		mdelay(5);
+	} else if (addr == 0xfc) {
+		mdelay(1);
+	} else if (addr == 0xfb) {
+		udelay(50);
+	} else if (addr == 0xfa) {
+		udelay(5);
+	} else if (addr == 0xf9) {
+		udelay(1);
+	} else {
+		rtl8188e_PHY_SetRFReg(adapt, rfpath, addr, mask, data);
+		udelay(1);
 	}
+}
 
-	for (i = 0; i < ArrayLen; i += 2) {
-		u32 v1 = Array[i];
-		u32 v2 = Array[i+1];
+static void rtl8188e_config_rf_reg(struct adapter *adapt,
+	u32 addr, u32 data)
+{
+	u32 content = 0x1000; /*RF Content: radio_a_txt*/
+	u32 maskforphyset = (u32)(content & 0xE000);
+
+	rtl_rfreg_delay(adapt, RF90_PATH_A, addr| maskforphyset,
+			RFREG_OFFSET_MASK,
+			data);
+}
+
+static bool rtl88e_phy_config_rf_with_headerfile(struct adapter *adapt)
+{
+	u32 i;
+	u32 array_len = sizeof(Array_RadioA_1T_8188E)/sizeof(u32);
+	u32 *array = Array_RadioA_1T_8188E;
+
+	for (i = 0; i < array_len; i += 2) {
+		u32 v1 = array[i];
+		u32 v2 = array[i+1];
 
-		/*  This (offset, data) pair meets the condition. */
 		if (v1 < 0xCDCDCDCD) {
-			if (biol) {
-				if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-					bndy_cnt++;
-
-				if (v1 == 0xffe)
-					rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 50);
-				else if (v1 == 0xfd)
-					rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 5);
-				else if (v1 == 0xfc)
-					rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 1);
-				else if (v1 == 0xfb)
-					rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 50);
-				else if (v1 == 0xfa)
-					rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 5);
-				else if (v1 == 0xf9)
-					rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 1);
-				else
-					rtw_IOL_append_WRF_cmd(pxmit_frame, RF_PATH_A, (u16)v1, v2, bRFRegOffsetMask);
-			} else {
-				odm_ConfigRF_RadioA_8188E(pDM_Odm, v1, v2);
-			}
-		    continue;
-		} else { /*  This line is the start line of branch. */
-			if (!CheckCondition(Array[i], hex)) {
-				/*  Discard the following (offset, data) pairs. */
+			rtl8188e_config_rf_reg(adapt, v1, v2);
+			continue;
+		} else {
+			if (!check_condition(adapt, array[i])) {
 				READ_NEXT_PAIR(v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < ArrayLen - 2)
-					READ_NEXT_PAIR(v1, v2, i);
-				i -= 2; /*  prevent from for-loop += 2 */
-			} else { /*  Configure matched pairs and skip to end of if-else. */
-			READ_NEXT_PAIR(v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < ArrayLen - 2) {
-					if (biol) {
-						if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-							bndy_cnt++;
-
-						if (v1 == 0xffe)
-							rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 50);
-						else if (v1 == 0xfd)
-							rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 5);
-						else if (v1 == 0xfc)
-							rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 1);
-						else if (v1 == 0xfb)
-							rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 50);
-						else if (v1 == 0xfa)
-							rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 5);
-						else if (v1 == 0xf9)
-							rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 1);
-						else
-							rtw_IOL_append_WRF_cmd(pxmit_frame, RF_PATH_A, (u16)v1, v2, bRFRegOffsetMask);
-					} else {
-						odm_ConfigRF_RadioA_8188E(pDM_Odm, v1, v2);
-					}
+				while (v2 != 0xDEAD && v2 != 0xCDEF &&
+				       v2 != 0xCDCD && i < array_len - 2)
 					READ_NEXT_PAIR(v1, v2, i);
+					i -= 2;
+			} else {
+				READ_NEXT_PAIR(v1, v2, i);
+				while (v2 != 0xDEAD && v2 != 0xCDEF &&
+				       v2 != 0xCDCD && i < array_len - 2) {
+						rtl8188e_config_rf_reg(adapt, v1, v2);
+						READ_NEXT_PAIR(v1, v2, i);
 				}
 
-				while (v2 != 0xDEAD && i < ArrayLen - 2)
+				while (v2 != 0xDEAD && i < array_len - 2)
 					READ_NEXT_PAIR(v1, v2, i);
 			}
 		}
 	}
-	if (biol) {
-		if (!rtw_IOL_exec_cmds_sync(pDM_Odm->Adapter, pxmit_frame, 1000, bndy_cnt)) {
-			rst = HAL_STATUS_FAILURE;
-			pr_info("~~~ IOL Config %s Failed !!!\n", __func__);
+	return true;
+}
+
+static bool rf6052_conf_para(struct adapter *adapt)
+{
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	u32 u4val = 0;
+	u8 rfpath;
+	bool rtstatus = true;
+	struct bb_reg_def *pphyreg;
+
+	for (rfpath = 0; rfpath < hal_data->NumTotalRFPath; rfpath++) {
+		pphyreg = &hal_data->PHYRegDef[rfpath];
+
+		switch (rfpath) {
+		case RF90_PATH_A:
+		case RF90_PATH_C:
+			u4val = PHY_QueryBBReg(adapt, pphyreg->rfintfs,
+						    BRFSI_RFENV);
+			break;
+		case RF90_PATH_B:
+		case RF90_PATH_D:
+			u4val = PHY_QueryBBReg(adapt, pphyreg->rfintfs,
+						    BRFSI_RFENV << 16);
+			break;
+		}
+
+		PHY_SetBBReg(adapt, pphyreg->rfintfe, BRFSI_RFENV << 16, 0x1);
+		udelay(1);
+
+		PHY_SetBBReg(adapt, pphyreg->rfintfo, BRFSI_RFENV, 0x1);
+		udelay(1);
+
+		PHY_SetBBReg(adapt, pphyreg->rfHSSIPara2,
+			      B3WIREADDREAALENGTH, 0x0);
+		udelay(1);
+
+		PHY_SetBBReg(adapt, pphyreg->rfHSSIPara2, B3WIREDATALENGTH, 0x0);
+		udelay(1);
+
+		switch (rfpath) {
+		case RF90_PATH_A:
+			rtstatus = rtl88e_phy_config_rf_with_headerfile(adapt);
+			break;
+		case RF90_PATH_B:
+			rtstatus = rtl88e_phy_config_rf_with_headerfile(adapt);
+			break;
+		case RF90_PATH_C:
+			break;
+		case RF90_PATH_D:
+			break;
+		}
+
+		switch (rfpath) {
+		case RF90_PATH_A:
+		case RF90_PATH_C:
+			PHY_SetBBReg(adapt, pphyreg->rfintfs, BRFSI_RFENV, u4val);
+			break;
+		case RF90_PATH_B:
+		case RF90_PATH_D:
+			PHY_SetBBReg(adapt, pphyreg->rfintfs, BRFSI_RFENV << 16,
+				      u4val);
+			break;
 		}
+
+		if (rtstatus != true)
+			return false;
 	}
-	return rst;
+
+	return rtstatus;
+}
+
+static bool rtl88e_phy_rf6052_config(struct adapter *adapt)
+{
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+
+	if (hal_data->rf_type == RF_1T1R)
+		hal_data->NumTotalRFPath = 1;
+	else
+		hal_data->NumTotalRFPath = 2;
+
+	return rf6052_conf_para(adapt);
+}
+
+bool rtl88e_phy_rf_config(struct adapter *adapt)
+{
+	return rtl88e_phy_rf6052_config(adapt);
 }
diff --git a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
index 5cd0057..4d28ce5 100644
--- a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
+++ b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
@@ -432,20 +432,6 @@ void ODM_PhyStatusQuery(struct odm_dm_struct *dm_odm,
 	ODM_PhyStatusQuery_92CSeries(dm_odm, pPhyInfo, pPhyStatus, pPktinfo);
 }
 
-enum HAL_STATUS ODM_ConfigRFWithHeaderFile(struct odm_dm_struct *dm_odm,
-					   enum rf_radio_path content,
-					   enum rf_radio_path rfpath)
-{
-	ODM_RT_TRACE(dm_odm, ODM_COMP_INIT, ODM_DBG_LOUD, ("===>ODM_ConfigRFWithHeaderFile\n"));
-	if (rfpath == RF_PATH_A)
-		READ_AND_CONFIG(8188E, _RadioA_1T_);
-	ODM_RT_TRACE(dm_odm, ODM_COMP_INIT, ODM_DBG_LOUD, (" ===> ODM_ConfigRFWithHeaderFile() Radio_A:Rtl8188ERadioA_1TArray\n"));
-	ODM_RT_TRACE(dm_odm, ODM_COMP_INIT, ODM_DBG_LOUD, (" ===> ODM_ConfigRFWithHeaderFile() Radio_B:Rtl8188ERadioB_1TArray\n"));
-
-	ODM_RT_TRACE(dm_odm, ODM_COMP_INIT, ODM_DBG_TRACE, ("ODM_ConfigRFWithHeaderFile: Radio No %x\n", rfpath));
-	return HAL_STATUS_SUCCESS;
-}
-
 enum HAL_STATUS ODM_ConfigBBWithHeaderFile(struct odm_dm_struct *dm_odm,
 					   enum odm_bb_config_type config_tp)
 {
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 922d400..c1a1997 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -585,15 +585,6 @@ PHY_BBConfig8188E(
 	return rtStatus;
 }
 
-int PHY_RFConfig8188E(struct adapter *Adapter)
-{
-	int		rtStatus = _SUCCESS;
-
-	/*  RF config */
-	rtStatus = PHY_RF6052_Config8188E(Adapter);
-	return rtStatus;
-}
-
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
 			       u8 *ofdmPowerLevel, u8 *BW20PowerLevel,
 			       u8 *BW40PowerLevel)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 8ce9d0e..655d8e0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -429,99 +429,3 @@ rtl8188e_PHY_RF6052SetOFDMTxPower(
 		writeOFDMPowerReg88E(Adapter, index, &writeVal[0]);
 	}
 }
-
-static int phy_RF6052_Config_ParaFile(struct adapter *Adapter)
-{
-	struct bb_reg_def *pPhyReg;
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	u32 u4RegValue = 0;
-	u8 eRFPath;
-	int rtStatus = _SUCCESS;
-
-	/* 3----------------------------------------------------------------- */
-	/* 3 <2> Initialize RF */
-	/* 3----------------------------------------------------------------- */
-	for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++) {
-		pPhyReg = &pHalData->PHYRegDef[eRFPath];
-
-		/*----Store original RFENV control type----*/
-		switch (eRFPath) {
-		case RF_PATH_A:
-		case RF_PATH_C:
-			u4RegValue = PHY_QueryBBReg(Adapter, pPhyReg->rfintfs, bRFSI_RFENV);
-			break;
-		case RF_PATH_B:
-		case RF_PATH_D:
-			u4RegValue = PHY_QueryBBReg(Adapter, pPhyReg->rfintfs, bRFSI_RFENV<<16);
-			break;
-		}
-		/*----Set RF_ENV enable----*/
-		PHY_SetBBReg(Adapter, pPhyReg->rfintfe, bRFSI_RFENV<<16, 0x1);
-		udelay(1);/* PlatformStallExecution(1); */
-
-		/*----Set RF_ENV output high----*/
-		PHY_SetBBReg(Adapter, pPhyReg->rfintfo, bRFSI_RFENV, 0x1);
-		udelay(1);/* PlatformStallExecution(1); */
-
-		/* Set bit number of Address and Data for RF register */
-		PHY_SetBBReg(Adapter, pPhyReg->rfHSSIPara2, b3WireAddressLength, 0x0);	/*  Set 1 to 4 bits for 8255 */
-		udelay(1);/* PlatformStallExecution(1); */
-
-		PHY_SetBBReg(Adapter, pPhyReg->rfHSSIPara2, b3WireDataLength, 0x0);	/*  Set 0 to 12  bits for 8255 */
-		udelay(1);/* PlatformStallExecution(1); */
-
-		/*----Initialize RF fom connfiguration file----*/
-		switch (eRFPath) {
-		case RF_PATH_A:
-			if (HAL_STATUS_FAILURE == ODM_ConfigRFWithHeaderFile(&pHalData->odmpriv, (enum rf_radio_path)eRFPath, (enum rf_radio_path)eRFPath))
-				rtStatus = _FAIL;
-			break;
-		case RF_PATH_B:
-		if (HAL_STATUS_FAILURE == ODM_ConfigRFWithHeaderFile(&pHalData->odmpriv, (enum rf_radio_path)eRFPath, (enum rf_radio_path)eRFPath))
-				rtStatus = _FAIL;
-			break;
-		case RF_PATH_C:
-			break;
-		case RF_PATH_D:
-			break;
-		}
-		/*----Restore RFENV control type----*/;
-		switch (eRFPath) {
-		case RF_PATH_A:
-		case RF_PATH_C:
-			PHY_SetBBReg(Adapter, pPhyReg->rfintfs, bRFSI_RFENV, u4RegValue);
-			break;
-		case RF_PATH_B:
-		case RF_PATH_D:
-			PHY_SetBBReg(Adapter, pPhyReg->rfintfs, bRFSI_RFENV<<16, u4RegValue);
-			break;
-		}
-		if (rtStatus != _SUCCESS)
-			goto phy_RF6052_Config_ParaFile_Fail;
-	}
-	return rtStatus;
-
-phy_RF6052_Config_ParaFile_Fail:
-	return rtStatus;
-}
-
-int PHY_RF6052_Config8188E(struct adapter *Adapter)
-{
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	int rtStatus = _SUCCESS;
-
-	/*  */
-	/*  Initialize general global value */
-	/*  */
-	/*  TODO: Extend RF_PATH_C and RF_PATH_D in the future */
-	if (pHalData->rf_type == RF_1T1R)
-		pHalData->NumTotalRFPath = 1;
-	else
-		pHalData->NumTotalRFPath = 2;
-
-	/*  */
-	/*  Config BB and RF */
-	/*  */
-	rtStatus = phy_RF6052_Config_ParaFile(Adapter);
-	return rtStatus;
-}
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 46d92b1..efb3f7f 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -30,7 +30,6 @@
 #include <phy.h>
 
 #define		HAL_BB_ENABLE		1
-#define		HAL_RF_ENABLE		1
 
 static void _ConfigNormalChipOutEP_8188E(struct adapter *adapt, u8 NumOutPipe)
 {
@@ -771,14 +770,7 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	}
 #endif
 
-	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_RF);
-#if (HAL_RF_ENABLE == 1)
-	status = PHY_RFConfig8188E(Adapter);
-	if (status == _FAIL) {
-		DBG_88E(" ### Failed to init RF ......\n ");
-		goto exit;
-	}
-#endif
+	rtl88e_phy_rf_config(Adapter);
 
 	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_EFUSE_PATCH);
 	status = rtl8188e_iol_efuse_patch(Adapter);
diff --git a/drivers/staging/rtl8188eu/include/HalHWImg8188E_RF.h b/drivers/staging/rtl8188eu/include/HalHWImg8188E_RF.h
deleted file mode 100644
index 8ecb40d..0000000
--- a/drivers/staging/rtl8188eu/include/HalHWImg8188E_RF.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/******************************************************************************
-*
-* Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
-*
-* This program is free software; you can redistribute it and/or modify it
-* under the terms of version 2 of the GNU General Public License as
-* published by the Free Software Foundation.
-*
-* This program is distributed in the hope that it will be useful, but WITHOUT
-* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
-* more details.
-*
-* You should have received a copy of the GNU General Public License along with
-* this program; if not, write to the Free Software Foundation, Inc.,
-* 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
-*
-*
-******************************************************************************/
-
-#ifndef __INC_RF_8188E_HW_IMG_H
-#define __INC_RF_8188E_HW_IMG_H
-
-/******************************************************************************
- *                           RadioA_1T.TXT
- ******************************************************************************/
-
-enum HAL_STATUS ODM_ReadAndConfig_RadioA_1T_8188E(struct odm_dm_struct *odm);
-
-#endif /*  end of HWIMG_SUPPORT */
diff --git a/drivers/staging/rtl8188eu/include/odm_HWConfig.h b/drivers/staging/rtl8188eu/include/odm_HWConfig.h
index a687d17..1de4e63 100644
--- a/drivers/staging/rtl8188eu/include/odm_HWConfig.h
+++ b/drivers/staging/rtl8188eu/include/odm_HWConfig.h
@@ -120,10 +120,6 @@ void ODM_MacStatusQuery(struct odm_dm_struct *pDM_Odm,
 			bool	bPacketToSelf,
 			bool	bPacketBeacon);
 
-enum HAL_STATUS ODM_ConfigRFWithHeaderFile(struct odm_dm_struct *pDM_Odm,
-					   enum rf_radio_path Content,
-					   enum rf_radio_path eRFPath);
-
 enum HAL_STATUS ODM_ConfigBBWithHeaderFile(struct odm_dm_struct *pDM_Odm,
 					   enum odm_bb_config_type ConfigType);
 
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 7b98be5..2b3e51b 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -46,7 +46,6 @@
 
 #include "odm_reg.h"
 
-#include "HalHWImg8188E_RF.h"
 #include "HalHWImg8188E_BB.h"
 
 #include "odm_RegConfig8188E.h"
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index cab4c8e..254d418 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -1 +1,2 @@
 bool rtl88e_phy_mac_config(struct adapter *adapt);
+bool rtl88e_phy_rf_config(struct adapter *adapt);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
index 10fc356..20b5ba0 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
@@ -25,7 +25,6 @@
 #define		RF6052_MAX_PATH			2
 
 
-int	PHY_RF6052_Config8188E(struct adapter *Adapter);
 void rtl8188e_RF_ChangeTxPath(struct adapter *Adapter, u16 DataRate);
 void rtl8188e_PHY_RF6052SetBandwidth(struct adapter *Adapter,
 				     enum ht_channel_width Bandwidth);
-- 
1.7.10.4

