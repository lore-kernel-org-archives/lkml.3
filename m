Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbaGZTeU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:34:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaGZTVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:21:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H.K. Jerry Chu" <hkchu@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 067/109] net-gre-gro: Fix a bug that breaks the forwarding path
Date: Sat, 26 Jul 2014 12:02:29 -0700
Message-Id: <20140726190225.899625749@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerry Chu <hkchu@google.com>

[ Upstream commit c3caf1192f904de2f1381211f564537235d50de3 ]

Fixed a bug that was introduced by my GRE-GRO patch
(bf5a755f5e9186406bbf50f4087100af5bd68e40 net-gre-gro: Add GRE
support to the GRO stack) that breaks the forwarding path
because various GSO related fields were not set. The bug will
cause on the egress path either the GSO code to fail, or a
GRE-TSO capable (NETIF_F_GSO_GRE) NICs to choke. The following
fix has been tested for both cases.

Signed-off-by: H.K. Jerry Chu <hkchu@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c           |    2 ++
 net/ipv4/af_inet.c       |    3 +++
 net/ipv4/gre_offload.c   |    3 +++
 net/ipv4/tcp_offload.c   |    2 +-
 net/ipv6/tcpv6_offload.c |    2 +-
 5 files changed, 10 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4064,6 +4064,8 @@ static void napi_reuse_skb(struct napi_s
 	skb->vlan_tci = 0;
 	skb->dev = napi->dev;
 	skb->skb_iif = 0;
+	skb->encapsulation = 0;
+	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 
 	napi->skb = skb;
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1434,6 +1434,9 @@ static int inet_gro_complete(struct sk_b
 	int proto = iph->protocol;
 	int err = -ENOSYS;
 
+	if (skb->encapsulation)
+		skb_set_inner_network_header(skb, nhoff);
+
 	csum_replace2(&iph->check, iph->tot_len, newlen);
 	iph->tot_len = newlen;
 
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -255,6 +255,9 @@ static int gre_gro_complete(struct sk_bu
 	int err = -ENOENT;
 	__be16 type;
 
+	skb->encapsulation = 1;
+	skb_shinfo(skb)->gso_type = SKB_GSO_GRE;
+
 	type = greh->protocol;
 	if (greh->flags & GRE_KEY)
 		grehlen += GRE_HEADER_SECTION;
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -310,7 +310,7 @@ static int tcp4_gro_complete(struct sk_b
 
 	th->check = ~tcp_v4_check(skb->len - thoff, iph->saddr,
 				  iph->daddr, 0);
-	skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 
 	return tcp_gro_complete(skb);
 }
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -73,7 +73,7 @@ static int tcp6_gro_complete(struct sk_b
 
 	th->check = ~tcp_v6_check(skb->len - thoff, &iph->saddr,
 				  &iph->daddr, 0);
-	skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+	skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
 
 	return tcp_gro_complete(skb);
 }


