Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaKKLtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:49:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaKKLKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 074/170] ipv4: fix a potential use after free in ip_tunnel_core.c
Date: Tue, 11 Nov 2014 11:07:13 +0000
Message-Id: <1415704129-12709-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

commit 1245dfc8cadb258386fcd27df38215a0eccb1f17 upstream.

pskb_may_pull() maybe change skb->data and make eth pointer oboslete,
so set eth after pskb_may_pull()

Fixes:3d7b46cd("ip_tunnel: push generic protocol handling to ip_tunnel module")
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_tunnel_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index f4c987bb7e94..88c386cf7d85 100644
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
2.1.0

