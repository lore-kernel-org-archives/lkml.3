Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbaCDHNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:13:13 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56937 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaCDHNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:07 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 2/9] drivers: staging: rtl8187se: refactor/clean signal smoothing
Date: Tue,  4 Mar 2014 00:12:50 -0700
Message-Id: <89f2a1822cd770fc626cce58fc70056fedb352ff.1393916553.git.axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <cover.1393916553.git.axel.rasmussen1@gmail.com>
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com> <cover.1393916553.git.axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180.h      |  2 +-
 drivers/staging/rtl8187se/r8180_core.c | 29 ++++++++++++++++++-----------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index f81e6b5..5ac4673 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -586,7 +586,7 @@ typedef struct r8180_priv {
 	/* High Power Mechanism. Added by amy, 080312. */
 	bool bToUpdateTxPwr;
 	long UndecoratedSmoothedSS;
-	long UndercorateSmoothedRxPower;
+	long UndecoratedSmoothedRxPower;
 	u8 RSSI;
 	char RxPower;
 	u8 InitialGain;
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index e5f8a56..67c2583 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1143,23 +1143,30 @@ static long TranslateToDbm8185(u8 SignalStrengthIndex)
 /*
  * Perform signal smoothing for dynamic mechanism.
  * This is different with PerformSignalSmoothing8185 in smoothing formula.
- * No dramatic adjustion is apply because dynamic mechanism need some degree
- * of correctness. Ported from 8187B.
+ * No dramatic adjustment is applied because dynamic mechanism need some
+ * degree of correctness. Ported from 8187B.
  */
 static void PerformUndecoratedSignalSmoothing8185(struct r8180_priv *priv,
 						  bool bCckRate)
 {
-	/* Determin the current packet is CCK rate. */
+	long smoothedSS;
+	long smoothedRx;
+
+	/* Determine the current packet is CCK rate. */
 	priv->bCurCCKPkt = bCckRate;
 
+	smoothedSS = priv->SignalStrength * 10;
+
 	if (priv->UndecoratedSmoothedSS >= 0)
-		priv->UndecoratedSmoothedSS = ((priv->UndecoratedSmoothedSS * 5) +
-					       (priv->SignalStrength * 10)) / 6;
-	else
-		priv->UndecoratedSmoothedSS = priv->SignalStrength * 10;
+		smoothedSS = ((priv->UndecoratedSmoothedSS * 5) +
+				smoothedSS) / 6;
+
+	priv->UndecoratedSmoothedSS = smoothedSS;
+
+	smoothedRx = ((priv->UndecoratedSmoothedRxPower * 50) +
+			(priv->RxPower * 11)) / 60;
 
-	priv->UndercorateSmoothedRxPower = ((priv->UndercorateSmoothedRxPower * 50) +
-					    (priv->RxPower * 11)) / 60;
+	priv->UndecoratedSmoothedRxPower = smoothedRx;
 
 	if (bCckRate)
 		priv->CurCCKRSSI = priv->RSSI;
@@ -1399,8 +1406,8 @@ static void rtl8180_rx(struct net_device *dev)
 
 			/* For good-looking singal strength. */
 			SignalStrengthIndex = NetgearSignalStrengthTranslate(
-							priv->LastSignalStrengthInPercent,
-							priv->SignalStrength);
+				priv->LastSignalStrengthInPercent,
+				priv->SignalStrength);
 
 			priv->LastSignalStrengthInPercent = SignalStrengthIndex;
 			priv->Stats_SignalStrength = TranslateToDbm8185((u8)SignalStrengthIndex);
-- 
1.8.3.2

