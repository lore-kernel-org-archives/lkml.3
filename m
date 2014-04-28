Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaD1BdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42839 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Fabio Estevam" <festevam@gmail.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.919211024@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 11/94] ipv6: some ipv6 statistic counters failed to
 disable bh
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/icmp.c       |  2 +-
 net/ipv6/ip6_output.c |  4 ++--
 net/ipv6/mcast.c      | 11 ++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -499,7 +499,7 @@ void icmpv6_send(struct sk_buff *skb, u8
 			      np->tclass, NULL, &fl6, (struct rt6_info*)dst,
 			      MSG_DONTWAIT, np->dontfrag);
 	if (err) {
-		ICMP6_INC_STATS_BH(net, idev, ICMP6_MIB_OUTERRORS);
+		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTERRORS);
 		ip6_flush_pending_frames(sk);
 	} else {
 		err = icmpv6_push_pending_frames(sk, &fl6, &tmp_hdr,
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1658,8 +1658,8 @@ int ip6_push_pending_frames(struct sock
 	if (proto == IPPROTO_ICMPV6) {
 		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
 
-		ICMP6MSGOUT_INC_STATS_BH(net, idev, icmp6_hdr(skb)->icmp6_type);
-		ICMP6_INC_STATS_BH(net, idev, ICMP6_MIB_OUTMSGS);
+		ICMP6MSGOUT_INC_STATS(net, idev, icmp6_hdr(skb)->icmp6_type);
+		ICMP6_INC_STATS(net, idev, ICMP6_MIB_OUTMSGS);
 	}
 
 	err = ip6_local_out(skb);
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1435,11 +1435,12 @@ static void mld_sendpack(struct sk_buff
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

