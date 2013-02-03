Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3BCVvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:51 -0500
Received: from mout.gmx.net ([212.227.17.20]:63300 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3BCVvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:44 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18+d68mJW8+QzVj4hLGuRoZXCVWc77YxV4EIVjYr4
	rwtPIpNj6aAHZR
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] staging/xgifb: Consolidate XGI_EnableChISLCD and XGI_DisableChISLCD
Date: Sun,  3 Feb 2013 22:54:38 +0100
Message-Id: <1359928479-8484-9-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions share the same code except one line - thus we can
simply merge them and add a parameter to switch between both variants.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   48 +++++++++--------------------------
 1 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 1ff1178..c5faa89 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -4684,43 +4684,21 @@ static unsigned char XGI_IsLCDON(struct vb_device_info *pVBInfo)
 }
 
 /* --------------------------------------------------------------------- */
-/* Function : XGI_DisableChISLCD */
-/* Input : */
-/* Output : 0 -> Not LCD Mode */
-/* Description : */
-/* --------------------------------------------------------------------- */
-static unsigned char XGI_DisableChISLCD(struct vb_device_info *pVBInfo)
-{
-	unsigned short tempbx, tempah;
-
-	tempbx = pVBInfo->SetFlag & (DisableChA | DisableChB);
-	tempah = ~((unsigned short) xgifb_reg_get(pVBInfo->Part1Port, 0x2E));
-
-	if (tempbx & (EnableChA | DisableChA)) {
-		if (!(tempah & 0x08)) /* Chk LCDA Mode */
-			return 0;
-	}
-
-	if (!(tempbx & (EnableChB | DisableChB)))
-		return 0;
-
-	if (tempah & 0x01) /* Chk LCDB Mode */
-		return 1;
-
-	return 0;
-}
-
-/* --------------------------------------------------------------------- */
 /* Function : XGI_EnableChISLCD */
 /* Input : */
 /* Output : 0 -> Not LCD mode */
-/* Description : */
+/* Description : if bool enable = true -> enable, else disable  */
 /* --------------------------------------------------------------------- */
-static unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo)
+static unsigned char XGI_EnableChISLCD(struct vb_device_info *pVBInfo,
+	bool enable)
 {
 	unsigned short tempbx, tempah;
 
-	tempbx = pVBInfo->SetFlag & (EnableChA | EnableChB);
+	if (enable)
+		tempbx = pVBInfo->SetFlag & (EnableChA | EnableChB);
+	else
+		tempbx = pVBInfo->SetFlag & (DisableChA | DisableChB);
+
 	tempah = ~((unsigned short) xgifb_reg_get(pVBInfo->Part1Port, 0x2E));
 
 	if (tempbx & (EnableChA | DisableChA)) {
@@ -4772,9 +4750,9 @@ static void XGI_DisableBridge(struct xgifb_video_info *xgifb_info,
 
 		if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
 			if (((pVBInfo->VBInfo &
-			      (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
-			    || (XGI_DisableChISLCD(pVBInfo))
-			    || (XGI_IsLCDON(pVBInfo)))
+			      (SetCRT2ToLCD | XGI_SetCRT2ToLCDA))) ||
+				(XGI_EnableChISLCD(pVBInfo, false)) ||
+				(XGI_IsLCDON(pVBInfo)))
 				/* LVDS Driver power down */
 				xgifb_reg_or(pVBInfo->Part4Port, 0x30, 0x80);
 		}
@@ -5731,8 +5709,8 @@ static void XGI_EnableBridge(struct xgifb_video_info *xgifb_info,
 			xgifb_reg_and_or(pVBInfo->Part2Port, 0x00, ~0xE0,
 					0x20); /* shampoo 0129 */
 			if (pVBInfo->VBType & (VB_SIS302LV | VB_XGI301C)) {
-				if (!XGI_DisableChISLCD(pVBInfo)) {
-					if (XGI_EnableChISLCD(pVBInfo) ||
+				if (!XGI_EnableChISLCD(pVBInfo, false)) {
+					if (XGI_EnableChISLCD(pVBInfo, true) ||
 					    (pVBInfo->VBInfo &
 					    (SetCRT2ToLCD | XGI_SetCRT2ToLCDA)))
 						/* LVDS PLL power on */
-- 
1.7.8.6

