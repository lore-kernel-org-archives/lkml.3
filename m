Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3G3Srr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:47:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab3G3Srn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:47:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 72/75] ipv4: set transport header earlier
Date: Tue, 30 Jul 2013 11:45:16 -0700
Message-Id: <1375209919-1768-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index f1395a6..e1e5a6a 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -190,10 +190,7 @@ static int ip_local_deliver_finish(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
 
-	__skb_pull(skb, ip_hdrlen(skb));
-
-	/* Point into the IP datagram, just past the header. */
-	skb_reset_transport_header(skb);
+	__skb_pull(skb, skb_network_header_len(skb));
 
 	rcu_read_lock();
 	{
@@ -442,6 +439,8 @@ int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt,
 		goto drop;
 	}
 
+	skb->transport_header = skb->network_header + iph->ihl*4;
+
 	/* Remove any debris in the socket control block */
 	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
 
-- 
1.8.1.2

