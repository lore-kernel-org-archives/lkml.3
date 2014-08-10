Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaHJOpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:45:18 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57144 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHJOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:45:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/22] staging: rtl8188eu: Cleanup and simplify MAC configuration code
Date: Sun, 10 Aug 2014 20:14:15 +0530
Message-Id: <1407681875-2611-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c  |  120 ++------------------
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |    7 --
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   37 ------
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   15 +--
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    1 -
 .../staging/rtl8188eu/include/HalHWImg8188E_MAC.h  |   30 -----
 drivers/staging/rtl8188eu/include/odm_HWConfig.h   |    2 -
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    1 -
 drivers/staging/rtl8188eu/include/phy.h            |    1 +
 9 files changed, 15 insertions(+), 199 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_MAC.h
 create mode 100644 drivers/staging/rtl8188eu/include/phy.h

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
index b49b5ab..ccca6a4 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
@@ -21,36 +21,7 @@
 #include "odm_precomp.h"
 #include <rtw_iol.h>
 
-static bool Checkcondition(const u32  condition, const u32  hex)
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
-
-/******************************************************************************
-*                           MAC_REG.TXT
-******************************************************************************/
+/* MAC_REG.TXT */
 
 static u32 array_MAC_REG_8188E[] = {
 		0x026, 0x00000041,
@@ -145,87 +116,18 @@ static u32 array_MAC_REG_8188E[] = {
 		0x70B, 0x00000087,
 };
 
-enum HAL_STATUS ODM_ReadAndConfig_MAC_REG_8188E(struct odm_dm_struct *dm_odm)
+bool rtl88e_phy_mac_config(struct adapter *adapt)
 {
-	#define READ_NEXT_PAIR(v1, v2, i) do { i += 2; v1 = array[i]; v2 = array[i+1]; } while (0)
-
-	u32     hex         = 0;
-	u32     i;
-	u8     platform    = dm_odm->SupportPlatform;
-	u8     interface_val   = dm_odm->SupportInterface;
-	u8     board       = dm_odm->BoardType;
-	u32     array_len    = sizeof(array_MAC_REG_8188E)/sizeof(u32);
-	u32    *array       = array_MAC_REG_8188E;
-	bool	biol = false;
+	u32 i;
+	u32 arraylength;
+	u32 *ptrarray;
 
-	struct adapter *adapt =  dm_odm->Adapter;
-	struct xmit_frame	*pxmit_frame = NULL;
-	u8 bndy_cnt = 1;
-	enum HAL_STATUS rst = HAL_STATUS_SUCCESS;
-	hex += board;
-	hex += interface_val << 8;
-	hex += platform << 16;
-	hex += 0xFF000000;
+	arraylength = sizeof(array_MAC_REG_8188E)/sizeof(u32);
+	ptrarray = array_MAC_REG_8188E;
 
-	biol = rtw_IOL_applied(adapt);
+	for (i = 0; i < arraylength; i = i + 2)
+		usb_write8(adapt, ptrarray[i], (u8) ptrarray[i + 1]);
 
-	if (biol) {
-		pxmit_frame = rtw_IOL_accquire_xmit_frame(adapt);
-		if (pxmit_frame == NULL) {
-			pr_info("rtw_IOL_accquire_xmit_frame failed\n");
-			return HAL_STATUS_FAILURE;
-		}
-	}
-
-	for (i = 0; i < array_len; i += 2) {
-		u32 v1 = array[i];
-		u32 v2 = array[i+1];
-
-		/*  This (offset, data) pair meets the condition. */
-		if (v1 < 0xCDCDCDCD) {
-				if (biol) {
-					if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-						bndy_cnt++;
-					rtw_IOL_append_WB_cmd(pxmit_frame, (u16)v1, (u8)v2, 0xFF);
-				} else {
-					odm_ConfigMAC_8188E(dm_odm, v1, (u8)v2);
-				}
-				continue;
-		} else { /*  This line is the start line of branch. */
-			if (!Checkcondition(array[i], hex)) {
-				/*  Discard the following (offset, data) pairs. */
-				READ_NEXT_PAIR(v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < array_len - 2) {
-					READ_NEXT_PAIR(v1, v2, i);
-				}
-				i -= 2; /*  prevent from for-loop += 2 */
-			} else { /*  Configure matched pairs and skip to end of if-else. */
-				READ_NEXT_PAIR(v1, v2, i);
-				while (v2 != 0xDEAD &&
-				       v2 != 0xCDEF &&
-				       v2 != 0xCDCD && i < array_len - 2) {
-					if (biol) {
-						if (rtw_IOL_cmd_boundary_handle(pxmit_frame))
-							bndy_cnt++;
-						rtw_IOL_append_WB_cmd(pxmit_frame, (u16)v1, (u8)v2, 0xFF);
-					} else {
-						odm_ConfigMAC_8188E(dm_odm, v1, (u8)v2);
-					}
-
-					READ_NEXT_PAIR(v1, v2, i);
-				}
-				while (v2 != 0xDEAD && i < array_len - 2)
-					READ_NEXT_PAIR(v1, v2, i);
-			}
-		}
-	}
-	if (biol) {
-		if (!rtw_IOL_exec_cmds_sync(dm_odm->Adapter, pxmit_frame, 1000, bndy_cnt)) {
-			pr_info("~~~ MAC IOL_exec_cmds Failed !!!\n");
-			rst = HAL_STATUS_FAILURE;
-		}
-	}
-	return rst;
+	usb_write8(adapt, REG_MAX_AGGR_NUM, MAX_AGGR_NUM);
+	return true;
 }
diff --git a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
index f2e1d02..5cd0057 100644
--- a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
+++ b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
@@ -460,10 +460,3 @@ enum HAL_STATUS ODM_ConfigBBWithHeaderFile(struct odm_dm_struct *dm_odm,
 	}
 	return HAL_STATUS_SUCCESS;
 }
