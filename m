Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaAHC47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:56:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40856 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaAHCyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:54:53 -0500
Message-ID: <52CCBDDC.1050503@huawei.com>
Date: Wed, 8 Jan 2014 10:54:20 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>, "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.6 17/19] mwifiex: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
instead of memcmp.

Cc: Bing Zhao <bzhao@marvell.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/wireless/mwifiex/11n.c         | 2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 3 +--
 drivers/net/wireless/mwifiex/sta_rx.c      | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 0b803c0..6261f8c 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -483,7 +483,7 @@ mwifiex_get_ba_tbl(struct mwifiex_private *priv, int tid, u8 *ra)
 
 	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
 	list_for_each_entry(tx_ba_tsr_tbl, &priv->tx_ba_stream_tbl_ptr, list) {
-		if (!memcmp(tx_ba_tsr_tbl->ra, ra, ETH_ALEN) &&
+		if (ether_addr_equal_unaligned(tx_ba_tsr_tbl->ra, ra) &&
 		    tx_ba_tsr_tbl->tid == tid) {
 			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
 					       flags);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 5511946..24523e4 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -782,8 +782,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 	}
 
 	/* If BSSID is diff, modify current BSS parameters */
-	if (memcmp(priv->curr_bss_params.bss_descriptor.mac_address,
-		   ibss_coal_resp->bssid, ETH_ALEN)) {
+	if (!ether_addr_equal(priv->curr_bss_params.bss_descriptor.mac_address, ibss_coal_resp->bssid)) {
 		/* BSSID */
 		memcpy(priv->curr_bss_params.bss_descriptor.mac_address,
 		       ibss_coal_resp->bssid, ETH_ALEN);
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index 0bb510d..4651d67 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -224,7 +224,7 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_private *priv,
 	 * directly to os. Don't pass thru rx reordering
 	 */
 	if (!IS_11N_ENABLED(priv) ||
-	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest, ETH_ALEN)) {
+	    !ether_addr_equal_unaligned(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest)) {
 		mwifiex_process_rx_packet(priv, skb);
 		return ret;
 	}
-- 
1.8.0


