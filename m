Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3CZRqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:46:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3CZRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:21 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=nLQbshE984MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mPrkuYEkOtMA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=1YAWUHBhtAeQkI5-w-YA:9 a=E6k37eg1NvgA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173613.234745718@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 84/86] tcp: fix SYN-data space mis-accounting
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0084-tcp-fix-SYN-data-space-mis-accounting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit f7983d26995f85994a08ee173ee7d0c4ff3da356 ]

In fast open the sender unncessarily reduces the space available
for data in SYN by 12 bytes.  This is because in the sender
incorrectly reserves space for TS option twice in tcp_send_syn_data():
tcp_mtu_to_mss() already accounts for TS option space. But it further
reserves MAX_TCP_OPTION_SPACE when computing the payload space.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_output.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6735bea..6a1cdc8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1342,8 +1342,8 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 	return 0;
 }
 
-/* Calculate MSS. Not accounting for SACKs here.  */
-int tcp_mtu_to_mss(struct sock *sk, int pmtu)
+/* Calculate MSS not accounting any TCP options.  */
+static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1372,13 +1372,17 @@ int tcp_mtu_to_mss(struct sock *sk, int pmtu)
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
@@ -2914,7 +2918,7 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	 */
 	if (tp->rx_opt.user_mss && tp->rx_opt.user_mss < tp->rx_opt.mss_clamp)
 		tp->rx_opt.mss_clamp = tp->rx_opt.user_mss;
-	space = tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
+	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
 	syn_data = skb_copy_expand(syn, skb_headroom(syn), space,
-- 
1.7.10.4


