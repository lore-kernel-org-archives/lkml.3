Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3BCVvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:22 -0500
Received: from mout.gmx.net ([212.227.15.19]:60225 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab3BCVvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:20 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/38sdgeAH3tpmhT5qMuPvKhXzVprQiTaQFbKTR8z
	zFf86fE7GW2Vqh
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] staging/xgifb: Simplify XGI_GetRatePtrCRT2
Date: Sun,  3 Feb 2013 22:54:30 +0100
Message-Id: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the smaller LCDRefreshIndex is contained identically in LCDARefreshIndex
we can simply use LCDARefreshIndex and skip the if/else.

Since LCDARefreshIndex is only used readonly and contains only small
unsigned values we also change its declaration to const u8.

In order to prevent an out-of-bounds access I changed the mask from 0x0F
to 0x07 and added a dummy value.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Please apply this series after my previous one 
 [PATCH 1/6] staging/xgifb: Remove unused variables and dead assignments
 [PATCH 2/6] staging/xgifb: Remove unused variable
 [PATCH 3/6] staging/xgifb: Remove unused variable and dead assignment
 [PATCH 4/6] staging/xgifb: Remove unused variables
 [PATCH 5/6] staging/xgifb: Remove redundant if statement
 [PATCH 6/6] staging/xgifb: remove unused variables

 drivers/staging/xgifb/vb_setmode.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 8eb23a4..02e76c5 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5470,9 +5470,8 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 		unsigned short ModeNo, unsigned short ModeIdIndex,
 		struct vb_device_info *pVBInfo)
 {
-	short LCDRefreshIndex[] = { 0x00, 0x00, 0x03, 0x01 },
-			LCDARefreshIndex[] = { 0x00, 0x00, 0x03, 0x01, 0x01,
-					0x01, 0x01 };
+	const u8 LCDARefreshIndex[] = {
+		0x00, 0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x00 };
 
 	unsigned short RefreshRateTableIndex, i, index, temp;
 
@@ -5489,15 +5488,8 @@ unsigned short XGI_GetRatePtrCRT2(struct xgi_hw_device_info *pXGIHWDE,
 	if (pVBInfo->SetFlag & ProgrammingCRT2) {
 		if (pVBInfo->VBInfo & (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)) {
 			if (pVBInfo->IF_DEF_LVDS == 0) {
-				if (pVBInfo->VBType & (VB_SIS301B | VB_SIS302B
-						| VB_SIS301LV | VB_SIS302LV
-						| VB_XGI301C))
-					/* 301b */
-					temp = LCDARefreshIndex[
-						pVBInfo->LCDResInfo & 0x0F];
-				else
-					temp = LCDRefreshIndex[
-						pVBInfo->LCDResInfo & 0x0F];
+				temp = LCDARefreshIndex[
+					pVBInfo->LCDResInfo & 0x07];
 
 				if (index > temp)
 					index = temp;
-- 
1.7.8.6

