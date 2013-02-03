Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3BCDFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:05:30 -0500
Received: from mout.gmx.net ([212.227.15.18]:57144 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3BCDFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:05:04 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/H3FlS1fvHkHiyxBU7X9fmjgpKPZis5xoO1uxEC5
	Ss7US8XAO6SDya
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging/xgifb: Remove unused variable and dead assignment
Date: Sun,  3 Feb 2013 04:08:43 +0100
Message-Id: <1359860926-27769-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
References: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modeflag is unused in XGI_SetSeqRegs, XGI_GetTVInfo,
  XGI_SetLCDRegs, XGI_GetRatePtrCRT2 -> remove

resinfo is unused in XGI_PreSetGroup1, XGI_SetGroup1, XGI_SetGroup2,
  XGI_SetLCDRegs -> remove

push1,push2 are unused in XGI_SetLCDRegs -> remove

CRT1Index is unused in XGI_PreSetGroup1, XGI_SetLockRegs,
  XGI_SetLCDRegs -> remove

tempcx in XGI_PreSetGroup1 only holds the values 4,5,6
  -> change its type to u8

crt2crtc is unused in XGI_SetGroup2 -> remove

CRT2Index is unused in XGI_GetVCLK2Ptr -> remove.

Assignment to i is dead in XGI_SetSeqRegs since it is not used before
  the next assignment -> remove the dead assignment.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   46 ++++++++----------------------------
 1 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index a7fb52f..10b9cb6 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -65,14 +65,11 @@ static void XGI_SetSeqRegs(unsigned short ModeNo,
 			   struct vb_device_info *pVBInfo)
 {
 	unsigned char tempah, SRdata;
-	unsigned short i, modeflag;
-
-	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+	unsigned short i;
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x00, 0x03); /* Set SR0 */
 	tempah = XGI330_StandTable.SR[0];
 
-	i = XGI_SetCRT2ToLCDA;
 	if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
 		tempah |= 0x01;
 	} else if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD)) {
@@ -877,16 +874,12 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeNo,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short CRT2Index, VCLKIndex;
-	unsigned short modeflag, resinfo;
+	unsigned short VCLKIndex, modeflag;
 
 	/* si+Ext_ResInfo */
 	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-	CRT2Index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
 
 	if (pVBInfo->IF_DEF_LVDS == 0) {
-		CRT2Index = CRT2Index >> 6; /*  for LCD */
 		if (pVBInfo->VBInfo &
 		    (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) { /*301b*/
 			if (pVBInfo->LCDResInfo != Panel_1024x768)
@@ -2290,13 +2283,12 @@ static void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 static unsigned char XGI_GetLCDInfo(unsigned short ModeNo,
 		unsigned short ModeIdIndex, struct vb_device_info *pVBInfo)
 {
-	unsigned short temp, tempax, tempbx, modeflag, resinfo = 0, LCDIdIndex;
+	unsigned short temp, tempax, tempbx, resinfo = 0, LCDIdIndex;
 
 	pVBInfo->LCDResInfo = 0;
 	pVBInfo->LCDTypeInfo = 0;
 	pVBInfo->LCDInfo = 0;
 
-	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 	/* si+Ext_ResInfo // */
 	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	temp = xgifb_reg_get(pVBInfo->P3d4, 0x36); /* Get LCD Res.Info */
@@ -3019,11 +3011,7 @@ static void XGI_PreSetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short tempcx = 0, CRT1Index = 0, resinfo = 0;
-
-	CRT1Index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
-	CRT1Index &= IndexMask;
-	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
+	u8 tempcx;
 
 	XGI_SetCRT2Offset(ModeNo, ModeIdIndex, RefreshRateTableIndex,
 			HwDeviceExtension, pVBInfo);
@@ -3042,11 +3030,10 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short temp = 0, tempax = 0, tempbx = 0, tempcx = 0,
-			pushbx = 0, CRT1Index = 0, modeflag, resinfo = 0;
+			pushbx = 0, CRT1Index, modeflag;
 
 	CRT1Index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
 	CRT1Index &= IndexMask;
-	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
 	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 
 	/* bainy change table name */
@@ -3201,13 +3188,11 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short push1, push2, tempax, tempbx = 0, tempcx, temp, resinfo,
-			modeflag, CRT1Index;
+			modeflag;
 
 	/* si+Ext_ResInfo */
 	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-	CRT1Index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
-	CRT1Index &= IndexMask;
 
 	if (!(pVBInfo->VBInfo & SetInSlaveMode))
 		return;
@@ -3498,15 +3483,13 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
 	unsigned short i, j, tempax, tempbx, tempcx, temp, push1, push2,
-			modeflag, resinfo, crt2crtc;
+			modeflag;
 	unsigned char const *TimingPoint;
 
 	unsigned long longtemp, tempeax, tempebx, temp2, tempecx;
 
 	/* si+Ext_ResInfo */
 	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-	crt2crtc = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
 
 	tempax = 0;
 
@@ -3937,17 +3920,12 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RefreshRateTableIndex,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short push1, push2, pushbx, tempax, tempbx, tempcx, temp,
-			tempah, tempbh, tempch, resinfo, modeflag, CRT1Index;
+	unsigned short pushbx, tempax, tempbx, tempcx, temp, tempah,
+			tempbh, tempch;
 
 	struct XGI_LCDDesStruct const *LCDBDesPtr = NULL;
 
 	/* si+Ext_ResInfo */
-	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
-	resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-	CRT1Index = XGI330_RefIndex[RefreshRateTableIndex].Ext_CRT1CRTC;
-	CRT1Index &= IndexMask;
-
 	if (!(pVBInfo->VBInfo & SetCRT2ToLCD))
 		return;
 
@@ -3966,7 +3944,6 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	xgifb_reg_set(pVBInfo->Part2Port, 0x0B, temp);
 	tempbx = pVBInfo->VDE; /* RTVACTEO=(VDE-1)&0xFF */
-	push1 = tempbx;
 	tempbx--;
 	temp = tempbx & 0x00FF;
 	xgifb_reg_set(pVBInfo->Part2Port, 0x03, temp);
@@ -3974,7 +3951,6 @@ static void XGI_SetLCDRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0C, ~0x07, temp);
 
 	tempcx = pVBInfo->VT - 1;
-	push2 = tempcx + 1;
 	temp = tempcx & 0x00FF; /* RVTVT=VT-1 */
 	xgifb_reg_set(pVBInfo->Part2Port, 0x19, temp);
 	temp = (tempcx & 0xFF00) >> 8;
@@ -5511,9 +5487,7 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 			LCDARefreshIndex[] = { 0x00, 0x00, 0x03, 0x01, 0x01,
 					0x01, 0x01 };
 
-	unsigned short RefreshRateTableIndex, i, modeflag, index, temp;
-
-	modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
+	unsigned short RefreshRateTableIndex, i, index, temp;
 
 	index = xgifb_reg_get(pVBInfo->P3d4, 0x33);
 	index = index >> pVBInfo->SelectCRT2Rate;
-- 
1.7.8.6

