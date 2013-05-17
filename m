Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3EQWPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:15:09 -0400
Received: from mout.gmx.net ([212.227.15.19]:64988 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094Ab3EQWPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:15:00 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18fSiwFqaYf6rJa3LWlWsYFgcf7fBR788azvYZvGn
	8ztJLhlR9iw+jq
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/xgifb: Remove dead assignments/increments
Date: Sat, 18 May 2013 00:19:54 +0200
Message-Id: <1368829194-16677-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code now contains several dead assignments which are shadowed by
another assignment a few lines later.

-> This patch removes them (and possibly associated code).

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---

The patch did not remove occurences where a register from the device is read.
If the device does not have implicit actions associated with reading from its
registers these instances could also be removed.

 drivers/staging/xgifb/vb_init.c    |  1 -
 drivers/staging/xgifb/vb_setmode.c | 20 +-------------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 090c424..5c72104 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1296,7 +1296,6 @@ unsigned char XGIInitNew(struct pci_dev *pdev)
 		xgifb_reg_set(pVBInfo->Part1Port, 0x00, 0x00);
 		/* chk if BCLK>=100MHz */
 		temp1 = xgifb_reg_get(pVBInfo->P3d4, 0x7B);
-		temp = (unsigned char) ((temp1 >> 4) & 0x0F);
 
 		xgifb_reg_set(pVBInfo->Part1Port,
 			      0x02, XGI330_CRT2Data_1_2);
diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 5fb699d..bee4b38 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -759,7 +759,6 @@ static void XGI_SetCRT1DE(struct xgi_hw_device_info *HwDeviceExtension,
 
 	xgifb_reg_and_or(pVBInfo->P3d4, 0x07, ~0x42, tempax);
 	data = xgifb_reg_get(pVBInfo->P3d4, 0x07);
-	data &= 0xFF;
 	tempax = 0;
 
 	if (tempbx & 0x04)
@@ -1589,10 +1588,8 @@ static void XGI_SetLVDSRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	xgifb_reg_and_or(pVBInfo->Part1Port, 0x1a, 0x07,
 				tempax);
 
-	tempcx = pVBInfo->VGAVT;
 	tempbx = pVBInfo->VDE;
 	tempax = pVBInfo->VGAVDE;
-	tempcx -= tempax;
 
 	temp = tempax; /* 0430 ylshieh */
 	temp1 = (temp << 18) / tempbx;
@@ -2657,10 +2654,7 @@ static void XGI_GetCRT2Data(unsigned short ModeNo, unsigned short ModeIdIndex,
 					tempbx = 775;
 				else if (pVBInfo->VGAVDE == 600)
 					tempbx = 775;
-				else
-					tempbx = 768;
-			} else
-				tempbx = 768;
+			}
 		} else if (pVBInfo->LCDResInfo == Panel_1024x768x75) {
 			tempax = 1024;
 			tempbx = 768;
@@ -3015,9 +3009,6 @@ static void XGI_SetGroup1(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp |= ((tempcx & 0xFF00) >> 8);
 	xgifb_reg_set(pVBInfo->Part1Port, 0x12, temp);
 
-	tempax = pVBInfo->VGAVDE;
-	tempbx = pVBInfo->VGAVDE;
-	tempcx = pVBInfo->VGAVT;
 	/* BTVGA2VRS 0x10,0x11 */
 	tempbx = (pVBInfo->VGAVT + pVBInfo->VGAVDE) >> 1;
 	/* BTVGA2VRE 0x11 */
@@ -3226,7 +3217,6 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 		}
 	}
 	tempbx--;
-	temp = tempbx & 0x00FF;
 	tempbx--;
 	temp = tempbx & 0x00FF;
 	/* 0x10 vertical Blank Start */
@@ -3445,9 +3435,6 @@ static void XGI_SetGroup2(unsigned short ModeNo, unsigned short ModeIdIndex,
 	temp &= 0x80;
 	xgifb_reg_and_or(pVBInfo->Part2Port, 0x0A, 0xFF, temp);
 
-	if (pVBInfo->VBInfo & SetCRT2ToHiVision)
-		tempax = 950;
-
 	if (pVBInfo->TVInfo & TVSetPAL)
 		tempax = 520;
 	else
@@ -4211,11 +4198,6 @@ static void XGI_SetGroup4(unsigned short ModeNo, unsigned short ModeIdIndex,
 
 	tempebx = pVBInfo->VDE;
 
-	if (tempcx & SetCRT2ToHiVision) {
-		if (!(temp & 0xE000))
-			tempbx = tempbx >> 1;
-	}
-
 	tempcx = pVBInfo->RVBHRS;
 	temp = tempcx & 0x00FF;
 	xgifb_reg_set(pVBInfo->Part4Port, 0x18, temp);
-- 
1.8.1.5

