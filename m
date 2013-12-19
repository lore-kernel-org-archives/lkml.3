Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3LSLzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:55:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3LSLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 015/208] tcp: tsq: restore minimal amount of queueing
Date: Thu, 19 Dec 2013 11:51:53 +0000
Message-Id: <1387454106-19326-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 98e09386c0ef4dfd48af7ba60ff908f0d525cdee upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/networking/ip-sysctl.txt | 3 ---
 net/ipv4/tcp.c                         | 6 ------
 net/ipv4/tcp_output.c                  | 6 +++++-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index b522883..392d7cd 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -571,9 +571,6 @@ tcp_limit_output_bytes - INTEGER
 	typical pfifo_fast qdiscs.
 	tcp_limit_output_bytes limits the number of bytes on qdisc
 	or device to reduce artificial RTT/cwnd and reduce bufferbloat.
-	Note: For GSO/TSO enabled flows, we try to have at least two
-	packets in flight. Reducing tcp_limit_output_bytes might also
-	reduce the size of individual GSO packet (64KB being the max)
 	Default: 131072
 
 tcp_challenge_ack_limit - INTEGER
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ec586e5..2d2e978 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -810,12 +810,6 @@ static unsigned int tcp_xmit_size_goal(struct sock *sk, u32 mss_now,
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
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 28c0d6a..d673814 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1871,8 +1871,12 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
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
-- 
1.8.3.2

