Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889Ab3D2TkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:40:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab3D2TCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
        Eric Dumazet <edumazet@google.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>, John Eaglesham <linux@8192.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/42] bonding: fix l23 and l34 load balancing in forwarding path
Date: Mon, 29 Apr 2013 12:02:07 -0700
Message-Id: <20130429184755.260385446@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4394542ca4ec9f28c3c8405063d200b1e7c347d7 ]

Since commit 6b923cb7188d46 (bonding: support for IPv6 transmit hashing)
bonding doesn't properly hash traffic in forwarding setups.

Vitaly V. Bursov diagnosed that skb_network_header_len() returned 0 in
this case.

More generally, the transport header might not be in the skb head.

Use pskb_may_pull() & skb_header_pointer() to get it right, and use
proto_ports_offset() in bond_xmit_hash_policy_l34() to get support for
more protocols than TCP and UDP.

Reported-by: Vitaly V. Bursov <vitalyb@telenet.dn.ua>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jay Vosburgh <fubar@us.ibm.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: John Eaglesham <linux@8192.net>
Tested-by: Vitaly V. Bursov <vitalyb@telenet.dn.ua>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   55 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3380,20 +3380,22 @@ static int bond_xmit_hash_policy_l2(stru
  */
 static int bond_xmit_hash_policy_l23(struct sk_buff *skb, int count)
 {
-	struct ethhdr *data = (struct ethhdr *)skb->data;
-	struct iphdr *iph;
-	struct ipv6hdr *ipv6h;
+	const struct ethhdr *data;
+	const struct iphdr *iph;
+	const struct ipv6hdr *ipv6h;
 	u32 v6hash;
-	__be32 *s, *d;
+	const __be32 *s, *d;
 
 	if (skb->protocol == htons(ETH_P_IP) &&
-	    skb_network_header_len(skb) >= sizeof(*iph)) {
+	    pskb_network_may_pull(skb, sizeof(*iph))) {
 		iph = ip_hdr(skb);
+		data = (struct ethhdr *)skb->data;
 		return ((ntohl(iph->saddr ^ iph->daddr) & 0xffff) ^
 			(data->h_dest[5] ^ data->h_source[5])) % count;
 	} else if (skb->protocol == htons(ETH_P_IPV6) &&
-		   skb_network_header_len(skb) >= sizeof(*ipv6h)) {
+		   pskb_network_may_pull(skb, sizeof(*ipv6h))) {
 		ipv6h = ipv6_hdr(skb);
+		data = (struct ethhdr *)skb->data;
 		s = &ipv6h->saddr.s6_addr32[0];
 		d = &ipv6h->daddr.s6_addr32[0];
 		v6hash = (s[1] ^ d[1]) ^ (s[2] ^ d[2]) ^ (s[3] ^ d[3]);
@@ -3412,33 +3414,36 @@ static int bond_xmit_hash_policy_l23(str
 static int bond_xmit_hash_policy_l34(struct sk_buff *skb, int count)
 {
 	u32 layer4_xor = 0;
-	struct iphdr *iph;
-	struct ipv6hdr *ipv6h;
-	__be32 *s, *d;
-	__be16 *layer4hdr;
+	const struct iphdr *iph;
+	const struct ipv6hdr *ipv6h;
+	const __be32 *s, *d;
+	const __be16 *l4 = NULL;
+	__be16 _l4[2];
+	int noff = skb_network_offset(skb);
+	int poff;
 
 	if (skb->protocol == htons(ETH_P_IP) &&
-	    skb_network_header_len(skb) >= sizeof(*iph)) {
+	    pskb_may_pull(skb, noff + sizeof(*iph))) {
 		iph = ip_hdr(skb);
-		if (!ip_is_fragment(iph) &&
-		    (iph->protocol == IPPROTO_TCP ||
-		     iph->protocol == IPPROTO_UDP) &&
-		    (skb_headlen(skb) - skb_network_offset(skb) >=
-		     iph->ihl * sizeof(u32) + sizeof(*layer4hdr) * 2)) {
-			layer4hdr = (__be16 *)((u32 *)iph + iph->ihl);
-			layer4_xor = ntohs(*layer4hdr ^ *(layer4hdr + 1));
+		poff = proto_ports_offset(iph->protocol);
+
+		if (!ip_is_fragment(iph) && poff >= 0) {
+			l4 = skb_header_pointer(skb, noff + (iph->ihl << 2) + poff,
+						sizeof(_l4), &_l4);
+			if (l4)
+				layer4_xor = ntohs(l4[0] ^ l4[1]);
 		}
 		return (layer4_xor ^
 			((ntohl(iph->saddr ^ iph->daddr)) & 0xffff)) % count;
 	} else if (skb->protocol == htons(ETH_P_IPV6) &&
-		   skb_network_header_len(skb) >= sizeof(*ipv6h)) {
+		   pskb_may_pull(skb, noff + sizeof(*ipv6h))) {
 		ipv6h = ipv6_hdr(skb);
-		if ((ipv6h->nexthdr == IPPROTO_TCP ||
-		     ipv6h->nexthdr == IPPROTO_UDP) &&
-		    (skb_headlen(skb) - skb_network_offset(skb) >=
-		     sizeof(*ipv6h) + sizeof(*layer4hdr) * 2)) {
-			layer4hdr = (__be16 *)(ipv6h + 1);
-			layer4_xor = ntohs(*layer4hdr ^ *(layer4hdr + 1));
+		poff = proto_ports_offset(ipv6h->nexthdr);
+		if (poff >= 0) {
+			l4 = skb_header_pointer(skb, noff + sizeof(*ipv6h) + poff,
+						sizeof(_l4), &_l4);
+			if (l4)
+				layer4_xor = ntohs(l4[0] ^ l4[1]);
 		}
 		s = &ipv6h->saddr.s6_addr32[0];
 		d = &ipv6h->daddr.s6_addr32[0];


