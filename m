Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbbA0MhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:37:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbbA0MSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 067/126] tcp: Do not apply TSO segment limit to non-TSO packets
Date: Tue, 27 Jan 2015 12:16:12 +0000
Message-Id: <1422361031-19364-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 843925f33fcc293d80acf2c5c8a78adf3344d49b upstream.

Thomas Jarosch reported IPsec TCP stalls when a PMTU event occurs.

In fact the problem was completely unrelated to IPsec.  The bug is
also reproducible if you just disable TSO/GSO.

The problem is that when the MSS goes down, existing queued packet
on the TX queue that have not been transmitted yet all look like
TSO packets and get treated as such.

This then triggers a bug where tcp_mss_split_point tells us to
generate a zero-sized packet on the TX queue.  Once that happens
we're screwed because the zero-sized packet can never be removed
by ACKs.

Fixes: 1485348d242 ("tcp: Apply device TSO segment limit earlier")
Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.16: used davem's backport to 3.18 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a8794367cd20..64fb6e84127e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1935,7 +1935,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		if (unlikely(!tcp_snd_wnd_test(tp, skb, mss_now)))
 			break;
 
-		if (tso_segs == 1) {
+		if (tso_segs == 1 || !sk->sk_gso_max_segs) {
 			if (unlikely(!tcp_nagle_test(tp, skb, mss_now,
 						     (tcp_skb_is_last(sk, skb) ?
 						      nonagle : TCP_NAGLE_PUSH))))
@@ -1971,7 +1971,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		}
 
 		limit = mss_now;
-		if (tso_segs > 1 && !tcp_urg_mode(tp))
+		if (tso_segs > 1 && sk->sk_gso_max_segs && !tcp_urg_mode(tp))
 			limit = tcp_mss_split_point(sk, skb, mss_now,
 						    min_t(unsigned int,
 							  cwnd_quota,
-- 
2.1.4

