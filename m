Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaHJOqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:46:11 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50700 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaHJOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:46:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/22] staging: rtl8188eu: Cleanup and simplify Baseband configuration code
Date: Sun, 10 Aug 2014 20:14:20 +0530
Message-Id: <1407681875-2611-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup and consolidate Baseband configuration related code in
HalHWImg8188E_BB.c file.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c   |  474 ++++++++++----------
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |   15 -
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |  187 --------
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   10 +-
 .../staging/rtl8188eu/include/HalHWImg8188E_BB.h   |   44 --
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    2 -
 drivers/staging/rtl8188eu/include/phy.h            |    1 +
 7 files changed, 236 insertions(+), 497 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_BB.h

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
index 787e8f1..00f9cd7 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
@@ -20,7 +20,7 @@
 
 #include "odm_precomp.h"
 
-#include <rtw_iol.h>
+#include <phy.h>
 
 #define read_next_pair(array, v1, v2, i)		\
 	 do {						\
@@ -29,36 +29,8 @@
 		 v2 = array[i+1];			\
 	 } while (0)
 
-static bool CheckCondition(const u32  condition, const u32  hex)
-{
-	u32 _board     = (hex & 0x000000FF);
-	u32 _interface = (hex & 0x0000FF00) >> 8;
-	u32 _platform  = (hex & 0x00FF0000) >> 16;
-	u32 cond = condition;
-
-	if (condition == 0xCDCDCDCD)
-		return true;
-
-	cond = condition & 0x000000FF;
-	if ((_board == cond) && cond != 0x00)
-		return false;
-
-	cond = condition & 0x0000FF00;
-	cond = cond >> 8;
-	if ((_interface & cond) == 0 && cond != 0x07)
-		return false;
-
-	cond = condition & 0x00FF0000;
-	cond = cond >> 16;
-	if ((_platform & cond) == 0 && cond != 0x0F)
-		return false;
-	return true;
-}
 
