Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab3B0Aso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:48:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3BZX6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 132/150] tcp: fix SYN-data space mis-accounting
Date: Tue, 26 Feb 2013 15:56:29 -0800
Message-Id: <20130226235537.920210317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 1b63edd6ecc55c3a61b40297b49e2323783bddfd ]

In fast open the sender unncessarily reduces the space available
for data in SYN by 12 bytes.  This is because in the sender
incorrectly reserves space for TS option twice in tcp_send_syn_data():
tcp_mtu_to_mss() already accounts for TS option space. But it further
reserves MAX_TCP_OPTION_SPACE when computing the payload space.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1351,8 +1351,8 @@ int tcp_trim_head(struct sock *sk, struc
 	return 0;
 }
 
-/* Calculate MSS. Not accounting for SACKs here.  */
-int tcp_mtu_to_mss(struct sock *sk, int pmtu)
+/* Calculate MSS not accounting any TCP options.  */
+static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1381,13 +1381,17 @@ int tcp_mtu_to_mss(struct sock *sk, int
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
 	if (mss_now < 48)
 		mss_now = 48;
-
-	/* Now subtract TCP options size, not including SACKs */
-	mss_now -= tp->tcp_header_len - sizeof(struct tcphdr);
-
 	return mss_now;
 }
 
+/* Calculate MSS. Not accounting for SACKs here.  */
+int tcp_mtu_to_mss(struct sock *sk, int pmtu)
+{
+	/* Subtract TCP options size, not including SACKs */
+	return __tcp_mtu_to_mss(sk, pmtu) -
+	       (tcp_sk(sk)->tcp_header_len - sizeof(struct tcphdr));
+}
+
 /* Inverse of above */
 int tcp_mss_to_mtu(struct sock *sk, int mss)
 {
@@ -2930,7 +2934,7 @@ static int tcp_send_syn_data(struct sock
 	 */
 	if (tp->rx_opt.user_mss && tp->rx_opt.user_mss < tp->rx_opt.mss_clamp)
 		tp->rx_opt.mss_clamp = tp->rx_opt.user_mss;
-	space = tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
+	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
 	syn_data = skb_copy_expand(syn, skb_headroom(syn), space,


