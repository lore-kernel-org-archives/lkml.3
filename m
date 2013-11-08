Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3KHCRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab3KHCQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu2@citrix.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 07/91] tcp: TSQ can use a dynamic limit
Date: Thu,  7 Nov 2013 18:14:22 -0800
Message-Id: <1383876946-2396-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c9eeec26e32e087359160406f96e0949b3cc6f10 ]

When TCP Small Queues was added, we used a sysctl to limit amount of
packets queues on Qdisc/device queues for a given TCP flow.

Problem is this limit is either too big for low rates, or too small
for high rates.

Now TCP stack has rate estimation in sk->sk_pacing_rate, and TSO
auto sizing, it can better control number of packets in Qdisc/device
queues.

New limit is two packets or at least 1 to 2 ms worth of packets.

Low rates flows benefit from this patch by having even smaller
number of packets in queues, allowing for faster recovery,
better RTT estimations.

High rates flows benefit from this patch by allowing more than 2 packets
in flight as we had reports this was a limiting factor to reach line
rate. [ In particular if TX completion is delayed because of coalescing
parameters ]

Example for a single flow on 10Gbp link controlled by FQ/pacing

14 packets in flight instead of 2

$ tc -s -d qd
qdisc fq 8001: dev eth0 root refcnt 32 limit 10000p flow_limit 100p
buckets 1024 quantum 3028 initial_quantum 15140
 Sent 1168459366606 bytes 771822841 pkt (dropped 0, overlimits 0
requeues 6822476)
 rate 9346Mbit 771713pps backlog 953820b 14p requeues 6822476
  2047 flow, 2046 inactive, 1 throttled, delay 15673 ns
  2372 gc, 0 highprio, 0 retrans, 9739249 throttled, 0 flows_plimit

Note that sk_pacing_rate is currently set to twice the actual rate, but
this might be refined in the future when a flow is in congestion
avoidance.

Additional change : skb->destructor should be set to tcp_wfree().

A future patch (for linux 3.13+) might remove tcp_limit_output_bytes

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_output.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9d2de62..bef538f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1045,8 +1045,7 @@ static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
 
 	skb_orphan(skb);
 	skb->sk = sk;
-	skb->destructor = (sysctl_tcp_limit_output_bytes > 0) ?
-			  tcp_wfree : sock_wfree;
+	skb->destructor = tcp_wfree;
 	atomic_add(skb->truesize, &sk->sk_wmem_alloc);
 
 	/* Build TCP header and checksum it. */
@@ -1990,7 +1989,6 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 	while ((skb = tcp_send_head(sk))) {
 		unsigned int limit;
 
-
 		tso_segs = tcp_init_tso_segs(sk, skb, mss_now);
 		BUG_ON(!tso_segs);
 
@@ -2014,13 +2012,20 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 				break;
 		}
 
-		/* TSQ : sk_wmem_alloc accounts skb truesize,
-		 * including skb overhead. But thats OK.
+		/* TCP Small Queues :
+		 * Control number of packets in qdisc/devices to two packets / or ~1 ms.
+		 * This allows for :
+		 *  - better RTT estimation and ACK scheduling
+		 *  - faster recovery
+		 *  - high rates
 		 */
-		if (atomic_read(&sk->sk_wmem_alloc) >= sysctl_tcp_limit_output_bytes) {
+		limit = max(skb->truesize, sk->sk_pacing_rate >> 10);
+
+		if (atomic_read(&sk->sk_wmem_alloc) > limit) {
 			set_bit(TSQ_THROTTLED, &tp->tsq_flags);
 			break;
 		}
+
 		limit = mss_now;
 		if (tso_segs > 1 && !tcp_urg_mode(tp))
 			limit = tcp_mss_split_point(sk, skb, mss_now,
-- 
1.8.1.2