-
-/******************************************************************************
-*                           AGC_TAB_1T.TXT
-******************************************************************************/
+/* AGC_TAB_1T.TXT */
 
 static u32 array_agc_tab_1t_8188e[] = {
 		0xC78, 0xFB000001,
@@ -191,91 +163,25 @@ static u32 array_agc_tab_1t_8188e[] = {
 		0xC78, 0x407F0001,
 };
 
-enum HAL_STATUS ODM_ReadAndConfig_AGC_TAB_1T_8188E(struct odm_dm_struct *dm_odm)
+static bool set_baseband_agc_config(struct adapter *adapt)
 {
-	u32     hex         = 0;
-	u32     i           = 0;
-	u8     platform    = dm_odm->SupportPlatform;
-	u8     interfaceValue   = dm_odm->SupportInterface;
-	u8     board       = dm_odm->BoardType;
-	u32     arraylen    = sizeof(array_agc_tab_1t_8188e)/sizeof(u32);
-	u32    *array       = array_agc_tab_1t_8188e;
-	bool		biol = false;
-	struct adapter *adapter =  dm_odm->Adapter;
-	struct xmit_frame *pxmit_frame = NULL;
-	u8 bndy_cnt = 1;
-	enum HAL_STATUS rst = HAL_STATUS_SUCCESS;
-
-	hex += board;
-	hex += interfaceValue << 8;
-	hex += platform << 16;
-	hex += 0xFF000000;
-	biol = rtw_IOL_applied(adapter);
-
-	if (biol) {
-		pxmit_frame = rtw_IOL_accquire_xmit_frame(adapter);
-		if (pxmit_frame == NULL) {
-			pr_info("rtw_IOL_accquire_xmit_frame failed\n");
-			return HAL_STATUS_FAILURE;
-		}
-	}
+	u32 i;
+	u32 arraylen = sizeof(array_agc_tab_1t_8188e)/sizeof(u32);
+	u32 *array = array_agc_tab_1t_8188e;
 
 	for (i = 0; i < arraylen; i += 2) {
 		u32 v1 = array[i];
 		u32 v2 = array[i+1];
 
-		/*  This (offset, data) pair meets the condition. */
-		if (v1 < 0xCDCDCDCD) {
-			if (biol) {
-				if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-					bndy_cnt++;
-				rtw_IOL_append_WD_cmd(pxmit_frame, (u16)v1, v2, bMaskDWord);
-			} else {
-				odm_ConfigBB_AGC_8188E(dm_odm, v1, bMaskDWord, v2);
-			}
-			continue;
-		} else {
-			/*  This line is the start line of branch. */
-			if (!CheckCondition(array[i], hex)) {
-				/*  Discard the following (offset, data) pairs. */
-				read_next_pair(array, v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylen - 2)
-					read_next_pair(array, v1, v2, i);
-				i -= 2; /*  prevent from for-loop += 2 */
-			} else { /*  Configure matched pairs and skip to end of if-else. */
-				read_next_pair(array, v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylen - 2) {
-					if (biol) {
-						if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-							bndy_cnt++;
-						rtw_IOL_append_WD_cmd(pxmit_frame, (u16)v1, v2, bMaskDWord);
-					} else {
-						odm_ConfigBB_AGC_8188E(dm_odm, v1, bMaskDWord, v2);
-					}
-					read_next_pair(array, v1, v2, i);
-				}
-
-				while (v2 != 0xDEAD && i < arraylen - 2)
-					read_next_pair(array, v1, v2, i);
-			}
-		}
-	}
-	if (biol) {
-		if (!rtw_IOL_exec_cmds_sync(dm_odm->Adapter, pxmit_frame, 1000, bndy_cnt)) {
-			printk("~~~ %s IOL_exec_cmds Failed !!!\n", __func__);
-			rst = HAL_STATUS_FAILURE;
+		if (v1 < 0xCDCDCDCD){
+			PHY_SetBBReg(adapt, v1, bMaskDWord, v2);
+			udelay(1);
 		}
 	}
-	return rst;
+	return true;
 }
 
-/******************************************************************************
-*                           PHY_REG_1T.TXT
-******************************************************************************/
+/*  PHY_REG_1T.TXT  */
 
 static u32 array_phy_reg_1t_8188e[] = {
 		0x800, 0x80040000,
@@ -471,122 +377,44 @@ static u32 array_phy_reg_1t_8188e[] = {
 		0xF00, 0x00000300,
 };
 
-enum HAL_STATUS ODM_ReadAndConfig_PHY_REG_1T_8188E(struct odm_dm_struct *dm_odm)
+static void rtl_bb_delay(struct adapter *adapt, u32 addr, u32 data)
 {
-	u32     hex         = 0;
-	u32     i           = 0;
-	u8     platform    = dm_odm->SupportPlatform;
-	u8     interfaceValue   = dm_odm->SupportInterface;
-	u8     board       = dm_odm->BoardType;
-	u32     arraylen    = sizeof(array_phy_reg_1t_8188e)/sizeof(u32);
-	u32    *array       = array_phy_reg_1t_8188e;
-	bool	biol = false;
-	struct adapter *adapter =  dm_odm->Adapter;
-	struct xmit_frame *pxmit_frame = NULL;
-	u8 bndy_cnt = 1;
-	enum HAL_STATUS rst = HAL_STATUS_SUCCESS;
-	hex += board;
-	hex += interfaceValue << 8;
-	hex += platform << 16;
-	hex += 0xFF000000;
-	biol = rtw_IOL_applied(adapter);
-
-	if (biol) {
-		pxmit_frame = rtw_IOL_accquire_xmit_frame(adapter);
-		if (pxmit_frame == NULL) {
-			pr_info("rtw_IOL_accquire_xmit_frame failed\n");
-			return HAL_STATUS_FAILURE;
-		}
+	if (addr == 0xfe) {
+		msleep(50);
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
+		PHY_SetBBReg(adapt, addr, bMaskDWord, data);
+		/*  Add 1us delay between BB/RF register setting. */
+		udelay(1);
 	}
+}
+
+static bool set_baseband_phy_config(struct adapter *adapt)
+{
+	u32 i;
+	u32 arraylen = sizeof(array_phy_reg_1t_8188e)/sizeof(u32);
+	u32 *array = array_phy_reg_1t_8188e;
 
 	for (i = 0; i < arraylen; i += 2) {
 		u32 v1 = array[i];
 		u32 v2 = array[i+1];
 
-		/*  This (offset, data) pair meets the condition. */
-		if (v1 < 0xCDCDCDCD) {
-			if (biol) {
-				if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-					bndy_cnt++;
-				if (v1 == 0xfe) {
-					rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 50);
-				} else if (v1 == 0xfd) {
-					rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 5);
-				} else if (v1 == 0xfc) {
-					rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 1);
-				} else if (v1 == 0xfb) {
-					rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 50);
-				} else if (v1 == 0xfa) {
-					rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 5);
-				} else if (v1 == 0xf9) {
-					rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 1);
-				} else {
-					if (v1 == 0xa24)
-						dm_odm->RFCalibrateInfo.RegA24 = v2;
-					rtw_IOL_append_WD_cmd(pxmit_frame, (u16)v1, v2, bMaskDWord);
-				}
-			} else {
-				odm_ConfigBB_PHY_8188E(dm_odm, v1, bMaskDWord, v2);
-			}
-			continue;
-		} else { /*  This line is the start line of branch. */
-			if (!CheckCondition(array[i], hex)) {
-				/*  Discard the following (offset, data) pairs. */
-				read_next_pair(array, v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylen - 2)
-					read_next_pair(array, v1, v2, i);
-				i -= 2; /*  prevent from for-loop += 2 */
-			} else { /*  Configure matched pairs and skip to end of if-else. */
-				read_next_pair(array, v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < arraylen - 2) {
-					if (biol) {
-						if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-							bndy_cnt++;
-						if (v1 == 0xfe) {
-							rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 50);
-						} else if (v1 == 0xfd) {
-							rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 5);
-						} else if (v1 == 0xfc) {
-							rtw_IOL_append_DELAY_MS_cmd(pxmit_frame, 1);
-						} else if (v1 == 0xfb) {
-							rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 50);
-						} else if (v1 == 0xfa) {
-							rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 5);
-						} else if (v1 == 0xf9) {
-							rtw_IOL_append_DELAY_US_cmd(pxmit_frame, 1);
-						} else{
-							if (v1 == 0xa24)
-								dm_odm->RFCalibrateInfo.RegA24 = v2;
-
-							rtw_IOL_append_WD_cmd(pxmit_frame, (u16)v1, v2, bMaskDWord);
-						}
-					} else {
-						odm_ConfigBB_PHY_8188E(dm_odm, v1, bMaskDWord, v2);
-					}
-					read_next_pair(array, v1, v2, i);
-				}
-
-				while (v2 != 0xDEAD && i < arraylen - 2)
-					read_next_pair(array, v1, v2, i);
-			}
-		}
+		if (v1 < 0xCDCDCDCD)
+			rtl_bb_delay(adapt, v1, v2);
 	}
