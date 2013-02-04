Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab3BDXZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:25:58 -0500
Received: from mout.gmx.net ([212.227.17.21]:60831 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab3BDXZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:25:57 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+Rn6EQyVqR39NJUtQUK+aryTrTMxEmPtD57YCLic
	up2CjJzV4Nq8u6
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging/xgifb: Replace XGI340_CR6B table with simple if/else
Date: Tue,  5 Feb 2013 00:29:43 +0100
Message-Id: <1360020587-8399-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XGI340_CR6B lookup table consists of the entries
{0xaa, 0xaa, 0xaa, 0xaa} for an index <= 2 and
{0x00, 0x00, 0x00, 0x00} for all other indices.

The only user XGINew_SetDRAMDefaultRegister340 loops over these 4 values
of a line with a for loop and since all entries are the same for each line
we can simply replace the whole lookup table with a simple if/else assignment.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_init.c  |    2 +-
 drivers/staging/xgifb/vb_table.h |   11 -----------
 2 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index dd34570..a778df6 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -429,7 +429,7 @@ static void XGINew_SetDRAMDefaultRegister340(
 	temp2 = 0;
 	for (i = 0; i < 4; i++) {
 		/* CR6B DQS fine tune delay */
-		temp = XGI340_CR6B[pVBInfo->ram_type][i];
+		temp = (pVBInfo->ram_type <= 2) ? 0xaa : 0x00;
 		for (j = 0; j < 4; j++) {
 			temp1 = ((temp >> (2 * j)) & 0x03) << 2;
 			temp2 |= temp1;
diff --git a/drivers/staging/xgifb/vb_table.h b/drivers/staging/xgifb/vb_table.h
index fca1a1d..34e1656 100644
--- a/drivers/staging/xgifb/vb_table.h
+++ b/drivers/staging/xgifb/vb_table.h
@@ -103,17 +103,6 @@ static const unsigned char XGI27_cr41[24][8] = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}  /* 23 CRC5 */
 };
 
-const unsigned char XGI340_CR6B[8][4] = {
-	{0xaa, 0xaa, 0xaa, 0xaa},
-	{0xaa, 0xaa, 0xaa, 0xaa},
-	{0xaa, 0xaa, 0xaa, 0xaa},
-	{0x00, 0x00, 0x00, 0x00},
-	{0x00, 0x00, 0x00, 0x00},
-	{0x00, 0x00, 0x00, 0x00},
-	{0x00, 0x00, 0x00, 0x00},
-	{0x00, 0x00, 0x00, 0x00}
-};
-
 /* CR47,CR48,CR49,CR4A,CR4B,CR4C,CR70,CR71,CR74,CR75,CR76,CR77 */
 const unsigned char XGI340_AGPReg[12] = {
 	0x28, 0x23, 0x00, 0x20, 0x00, 0x20,
-- 
1.7.8.6

