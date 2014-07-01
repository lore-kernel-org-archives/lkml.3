Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaGAK02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:26:28 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39605 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbaGAK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:26:11 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] staging: rtl8192ee: Pass large struct by const reference
Date: Tue,  1 Jul 2014 12:25:45 +0200
Message-Id: <1404210345-28181-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404210345-28181-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404210345-28181-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct rtl_stats is rather huge (152 bytes), and since
rtl92ee_rx_command_packet() does not modify it, it might as
well be passed by const reference.

Reported by Coverity: CID 1222131

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/rtl8192ee/pci.c           | 2 +-
 drivers/staging/rtl8192ee/rtl8192ee/trx.c | 4 ++--
 drivers/staging/rtl8192ee/rtl8192ee/trx.h | 2 +-
 drivers/staging/rtl8192ee/wifi.h          | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192ee/pci.c b/drivers/staging/rtl8192ee/pci.c
index 3fe9b7b..f3abbcc 100644
--- a/drivers/staging/rtl8192ee/pci.c
+++ b/drivers/staging/rtl8192ee/pci.c
@@ -892,7 +892,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		}
 
 		/* handle command packet here */
-		if (rtlpriv->cfg->ops->rx_command_packet(hw, stats, skb)) {
+		if (rtlpriv->cfg->ops->rx_command_packet(hw, &stats, skb)) {
 				dev_kfree_skb_any(skb);
 				goto end;
 		}
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/trx.c b/drivers/staging/rtl8192ee/rtl8192ee/trx.c
index c930f52..1190c8b 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/trx.c
+++ b/drivers/staging/rtl8192ee/rtl8192ee/trx.c
@@ -1263,13 +1263,13 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 }
 
 u32 rtl92ee_rx_command_packet(struct ieee80211_hw *hw,
-			      struct rtl_stats status,
+			      const struct rtl_stats *status,
 			      struct sk_buff *skb)
 {
 	u32 result = 0;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	switch (status.packet_report_type) {
+	switch (status->packet_report_type) {
 	case NORMAL_RX:
 		result = 0;
 		break;
diff --git a/drivers/staging/rtl8192ee/rtl8192ee/trx.h b/drivers/staging/rtl8192ee/rtl8192ee/trx.h
index c2cd581..e04ee7e 100644
--- a/drivers/staging/rtl8192ee/rtl8192ee/trx.h
+++ b/drivers/staging/rtl8192ee/rtl8192ee/trx.h
@@ -872,6 +872,6 @@ void rtl92ee_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool b_firstseg, bool b_lastseg,
 			     struct sk_buff *skb);
 u32 rtl92ee_rx_command_packet(struct ieee80211_hw *hw,
-			      struct rtl_stats status,
+			      const struct rtl_stats *status,
 			      struct sk_buff *skb);
 #endif
diff --git a/drivers/staging/rtl8192ee/wifi.h b/drivers/staging/rtl8192ee/wifi.h
index 96fa261..a37176a 100644
--- a/drivers/staging/rtl8192ee/wifi.h
+++ b/drivers/staging/rtl8192ee/wifi.h
@@ -1946,7 +1946,7 @@ struct rtl_hal_ops {
 			     u32 cmd_len, u8 *p_cmdbuffer);
 	bool (*get_btc_status)(void);
 	u32 (*rx_command_packet)(struct ieee80211_hw *hw,
-				 struct rtl_stats status, struct sk_buff *skb);
+				 const struct rtl_stats *status, struct sk_buff *skb);
 	void (*add_wowlan_pattern)(struct ieee80211_hw *hw,
 				   struct rtl_wow_pattern *rtl_pattern,
 				   u8 index);
-- 
1.9.2