-	if (biol) {
-		if (!rtw_IOL_exec_cmds_sync(dm_odm->Adapter, pxmit_frame, 1000, bndy_cnt)) {
-			rst = HAL_STATUS_FAILURE;
-			pr_info("~~~ IOL Config %s Failed !!!\n", __func__);
-		}
-	}
-	return rst;
+	return true;
 }
 
-/******************************************************************************
-*                           PHY_REG_PG.TXT
-******************************************************************************/
+/*  PHY_REG_PG.TXT  */
 
 static u32 array_phy_reg_pg_8188e[] = {
 		0xE00, 0xFFFFFFFF, 0x06070809,
@@ -680,42 +508,208 @@ static u32 array_phy_reg_pg_8188e[] = {
 
 };
 
-void ODM_ReadAndConfig_PHY_REG_PG_8188E(struct odm_dm_struct *dm_odm)
+static void store_pwrindex_offset(struct adapter *Adapter, u32 regaddr, u32 bitmask, u32 data)
 {
-	u32  hex;
-	u32  i           = 0;
-	u8  platform    = dm_odm->SupportPlatform;
-	u8  interfaceValue   = dm_odm->SupportInterface;
-	u8  board       = dm_odm->BoardType;
-	u32  arraylen    = sizeof(array_phy_reg_pg_8188e) / sizeof(u32);
-	u32 *array       = array_phy_reg_pg_8188e;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(Adapter);
+
+	if (regaddr == rTxAGC_A_Rate18_06)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][0] = data;
+	if (regaddr == rTxAGC_A_Rate54_24)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][1] = data;
+	if (regaddr == rTxAGC_A_CCK1_Mcs32)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][6] = data;
+	if (regaddr == rTxAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][7] = data;
+	if (regaddr == rTxAGC_A_Mcs03_Mcs00)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][2] = data;
+	if (regaddr == rTxAGC_A_Mcs07_Mcs04)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][3] = data;
+	if (regaddr == rTxAGC_A_Mcs11_Mcs08)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][4] = data;
+	if (regaddr == rTxAGC_A_Mcs15_Mcs12) {
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][5] = data;
+		if (hal_data->rf_type == RF_1T1R)
+			hal_data->pwrGroupCnt++;
+	}
+	if (regaddr == rTxAGC_B_Rate18_06)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][8] = data;
+	if (regaddr == rTxAGC_B_Rate54_24)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][9] = data;
+	if (regaddr == rTxAGC_B_CCK1_55_Mcs32)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][14] = data;
+	if (regaddr == rTxAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][15] = data;
+	if (regaddr == rTxAGC_B_Mcs03_Mcs00)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][10] = data;
+	if (regaddr == rTxAGC_B_Mcs07_Mcs04)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][11] = data;
+	if (regaddr == rTxAGC_B_Mcs11_Mcs08)
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][12] = data;
+	if (regaddr == rTxAGC_B_Mcs15_Mcs12) {
+		hal_data->MCSTxPowerLevelOriginalOffset[hal_data->pwrGroupCnt][13] = data;
+		if (hal_data->rf_type != RF_1T1R)
+			hal_data->pwrGroupCnt++;
+	}
+}
 
