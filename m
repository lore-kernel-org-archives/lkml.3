Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaCJGWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 02:22:54 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:36092 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaCJGWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 02:22:53 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2A6MnlV029100, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: add skb_cow_head
Date: Mon, 10 Mar 2014 14:22:31 +0800
Message-ID: <1394432551-4856-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call skb_cow_head() before editing the tx packet header. The header
would be reallocated if it is shared.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c7ef30d..faad39b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1376,6 +1376,11 @@ static int msdn_giant_send_check(struct sk_buff *skb)
 {
 	const struct ipv6hdr *ipv6h;
 	struct tcphdr *th;
+	int ret;
+
+	ret = skb_cow_head(skb, 0);
+	if (ret)
+		goto out1;
 
 	ipv6h = ipv6_hdr(skb);
 	th = tcp_hdr(skb);
@@ -1383,7 +1388,8 @@ static int msdn_giant_send_check(struct sk_buff *skb)
 	th->check = 0;
 	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
 
-	return 0;
+out1:
+	return ret;
 }
 
 static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
@@ -1412,8 +1418,11 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 			break;
 
 		case htons(ETH_P_IPV6):
+			if (msdn_giant_send_check(skb)) {
+				ret = TX_CSUM_TSO;
+				goto unavailable;
+			}
 			opts1 |= GTSENDV6;
-			msdn_giant_send_check(skb);
 			break;
 
 		default:
-- 
1.8.4.2

