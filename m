Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbbAYTeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:34:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbbAYSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 04/50] tcp: Do not apply TSO segment limit to non-TSO packets
Date: Sun, 25 Jan 2015 10:06:54 -0800
Message-Id: <20150125180702.827613145@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1862,7 +1862,7 @@ static bool tcp_write_xmit(struct sock *
 		if (unlikely(!tcp_snd_wnd_test(tp, skb, mss_now)))
 			break;
 
-		if (tso_segs == 1) {
+		if (tso_segs == 1 || !sk->sk_gso_max_segs) {
 			if (unlikely(!tcp_nagle_test(tp, skb, mss_now,
 						     (tcp_skb_is_last(sk, skb) ?
 						      nonagle : TCP_NAGLE_PUSH))))
@@ -1899,7 +1899,7 @@ static bool tcp_write_xmit(struct sock *
 		}
 
 		limit = mss_now;
-		if (tso_segs > 1 && !tcp_urg_mode(tp))
+		if (tso_segs > 1 && sk->sk_gso_max_segs && !tcp_urg_mode(tp))
 			limit = tcp_mss_split_point(sk, skb, mss_now,
 						    min_t(unsigned int,
 							  cwnd_quota,


