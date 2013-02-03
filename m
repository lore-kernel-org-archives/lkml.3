Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3BCVvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:36 -0500
Received: from mout.gmx.net ([212.227.15.19]:53871 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab3BCVvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:32 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19Z+eBRqZZZPYPqD6bxfP1ilurMEG5AQvjVyeYo/m
	3J9XbXPvLX9Yi8
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] staging/xgifb: Simplify XGI_SetSeqRegs
Date: Sun,  3 Feb 2013 22:54:34 +0100
Message-Id: <1359928479-8484-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since SR[0] in the (readonly) XGI330_StandTable is always 0x01 we can
skip or'ing with 0x01 and make the code simpler by removing the if
statements.

Since this function is the only user of the XGI330_StandTable we can
also include the unconditional |= 0x20 into the input data and move the
assignment to SR1 into the loop, which I prefer to start at 0.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   23 ++++++-----------------
 drivers/staging/xgifb/vb_table.h   |    2 +-
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 02e76c5..6f366f4 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -64,26 +64,15 @@ static void XGI_SetSeqRegs(unsigned short ModeNo,
 			   unsigned short ModeIdIndex,
 			   struct vb_device_info *pVBInfo)
 {
-	unsigned char tempah, SRdata;
-	unsigned short i;
+	unsigned char SRdata, i;
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x00, 0x03); /* Set SR0 */
-	tempah = XGI330_StandTable.SR[0];
-
-	if (pVBInfo->VBInfo & XGI_SetCRT2ToLCDA) {
-		tempah |= 0x01;
-	} else if (pVBInfo->VBInfo & (SetCRT2ToTV | SetCRT2ToLCD)) {
-		if (pVBInfo->VBInfo & SetInSlaveMode)
-			tempah |= 0x01;
-	}
 
-	tempah |= 0x20; /* screen off */
-	xgifb_reg_set(pVBInfo->P3c4, 0x01, tempah); /* Set SR1 */
-
-	for (i = 02; i <= 04; i++) {
-		/* Get SR2,3,4 from file */
-		SRdata = XGI330_StandTable.SR[i - 1];
-		xgifb_reg_set(pVBInfo->P3c4, i, SRdata); /* Set SR2 3 4 */
+	for (i = 0; i < 4; i++) {
+		/* Get SR1,2,3,4 from file */
+		/* SR1 is with screen off 0x20 */
+		SRdata = XGI330_StandTable.SR[i];
+		xgifb_reg_set(pVBInfo->P3c4, i+1, SRdata); /* Set SR 1 2 3 4 */
 	}
 }
 
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index 39f528b..fca1a1d 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -195,7 +195,7 @@ const struct XGI_ExtStruct XGI330_EModeIDTable[] = {
 static const struct SiS_StandTable_S XGI330_StandTable = {
 /* ExtVGATable */
 	0x00, 0x00, 0x00, 0x0000,
-	{0x01, 0x0f, 0x00, 0x0e},
+	{0x21, 0x0f, 0x00, 0x0e}, /* 0x21 = 0x01 | (0x20 = screen off) */
 	 0x23,
 	{0x5f, 0x4f, 0x50, 0x82, 0x54, 0x80, 0x0b, 0x3e,
 	 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-- 
1.7.8.6

