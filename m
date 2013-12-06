Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab3LFWnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:43:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab3LFVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Sujith Manoharan <sujith@msujith.org>,
        Arnaud Ebalard <arno@natisbad.org>, Felix Fietkau <nbd@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 17/83] tcp: tsq: restore minimal amount of queueing
Date: Fri,  6 Dec 2013 13:51:07 -0800
Message-Id: <20131206214641.673468582@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 98e09386c0ef4dfd48af7ba60ff908f0d525cdee ]

After commit c9eeec26e32e ("tcp: TSQ can use a dynamic limit"), several
users reported throughput regressions, notably on mvneta and wifi
adapters.

802.11 AMPDU requires a fair amount of queueing to be effective.

This patch partially reverts the change done in tcp_write_xmit()
so that the minimal amount is sysctl_tcp_limit_output_bytes.

It also remove the use of this sysctl while building skb stored
in write queue, as TSO autosizing does the right thing anyway.

Users with well behaving NICS and correct qdisc (like sch_fq),
can then lower the default sysctl_tcp_limit_output_bytes value from
128KB to 8KB.

This new usage of sysctl_tcp_limit_output_bytes permits each driver
authors to check how their driver performs when/if the value is set
to a minimum of 4KB.

Normally, line rate for a single TCP flow should be possible,
but some drivers rely on timers to perform TX completion and
too long TX completion delays prevent reaching full throughput.

Fixes: c9eeec26e32e ("tcp: TSQ can use a dynamic limit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Sujith Manoharan <sujith@msujith.org>
Reported-by: Arnaud Ebalard <arno@natisbad.org>
Tested-by: Sujith Manoharan <sujith@msujith.org>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/ip-sysctl.txt |    3 ---
 net/ipv4/tcp.c                         |    6 ------
 net/ipv4/tcp_output.c                  |    6 +++++-
 3 files changed, 5 insertions(+), 10 deletions(-)

--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -588,9 +588,6 @@ tcp_limit_output_bytes - INTEGER
 	typical pfifo_fast qdiscs.
 	tcp_limit_output_bytes limits the number of bytes on qdisc
 	or device to reduce artificial RTT/cwnd and reduce bufferbloat.
-	Note: For GSO/TSO enabled flows, we try to have at least two
-	packets in flight. Reducing tcp_limit_output_bytes might also
-	reduce the size of individual GSO packet (64KB being the max)
 	Default: 131072
 
 tcp_challenge_ack_limit - INTEGER
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -806,12 +806,6 @@ static unsigned int tcp_xmit_size_goal(s
 		xmit_size_goal = min_t(u32, gso_size,
 				       sk->sk_gso_max_size - 1 - hlen);
 
-		/* TSQ : try to have at least two segments in flight
-		 * (one in NIC TX ring, another in Qdisc)
-		 */
-		xmit_size_goal = min_t(u32, xmit_size_goal,
-				       sysctl_tcp_limit_output_bytes >> 1);
-
 		xmit_size_goal = tcp_bound_to_half_wnd(tp, xmit_size_goal);
 
 		/* We try hard to avoid divides here */
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1875,8 +1875,12 @@ static bool tcp_write_xmit(struct sock *
 		 *  - better RTT estimation and ACK scheduling
 		 *  - faster recovery
 		 *  - high rates
+		 * Alas, some drivers / subsystems require a fair amount
+		 * of queued bytes to ensure line rate.
+		 * One example is wifi aggregation (802.11 AMPDU)
 		 */
-		limit = max(skb->truesize, sk->sk_pacing_rate >> 10);
+		limit = max_t(unsigned int, sysctl_tcp_limit_output_bytes,
+			      sk->sk_pacing_rate >> 10);
 
 		if (atomic_read(&sk->sk_wmem_alloc) > limit) {
 			set_bit(TSQ_THROTTLED, &tp->tsq_flags);


