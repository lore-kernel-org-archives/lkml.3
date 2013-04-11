Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab3DKUg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:36:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3DKU0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:09 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_Hx_WVLdq4wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9dUz2jg_Z6YA:10 a=1XWaLZrsAAAA:8 a=GNf4gGeWAAAA:8 a=J1Y8HTJGAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=UTB_XpHje0EA:10 a=2YyZKW9jWmQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202549.368527008@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: dormando <dormando@rydia.net>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 019/171 ] tcp: dont handle MTU reduction on LISTEN socket
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0019-tcp-dont-handle-MTU-reduction-on-LISTEN-socket.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0d4f0608619de59fd8169dd8e72aadc28d80e715 ]

When an ICMP ICMP_FRAG_NEEDED (or ICMPV6_PKT_TOOBIG) message finds a
LISTEN socket, and this socket is currently owned by the user, we
set TCP_MTU_REDUCED_DEFERRED flag in listener tsq_flags.

This is bad because if we clone the parent before it had a chance to
clear the flag, the child inherits the tsq_flags value, and next
tcp_release_cb() on the child will decrement sk_refcnt.

Result is that we might free a live TCP socket, as reported by
Dormando.

IPv4: Attempt to release TCP socket in state 1

Fix this issue by testing sk_state against TCP_LISTEN early, so that we
set TCP_MTU_REDUCED_DEFERRED on appropriate sockets (not a LISTEN one)

This bug was introduced in commit 563d34d05786
(tcp: dont drop MTU reduction indications)

Reported-by: dormando <dormando@rydia.net>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/tcp_ipv4.c |   14 +++++++-------
 net/ipv6/tcp_ipv6.c |    7 +++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c883f4f..e6ed4ae 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -285,13 +285,6 @@ static void tcp_v4_mtu_reduced(struct sock *sk)
 	struct inet_sock *inet = inet_sk(sk);
 	u32 mtu = tcp_sk(sk)->mtu_info;
 
-	/* We are not interested in TCP_LISTEN and open_requests (SYN-ACKs
-	 * send out by Linux are always <576bytes so they should go through
-	 * unfragmented).
-	 */
-	if (sk->sk_state == TCP_LISTEN)
-		return;
-
 	dst = inet_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
@@ -415,6 +408,13 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 			goto out;
 
 		if (code == ICMP_FRAG_NEEDED) { /* PMTU discovery (RFC1191) */
+			/* We are not interested in TCP_LISTEN and open_requests
+			 * (SYN-ACKs send out by Linux are always <576bytes so
+			 * they should go through unfragmented).
+			 */
+			if (sk->sk_state == TCP_LISTEN)
+				goto out;
+
 			tp->mtu_info = info;
 			if (!sock_owned_by_user(sk)) {
 				tcp_v4_mtu_reduced(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8b45fb4..fe48fc9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -400,6 +400,13 @@ static void tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
+		/* We are not interested in TCP_LISTEN and open_requests
+		 * (SYN-ACKs send out by Linux are always <576bytes so
+		 * they should go through unfragmented).
+		 */
+		if (sk->sk_state == TCP_LISTEN)
+			goto out;
+
 		tp->mtu_info = ntohl(info);
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
-- 
1.7.10.4


