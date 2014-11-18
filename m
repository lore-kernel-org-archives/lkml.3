Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbaKRPYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:24:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbaKROJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 011/206] ipv4: fix a potential use after free in ip_tunnel_core.c
Date: Tue, 18 Nov 2014 15:06:06 +0100
Message-Id: <690050bfb427bd2191188d032ad6bac5f277bafd.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 1245dfc8cadb258386fcd27df38215a0eccb1f17 ]

pskb_may_pull() maybe change skb->data and make eth pointer oboslete,
so set eth after pskb_may_pull()

Fixes:3d7b46cd("ip_tunnel: push generic protocol handling to ip_tunnel module")
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ip_tunnel_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 8469d2338727..ff3f84f38e6d 100644
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
2.1.3

