Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaDRJaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:30:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46034 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 63/72] ipv6: some ipv6 statistic counters failed to disable bh
Date: Fri, 18 Apr 2014 11:22:36 +0200
Message-Id: <60fe3f632b692e088f9536a044accb6866dbf36e.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 43a43b6040165f7b40b5b489fe61a4cb7f8c4980 ]

After commit c15b1ccadb323ea ("ipv6: move DAD and addrconf_verify
processing to workqueue") some counters are now updated in process context
and thus need to disable bh before doing so, otherwise deadlocks can
happen on 32-bit archs. Fabio Estevam noticed this while while mounting
a NFS volume on an ARM board.

As a compensation for missing this I looked after the other *_STATS_BH
and found three other calls which need updating:

1) icmp6_send: ip6_fragment -> icmpv6_send -> icmp6_send (error handling)
2) ip6_push_pending_frames: rawv6_sendmsg -> rawv6_push_pending_frames -> ...
   (only in case of icmp protocol with raw sockets in error handling)
3) ping6_v6_sendmsg (error handling)

Fixes: c15b1ccadb323ea ("ipv6: move DAD and addrconf_verify processing to workqueue")
Reported-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/icmp.c       |  2 +-
 net/ipv6/ip6_output.c |  4 ++--
 net/ipv6/mcast.c      | 11 ++++++-----
 net/ipv6/ping.c       |  4 ++--
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index eef8d945b362..e2c9ff840f63 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -516,7 +516,7 @@ static void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 			      np->tclass, NULL, &fl6, (struct rt6_info *)dst,
 			      MSG_DONTWAIT, np->dontfrag);
 	if (err) {
-		ICMP6_INC_STATS_BH(net, idev, ICMP6_MIB_OUTERRORS);
+		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTERRORS);
 		ip6_flush_pending_frames(sk);
 	} else {
 		err = icmpv6_push_pending_frames(sk, &fl6, &tmp_hdr,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 49f85d49cdb4..516e136f15ca 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1535,8 +1535,8 @@ int ip6_push_pending_frames(struct sock *sk)
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 
-		ICMP6MSGOUT_INC_STATS_BH(net, idev, icmp6_hdr(skb)->icmp6_type);
-		ICMP6_INC_STATS_BH(net, idev, ICMP6_MIB_OUTMSGS);
+		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_hdr(skb)->icmp6_type);
+		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
 	}
 
 	err = ip6_local_out(skb);
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d18f9f903db6..d81abd5ba767 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1620,11 +1620,12 @@ static void mld_sendpack(struct sk_buff *skb)
 		      dst_output);
 out:
 	if (!err) {
-		ICMP6MSGOUT_INC_STATS_BH(net, idev, ICMPV6_MLD2_REPORT);
-		ICMP6_INC_STATS_BH(net, idev, ICMP6_MIB_OUTMSGS);
-		IP6_UPD_PO_STATS_BH(net, idev, IPSTATS_MIB_OUTMCAST, payload_len);
-	} else
-		IP6_INC_STATS_BH(net, idev, IPSTATS_MIB_OUTDISCARDS);
+		ICMP6MSGOUT_INC_STATS(net, idev, ICMPV6_MLD2_REPORT);
+		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
+		IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUTMCAST, payload_len);
+	} else {
+		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+	}
 
 	rcu_read_unlock();
 	return;
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 7856e962a3e6..6acab0bce9d8 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -182,8 +182,8 @@ int ping_v6_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			      MSG_DONTWAIT, np->dontfrag);
 
 	if (err) {
-		ICMP6_INC_STATS_BH(sock_net(sk), rt->rt6i_idev,
-				   ICMP6_MIB_OUTERRORS);
+		ICMP6_INC_STATS(sock_net(sk), rt->rt6i_idev,
+				ICMP6_MIB_OUTERRORS);
 		ip6_flush_pending_frames(sk);
 	} else {
 		err = icmpv6_push_pending_frames(sk, &fl6,
-- 
1.9.2

