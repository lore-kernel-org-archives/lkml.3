Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab3LSNAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:00:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3LSL4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 045/208] gro: Only verify TCP checksums for candidates
Date: Thu, 19 Dec 2013 11:52:23 +0000
Message-Id: <1387454106-19326-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit cc5c00bbb44c5d68b883aa5cb9d01514a2525d94 upstream.

In some cases we may receive IP packets that are longer than
their stated lengths.  Such packets are never merged in GRO.
However, we may end up computing their checksums incorrectly
and end up allowing packets with a bogus checksum enter our
stack with the checksum status set as verified.

Since such packets are rare and not performance-critical, this
patch simply skips the checksum verification for them.

Reported-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Alexander Duyck <alexander.h.duyck@intel.com>

Thanks,
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_offload.c   | 5 +++++
 net/ipv6/tcpv6_offload.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 533c58a..44c8678 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -274,6 +274,10 @@ static struct sk_buff **tcp4_gro_receive(struct sk_buff **head, struct sk_buff *
 	__wsum wsum;
 	__sum16 sum;
 
+	/* Don't bother verifying checksum if we're going to flush anyway. */
+	if (NAPI_GRO_CB(skb)->flush)
+		goto skip_csum;
+
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
 		if (!tcp_v4_check(skb_gro_len(skb), iph->saddr, iph->daddr,
@@ -299,6 +303,7 @@ flush:
 		break;
 	}
 
+skip_csum:
 	return tcp_gro_receive(head, skb);
 }
 
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 2ec6bf6..78081d8 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -39,6 +39,10 @@ static struct sk_buff **tcp6_gro_receive(struct sk_buff **head,
 	__wsum wsum;
 	__sum16 sum;
 
+	/* Don't bother verifying checksum if we're going to flush anyway. */
+	if (NAPI_GRO_CB(skb)->flush)
+		goto skip_csum;
+
 	switch (skb->ip_summed) {
 	case CHECKSUM_COMPLETE:
 		if (!tcp_v6_check(skb_gro_len(skb), &iph->saddr, &iph->daddr,
@@ -65,6 +69,7 @@ flush:
 		break;
 	}
 
+skip_csum:
 	return tcp_gro_receive(head, skb);
 }
 
-- 
1.8.3.2

