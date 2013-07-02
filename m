Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3GBCTC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:19:02 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65257 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3GBCTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:19:00 -0400
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Huawei Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH V2 1/1] mwifiex: add tx info to skb when forming mgmt frame
Date: Tue,  2 Jul 2013 10:18:46 +0800
Message-Id: <1372731526-2979-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huawei Yang <harvey.huawei.yang@gmail.com>

In function 'mwifiex_write_data_complete' it need tx info to find
the mwifiex_private to updates statistics and wake up tx queues.
Or we may trigger tx queues timeout when transmitting lots of mgmt
frames.

Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e42b266..b4e2538 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -186,6 +186,7 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct sk_buff *skb;
 	u16 pkt_len;
 	const struct ieee80211_mgmt *mgmt;
+	struct mwifiex_txinfo *tx_info;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 
 	if (!buf || !len) {
@@ -212,6 +213,10 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		wiphy_err(wiphy, "allocate skb failed for management frame\n");
 		return -ENOMEM;
 	}
+	
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_num = priv->bss_num;
+	tx_info->bss_type = priv->bss_type;
 
 	mwifiex_form_mgmt_frame(skb, buf, len);
 	mwifiex_queue_tx_pkt(priv, skb);
-- 
1.7.10.4

