Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab3ERDM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:12:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3ERDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:18 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aTh_rax0Q6IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3Xg0TcrJk-gA:10 a=DfNHnWVPAAAA:8 a=zhf81SHlAAAA:8 a=n9Sqmae0AAAA:8 a=J1Y8HTJGAAAA:8 a=poVTkzvNeXFeW-M0QIIA:9 a=lBRciGGoxdUA:10 a=z0jh1eRXt18A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021658.398536101@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        hayeswang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 104/136 ] r8169: fix 8168evl frame padding.
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0104-r8169-fix-8168evl-frame-padding.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

[ Upstream commit e5195c1f31f399289347e043d6abf3ffa80f0005 ]

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: hayeswang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/realtek/r8169.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 886b52f..74ca124 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5806,6 +5806,14 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		goto err_stop_0;
 	}
 
+	/* 8168evl does not automatically pad to minimum length. */
+	if (unlikely(tp->mac_version == RTL_GIGA_MAC_VER_34 &&
+		     skb->len < ETH_ZLEN)) {
+		if (skb_padto(skb, ETH_ZLEN))
+			goto err_update_stats;
+		skb_put(skb, ETH_ZLEN - skb->len);
+	}
+
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
@@ -5877,6 +5885,7 @@ err_dma_1:
 	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
 err_dma_0:
 	dev_kfree_skb(skb);
+err_update_stats:
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 
-- 
1.7.10.4


