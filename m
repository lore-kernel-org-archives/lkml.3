Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab3DBWgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:36:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500Ab3DBWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Erik Hugne <erik.hugne@ericsson.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 117/124] ipv6: dont accept node local multicast traffic from the wire
Date: Tue,  2 Apr 2013 15:11:39 -0700
Message-Id: <20130402221117.720986532@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 1c4a154e5253687c51123956dfcee9e9dfa8542d ]

Erik Hugne's errata proposal (Errata ID: 3480) to RFC4291 has been
verified: http://www.rfc-editor.org/errata_search.php?eid=3480

We have to check for pkt_type and loopback flag because either the
packets are allowed to travel over the loopback interface (in which case
pkt_type is PACKET_HOST and IFF_LOOPBACK flag is set) or they travel
over a non-loopback interface back to us (in which case PACKET_TYPE is
PACKET_LOOPBACK and IFF_LOOPBACK flag is not set).

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Erik Hugne <erik.hugne@ericsson.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_input.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -118,6 +118,18 @@ int ipv6_rcv(struct sk_buff *skb, struct
 	    ipv6_addr_loopback(&hdr->daddr))
 		goto err;
 
+	/* RFC4291 Errata ID: 3480
+	 * Interface-Local scope spans only a single interface on a
+	 * node and is useful only for loopback transmission of
+	 * multicast.  Packets with interface-local scope received
+	 * from another node must be discarded.
+	 */
+	if (!(skb->pkt_type == PACKET_LOOPBACK ||
+	      dev->flags & IFF_LOOPBACK) &&
+	    ipv6_addr_is_multicast(&hdr->daddr) &&
+	    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 1)
+		goto err;
+
 	/* RFC4291 2.7
 	 * Nodes must not originate a packet to a multicast address whose scope
 	 * field contains the reserved value 0; if such a packet is received, it


