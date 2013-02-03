Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3BCDF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:05:27 -0500
Received: from mout.gmx.net ([212.227.17.20]:50865 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab3BCDFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:05:08 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1++BuRDqe6+knK8nmMCMB64415fpcZzw3008atRCL
	P/xgZ09IHt9chG
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging/xgifb: Remove redundant if statement
Date: Sun,  3 Feb 2013 04:08:45 +0100
Message-Id: <1359860926-27769-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
References: <1359860926-27769-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code checks twice for if (pVBInfo->VBInfo & SetCRT2ToTV) without any
changes in between -> we can remove the second check.
And while at it we can also save the temp variable and use tempbx
directly.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   34 ++++++++++++++--------------------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 2e7277e..93f5d46 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -2197,31 +2197,25 @@ static void XGI_GetVBInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 static void XGI_GetTVInfo(unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short temp, tempbx = 0, resinfo = 0, modeflag, index1;
-
-	tempbx = 0;
-	resinfo = 0;
+	unsigned short tempbx = 0, resinfo = 0, modeflag, index1;
 
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
 		modeflag = XGI330_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
 		resinfo = XGI330_EModeIDTable[ModeIdIndex].Ext_RESINFO;
 
-		if (pVBInfo->VBInfo & SetCRT2ToTV) {
-			temp = xgifb_reg_get(pVBInfo->P3d4, 0x35);
-			tempbx = temp;
-			if (tempbx & TVSetPAL) {
-				tempbx &= (SetCHTVOverScan |
-					   TVSetPALM |
-					   TVSetPALN |
-					   TVSetPAL);
-				if (tempbx & TVSetPALM)
-					/* set to NTSC if PAL-M */
-					tempbx &= ~TVSetPAL;
-			} else
-				tempbx &= (SetCHTVOverScan |
-					   TVSetNTSCJ |
-					   TVSetPAL);
-		}
+		tempbx = xgifb_reg_get(pVBInfo->P3d4, 0x35);
+		if (tempbx & TVSetPAL) {
+			tempbx &= (SetCHTVOverScan |
+				   TVSetPALM |
+				   TVSetPALN |
+				   TVSetPAL);
+			if (tempbx & TVSetPALM)
+				/* set to NTSC if PAL-M */
+				tempbx &= ~TVSetPAL;
+		} else
+			tempbx &= (SetCHTVOverScan |
+				   TVSetNTSCJ |
+				   TVSetPAL);
 
 		if (pVBInfo->IF_DEF_LVDS == 0) {
 			if (pVBInfo->VBInfo & SetCRT2ToSCART)
-- 
1.7.8.6

