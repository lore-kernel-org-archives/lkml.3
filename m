Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbbA2JE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:04:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44818 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932133AbbA2JEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/176] tcp: Do not apply TSO segment limit to non-TSO packets
Date: Wed, 28 Jan 2015 15:28:13 +0100
Message-Id: <dc5e8861c1ab671c1fd3908d63a03fe5f2f4fb11.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 843925f33fcc293d80acf2c5c8a78adf3344d49b ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4c0e55f14f2e..b4435ae4c485 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1871,7 +1871,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		if (unlikely(!tcp_snd_wnd_test(tp, skb, mss_now)))
 			break;
 
-		if (tso_segs == 1) {
+		if (tso_segs == 1 || !sk->sk_gso_max_segs) {
 			if (unlikely(!tcp_nagle_test(tp, skb, mss_now,
 						     (tcp_skb_is_last(sk, skb) ?
 						      nonagle : TCP_NAGLE_PUSH))))
@@ -1908,7 +1908,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		}
 
 		limit = mss_now;
-		if (tso_segs > 1 && !tcp_urg_mode(tp))
+		if (tso_segs > 1 && sk->sk_gso_max_segs && !tcp_urg_mode(tp))
 			limit = tcp_mss_split_point(sk, skb, mss_now,
 						    min_t(unsigned int,
 							  cwnd_quota,
-- 
2.2.2

