Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbbALSF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbALSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jesse Gross <jesse@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 003/216] udptunnel: Add SKB_GSO_UDP_TUNNEL during gro_complete.
Date: Mon, 12 Jan 2015 18:02:00 +0000
Message-Id: <1421085933-32536-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Gross <jesse@nicira.com>

commit cfdf1e1ba5bf55e095cf4bcaa9585c4759f239e8 upstream.

When doing GRO processing for UDP tunnels, we never add
SKB_GSO_UDP_TUNNEL to gso_type - only the type of the inner protocol
is added (such as SKB_GSO_TCPV4). The result is that if the packet is
later resegmented we will do GSO but not treat it as a tunnel. This
results in UDP fragmentation of the outer header instead of (i.e.) TCP
segmentation of the inner header as was originally on the wire.

Signed-off-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
[ luis: backported to 3.16:
  - dropped changes to net/ipv4/fou.c
  - inlined call to udp_tunnel_gro_complete() in drivers/net/vxlan.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/vxlan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 24c1bef7abc6..40bf8a87b3d9 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -618,10 +618,15 @@ static int vxlan_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	struct ethhdr *eh;
 	struct packet_offload *ptype;
+	struct udphdr *uh;
 	__be16 type;
 	int vxlan_len  = sizeof(struct vxlanhdr) + sizeof(struct ethhdr);
 	int err = -ENOSYS;
 
+	uh = (struct udphdr *)(skb->data + nhoff - sizeof(struct udphdr));
+	skb_shinfo(skb)->gso_type |= uh->check ?
+		SKB_GSO_UDP_TUNNEL_CSUM : SKB_GSO_UDP_TUNNEL;
+
 	eh = (struct ethhdr *)(skb->data + nhoff + sizeof(struct vxlanhdr));
 	type = eh->h_proto;
 
-- 
2.1.4

