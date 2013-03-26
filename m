Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3CZXoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3CZWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        dormando <dormando@rydia.net>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/98] tcp: dont handle MTU reduction on LISTEN socket
Date: Tue, 26 Mar 2013 15:42:10 -0700
Message-Id: <20130326224244.684801566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |   14 +++++++-------
 net/ipv6/tcp_ipv6.c |    7 +++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -274,13 +274,6 @@ static void tcp_v4_mtu_reduced(struct so
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
@@ -408,6 +401,13 @@ void tcp_v4_err(struct sk_buff *icmp_skb
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
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -389,6 +389,13 @@ static void tcp_v6_err(struct sk_buff *s
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


