Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3FYSe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3FYSeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 79/95] packet: set transport header before doing xmit
Date: Tue, 25 Jun 2013 11:33:06 -0700
Message-Id: <20130625182202.513570963@linuxfoundation.org>
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

[ Upstream commit c1aad275b0293d2b1905ec95a945422262470684 ]

Set the transport header for 1) some drivers (e.g ixgbe needs l4 header to do
atr) 2) precise packet length estimation (introduced in 1def9238) needs l4
header to compute header length.

So this patch first tries to get l4 header for packet socket through
skb_flow_dissect(), and pretend no l4 header if skb_flow_dissect() fails.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -88,6 +88,7 @@
 #include <linux/virtio_net.h>
 #include <linux/errqueue.h>
 #include <linux/net_tstamp.h>
+#include <net/flow_keys.h>
 
 #ifdef CONFIG_INET
 #include <net/inet_common.h>
@@ -1343,6 +1344,7 @@ static int packet_sendmsg_spkt(struct ki
 	__be16 proto = 0;
 	int err;
 	int extra_len = 0;
+	struct flow_keys keys;
 
 	/*
 	 *	Get and verify the address.
@@ -1443,6 +1445,11 @@ retry:
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
 
+	if (skb_flow_dissect(skb, &keys))
+		skb_set_transport_header(skb, keys.thoff);
+	else
+		skb_reset_transport_header(skb);
+
 	dev_queue_xmit(skb);
 	rcu_read_unlock();
 	return len;
@@ -1849,6 +1856,7 @@ static int tpacket_fill_skb(struct packe
 	struct page *page;
 	void *data;
 	int err;
+	struct flow_keys keys;
 
 	ph.raw = frame;
 
@@ -1874,6 +1882,11 @@ static int tpacket_fill_skb(struct packe
 	skb_reserve(skb, hlen);
 	skb_reset_network_header(skb);
 
+	if (skb_flow_dissect(skb, &keys))
+		skb_set_transport_header(skb, keys.thoff);
+	else
+		skb_reset_transport_header(skb);
+
 	if (po->tp_tx_has_off) {
 		int off_min, off_max, off;
 		off_min = po->tp_hdrlen - sizeof(struct sockaddr_ll);
@@ -2130,6 +2143,7 @@ static int packet_snd(struct socket *soc
 	unsigned short gso_type = 0;
 	int hlen, tlen;
 	int extra_len = 0;
+	struct flow_keys keys;
 
 	/*
 	 *	Get and verify the address.
@@ -2282,6 +2296,13 @@ static int packet_snd(struct socket *soc
 		len += vnet_hdr_len;
 	}
 
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		skb_set_transport_header(skb, skb_checksum_start_offset(skb));
+	else if (skb_flow_dissect(skb, &keys))
+		skb_set_transport_header(skb, keys.thoff);
+	else
+		skb_set_transport_header(skb, reserve);
+
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
 


