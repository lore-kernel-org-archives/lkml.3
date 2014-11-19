Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348AbaKSW3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:29:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbaKSUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jesse Gross <jesse@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 009/141] udptunnel: Add SKB_GSO_UDP_TUNNEL during gro_complete.
Date: Wed, 19 Nov 2014 12:50:32 -0800
Message-Id: <20141119205150.986546753@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Gross <jesse@nicira.com>

[ Upstream commit cfdf1e1ba5bf55e095cf4bcaa9585c4759f239e8 ]

When doing GRO processing for UDP tunnels, we never add
SKB_GSO_UDP_TUNNEL to gso_type - only the type of the inner protocol
is added (such as SKB_GSO_TCPV4). The result is that if the packet is
later resegmented we will do GSO but not treat it as a tunnel. This
results in UDP fragmentation of the outer header instead of (i.e.) TCP
segmentation of the inner header as was originally on the wire.

Signed-off-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c      |    2 ++
 include/net/udp_tunnel.h |    9 +++++++++
 2 files changed, 11 insertions(+)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -620,6 +620,8 @@ static int vxlan_gro_complete(struct sk_
 	int vxlan_len  = sizeof(struct vxlanhdr) + sizeof(struct ethhdr);
 	int err = -ENOSYS;
 
+	udp_tunnel_gro_complete(skb, nhoff);
+
 	eh = (struct ethhdr *)(skb->data + nhoff + sizeof(struct vxlanhdr));
 	type = eh->h_proto;
 
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -26,6 +26,15 @@ struct udp_port_cfg {
 				use_udp6_rx_checksums:1;
 };
 
+static inline void udp_tunnel_gro_complete(struct sk_buff *skb, int nhoff)
+{
+	struct udphdr *uh;
+
+	uh = (struct udphdr *)(skb->data + nhoff - sizeof(struct udphdr));
+	skb_shinfo(skb)->gso_type |= uh->check ?
+				SKB_GSO_UDP_TUNNEL_CSUM : SKB_GSO_UDP_TUNNEL;
+}
+
 int udp_sock_create(struct net *net, struct udp_port_cfg *cfg,
 		    struct socket **sockp);
 


