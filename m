Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab3LBVgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:36:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3LBTGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:06:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.4 15/60] rtlwifi: rtl8192cu: Fix more pointer arithmetic errors
Date: Mon,  2 Dec 2013 11:05:56 -0800
Message-Id: <20131202190333.581773718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit eafbdde9c5629bea58df07275c5917eb42afbbe7 upstream.

This driver uses a number of macros to get and set various fields in the
RX and TX descriptors. To work correctly, a u8 pointer to the descriptor
must be used; however, in some cases a descriptor structure pointer is used
instead. In addition, a duplicated statement is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    6 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -762,7 +762,7 @@ static long _rtl92c_signal_scale_mapping
 
 static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 				      struct rtl_stats *pstats,
-				      struct rx_desc_92c *pdesc,
+				      struct rx_desc_92c *p_desc,
 				      struct rx_fwinfo_92c *p_drvinfo,
 				      bool packet_match_bssid,
 				      bool packet_toself,
@@ -777,11 +777,11 @@ static void _rtl92c_query_rxphystatus(st
 	u32 rssi, total_rssi = 0;
 	bool in_powersavemode = false;
 	bool is_cck_rate;
+	u8 *pdesc = (u8 *)p_desc;
 
-	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
+	is_cck_rate = RX_HAL_IS_CCK_RATE(p_desc);
 	pstats->packet_matchbssid = packet_match_bssid;
 	pstats->packet_toself = packet_toself;
-	pstats->is_cck = is_cck_rate;
 	pstats->packet_beacon = packet_beacon;
 	pstats->is_cck = is_cck_rate;
 	pstats->RX_SIGQ[0] = -1;
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -303,10 +303,10 @@ out:
 bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
-			   u8 *p_desc, struct sk_buff *skb)
+			   u8 *pdesc, struct sk_buff *skb)
 {
 	struct rx_fwinfo_92c *p_drvinfo;
-	struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
+	struct rx_desc_92c *p_desc = (struct rx_desc_92c *)pdesc;
 	u32 phystatus = GET_RX_DESC_PHY_STATUS(pdesc);
 
 	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
@@ -345,7 +345,7 @@ bool rtl92cu_rx_query_desc(struct ieee80
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
 						     stats->rx_bufshift);
-		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
+		rtl92c_translate_rx_signal_stuff(hw, skb, stats, p_desc,
 						 p_drvinfo);
 	}
 	/*rx_status->qual = stats->signal; */