-	hex = board + (interfaceValue << 8);
-	hex += (platform << 16) + 0xFF000000;
+static void rtl_addr_delay(struct adapter *adapt, u32 addr, u32 bit_mask ,u32 data)
+{
+	if (addr == 0xfe) {
+		msleep(50);
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
+	} else{
+		store_pwrindex_offset(adapt, addr, bit_mask, data);
+	}
+}
+
+static bool config_bb_with_pgheader(struct adapter *adapt)
+{
+	u32 i = 0;
+	u32 arraylen = sizeof(array_phy_reg_pg_8188e) / sizeof(u32);
+	u32 *array = array_phy_reg_pg_8188e;
 
 	for (i = 0; i < arraylen; i += 3) {
 		u32 v1 = array[i];
 		u32 v2 = array[i+1];
 		u32 v3 = array[i+2];
 
-		/*  this line is a line of pure_body */
-		if (v1 < 0xCDCDCDCD) {
-			odm_ConfigBB_PHY_REG_PG_8188E(dm_odm, v1, v2, v3);
-			continue;
-		} else { /*  this line is the start of branch */
-			if (!CheckCondition(array[i], hex)) {
-				/*  don't need the hw_body */
-				i += 2; /*  skip the pair of expression */
-				v1 = array[i];
-				v2 = array[i+1];
-				v3 = array[i+2];
-				while (v2 != 0xDEAD) {
-					i += 3;
-					v1 = array[i];
-					v2 = array[i+1];
-					v3 = array[i+1];
-				}
-			}
-		}
+		if (v1 < 0xCDCDCDCD)
+			rtl_addr_delay(adapt, v1, v2, v3);
+	}
+	return true;
+}
+
+static void rtl88e_phy_init_bb_rf_register_definition(struct adapter *Adapter)
+{
+	struct hal_data_8188e		*hal_data = GET_HAL_DATA(Adapter);
+
+	hal_data->PHYRegDef[RF_PATH_A].rfintfs = rFPGA0_XAB_RFInterfaceSW;
+	hal_data->PHYRegDef[RF_PATH_B].rfintfs = rFPGA0_XAB_RFInterfaceSW;
+	hal_data->PHYRegDef[RF_PATH_C].rfintfs = rFPGA0_XCD_RFInterfaceSW;
+	hal_data->PHYRegDef[RF_PATH_D].rfintfs = rFPGA0_XCD_RFInterfaceSW;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfintfi = rFPGA0_XAB_RFInterfaceRB;
+	hal_data->PHYRegDef[RF_PATH_B].rfintfi = rFPGA0_XAB_RFInterfaceRB;
+	hal_data->PHYRegDef[RF_PATH_C].rfintfi = rFPGA0_XCD_RFInterfaceRB;
+	hal_data->PHYRegDef[RF_PATH_D].rfintfi = rFPGA0_XCD_RFInterfaceRB;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfintfo = rFPGA0_XA_RFInterfaceOE;
+	hal_data->PHYRegDef[RF_PATH_B].rfintfo = rFPGA0_XB_RFInterfaceOE;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfintfe = rFPGA0_XA_RFInterfaceOE;
+	hal_data->PHYRegDef[RF_PATH_B].rfintfe = rFPGA0_XB_RFInterfaceOE;
+
+	hal_data->PHYRegDef[RF_PATH_A].rf3wireOffset = rFPGA0_XA_LSSIParameter;
+	hal_data->PHYRegDef[RF_PATH_B].rf3wireOffset = rFPGA0_XB_LSSIParameter;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfLSSI_Select = rFPGA0_XAB_RFParameter;
+	hal_data->PHYRegDef[RF_PATH_B].rfLSSI_Select = rFPGA0_XAB_RFParameter;
+	hal_data->PHYRegDef[RF_PATH_C].rfLSSI_Select = rFPGA0_XCD_RFParameter;
+	hal_data->PHYRegDef[RF_PATH_D].rfLSSI_Select = rFPGA0_XCD_RFParameter;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfTxGainStage = rFPGA0_TxGainStage;
+	hal_data->PHYRegDef[RF_PATH_B].rfTxGainStage = rFPGA0_TxGainStage;
+	hal_data->PHYRegDef[RF_PATH_C].rfTxGainStage = rFPGA0_TxGainStage;
+	hal_data->PHYRegDef[RF_PATH_D].rfTxGainStage = rFPGA0_TxGainStage;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfHSSIPara1 = rFPGA0_XA_HSSIParameter1;
+	hal_data->PHYRegDef[RF_PATH_B].rfHSSIPara1 = rFPGA0_XB_HSSIParameter1;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfHSSIPara2 = rFPGA0_XA_HSSIParameter2;
+	hal_data->PHYRegDef[RF_PATH_B].rfHSSIPara2 = rFPGA0_XB_HSSIParameter2;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfSwitchControl = rFPGA0_XAB_SwitchControl;
+	hal_data->PHYRegDef[RF_PATH_B].rfSwitchControl = rFPGA0_XAB_SwitchControl;
+	hal_data->PHYRegDef[RF_PATH_C].rfSwitchControl = rFPGA0_XCD_SwitchControl;
+	hal_data->PHYRegDef[RF_PATH_D].rfSwitchControl = rFPGA0_XCD_SwitchControl;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfAGCControl1 = rOFDM0_XAAGCCore1;
+	hal_data->PHYRegDef[RF_PATH_B].rfAGCControl1 = rOFDM0_XBAGCCore1;
+	hal_data->PHYRegDef[RF_PATH_C].rfAGCControl1 = rOFDM0_XCAGCCore1;
+	hal_data->PHYRegDef[RF_PATH_D].rfAGCControl1 = rOFDM0_XDAGCCore1;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfAGCControl2 = rOFDM0_XAAGCCore2;
+	hal_data->PHYRegDef[RF_PATH_B].rfAGCControl2 = rOFDM0_XBAGCCore2;
+	hal_data->PHYRegDef[RF_PATH_C].rfAGCControl2 = rOFDM0_XCAGCCore2;
+	hal_data->PHYRegDef[RF_PATH_D].rfAGCControl2 = rOFDM0_XDAGCCore2;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfRxIQImbalance = rOFDM0_XARxIQImbalance;
+	hal_data->PHYRegDef[RF_PATH_B].rfRxIQImbalance = rOFDM0_XBRxIQImbalance;
+	hal_data->PHYRegDef[RF_PATH_C].rfRxIQImbalance = rOFDM0_XCRxIQImbalance;
+	hal_data->PHYRegDef[RF_PATH_D].rfRxIQImbalance = rOFDM0_XDRxIQImbalance;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfRxAFE = rOFDM0_XARxAFE;
+	hal_data->PHYRegDef[RF_PATH_B].rfRxAFE = rOFDM0_XBRxAFE;
+	hal_data->PHYRegDef[RF_PATH_C].rfRxAFE = rOFDM0_XCRxAFE;
+	hal_data->PHYRegDef[RF_PATH_D].rfRxAFE = rOFDM0_XDRxAFE;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfTxIQImbalance = rOFDM0_XATxIQImbalance;
+	hal_data->PHYRegDef[RF_PATH_B].rfTxIQImbalance = rOFDM0_XBTxIQImbalance;
+	hal_data->PHYRegDef[RF_PATH_C].rfTxIQImbalance = rOFDM0_XCTxIQImbalance;
+	hal_data->PHYRegDef[RF_PATH_D].rfTxIQImbalance = rOFDM0_XDTxIQImbalance;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfTxAFE = rOFDM0_XATxAFE;
+	hal_data->PHYRegDef[RF_PATH_B].rfTxAFE = rOFDM0_XBTxAFE;
+	hal_data->PHYRegDef[RF_PATH_C].rfTxAFE = rOFDM0_XCTxAFE;
+	hal_data->PHYRegDef[RF_PATH_D].rfTxAFE = rOFDM0_XDTxAFE;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfLSSIReadBack = rFPGA0_XA_LSSIReadBack;
+	hal_data->PHYRegDef[RF_PATH_B].rfLSSIReadBack = rFPGA0_XB_LSSIReadBack;
+	hal_data->PHYRegDef[RF_PATH_C].rfLSSIReadBack = rFPGA0_XC_LSSIReadBack;
+	hal_data->PHYRegDef[RF_PATH_D].rfLSSIReadBack = rFPGA0_XD_LSSIReadBack;
+
+	hal_data->PHYRegDef[RF_PATH_A].rfLSSIReadBackPi = TransceiverA_HSPI_Readback;
+	hal_data->PHYRegDef[RF_PATH_B].rfLSSIReadBackPi = TransceiverB_HSPI_Readback;
+}
+
+static bool config_parafile(struct adapter *adapt)
+{
+	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(adapt);
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+
+	set_baseband_phy_config(adapt);
+
+	/* If EEPROM or EFUSE autoload OK, We must config by PHY_REG_PG.txt */
+	if (!pEEPROM->bautoload_fail_flag) {
+		hal_data->pwrGroupCnt = 0;
+		config_bb_with_pgheader(adapt);
 	}
+	set_baseband_agc_config(adapt);
+	return true;
+}
+
+bool rtl88e_phy_bb_config(struct adapter *adapt)
+{
+	int rtstatus = true;
+	struct hal_data_8188e	*hal_data = GET_HAL_DATA(adapt);
+	u32 regval;
+	u8 crystal_cap;
+
+	rtl88e_phy_init_bb_rf_register_definition(adapt);
+
+	/*  Enable BB and RF */
+	regval = usb_read16(adapt, REG_SYS_FUNC_EN);
+	usb_write16(adapt, REG_SYS_FUNC_EN, (u16)(regval|BIT13|BIT0|BIT1));
+
+	usb_write8(adapt, REG_RF_CTRL, RF_EN|RF_RSTB|RF_SDMRSTB);
+
+	usb_write8(adapt, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD | FEN_BB_GLB_RSTn | FEN_BBRSTB);
+
+	/*  Config BB and AGC */
+	rtstatus = config_parafile(adapt);
+
+	/*  write 0x24[16:11] = 0x24[22:17] = crystal_cap */
+	crystal_cap = hal_data->CrystalCap & 0x3F;
+	PHY_SetBBReg(adapt, REG_AFE_XTAL_CTRL, 0x7ff800, (crystal_cap | (crystal_cap << 6)));
+
+	return rtstatus;
 }
