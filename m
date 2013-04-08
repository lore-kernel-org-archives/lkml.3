Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935889Ab3DHJwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42972 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935853Ab3DHJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Erik Hugne <erik.hugne@ericsson.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/102] ipv6: don't accept node local multicast traffic from the wire
Date: Mon,  8 Apr 2013 10:50:32 +0100
Message-Id: <1365414657-29191-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 1c4a154e5253687c51123956dfcee9e9dfa8542d upstream.

Erik Hugne's errata proposal (Errata ID: 3480) to RFC4291 has been
verified: http://www.rfc-editor.org/errata_search.php?eid=3480

We have to check for pkt_type and loopback flag because either the
packets are allowed to travel over the loopback interface (in which case
pkt_type is PACKET_HOST and IFF_LOOPBACK flag is set) or they travel
over a non-loopback interface back to us (in which case PACKET_TYPE is
PACKET_LOOPBACK and IFF_LOOPBACK flag is not set).

Cc: Erik Hugne <erik.hugne@ericsson.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_input.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 311eac7..594a4ec 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -111,6 +111,18 @@ int ipv6_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt
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
-- 
1.8.1.2

