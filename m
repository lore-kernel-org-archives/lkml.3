Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3FYSeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3FYSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 80/95] netback: set transport header before passing it to kernel
Date: Tue, 25 Jun 2013 11:33:07 -0700
Message-Id: <20130625182202.613427055@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit f9ca8f74399f9195fd8e01f67a8424a8d33efa55 ]

Currently, for the packets receives from netback, before doing header check,
kernel just reset the transport header in netif_receive_skb() which pretends non
l4 header. This is suboptimal for precise packet length estimation (introduced
in 1def9238: net_sched: more precise pkt_len computation) which needs correct l4
header for gso packets.

The patch just reuse the header probed by netback for partial checksum packets
and tries to use skb_flow_dissect() for other cases, if both fail, just pretend
no l4 header.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -39,6 +39,7 @@
 #include <linux/udp.h>
 
 #include <net/tcp.h>
+#include <net/flow_keys.h>
 
 #include <xen/xen.h>
 #include <xen/events.h>
@@ -1352,6 +1353,7 @@ static int checksum_setup(struct xenvif
 	if (th >= skb_tail_pointer(skb))
 		goto out;
 
+	skb_set_transport_header(skb, 4 * iph->ihl);
 	skb->csum_start = th - skb->head;
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
@@ -1665,6 +1667,7 @@ static void xen_netbk_tx_submit(struct x
 
 		skb->dev      = vif->dev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
+		skb_reset_network_header(skb);
 
 		if (checksum_setup(vif, skb)) {
 			netdev_dbg(vif->dev,
@@ -1673,6 +1676,15 @@ static void xen_netbk_tx_submit(struct x
 			continue;
 		}
 
+		if (!skb_transport_header_was_set(skb)) {
+			struct flow_keys keys;
+
+			if (skb_flow_dissect(skb, &keys))
+				skb_set_transport_header(skb, keys.thoff);
+			else
+				skb_reset_transport_header(skb);
+		}
+
 		vif->dev->stats.rx_bytes += skb->len;
 		vif->dev->stats.rx_packets++;
 


