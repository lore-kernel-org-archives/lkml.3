Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198Ab3LFVw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759140Ab3LFVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 47/83] gro: Only verify TCP checksums for candidates
Date: Fri,  6 Dec 2013 13:51:37 -0800
Message-Id: <20131206214644.435990560@linuxfoundation.org>
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

[ Upstream commit cc5c00bbb44c5d68b883aa5cb9d01514a2525d94 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_offload.c   |    5 +++++
 net/ipv6/tcpv6_offload.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -274,6 +274,10 @@ static struct sk_buff **tcp4_gro_receive
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
 
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -39,6 +39,10 @@ static struct sk_buff **tcp6_gro_receive
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
 


