Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbaKLBhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:37:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbaKLBhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:37:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 006/203] ipv4: fix a potential use after free in ip_tunnel_core.c
Date: Wed, 12 Nov 2014 10:14:36 +0900
Message-Id: <20141112011542.983700250@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -91,11 +91,12 @@ int iptunnel_pull_header(struct sk_buff
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


