Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaLBBjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:39:15 -0500
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:49185 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932280AbaLBBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:39:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3865:3867:3868:4050:4119:4605:5007:6119:6261:8603:9592:10004:10848:11026:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shade83_31d1dfc2a0714
X-Filterd-Recvd-Size: 8222
Message-ID: <1417484341.4894.6.camel@perches.com>
Subject: [PATCH net-next] udp: Neaten and reduce size of compute_score
 functions
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 17:39:01 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compute_score functions are a bit difficult to read.

Neaten them a bit to reduce object sizes and make them a
bit more intelligible.

Return early to avoid indentation and avoid unnecessary
initializations.

(allyesconfig, but w/ -O2 and no profiling)

$ size net/ipv[46]/udp.o.*
   text	   data	    bss	    dec	    hex	filename
  28680	   1184	     25	  29889	   74c1	net/ipv4/udp.o.new
  28756	   1184	     25	  29965	   750d	net/ipv4/udp.o.old
  17600	   1010	      2	  18612	   48b4	net/ipv6/udp.o.new
  17632	   1010	      2	  18644	   48d4	net/ipv6/udp.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv4/udp.c | 111 +++++++++++++++++++++++++++++++-------------------------
 net/ipv6/udp.c | 113 ++++++++++++++++++++++++++++++++-------------------------
 2 files changed, 125 insertions(+), 99 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b2d6068..227e6ad 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -336,38 +336,45 @@ int udp_v4_get_port(struct sock *sk, unsigned short snum)
 	return udp_lib_get_port(sk, snum, ipv4_rcv_saddr_equal, hash2_nulladdr);
 }
 
