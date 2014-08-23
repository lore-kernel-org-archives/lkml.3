Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaHWOUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47385 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHWOUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:02 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/20] staging: rtl8188eu: Rework function phy_RFSerialWrite()
Date: Sat, 23 Aug 2014 19:48:28 +0530
Message-Id: <1408803521-13715-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   85 +++--------------------
 1 file changed, 11 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index ef1082f..2cbaff5 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -110,81 +110,18 @@ static u32 rf_serial_read(struct adapter *adapt,
 	return ret;
 }
 
-/**
-* Function:	phy_RFSerialWrite
-*
-* OverView:	Write data to RF register (page 8~)
-*
-* Input:
-*			struct adapter *Adapter,
-*			enum rf_radio_path eRFPath,	Radio path of A/B/C/D
-*			u32			Offset,		The target address to be read
-*			u32			Data		The new register Data in the target bit position
-*									of the target to be read
-*
-* Output:	None
-* Return:		None
-* Note:		Threre are three types of serial operations:
-*			1. Software serial write
-*			2. Hardware LSSI-Low Speed Serial Interface
-*			3. Hardware HSSI-High speed
-*			serial write. Driver need to implement (1) and (2).
-*			This function is equal to the combination of RF_ReadReg() and  RFLSSIRead()
- *
- * Note:		  For RF8256 only
- *			 The total count of RTL8256(Zebra4) register is around 36 bit it only employs
- *			 4-bit RF address. RTL8256 uses "register mode control bit" (Reg00[12], Reg00[10])
- *			 to access register address bigger than 0xf. See "Appendix-4 in PHY Configuration
- *			 programming guide" for more details.
- *			 Thus, we define a sub-finction for RTL8526 register address conversion
- *		       ===========================================================
- *			 Register Mode		RegCTL[1]		RegCTL[0]		Note
- *								(Reg00[12])		(Reg00[10])
- *		       ===========================================================
- *			 Reg_Mode0				0				x			Reg 0 ~15(0x0 ~ 0xf)
- *		       ------------------------------------------------------------------
- *			 Reg_Mode1				1				0			Reg 16 ~30(0x1 ~ 0xf)
- *		       ------------------------------------------------------------------
- *			 Reg_Mode2				1				1			Reg 31 ~ 45(0x1 ~ 0xf)
- *		       ------------------------------------------------------------------
- *
- *	2008/09/02	MH	Add 92S RF definition
- *
- *
- *
-*/
-static	void
-phy_RFSerialWrite(
-		struct adapter *Adapter,
-		enum rf_radio_path eRFPath,
-		u32 Offset,
-		u32 Data
-	)
+static void rf_serial_write(struct adapter *adapt,
+			    enum rf_radio_path rfpath, u32 offset,
+			    u32 data)
 {
-	u32 DataAndAddr = 0;
-	struct hal_data_8188e				*pHalData = GET_HAL_DATA(Adapter);
-	struct bb_reg_def *pPhyReg = &pHalData->PHYRegDef[eRFPath];
-	u32 NewOffset;
-
-
-	/*  2009/06/17 MH We can not execute IO for power save or other accident mode. */
-
-	Offset &= 0xff;
-
-	/*  */
-	/*  Switch page for 8256 RF IC */
-	/*  */
-	NewOffset = Offset;
-
-	/*  */
-	/*  Put write addr in [5:0]  and write data in [31:16] */
-	/*  */
-	DataAndAddr = ((NewOffset<<20) | (Data&0x000fffff)) & 0x0fffffff;	/*  T65 RF */
+	u32 data_and_addr = 0;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	struct bb_reg_def *phyreg = &hal_data->PHYRegDef[rfpath];
+	u32 newoffset;
 
-	/*  */
-	/*  Write Operation */
-	/*  */
-	phy_set_bb_reg(Adapter, pPhyReg->rf3wireOffset, bMaskDWord, DataAndAddr);
+	newoffset = offset & 0xff;
+	data_and_addr = ((newoffset<<20) | (data&0x000fffff)) & 0x0fffffff;
+	phy_set_bb_reg(adapt, phyreg->rf3wireOffset, bMaskDWord, data_and_addr);
 }
 
 /**
@@ -251,7 +188,7 @@ rtl8188e_PHY_SetRFReg(
 		Data = ((Original_Value & (~BitMask)) | (Data << BitShift));
 	}
 
-	phy_RFSerialWrite(Adapter, eRFPath, RegAddr, Data);
+	rf_serial_write(Adapter, eRFPath, RegAddr, Data);
 }
 
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
-- 
1.7.10.4

