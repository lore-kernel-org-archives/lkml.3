Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3BDX0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:26:04 -0500
Received: from mout.gmx.net ([212.227.17.20]:56433 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3BDX0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:26:00 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+IyTsCnU2I4VYBKje/N38kkugj9vsnScqdsiJa+2
	4pJCsz74YKkjWc
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging/xgifb: Move duplicated code for dram to helper function
Date: Tue,  5 Feb 2013 00:29:44 +0100
Message-Id: <1360020587-8399-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
References: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XGINew_SetDRAMDefaultRegister340 uses the same code fragment 4 times
with only a slight variation each time.
-> Move this code to a helper function - this saves some lines and
~450bytes in the .o / .ko

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   58 +++++++++++---------------------------
 1 files changed, 17 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index a778df6..25fc7bc 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -413,6 +413,19 @@ static void XGINew_DDR2_DefaultRegister(
 		XGINew_DDR2_MRS_XG20(HwDeviceExtension, P3c4, pVBInfo);
 }
 
+static void XGI_SetDRAM_Helper(unsigned long P3d4, u8 seed, u8 temp2, u8 reg,
+	u8 shift_factor, u8 mask1, u8 mask2)
+{
+	u8 j;
+	for (j = 0; j < 4; j++) {
+		temp2 |= (((seed >> (2 * j)) & 0x03) << shift_factor);
+		xgifb_reg_set(P3d4, reg, temp2);
+		xgifb_reg_get(P3d4, reg);
+		temp2 &= mask1;
+		temp2 += mask2;
+	}
+}
+
 static void XGINew_SetDRAMDefaultRegister340(
 		struct xgi_hw_device_info *HwDeviceExtension,
 		unsigned long Port, struct vb_device_info *pVBInfo)
@@ -426,53 +439,24 @@ static void XGINew_SetDRAMDefaultRegister340(
 	xgifb_reg_set(P3d4, 0x69, pVBInfo->CR40[6][pVBInfo->ram_type]);
 	xgifb_reg_set(P3d4, 0x6A, pVBInfo->CR40[7][pVBInfo->ram_type]);
 
-	temp2 = 0;
 	for (i = 0; i < 4; i++) {
 		/* CR6B DQS fine tune delay */
 		temp = (pVBInfo->ram_type <= 2) ? 0xaa : 0x00;
-		for (j = 0; j < 4; j++) {
-			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
-			temp2 |= temp1;
-			xgifb_reg_set(P3d4, 0x6B, temp2);
-			/* Insert read command for delay */
-			xgifb_reg_get(P3d4, 0x6B);
-			temp2 &= 0xF0;
-			temp2 += 0x10;
-		}
+		XGI_SetDRAM_Helper(P3d4, temp, 0, 0x6B, 2, 0xF0, 0x10);
 	}
 
-	temp2 = 0;
 	for (i = 0; i < 4; i++) {
 		/* CR6E DQM fine tune delay */
-		temp = 0;
-		for (j = 0; j < 4; j++) {
-			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
-			temp2 |= temp1;
-			xgifb_reg_set(P3d4, 0x6E, temp2);
-			/* Insert read command for delay */
-			xgifb_reg_get(P3d4, 0x6E);
-			temp2 &= 0xF0;
-			temp2 += 0x10;
-		}
+		XGI_SetDRAM_Helper(P3d4, 0, 0, 0x6E, 2, 0xF0, 0x10);
 	}
 
 	temp3 = 0;
 	for (k = 0; k < 4; k++) {
 		/* CR6E_D[1:0] select channel */
 		xgifb_reg_and_or(P3d4, 0x6E, 0xFC, temp3);
-		temp2 = 0;
 		for (i = 0; i < 8; i++) {
 			/* CR6F DQ fine tune delay */
-			temp = 0;
-			for (j = 0; j < 4; j++) {
-				temp1 = (temp >> (2 * j)) & 0x03;
-				temp2 |= temp1;
-				xgifb_reg_set(P3d4, 0x6F, temp2);
-				/* Insert read command for delay */
-				xgifb_reg_get(P3d4, 0x6F);
-				temp2 &= 0xF8;
-				temp2 += 0x08;
-			}
+			XGI_SetDRAM_Helper(P3d4, 0, 0, 0x6F, 0, 0xF8, 0x08);
 		}
 		temp3 += 0x01;
 	}
@@ -486,15 +470,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 
 	temp2 = 0x80;
 	/* CR89 terminator type select */
-	temp = 0;
-	for (j = 0; j < 4; j++) {
-		temp1 = (temp >> (2 * j)) & 0x03;
-		temp2 |= temp1;
-		xgifb_reg_set(P3d4, 0x89, temp2);
-		xgifb_reg_get(P3d4, 0x89); /* Insert read command for delay */
-		temp2 &= 0xF0;
-		temp2 += 0x10;
-	}
+	XGI_SetDRAM_Helper(P3d4, 0, temp2, 0x89, 0, 0xF0, 0x10);
 
 	temp = 0;
 	temp1 = temp & 0x03;
-- 
1.7.8.6

