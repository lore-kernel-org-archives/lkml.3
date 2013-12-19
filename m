Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3LSNAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:00:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab3LSL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 046/208] gro: Clean up tcpX_gro_receive checksum verification
Date: Thu, 19 Dec 2013 11:52:24 +0000
Message-Id: <1387454106-19326-47-git-send-email-luis.henriques@canonical.com>
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

commit b8ee93ba80b5a0b6c3c06b65c34dd1276f16c047 upstream.

This patch simplifies the checksum verification in tcpX_gro_receive
by reusing the CHECKSUM_COMPLETE code for CHECKSUM_NONE.  All it
does for CHECKSUM_NONE is compute the partial checksum and then
treat it as if it came from the hardware (CHECKSUM_COMPLETE).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_offload.c   | 26 ++++++++++----------------
 net/ipv6/tcpv6_offload.c | 27 ++++++++++-----------------
 2 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 44c8678..910ab81 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -272,35 +272,29 @@ static struct sk_buff **tcp4_gro_receive(struct sk_buff **head, struct sk_buff *
 {
 	const struct iphdr *iph = skb_gro_network_header(skb);
 	__wsum wsum;
-	__sum16 sum;
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
 	if (NAPI_GRO_CB(skb)->flush)
 		goto skip_csum;
 
+	wsum = skb->csum;
+
 	switch (skb->ip_summed) {
+	case CHECKSUM_NONE:
+		wsum = skb_checksum(skb, skb_gro_offset(skb), skb_gro_len(skb),
+				    0);
+
+		/* fall through */
+
 	case CHECKSUM_COMPLETE:
 		if (!tcp_v4_check(skb_gro_len(skb), iph->saddr, iph->daddr,
-				  skb->csum)) {
+				  wsum)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			break;
 		}
-flush:
+
 		NAPI_GRO_CB(skb)->flush = 1;
 		return NULL;
-
-	case CHECKSUM_NONE:
-		wsum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
-					  skb_gro_len(skb), IPPROTO_TCP, 0);
-		sum = csum_fold(skb_checksum(skb,
-					     skb_gro_offset(skb),
-					     skb_gro_len(skb),
-					     wsum));
-		if (sum)
-			goto flush;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		break;
 	}
 
 skip_csum:
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 78081d8..a7a2384 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -37,36 +37,29 @@ static struct sk_buff **tcp6_gro_receive(struct sk_buff **head,
 {
 	const struct ipv6hdr *iph = skb_gro_network_header(skb);
 	__wsum wsum;
-	__sum16 sum;
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
 	if (NAPI_GRO_CB(skb)->flush)
 		goto skip_csum;
 
+	wsum = skb->csum;
+
 	switch (skb->ip_summed) {
+	case CHECKSUM_NONE:
+		wsum = skb_checksum(skb, skb_gro_offset(skb), skb_gro_len(skb),
+				    wsum);
+
+		/* fall through */
+
 	case CHECKSUM_COMPLETE:
 		if (!tcp_v6_check(skb_gro_len(skb), &iph->saddr, &iph->daddr,
-				  skb->csum)) {
+				  wsum)) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			break;
 		}
-flush:
+
 		NAPI_GRO_CB(skb)->flush = 1;
 		return NULL;
-
-	case CHECKSUM_NONE:
-		wsum = ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
-						    skb_gro_len(skb),
-						    IPPROTO_TCP, 0));
-		sum = csum_fold(skb_checksum(skb,
-					     skb_gro_offset(skb),
-					     skb_gro_len(skb),
-					     wsum));
-		if (sum)
-			goto flush;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		break;
 	}
 
 skip_csum:
-- 
1.8.3.2

