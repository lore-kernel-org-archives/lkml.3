Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab3GZVew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:34:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759942Ab3GZUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Cong Wang <amwang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 31/79] gre: Fix MTU sizing check for gretap tunnels
Date: Fri, 26 Jul 2013 13:47:21 -0700
Message-Id: <20130726204725.184611789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

[ Upstream commit 8c91e162e058bb91b7766f26f4d5823a21941026 ]

This change fixes an MTU sizing issue seen with gretap tunnels when non-gso
packets are sent from the interface.

In my case I was able to reproduce the issue by simply sending a ping of
1421 bytes with the gretap interface created on a device with a standard
1500 mtu.

This fix is based on the fact that the tunnel mtu is already adjusted by
dev->hard_header_len so it would make sense that any packets being compared
against that mtu should also be adjusted by hard_header_len and the tunnel
header instead of just the tunnel header.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Reported-by: Cong Wang <amwang@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -490,7 +490,7 @@ static int tnl_update_pmtu(struct net_de
 			    struct rtable *rt, __be16 df)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-	int pkt_size = skb->len - tunnel->hlen;
+	int pkt_size = skb->len - tunnel->hlen - dev->hard_header_len;
 	int mtu;
 
 	if (df)


