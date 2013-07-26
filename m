Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab3GZVj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759918Ab3GZUs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 35/79] ipv4: set transport header earlier
Date: Fri, 26 Jul 2013 13:47:25 -0700
Message-Id: <20130726204725.603593263@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3 ]

commit 45f00f99d6e ("ipv4: tcp: clean up tcp_v4_early_demux()") added a
performance regression for non GRO traffic, basically disabling
IP early demux.

IPv6 stack resets transport header in ip6_rcv() before calling
IP early demux in ip6_rcv_finish(), while IPv4 does this only in
ip_local_deliver_finish(), _after_ IP early demux.

GRO traffic happened to enable IP early demux because transport header
is also set in inet_gro_receive()

Instead of reverting the faulty commit, we can make IPv4/IPv6 behave the
same : transport_header should be set in ip_rcv() instead of
ip_local_deliver_finish()

ip_local_deliver_finish() can also use skb_network_header_len() which is
faster than ip_hdrlen()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Tom Herbert <therbert@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_input.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -190,10 +190,7 @@ static int ip_local_deliver_finish(struc
 {
 	struct net *net = dev_net(skb->dev);
 
-	__skb_pull(skb, ip_hdrlen(skb));
-
-	/* Point into the IP datagram, just past the header. */
-	skb_reset_transport_header(skb);
+	__skb_pull(skb, skb_network_header_len(skb));
 
 	rcu_read_lock();
 	{
@@ -437,6 +434,8 @@ int ip_rcv(struct sk_buff *skb, struct n
 		goto drop;
 	}
 
+	skb->transport_header = skb->network_header + iph->ihl*4;
+
 	/* Remove any debris in the socket control block */
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 


