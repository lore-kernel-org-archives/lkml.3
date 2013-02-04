Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3BDX0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:26:47 -0500
Received: from mout.gmx.net ([212.227.17.21]:57009 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab3BDX0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:26:02 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18Ba2tXvIMBY/NNQLlfUQmmbrwMKTuvZjtV8PLSgd
	qD7ARFVTC1rFYg
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging/xgifb: Don't write the same values x times
Date: Tue,  5 Feb 2013 00:29:45 +0100
Message-Id: <1360020587-8399-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
References: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous patch 'Move duplicated code for dram to helper
function' it becomes evident that the code is performing the same
thing 4 or 8 times in a row without changing arguments to the function
and thus writing the same values over and over again.

It was tested that these repeats are unnecessary.

-> we can safely remove them.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 25fc7bc..1c6e0f3 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -439,25 +439,18 @@ static void XGINew_SetDRAMDefaultRegister340(
 	xgifb_reg_set(P3d4, 0x69, pVBInfo->CR40[6][pVBInfo->ram_type]);
 	xgifb_reg_set(P3d4, 0x6A, pVBInfo->CR40[7][pVBInfo->ram_type]);
 
-	for (i = 0; i < 4; i++) {
-		/* CR6B DQS fine tune delay */
-		temp = (pVBInfo->ram_type <= 2) ? 0xaa : 0x00;
-		XGI_SetDRAM_Helper(P3d4, temp, 0, 0x6B, 2, 0xF0, 0x10);
-	}
+	/* CR6B DQS fine tune delay */
+	temp = (pVBInfo->ram_type <= 2) ? 0xaa : 0x00;
+	XGI_SetDRAM_Helper(P3d4, temp, 0, 0x6B, 2, 0xF0, 0x10);
 
-	for (i = 0; i < 4; i++) {
-		/* CR6E DQM fine tune delay */
-		XGI_SetDRAM_Helper(P3d4, 0, 0, 0x6E, 2, 0xF0, 0x10);
-	}
+	/* CR6E DQM fine tune delay */
+	XGI_SetDRAM_Helper(P3d4, 0, 0, 0x6E, 2, 0xF0, 0x10);
 
 	temp3 = 0;
 	for (k = 0; k < 4; k++) {
 		/* CR6E_D[1:0] select channel */
 		xgifb_reg_and_or(P3d4, 0x6E, 0xFC, temp3);
-		for (i = 0; i < 8; i++) {
-			/* CR6F DQ fine tune delay */
-			XGI_SetDRAM_Helper(P3d4, 0, 0, 0x6F, 0, 0xF8, 0x08);
-		}
+		XGI_SetDRAM_Helper(P3d4, 0, 0, 0x6F, 0, 0xF8, 0x08);
 		temp3 += 0x01;
 	}
 
-- 
1.7.8.6