diff --git a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
index 4d28ce5..dbc1368 100644
--- a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
+++ b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
@@ -431,18 +431,3 @@ void ODM_PhyStatusQuery(struct odm_dm_struct *dm_odm,
 {
 	ODM_PhyStatusQuery_92CSeries(dm_odm, pPhyInfo, pPhyStatus, pPktinfo);
 }
-
-enum HAL_STATUS ODM_ConfigBBWithHeaderFile(struct odm_dm_struct *dm_odm,
-					   enum odm_bb_config_type config_tp)
-{
-	if (config_tp == CONFIG_BB_PHY_REG) {
-		READ_AND_CONFIG(8188E, _PHY_REG_1T_);
-	} else if (config_tp == CONFIG_BB_AGC_TAB) {
-		READ_AND_CONFIG(8188E, _AGC_TAB_1T_);
-	} else if (config_tp == CONFIG_BB_PHY_REG_PG) {
-		READ_AND_CONFIG(8188E, _PHY_REG_PG_);
-		ODM_RT_TRACE(dm_odm, ODM_COMP_INIT, ODM_DBG_LOUD,
-			     (" ===> phy_ConfigBBWithHeaderFile() agc:Rtl8188EPHY_REG_PGArray\n"));
-	}
-	return HAL_STATUS_SUCCESS;
-}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index c1a1997..96361b8 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -354,122 +354,6 @@ rtl8188e_PHY_SetRFReg(
 	phy_RFSerialWrite(Adapter, eRFPath, RegAddr, Data);
 }
 
-/**
-* Function:	phy_InitBBRFRegisterDefinition
-*
-* OverView:	Initialize Register definition offset for Radio Path A/B/C/D
-*
-* Input:
-*			struct adapter *Adapter,
-*
-* Output:	None
-* Return:		None
-* Note:		The initialization value is constant and it should never be changes
-*/
-static	void
-phy_InitBBRFRegisterDefinition(
-		struct adapter *Adapter
-)
-{
-	struct hal_data_8188e		*pHalData = GET_HAL_DATA(Adapter);
-
-	/*  RF Interface Sowrtware Control */
-	pHalData->PHYRegDef[RF_PATH_A].rfintfs = rFPGA0_XAB_RFInterfaceSW; /*  16 LSBs if read 32-bit from 0x870 */
-	pHalData->PHYRegDef[RF_PATH_B].rfintfs = rFPGA0_XAB_RFInterfaceSW; /*  16 MSBs if read 32-bit from 0x870 (16-bit for 0x872) */
-	pHalData->PHYRegDef[RF_PATH_C].rfintfs = rFPGA0_XCD_RFInterfaceSW;/*  16 LSBs if read 32-bit from 0x874 */
-	pHalData->PHYRegDef[RF_PATH_D].rfintfs = rFPGA0_XCD_RFInterfaceSW;/*  16 MSBs if read 32-bit from 0x874 (16-bit for 0x876) */
-
-	/*  RF Interface Readback Value */
-	pHalData->PHYRegDef[RF_PATH_A].rfintfi = rFPGA0_XAB_RFInterfaceRB; /*  16 LSBs if read 32-bit from 0x8E0 */
-	pHalData->PHYRegDef[RF_PATH_B].rfintfi = rFPGA0_XAB_RFInterfaceRB;/*  16 MSBs if read 32-bit from 0x8E0 (16-bit for 0x8E2) */
-	pHalData->PHYRegDef[RF_PATH_C].rfintfi = rFPGA0_XCD_RFInterfaceRB;/*  16 LSBs if read 32-bit from 0x8E4 */
-	pHalData->PHYRegDef[RF_PATH_D].rfintfi = rFPGA0_XCD_RFInterfaceRB;/*  16 MSBs if read 32-bit from 0x8E4 (16-bit for 0x8E6) */
-
-	/*  RF Interface Output (and Enable) */
-	pHalData->PHYRegDef[RF_PATH_A].rfintfo = rFPGA0_XA_RFInterfaceOE; /*  16 LSBs if read 32-bit from 0x860 */
-	pHalData->PHYRegDef[RF_PATH_B].rfintfo = rFPGA0_XB_RFInterfaceOE; /*  16 LSBs if read 32-bit from 0x864 */
-
-	/*  RF Interface (Output and)  Enable */
-	pHalData->PHYRegDef[RF_PATH_A].rfintfe = rFPGA0_XA_RFInterfaceOE; /*  16 MSBs if read 32-bit from 0x860 (16-bit for 0x862) */
-	pHalData->PHYRegDef[RF_PATH_B].rfintfe = rFPGA0_XB_RFInterfaceOE; /*  16 MSBs if read 32-bit from 0x864 (16-bit for 0x866) */
-
-	/* Addr of LSSI. Wirte RF register by driver */
-	pHalData->PHYRegDef[RF_PATH_A].rf3wireOffset = rFPGA0_XA_LSSIParameter; /* LSSI Parameter */
-	pHalData->PHYRegDef[RF_PATH_B].rf3wireOffset = rFPGA0_XB_LSSIParameter;
-
-	/*  RF parameter */
-	pHalData->PHYRegDef[RF_PATH_A].rfLSSI_Select = rFPGA0_XAB_RFParameter;  /* BB Band Select */
-	pHalData->PHYRegDef[RF_PATH_B].rfLSSI_Select = rFPGA0_XAB_RFParameter;
-	pHalData->PHYRegDef[RF_PATH_C].rfLSSI_Select = rFPGA0_XCD_RFParameter;
-	pHalData->PHYRegDef[RF_PATH_D].rfLSSI_Select = rFPGA0_XCD_RFParameter;
-
-	/*  Tx AGC Gain Stage (same for all path. Should we remove this?) */
-	pHalData->PHYRegDef[RF_PATH_A].rfTxGainStage = rFPGA0_TxGainStage; /* Tx gain stage */
-	pHalData->PHYRegDef[RF_PATH_B].rfTxGainStage = rFPGA0_TxGainStage; /* Tx gain stage */
-	pHalData->PHYRegDef[RF_PATH_C].rfTxGainStage = rFPGA0_TxGainStage; /* Tx gain stage */
-	pHalData->PHYRegDef[RF_PATH_D].rfTxGainStage = rFPGA0_TxGainStage; /* Tx gain stage */
-
-	/*  Tranceiver A~D HSSI Parameter-1 */
-	pHalData->PHYRegDef[RF_PATH_A].rfHSSIPara1 = rFPGA0_XA_HSSIParameter1;  /* wire control parameter1 */
-	pHalData->PHYRegDef[RF_PATH_B].rfHSSIPara1 = rFPGA0_XB_HSSIParameter1;  /* wire control parameter1 */
-
-	/*  Tranceiver A~D HSSI Parameter-2 */
-	pHalData->PHYRegDef[RF_PATH_A].rfHSSIPara2 = rFPGA0_XA_HSSIParameter2;  /* wire control parameter2 */
-	pHalData->PHYRegDef[RF_PATH_B].rfHSSIPara2 = rFPGA0_XB_HSSIParameter2;  /* wire control parameter2 */
-
-	/*  RF switch Control */
-	pHalData->PHYRegDef[RF_PATH_A].rfSwitchControl = rFPGA0_XAB_SwitchControl; /* TR/Ant switch control */
-	pHalData->PHYRegDef[RF_PATH_B].rfSwitchControl = rFPGA0_XAB_SwitchControl;
-	pHalData->PHYRegDef[RF_PATH_C].rfSwitchControl = rFPGA0_XCD_SwitchControl;
-	pHalData->PHYRegDef[RF_PATH_D].rfSwitchControl = rFPGA0_XCD_SwitchControl;
-
-	/*  AGC control 1 */
-	pHalData->PHYRegDef[RF_PATH_A].rfAGCControl1 = rOFDM0_XAAGCCore1;
-	pHalData->PHYRegDef[RF_PATH_B].rfAGCControl1 = rOFDM0_XBAGCCore1;
-	pHalData->PHYRegDef[RF_PATH_C].rfAGCControl1 = rOFDM0_XCAGCCore1;
-	pHalData->PHYRegDef[RF_PATH_D].rfAGCControl1 = rOFDM0_XDAGCCore1;
-
-	/*  AGC control 2 */
-	pHalData->PHYRegDef[RF_PATH_A].rfAGCControl2 = rOFDM0_XAAGCCore2;
-	pHalData->PHYRegDef[RF_PATH_B].rfAGCControl2 = rOFDM0_XBAGCCore2;
-	pHalData->PHYRegDef[RF_PATH_C].rfAGCControl2 = rOFDM0_XCAGCCore2;
-	pHalData->PHYRegDef[RF_PATH_D].rfAGCControl2 = rOFDM0_XDAGCCore2;
-
-	/*  RX AFE control 1 */
-	pHalData->PHYRegDef[RF_PATH_A].rfRxIQImbalance = rOFDM0_XARxIQImbalance;
-	pHalData->PHYRegDef[RF_PATH_B].rfRxIQImbalance = rOFDM0_XBRxIQImbalance;
-	pHalData->PHYRegDef[RF_PATH_C].rfRxIQImbalance = rOFDM0_XCRxIQImbalance;
-	pHalData->PHYRegDef[RF_PATH_D].rfRxIQImbalance = rOFDM0_XDRxIQImbalance;
-
-	/*  RX AFE control 1 */
-	pHalData->PHYRegDef[RF_PATH_A].rfRxAFE = rOFDM0_XARxAFE;
-	pHalData->PHYRegDef[RF_PATH_B].rfRxAFE = rOFDM0_XBRxAFE;
-	pHalData->PHYRegDef[RF_PATH_C].rfRxAFE = rOFDM0_XCRxAFE;
-	pHalData->PHYRegDef[RF_PATH_D].rfRxAFE = rOFDM0_XDRxAFE;
-
-	/*  Tx AFE control 1 */
-	pHalData->PHYRegDef[RF_PATH_A].rfTxIQImbalance = rOFDM0_XATxIQImbalance;
-	pHalData->PHYRegDef[RF_PATH_B].rfTxIQImbalance = rOFDM0_XBTxIQImbalance;
-	pHalData->PHYRegDef[RF_PATH_C].rfTxIQImbalance = rOFDM0_XCTxIQImbalance;
-	pHalData->PHYRegDef[RF_PATH_D].rfTxIQImbalance = rOFDM0_XDTxIQImbalance;
-
-	/*  Tx AFE control 2 */
-	pHalData->PHYRegDef[RF_PATH_A].rfTxAFE = rOFDM0_XATxAFE;
-	pHalData->PHYRegDef[RF_PATH_B].rfTxAFE = rOFDM0_XBTxAFE;
-	pHalData->PHYRegDef[RF_PATH_C].rfTxAFE = rOFDM0_XCTxAFE;
-	pHalData->PHYRegDef[RF_PATH_D].rfTxAFE = rOFDM0_XDTxAFE;
-
-	/*  Tranceiver LSSI Readback SI mode */
-	pHalData->PHYRegDef[RF_PATH_A].rfLSSIReadBack = rFPGA0_XA_LSSIReadBack;
-	pHalData->PHYRegDef[RF_PATH_B].rfLSSIReadBack = rFPGA0_XB_LSSIReadBack;
-	pHalData->PHYRegDef[RF_PATH_C].rfLSSIReadBack = rFPGA0_XC_LSSIReadBack;
-	pHalData->PHYRegDef[RF_PATH_D].rfLSSIReadBack = rFPGA0_XD_LSSIReadBack;
-
-	/*  Tranceiver LSSI Readback PI mode */
-	pHalData->PHYRegDef[RF_PATH_A].rfLSSIReadBackPi = TransceiverA_HSPI_Readback;
-	pHalData->PHYRegDef[RF_PATH_B].rfLSSIReadBackPi = TransceiverB_HSPI_Readback;
-}
-
 void storePwrIndexDiffRateOffset(struct adapter *Adapter, u32 RegAddr, u32 BitMask, u32 Data)
 {
 	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
@@ -514,77 +398,6 @@ void storePwrIndexDiffRateOffset(struct adapter *Adapter, u32 RegAddr, u32 BitMa
 	}
 }
 
-static	int phy_BB8188E_Config_ParaFile(struct adapter *Adapter)
-{
-	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(Adapter);
-	struct hal_data_8188e		*pHalData = GET_HAL_DATA(Adapter);
-	int			rtStatus = _SUCCESS;
-
-	/*  */
-	/*  1. Read PHY_REG.TXT BB INIT!! */
-	/*  We will separate as 88C / 92C according to chip version */
-	/*  */
-	if (HAL_STATUS_FAILURE == ODM_ConfigBBWithHeaderFile(&pHalData->odmpriv, CONFIG_BB_PHY_REG))
-		rtStatus = _FAIL;
-	if (rtStatus != _SUCCESS)
-		goto phy_BB8190_Config_ParaFile_Fail;
-
-	/*  2. If EEPROM or EFUSE autoload OK, We must config by PHY_REG_PG.txt */
-	if (!pEEPROM->bautoload_fail_flag) {
-		pHalData->pwrGroupCnt = 0;
-
-		if (HAL_STATUS_FAILURE == ODM_ConfigBBWithHeaderFile(&pHalData->odmpriv, CONFIG_BB_PHY_REG_PG))
-			rtStatus = _FAIL;
-	}
-
-	if (rtStatus != _SUCCESS)
-		goto phy_BB8190_Config_ParaFile_Fail;
-
-	/*  3. BB AGC table Initialization */
-	if (HAL_STATUS_FAILURE == ODM_ConfigBBWithHeaderFile(&pHalData->odmpriv,  CONFIG_BB_AGC_TAB))
-		rtStatus = _FAIL;
-
-	if (rtStatus != _SUCCESS)
-		goto phy_BB8190_Config_ParaFile_Fail;
-
-phy_BB8190_Config_ParaFile_Fail:
-
-	return rtStatus;
-}
-
-int
-PHY_BBConfig8188E(
-		struct adapter *Adapter
-	)
-{
-	int	rtStatus = _SUCCESS;
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-	u32 RegVal;
-	u8 CrystalCap;
-
-	phy_InitBBRFRegisterDefinition(Adapter);
-
-
-	/*  Enable BB and RF */
-	RegVal = usb_read16(Adapter, REG_SYS_FUNC_EN);
-	usb_write16(Adapter, REG_SYS_FUNC_EN, (u16)(RegVal|BIT13|BIT0|BIT1));
-
-	/*  20090923 Joseph: Advised by Steven and Jenyu. Power sequence before init RF. */
-
-	usb_write8(Adapter, REG_RF_CTRL, RF_EN|RF_RSTB|RF_SDMRSTB);
-
-	usb_write8(Adapter, REG_SYS_FUNC_EN, FEN_USBA | FEN_USBD | FEN_BB_GLB_RSTn | FEN_BBRSTB);
-
-	/*  Config BB and AGC */
-	rtStatus = phy_BB8188E_Config_ParaFile(Adapter);
-
-	/*  write 0x24[16:11] = 0x24[22:17] = CrystalCap */
-	CrystalCap = pHalData->CrystalCap & 0x3F;
-	PHY_SetBBReg(Adapter, REG_AFE_XTAL_CTRL, 0x7ff800, (CrystalCap | (CrystalCap << 6)));
-
-	return rtStatus;
-}
-
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
 			       u8 *ofdmPowerLevel, u8 *BW20PowerLevel,
 			       u8 *BW40PowerLevel)
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index efb3f7f..c5559df 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -760,15 +760,7 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 
 	rtl88e_phy_mac_config(Adapter);
 
