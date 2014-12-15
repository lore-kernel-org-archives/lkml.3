Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaLOT1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:27:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaLOT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 07/96] ipv4: fix a potential use after free in ip_tunnel_core.c
Date: Mon, 15 Dec 2014 11:25:27 -0800
Message-Id: <1418671616-25482-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 1245dfc8cadb258386fcd27df38215a0eccb1f17 ]

pskb_may_pull() maybe change skb->data and make eth pointer oboslete,
so set eth after pskb_may_pull()

Fixes:3d7b46cd("ip_tunnel: push generic protocol handling to ip_tunnel module")
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_tunnel_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 67bd005..e67e4be 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -91,11 +91,12 @@ int iptunnel_pull_header(struct sk_buff *skb, int hdr_len, __be16 inner_proto)
 	skb_pull_rcsum(skb, hdr_len);
 
 	if (inner_proto == htons(ETH_P_TEB)) {
-		struct ethhdr *eh = (struct ethhdr *)skb->data;
+		struct ethhdr *eh;
 
 		if (unlikely(!pskb_may_pull(skb, ETH_HLEN)))
 			return -ENOMEM;
 
+		eh = (struct ethhdr *)skb->data;
 		if (likely(ntohs(eh->h_proto) >= ETH_P_802_3_MIN))
 			skb->protocol = eh->h_proto;
 		else
-- 
1.9.1

