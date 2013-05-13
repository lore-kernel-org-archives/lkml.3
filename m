Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3EMViL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:38:11 -0400
Received: from mout.gmx.net ([212.227.15.19]:49337 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab3EMVh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:37:28 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/lmlkkbSDlhvpLbjF7qTnXXto6Mg1ctC8z8kZ6wP
	nFijO8IBBczRXo
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging/xgifb: Consolidate function almost identical calls in XGINew_GetXG21Sense
Date: Mon, 13 May 2013 23:41:47 +0200
Message-Id: <1368481309-4883-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
References: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling xgifb_reg_and_or with almost identical parameters in
a simple if/else scenario, we assign the changing parameter to a temp
variable and call xgifb_reg_and_or only from one location.

-> Easier to read, easier to understand (especially wrt the line breaks)

(For the if condition we don't need the Temp variable, so we can use the
value directly).

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index ab1706b..ba8796f 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1115,17 +1115,11 @@ static void XGINew_GetXG21Sense(struct pci_dev *pdev,
 			xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 			/* Enable read GPIOF */
 			xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x20, 0x20);
-			Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x04;
-			if (!Temp)
-				xgifb_reg_and_or(pVBInfo->P3d4,
-						 0x38,
-						 ~0xE0,
-						 0x80); /* TMDS on chip */
+			if (xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0x04)
+				Temp = 0xA0; /* Only DVO on chip */
 			else
-				xgifb_reg_and_or(pVBInfo->P3d4,
-						 0x38,
-						 ~0xE0,
-						 0xA0); /* Only DVO on chip */
+				Temp = 0x80; /* TMDS on chip */
+			xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, Temp);
 			/* Disable read GPIOF */
 			xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20);
 		}
-- 
1.8.1.5