-/* d. Initialize BB related configurations. */
-	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_BB);
-#if (HAL_BB_ENABLE == 1)
-	status = PHY_BBConfig8188E(Adapter);
-	if (status == _FAIL) {
-		DBG_88E(" ### Failed to init BB ......\n ");
-		goto exit;
-	}
-#endif
+	rtl88e_phy_bb_config(Adapter);
 
 	rtl88e_phy_rf_config(Adapter);
 
diff --git a/drivers/staging/rtl8188eu/include/HalHWImg8188E_BB.h b/drivers/staging/rtl8188eu/include/HalHWImg8188E_BB.h
deleted file mode 100644
index e574521..0000000
--- a/drivers/staging/rtl8188eu/include/HalHWImg8188E_BB.h
+++ /dev/null
@@ -1,44 +0,0 @@
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
-#ifndef __INC_BB_8188E_HW_IMG_H
-#define __INC_BB_8188E_HW_IMG_H
-
-/* static bool CheckCondition(const u32 Condition, const u32 Hex); */
-
-/******************************************************************************
-*                           AGC_TAB_1T.TXT
-******************************************************************************/
-
-enum HAL_STATUS ODM_ReadAndConfig_AGC_TAB_1T_8188E(struct odm_dm_struct *odm);
-
-/******************************************************************************
-*                           PHY_REG_1T.TXT
-******************************************************************************/
-
-enum HAL_STATUS ODM_ReadAndConfig_PHY_REG_1T_8188E(struct odm_dm_struct *odm);
-
-/******************************************************************************
-*                           PHY_REG_PG.TXT
-******************************************************************************/
-
-void ODM_ReadAndConfig_PHY_REG_PG_8188E(struct odm_dm_struct *dm_odm);
-
-#endif
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 2b3e51b..683c5bd 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -46,8 +46,6 @@
 
 #include "odm_reg.h"
 
-#include "HalHWImg8188E_BB.h"
-
 #include "odm_RegConfig8188E.h"
 #include "odm_RTL8188E.h"
 
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index 254d418..676a66c 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -1,2 +1,3 @@
 bool rtl88e_phy_mac_config(struct adapter *adapt);
 bool rtl88e_phy_rf_config(struct adapter *adapt);
+bool rtl88e_phy_bb_config(struct adapter *adapt);
-- 
1.7.10.4

