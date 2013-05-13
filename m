Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3EMVh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:37:27 -0400
Received: from mout.gmx.net ([212.227.15.15]:55778 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3EMVhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:37:25 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19r+SlPTuprBcLarRh/BmR9r4Qfba6BV4iE7j2J7i
	3eS8eWYI+HepwX
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging/xgifb: Remove unnecessary cases in XGINew_SenseLCD
Date: Mon, 13 May 2013 23:41:46 +0200
Message-Id: <1368481309-4883-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
References: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The switch statement sets the temp value to zero for certain cases and
leaves it untouched for other cases -> all these other cases can be
combined in the default case.

Since an empty case containing only a break, it can be removed.

The patch also removes the if statement, as it uses the same value as the switch
for comparison, and includes the code into the switch.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c | 51 ++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 9caf12a..ab1706b 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1077,44 +1077,23 @@ static unsigned short XGINew_SenseLCD(struct xgi_hw_device_info
 							*HwDeviceExtension,
 				      struct vb_device_info *pVBInfo)
 {
-	unsigned short temp;
-
-	/* add lcd sense */
-	if (HwDeviceExtension->ulCRT2LCDType == LCD_UNKNOWN) {
+	unsigned short temp = HwDeviceExtension->ulCRT2LCDType;
+
+	switch (HwDeviceExtension->ulCRT2LCDType) {
+	case LCD_640x480:
+	case LCD_1024x600:
+	case LCD_1152x864:
+	case LCD_1280x960:
+	case LCD_1152x768:
+	case LCD_1920x1440:
+	case LCD_2048x1536:
+		temp = 0; /* overwrite used ulCRT2LCDType */
+		break;
+	case LCD_UNKNOWN: /* unknown lcd, do nothing */
 		return 0;
-	} else {
-		temp = (unsigned short) HwDeviceExtension->ulCRT2LCDType;
-		switch (HwDeviceExtension->ulCRT2LCDType) {
-		case LCD_INVALID:
-		case LCD_800x600:
-		case LCD_1024x768:
-		case LCD_1280x1024:
-			break;
-
-		case LCD_640x480:
-		case LCD_1024x600:
-		case LCD_1152x864:
-		case LCD_1280x960:
-		case LCD_1152x768:
-			temp = 0;
-			break;
-
-		case LCD_1400x1050:
-		case LCD_1280x768:
-		case LCD_1600x1200:
-			break;
-
-		case LCD_1920x1440:
-		case LCD_2048x1536:
-			temp = 0;
-			break;
-
-		default:
-			break;
-		}
-		xgifb_reg_and_or(pVBInfo->P3d4, 0x36, 0xF0, temp);
-		return 1;
 	}
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x36, 0xF0, temp);
+	return 1;
 }
 
 static void XGINew_GetXG21Sense(struct pci_dev *pdev,
-- 
1.8.1.5

