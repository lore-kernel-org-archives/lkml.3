Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3BCVvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:51:42 -0500
Received: from mout.gmx.net ([212.227.17.21]:57036 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3BCVvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:39 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/JwKoYnL/JwCYFsPqUTcnmhCgRnIeP710x47ZMAC
	e2R3Pq1n1qyWqg
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] staging/xgifb: remove unnecessary temp variable in XGIfb_mode_rate_to_ddata
Date: Sun,  3 Feb 2013 22:54:36 +0100
Message-Id: <1359928479-8484-7-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of subtracting one and then assign a different name and add 1
again we simply use HDE directly. HDE wasn't used directly before, so no
change in functionality.
Same applies to VDE.

-> now we can remove the variable with the very descriptive name E ;)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 840b497..387d1bd 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -94,7 +94,7 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	unsigned short VRE, VBE, VRS, VDE;
 	unsigned short HRE, HBE, HRS, HDE;
 	unsigned char sr_data, cr_data, cr_data2;
-	int B, C, D, E, F, temp, j;
+	int B, C, D, F, temp, j;
 	InitTo330Pointer(HwDeviceExtension->jChipType, XGI_Pr);
 	if (!XGI_SearchModeID(ModeNo, &ModeIdIndex, XGI_Pr))
 		return 0;
@@ -104,14 +104,13 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 
 	sr_data = XGI_CRT1Table[index].CR[5];
 
-	HDE = (XGI330_RefIndex[RefreshRateTableIndex].XRes >> 3) - 1;
-	E = HDE + 1;
+	HDE = (XGI330_RefIndex[RefreshRateTableIndex].XRes >> 3);
 
 	cr_data = XGI_CRT1Table[index].CR[3];
 
 	/* Horizontal retrace (=sync) start */
 	HRS = (cr_data & 0xff) | ((unsigned short) (sr_data & 0xC0) << 2);
-	F = HRS - E - 3;
+	F = HRS - HDE - 3;
 
 	sr_data = XGI_CRT1Table[index].CR[6];
 
@@ -126,10 +125,10 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	/* Horizontal retrace (=sync) end */
 	HRE = (cr_data2 & 0x1f) | ((sr_data & 0x04) << 3);
 
-	temp = HBE - ((E - 1) & 255);
+	temp = HBE - ((HDE - 1) & 255);
 	B = (temp > 0) ? temp : (temp + 256);
 
-	temp = HRE - ((E + F + 3) & 63);
+	temp = HRE - ((HDE + F + 3) & 63);
 	C = (temp > 0) ? temp : (temp + 64);
 
 	D = B - F - C;
@@ -142,8 +141,7 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 
 	cr_data2 = XGI_CRT1Table[index].CR[9];
 
-	VDE = XGI330_RefIndex[RefreshRateTableIndex].YRes - 1;
-	E = VDE + 1;
+	VDE = XGI330_RefIndex[RefreshRateTableIndex].YRes;
 
 	cr_data = XGI_CRT1Table[index].CR[10];
 
@@ -151,20 +149,20 @@ static int XGIfb_mode_rate_to_ddata(struct vb_device_info *XGI_Pr,
 	VRS = (cr_data & 0xff) | ((unsigned short) (cr_data2 & 0x04) << 6)
 			| ((unsigned short) (cr_data2 & 0x80) << 2)
 			| ((unsigned short) (sr_data & 0x08) << 7);
-	F = VRS + 1 - E;
+	F = VRS + 1 - VDE;
 
 	cr_data = XGI_CRT1Table[index].CR[13];
 
 	/* Vertical blank end */
 	VBE = (cr_data & 0xff) | ((unsigned short) (sr_data & 0x10) << 4);
-	temp = VBE - ((E - 1) & 511);
+	temp = VBE - ((VDE - 1) & 511);
 	B = (temp > 0) ? temp : (temp + 512);
 
 	cr_data = XGI_CRT1Table[index].CR[11];
 
 	/* Vertical retrace (=sync) end */
 	VRE = (cr_data & 0x0f) | ((sr_data & 0x20) >> 1);
-	temp = VRE - ((E + F - 1) & 31);
+	temp = VRE - ((VDE + F - 1) & 31);
 	C = (temp > 0) ? temp : (temp + 32);
 
 	D = B - F - C;
-- 
1.7.8.6