-static inline int compute_score(struct sock *sk, struct net *net, __be32 saddr,
-			 unsigned short hnum,
-			 __be16 sport, __be32 daddr, __be16 dport, int dif)
+static inline int compute_score(struct sock *sk, struct net *net,
+				__be32 saddr, unsigned short hnum, __be16 sport,
+				__be32 daddr, __be16 dport, int dif)
 {
-	int score = -1;
+	int score;
+	struct inet_sock *inet;
 
-	if (net_eq(sock_net(sk), net) && udp_sk(sk)->udp_port_hash == hnum &&
-			!ipv6_only_sock(sk)) {
-		struct inet_sock *inet = inet_sk(sk);
+	if (!(net_eq(sock_net(sk), net) &&
+	      udp_sk(sk)->udp_port_hash == hnum &&
+	      !ipv6_only_sock(sk)))
+		return -1;
 
-		score = (sk->sk_family == PF_INET ? 2 : 1);
-		if (inet->inet_rcv_saddr) {
-			if (inet->inet_rcv_saddr != daddr)
-				return -1;
-			score += 4;
-		}
-		if (inet->inet_daddr) {
-			if (inet->inet_daddr != saddr)
-				return -1;
-			score += 4;
-		}
-		if (inet->inet_dport) {
-			if (inet->inet_dport != sport)
-				return -1;
-			score += 4;
-		}
-		if (sk->sk_bound_dev_if) {
-			if (sk->sk_bound_dev_if != dif)
-				return -1;
-			score += 4;
-		}
+	score = (sk->sk_family == PF_INET) ? 2 : 1;
+	inet = inet_sk(sk);
+
+	if (inet->inet_rcv_saddr) {
+		if (inet->inet_rcv_saddr != daddr)
+			return -1;
+		score += 4;
+	}
+
+	if (inet->inet_daddr) {
+		if (inet->inet_daddr != saddr)
+			return -1;
+		score += 4;
+	}
+
+	if (inet->inet_dport) {
+		if (inet->inet_dport != sport)
+			return -1;
+		score += 4;
+	}
+
+	if (sk->sk_bound_dev_if) {
+		if (sk->sk_bound_dev_if != dif)
+			return -1;
+		score += 4;
 	}
+
 	return score;
 }
 
@@ -378,33 +385,39 @@ static inline int compute_score2(struct sock *sk, struct net *net,
 				 __be32 saddr, __be16 sport,
 				 __be32 daddr, unsigned int hnum, int dif)
 {
-	int score = -1;
+	int score;
+	struct inet_sock *inet;
 
-	if (net_eq(sock_net(sk), net) && !ipv6_only_sock(sk)) {
-		struct inet_sock *inet = inet_sk(sk);
+	if (!(net_eq(sock_net(sk), net) && !ipv6_only_sock(sk)))
+		return -1;
 
-		if (inet->inet_rcv_saddr != daddr)
+	inet = inet_sk(sk);
+
+	if (inet->inet_rcv_saddr != daddr)
+		return -1;
+	if (inet->inet_num != hnum)
+		return -1;
+
+	score = (sk->sk_family == PF_INET) ? 2 : 1;
+
+	if (inet->inet_daddr) {
+		if (inet->inet_daddr != saddr)
 			return -1;
-		if (inet->inet_num != hnum)
+		score += 4;
+	}
+
+	if (inet->inet_dport) {
+		if (inet->inet_dport != sport)
 			return -1;
+		score += 4;
+	}
 
-		score = (sk->sk_family == PF_INET ? 2 : 1);
-		if (inet->inet_daddr) {
-			if (inet->inet_daddr != saddr)
-				return -1;
-			score += 4;
-		}
-		if (inet->inet_dport) {
-			if (inet->inet_dport != sport)
-				return -1;
-			score += 4;
-		}
-		if (sk->sk_bound_dev_if) {
-			if (sk->sk_bound_dev_if != dif)
-				return -1;
-			score += 4;
-		}
+	if (sk->sk_bound_dev_if) {
+		if (sk->sk_bound_dev_if != dif)
+			return -1;
+		score += 4;
 	}
+
 	return score;
 }
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7cfb5d7..0b9644a 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -148,72 +148,85 @@ static inline int compute_score(struct sock *sk, struct net *net,
 				const struct in6_addr *daddr, __be16 dport,
 				int dif)
 {
-	int score = -1;
+	int score;
+	struct inet_sock *inet;
 
-	if (net_eq(sock_net(sk), net) && udp_sk(sk)->udp_port_hash == hnum &&
-			sk->sk_family == PF_INET6) {
-		struct inet_sock *inet = inet_sk(sk);
+	if (!(net_eq(sock_net(sk), net) &&
+	      udp_sk(sk)->udp_port_hash == hnum &&
+	      sk->sk_family == PF_INET6))
+		return -1;
 
-		score = 0;
-		if (inet->inet_dport) {
-			if (inet->inet_dport != sport)
-				return -1;
-			score++;
-		}
-		if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr)) {
-			if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
-				return -1;
-			score++;
-		}
-		if (!ipv6_addr_any(&sk->sk_v6_daddr)) {
-			if (!ipv6_addr_equal(&sk->sk_v6_daddr, saddr))
-				return -1;
-			score++;
-		}
-		if (sk->sk_bound_dev_if) {
-			if (sk->sk_bound_dev_if != dif)
-				return -1;
-			score++;
-		}
+	score = 0;
+	inet = inet_sk(sk);
+
+	if (inet->inet_dport) {
+		if (inet->inet_dport != sport)
+			return -1;
+		score++;
 	}
+
+	if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr)) {
+		if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
+			return -1;
+		score++;
+	}
+
+	if (!ipv6_addr_any(&sk->sk_v6_daddr)) {
+		if (!ipv6_addr_equal(&sk->sk_v6_daddr, saddr))
+			return -1;
+		score++;
+	}
+
+	if (sk->sk_bound_dev_if) {
+		if (sk->sk_bound_dev_if != dif)
+			return -1;
+		score++;
+	}
+
 	return score;
 }
 
 #define SCORE2_MAX (1 + 1 + 1)
 static inline int compute_score2(struct sock *sk, struct net *net,
-				const struct in6_addr *saddr, __be16 sport,
-				const struct in6_addr *daddr, unsigned short hnum,
-				int dif)
+				 const struct in6_addr *saddr, __be16 sport,
+				 const struct in6_addr *daddr,
+				 unsigned short hnum, int dif)
 {
-	int score = -1;
+	int score;
+	struct inet_sock *inet;
 
-	if (net_eq(sock_net(sk), net) && udp_sk(sk)->udp_port_hash == hnum &&
-			sk->sk_family == PF_INET6) {
-		struct inet_sock *inet = inet_sk(sk);
+	if (!(net_eq(sock_net(sk), net) &&
+	      udp_sk(sk)->udp_port_hash == hnum &&
+	      sk->sk_family == PF_INET6))
+		return -1;
 
-		if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
+	if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
+		return -1;
+
+	score = 0;
+	inet = inet_sk(sk);
+
+	if (inet->inet_dport) {
+		if (inet->inet_dport != sport)
 			return -1;
-		score = 0;
-		if (inet->inet_dport) {
-			if (inet->inet_dport != sport)
-				return -1;
-			score++;
-		}
-		if (!ipv6_addr_any(&sk->sk_v6_daddr)) {
-			if (!ipv6_addr_equal(&sk->sk_v6_daddr, saddr))
-				return -1;
-			score++;
-		}
-		if (sk->sk_bound_dev_if) {
-			if (sk->sk_bound_dev_if != dif)
-				return -1;
-			score++;
-		}
+		score++;
 	}
+
+	if (!ipv6_addr_any(&sk->sk_v6_daddr)) {
+		if (!ipv6_addr_equal(&sk->sk_v6_daddr, saddr))
+			return -1;
+		score++;
+	}
+
+	if (sk->sk_bound_dev_if) {
+		if (sk->sk_bound_dev_if != dif)
+			return -1;
+		score++;
+	}
+
 	return score;
 }
 
-
 /* called with read_rcu_lock() */
 static struct sock *udp6_lib_lookup2(struct net *net,
 		const struct in6_addr *saddr, __be16 sport,