-
-enum HAL_STATUS ODM_ConfigMACWithHeaderFile(struct odm_dm_struct *dm_odm)
-{
-	u8 result = HAL_STATUS_SUCCESS;
-	result = READ_AND_CONFIG(8188E, _MAC_REG_);
-	return result;
-}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 9f016a5..922d400 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -354,43 +354,6 @@ rtl8188e_PHY_SetRFReg(
 	phy_RFSerialWrite(Adapter, eRFPath, RegAddr, Data);
 }
 
-/*  */
-/*  3. Initial MAC/BB/RF config by reading MAC/BB/RF txt. */
-/*  */
-
-/*-----------------------------------------------------------------------------
- * Function:    PHY_MACConfig8192C
- *
- * Overview:	Condig MAC by header file or parameter file.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- *  When		Who		Remark
- *  08/12/2008	MHC		Create Version 0.
- *
- *---------------------------------------------------------------------------*/
-s32 PHY_MACConfig8188E(struct adapter *Adapter)
-{
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-	int rtStatus = _SUCCESS;
-
-	/*  */
-	/*  Config MAC */
-	/*  */
-	if (HAL_STATUS_FAILURE == ODM_ConfigMACWithHeaderFile(&pHalData->odmpriv))
-		rtStatus = _FAIL;
-
-	/*  2010.07.13 AMPDU aggregation number B */
-	usb_write16(Adapter, REG_MAX_AGGR_NUM, MAX_AGGR_NUM);
-
-	return rtStatus;
-}
-
 /**
 * Function:	phy_InitBBRFRegisterDefinition
 *
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 42541c5..46d92b1 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -27,8 +27,8 @@
 #include <rtl8188e_led.h>
 #include <rtw_iol.h>
 #include <usb_hal.h>
+#include <phy.h>
 
-#define		HAL_MAC_ENABLE	1
 #define		HAL_BB_ENABLE		1
 #define		HAL_RF_ENABLE		1
 
@@ -759,18 +759,9 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	}
 	rtl8188e_InitializeFirmwareVars(Adapter);
 
-	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_MAC);
-#if (HAL_MAC_ENABLE == 1)
-	status = PHY_MACConfig8188E(Adapter);
-	if (status == _FAIL) {
-		DBG_88E(" ### Failed to init MAC ......\n ");
-		goto exit;
-	}
-#endif
+	rtl88e_phy_mac_config(Adapter);
 
-	/*  */
-	/* d. Initialize BB related configurations. */
-	/*  */
+/* d. Initialize BB related configurations. */
 	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_BB);
 #if (HAL_BB_ENABLE == 1)
 	status = PHY_BBConfig8188E(Adapter);
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 260ea6b..ed156d3 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -208,7 +208,6 @@ void rtl8188e_PHY_SetRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
 
 /*  Initialization related function */
 /* MAC/BB/RF HAL config */
-int PHY_MACConfig8188E(struct adapter *adapter);
 int PHY_BBConfig8188E(struct adapter *adapter);
 int PHY_RFConfig8188E(struct adapter *adapter);
 
diff --git a/drivers/staging/rtl8188eu/include/HalHWImg8188E_MAC.h b/drivers/staging/rtl8188eu/include/HalHWImg8188E_MAC.h
deleted file mode 100644
index acf78b9..0000000
--- a/drivers/staging/rtl8188eu/include/HalHWImg8188E_MAC.h
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
-#ifndef __INC_MAC_8188E_HW_IMG_H
-#define __INC_MAC_8188E_HW_IMG_H
-
-/******************************************************************************
-*                           MAC_REG.TXT
-******************************************************************************/
-
-enum HAL_STATUS ODM_ReadAndConfig_MAC_REG_8188E(struct odm_dm_struct *pDM_Odm);
-
-#endif /*  end of HWIMG_SUPPORT */
diff --git a/drivers/staging/rtl8188eu/include/odm_HWConfig.h b/drivers/staging/rtl8188eu/include/odm_HWConfig.h
index 49e7e16..a687d17 100644
--- a/drivers/staging/rtl8188eu/include/odm_HWConfig.h
+++ b/drivers/staging/rtl8188eu/include/odm_HWConfig.h
@@ -127,6 +127,4 @@ enum HAL_STATUS ODM_ConfigRFWithHeaderFile(struct odm_dm_struct *pDM_Odm,
 enum HAL_STATUS ODM_ConfigBBWithHeaderFile(struct odm_dm_struct *pDM_Odm,
 					   enum odm_bb_config_type ConfigType);
 
-enum HAL_STATUS ODM_ConfigMACWithHeaderFile(struct odm_dm_struct *pDM_Odm);
-
 #endif
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index 0ab8254..7b98be5 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -46,7 +46,6 @@
 
 #include "odm_reg.h"
 
-#include "HalHWImg8188E_MAC.h"
 #include "HalHWImg8188E_RF.h"
 #include "HalHWImg8188E_BB.h"
 
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
new file mode 100644
index 0000000..cab4c8e
--- /dev/null
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -0,0 +1 @@
+bool rtl88e_phy_mac_config(struct adapter *adapt);
-- 
1.7.10.4

