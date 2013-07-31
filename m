Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339Ab3GaPV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:21:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:31248 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GaPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:21:55 -0400
Message-ID: <799eca39dc7f85ba12e1d8c5b072f8b6740fda1c.1375283106.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375283104.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	<cover.1375283104.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 31 Jul 2013 11:05:04 -0400
Subject: [PATCH 09/12] tile: support TSO for IPv6 in tilegx network driver
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/net/ethernet/tile/tilegx.c | 44 +++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 01068a9..ebc1b43 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -36,6 +36,7 @@
 #include <linux/io.h>
 #include <linux/ctype.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/tcp.h>
 
 #include <asm/checksum.h>
@@ -1512,20 +1513,20 @@ static int tso_count_edescs(struct sk_buff *skb)
 	return num_edescs;
 }
 
-/* Prepare modified copies of the skbuff headers.
- * FIXME: add support for IPv6.
- */
+/* Prepare modified copies of the skbuff headers. */
 static void tso_headers_prepare(struct sk_buff *skb, unsigned char *headers,
 				s64 slot)
 {
 	struct skb_shared_info *sh = skb_shinfo(skb);
 	struct iphdr *ih;
+	struct ipv6hdr *ih6;
 	struct tcphdr *th;
 	unsigned int sh_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	unsigned int data_len = skb->len - sh_len;
 	unsigned char *data = skb->data;
 	unsigned int ih_off, th_off, p_len;
 	unsigned int isum_seed, tsum_seed, id, seq;
+	int is_ipv6;
 	long f_id = -1;    /* id of the current fragment */
 	long f_size = skb_headlen(skb) - sh_len;  /* current fragment size */
 	long f_used = 0;  /* bytes used from the current fragment */
@@ -1533,18 +1534,24 @@ static void tso_headers_prepare(struct sk_buff *skb, unsigned char *headers,
 	int segment;
 
 	/* Locate original headers and compute various lengths. */
-	ih = ip_hdr(skb);
+	is_ipv6 = skb_is_gso_v6(skb);
+	if (is_ipv6) {
+		ih6 = ipv6_hdr(skb);
+		ih_off = skb_network_offset(skb);
+	} else {
+		ih = ip_hdr(skb);
+		ih_off = skb_network_offset(skb);
+		isum_seed = ((0xFFFF - ih->check) +
+			     (0xFFFF - ih->tot_len) +
+			     (0xFFFF - ih->id));
+		id = ntohs(ih->id);
+	}
+
 	th = tcp_hdr(skb);
-	ih_off = skb_network_offset(skb);
 	th_off = skb_transport_offset(skb);
 	p_len = sh->gso_size;
 
-	/* Set up seed values for IP and TCP csum and initialize id and seq. */
-	isum_seed = ((0xFFFF - ih->check) +
-		     (0xFFFF - ih->tot_len) +
-		     (0xFFFF - ih->id));
 	tsum_seed = th->check + (0xFFFF ^ htons(skb->len));
-	id = ntohs(ih->id);
 	seq = ntohl(th->seq);
 
 	/* Prepare all the headers. */
@@ -1558,11 +1565,17 @@ static void tso_headers_prepare(struct sk_buff *skb, unsigned char *headers,
 		memcpy(buf, data, sh_len);
 
 		/* Update copied ip header. */
-		ih = (struct iphdr *)(buf + ih_off);
-		ih->tot_len = htons(sh_len + p_len - ih_off);
-		ih->id = htons(id);
-		ih->check = csum_long(isum_seed + ih->tot_len +
-				      ih->id) ^ 0xffff;
+		if (is_ipv6) {
+			ih6 = (struct ipv6hdr *)(buf + ih_off);
+			ih6->payload_len = htons(sh_len + p_len - ih_off -
+						 sizeof(*ih6));
+		} else {
+			ih = (struct iphdr *)(buf + ih_off);
+			ih->tot_len = htons(sh_len + p_len - ih_off);
+			ih->id = htons(id);
+			ih->check = csum_long(isum_seed + ih->tot_len +
+					      ih->id) ^ 0xffff;
+		}
 
 		/* Update copied tcp header. */
 		th = (struct tcphdr *)(buf + th_off);
@@ -1950,6 +1963,7 @@ static void tile_net_setup(struct net_device *dev)
 	dev->features |= NETIF_F_HW_CSUM;
 	dev->features |= NETIF_F_SG;
 	dev->features |= NETIF_F_TSO;
+	dev->features |= NETIF_F_TSO6;
 	dev->mtu = 1500;
 }
 
-- 
1.8.3.1

