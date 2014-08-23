Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaHWOT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:19:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33871 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHWOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:19:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/20] staging: rtl8188eu: Rework function phy_RFSerialRead()
Date: Sat, 23 Aug 2014 19:48:27 +0530
Message-Id: <1408803521-13715-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   99 ++++++++---------------
 1 file changed, 34 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 752ca42..ef1082f 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -64,81 +64,50 @@ void phy_set_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask, u32 data)
 	usb_write32(adapt, regaddr, data);
 }
 
-/*  */
-/*  2. RF register R/W API */
-/*  */
-/**
-* Function:	phy_RFSerialRead
-*
-* OverView:	Read regster from RF chips
-*
-* Input:
-*			struct adapter *Adapter,
-*			enum rf_radio_path eRFPath,	Radio path of A/B/C/D
-*			u32			Offset,		The target address to be read
-*
-* Output:	None
-* Return:		u32			reback value
-* Note:		Threre are three types of serial operations:
-*			1. Software serial write
-*			2. Hardware LSSI-Low Speed Serial Interface
-*			3. Hardware HSSI-High speed
-*			serial write. Driver need to implement (1) and (2).
-*			This function is equal to the combination of RF_ReadReg() and  RFLSSIRead()
-*/
-static	u32
-phy_RFSerialRead(
-		struct adapter *Adapter,
-		enum rf_radio_path eRFPath,
-		u32 Offset
-	)
+static u32 rf_serial_read(struct adapter *adapt,
+			enum rf_radio_path rfpath, u32 offset)
 {
-	u32 retValue = 0;
-	struct hal_data_8188e				*pHalData = GET_HAL_DATA(Adapter);
-	struct bb_reg_def *pPhyReg = &pHalData->PHYRegDef[eRFPath];
-	u32 NewOffset;
+	u32 ret = 0;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	struct bb_reg_def *phyreg = &hal_data->PHYRegDef[rfpath];
+	u32 newoffset;
 	u32 tmplong, tmplong2;
-	u8 	RfPiEnable = 0;
-	/*  */
-	/*  Make sure RF register offset is correct */
-	/*  */
-	Offset &= 0xff;
+	u8 rfpi_enable = 0;
 
-	/*  */
-	/*  Switch page for 8256 RF IC */
-	/*  */
-	NewOffset = Offset;
+	offset &= 0xff;
+	newoffset = offset;
 
-	/*  For 92S LSSI Read RFLSSIRead */
-	/*  For RF A/B write 0x824/82c(does not work in the future) */
-	/*  We must use 0x824 for RF A and B to execute read trigger */
-	tmplong = phy_query_bb_reg(Adapter, rFPGA0_XA_HSSIParameter2, bMaskDWord);
-	if (eRFPath == RF_PATH_A)
+	tmplong = phy_query_bb_reg(adapt, rFPGA0_XA_HSSIParameter2, bMaskDWord);
+	if (rfpath == RF_PATH_A)
 		tmplong2 = tmplong;
 	else
-		tmplong2 = phy_query_bb_reg(Adapter, pPhyReg->rfHSSIPara2, bMaskDWord);
+		tmplong2 = phy_query_bb_reg(adapt, phyreg->rfHSSIPara2,
+					    bMaskDWord);
 
-	tmplong2 = (tmplong2 & (~bLSSIReadAddress)) | (NewOffset<<23) | bLSSIReadEdge;	/* T65 RF */
+	tmplong2 = (tmplong2 & (~bLSSIReadAddress)) |
+		   (newoffset<<23) | bLSSIReadEdge;
 
-	phy_set_bb_reg(Adapter, rFPGA0_XA_HSSIParameter2, bMaskDWord, tmplong&(~bLSSIReadEdge));
-	udelay(10);/*  PlatformStallExecution(10); */
+	phy_set_bb_reg(adapt, rFPGA0_XA_HSSIParameter2, bMaskDWord,
+		       tmplong&(~bLSSIReadEdge));
+	udelay(10);
 
-	phy_set_bb_reg(Adapter, pPhyReg->rfHSSIPara2, bMaskDWord, tmplong2);
-	udelay(100);/* PlatformStallExecution(100); */
+	phy_set_bb_reg(adapt, phyreg->rfHSSIPara2, bMaskDWord, tmplong2);
+	udelay(100);
 
-	udelay(10);/* PlatformStallExecution(10); */
+	udelay(10);
 
-	if (eRFPath == RF_PATH_A)
-		RfPiEnable = (u8)phy_query_bb_reg(Adapter, rFPGA0_XA_HSSIParameter1, BIT8);
-	else if (eRFPath == RF_PATH_B)
-		RfPiEnable = (u8)phy_query_bb_reg(Adapter, rFPGA0_XB_HSSIParameter1, BIT8);
+	if (rfpath == RF_PATH_A)
+		rfpi_enable = (u8)phy_query_bb_reg(adapt, rFPGA0_XA_HSSIParameter1, BIT8);
+	else if (rfpath == RF_PATH_B)
+		rfpi_enable = (u8)phy_query_bb_reg(adapt, rFPGA0_XB_HSSIParameter1, BIT8);
 
-	if (RfPiEnable) {	/*  Read from BBreg8b8, 12 bits for 8190, 20bits for T65 RF */
-		retValue = phy_query_bb_reg(Adapter, pPhyReg->rfLSSIReadBackPi, bLSSIReadBackData);
-	} else {	/* Read from BBreg8a0, 12 bits for 8190, 20 bits for T65 RF */
-		retValue = phy_query_bb_reg(Adapter, pPhyReg->rfLSSIReadBack, bLSSIReadBackData);
-	}
-	return retValue;
+	if (rfpi_enable)
+		ret = phy_query_bb_reg(adapt, phyreg->rfLSSIReadBackPi,
+				       bLSSIReadBackData);
+	else
+		ret = phy_query_bb_reg(adapt, phyreg->rfLSSIReadBack,
+				       bLSSIReadBackData);
+	return ret;
 }
 
 /**
@@ -239,7 +208,7 @@ u32 rtl8188e_PHY_QueryRFReg(struct adapter *Adapter, enum rf_radio_path eRFPath,
 {
 	u32 Original_Value, Readback_Value, BitShift;
 
-	Original_Value = phy_RFSerialRead(Adapter, eRFPath, RegAddr);
+	Original_Value = rf_serial_read(Adapter, eRFPath, RegAddr);
 
 	BitShift =  cal_bit_shift(BitMask);
 	Readback_Value = (Original_Value & BitMask) >> BitShift;
@@ -277,7 +246,7 @@ rtl8188e_PHY_SetRFReg(
 
 	/*  RF data is 12 bits only */
 	if (BitMask != bRFRegOffsetMask) {
-		Original_Value = phy_RFSerialRead(Adapter, eRFPath, RegAddr);
+		Original_Value = rf_serial_read(Adapter, eRFPath, RegAddr);
 		BitShift =  cal_bit_shift(BitMask);
 		Data = ((Original_Value & (~BitMask)) | (Data << BitShift));
 	}
-- 
1.7.10.4

