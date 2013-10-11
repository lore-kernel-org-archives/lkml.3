Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3JKTj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3JKTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:39:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin Shelar <pshelar@nicira.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 040/110] ip_tunnel: Fix a memory corruption in ip_tunnel_xmit
Date: Fri, 11 Oct 2013 12:38:20 -0700
Message-Id: <20131011193812.178052543@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 3e08f4a72f689c6296d336c2aab4bddd60c93ae2 ]

We might extend the used aera of a skb beyond the total
headroom when we install the ipip header. Fix this by
calling skb_cow_head() unconditionally.

Bug was introduced with commit c544193214
("GRE: Refactor GRE tunneling code.")

Cc: Pravin Shelar <pshelar@nicira.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -659,13 +659,13 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 
 	max_headroom = LL_RESERVED_SPACE(tdev) + sizeof(struct iphdr)
 					       + rt->dst.header_len;
-	if (max_headroom > dev->needed_headroom) {
+	if (max_headroom > dev->needed_headroom)
 		dev->needed_headroom = max_headroom;
-		if (skb_cow_head(skb, dev->needed_headroom)) {
-			dev->stats.tx_dropped++;
-			dev_kfree_skb(skb);
-			return;
-		}
+
+	if (skb_cow_head(skb, dev->needed_headroom)) {
+		dev->stats.tx_dropped++;
+		dev_kfree_skb(skb);
+		return;
 	}
 
 	skb_dst_drop(skb);


