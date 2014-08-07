Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaHGErs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:47:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35318 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaHGErr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:47:47 -0400
From: A Raghavendra Rao <raghav3276@gmail.com>
X-Google-Original-From: A Raghavendra Rao <arrao@cdac.in>
To: gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com, c@24.io
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        A Raghavendra Rao <arrao@cdac.in>
Subject: [PATCH] Staging: rtl8192u: fix sparse warnings in r8192U_core.c
Date: Thu,  7 Aug 2014 10:10:47 +0530
Message-Id: <1407386447-16308-1-git-send-email-arrao@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:
drivers/staging/rtl8192u/r8192U_core.c:670:6: warning: symbol 'dump_eprom'
was not declared. Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning: symbol
'txqueue2outpipe' was not declared. Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning: symbol
'GetRxPacketShiftBytes819xUsb' was not declared. Should it be static?

Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
---
 drivers/staging/rtl8192u/r8192U_core.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..6ad767a 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -667,12 +667,14 @@ static void tx_timeout(struct net_device *dev)
 
 
 /* this is only for debug */
-void dump_eprom(struct net_device *dev)
+#ifdef DEBUG_EPROM
+static void dump_eprom(struct net_device *dev)
 {
 	int i;
 	for (i = 0; i < 63; i++)
 		RT_TRACE(COMP_EPROM, "EEPROM addr %x : %x", i, eprom_read(dev, i));
 }
+#endif
 
 void rtl8192_update_msr(struct net_device *dev)
 {
@@ -1553,7 +1555,9 @@ u16 N_DBPSOfRate(u16 DataRate)
 	return N_DBPS;
 }
 
-unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
+#ifndef USE_ONE_PIPE
+static unsigned int txqueue2outpipe(struct r8192_priv *priv,
+					unsigned int tx_queue)
 {
 	if (tx_queue >= 9) {
 		RT_TRACE(COMP_ERR, "%s():Unknown queue ID!!!\n", __func__);
@@ -1561,6 +1565,7 @@ unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
 	}
 	return priv->txqueue_to_outpipemap[tx_queue];
 }
+#endif
 
 short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 {
@@ -4873,17 +4878,18 @@ static void query_rxdesc_status(struct sk_buff *skb,
 
 }
 
-u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status, bool bIsRxAggrSubframe)
-{
 #ifdef USB_RX_AGGREGATION_SUPPORT
+static u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status,
+					bool bIsRxAggrSubframe)
+{
 	if (bIsRxAggrSubframe)
 		return (sizeof(rx_desc_819x_usb) + Status->RxDrvInfoSize
 			+ Status->RxBufShift + 8);
 	else
-#endif
 		return (sizeof(rx_desc_819x_usb) + Status->RxDrvInfoSize
 			+ Status->RxBufShift);
 }
+#endif
 
 static void rtl8192_rx_nomal(struct sk_buff *skb)
 {
-- 
1.7.9.5

