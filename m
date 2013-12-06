Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162262Ab3LFWck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:32:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759145Ab3LFVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 48/83] gro: Clean up tcpX_gro_receive checksum verification
Date: Fri,  6 Dec 2013 13:51:38 -0800
Message-Id: <20131206214644.526955792@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit b8ee93ba80b5a0b6c3c06b65c34dd1276f16c047 ]

This patch simplifies the checksum verification in tcpX_gro_receive
by reusing the CHECKSUM_COMPLETE code for CHECKSUM_NONE.  All it
does for CHECKSUM_NONE is compute the partial checksum and then
treat it as if it came from the hardware (CHECKSUM_COMPLETE).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_offload.c   |   26 ++++++++++----------------
 net/ipv6/tcpv6_offload.c |   27 ++++++++++-----------------
 2 files changed, 20 insertions(+), 33 deletions(-)

--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -272,35 +272,29 @@ static struct sk_buff **tcp4_gro_receive
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
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -37,36 +37,29 @@ static struct sk_buff **tcp6_gro_receive
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


