Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaGAK0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:26:12 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35309 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaGAK0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:26:10 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/2] staging: rtl8821ae: Pass large struct by const reference
Date: Tue,  1 Jul 2014 12:25:44 +0200
Message-Id: <1404210345-28181-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct rtl_stats is rather huge (152 bytes), and since
rtl8812ae_rx_command_packet_handler() does not modify it, it might as
well be passed by const reference.

Reported by Coverity: CID 1167285

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/rtl8821ae/pci.c          | 2 +-
 drivers/staging/rtl8821ae/rtl8821ae/sw.c | 4 ++--
 drivers/staging/rtl8821ae/wifi.h         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index e194ffe..f9847d1 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -861,7 +861,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			break;
 		}
 
-		rtlpriv->cfg->ops->rx_command_packet_handler(hw, status, skb);
+		rtlpriv->cfg->ops->rx_command_packet_handler(hw, &status, skb);
 
 		/*
 		 *NOTICE This can not be use for mac80211,
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/sw.c b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
index 2621275..115002f 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/sw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
@@ -227,14 +227,14 @@ void rtl8821ae_deinit_sw_vars(struct ieee80211_hw *hw)
 
 static u32 rtl8812ae_rx_command_packet_handler(
 	struct ieee80211_hw *hw,
-	struct rtl_stats status,
+	const struct rtl_stats *status,
 	struct sk_buff *skb
 	)
 {
 	u32 result = 0;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	switch (status.packet_report_type) {
+	switch (status->packet_report_type) {
 		case NORMAL_RX:
 			result = 0;
 			break;
diff --git a/drivers/staging/rtl8821ae/wifi.h b/drivers/staging/rtl8821ae/wifi.h
index e8250da..218cd44 100644
--- a/drivers/staging/rtl8821ae/wifi.h
+++ b/drivers/staging/rtl8821ae/wifi.h
@@ -1853,7 +1853,7 @@ struct rtl_hal_ops {
 			     u32 cmd_len, u8 *p_cmdbuffer);
 	bool (*get_btc_status)(void);
 	u32 (*rx_command_packet_handler)(struct ieee80211_hw *hw,
-					 struct rtl_stats status,
+					 const struct rtl_stats *status,
 					 struct sk_buff *skb);
 };
 
-- 
1.9.2

