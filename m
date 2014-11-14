Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724AbaKNAii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:38:38 -0500
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:51841 "HELO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934635AbaKNAif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:38:35 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, shahed.shaikh@qlogic.com, amirv@mellanox.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        gerlitz.or@gmail.com, alexander.duyck@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 net 1/4] net: Add vxlan_gso_check() helper
Date: Thu, 13 Nov 2014 16:38:12 -0800
Message-Id: <1415925495-59312-2-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
References: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most NICs that report NETIF_F_GSO_UDP_TUNNEL support VXLAN, and not
other UDP-based encapsulation protocols where the format and size of the
header differs. This patch implements a generic ndo_gso_check() for
VXLAN which will only advertise GSO support when the skb looks like it
contains VXLAN (or no UDP tunnelling at all).

Implementation shamelessly stolen from Tom Herbert:
http://thread.gmane.org/gmane.linux.network/332428/focus=333111

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
v2: Merge helpers for be2net, mlx4, qlcnic
    Use (sizeof(struct udphdr) + sizeof(struct vxlanhdr))
v1: Initial post
---
 drivers/net/vxlan.c |   13 +++++++++++++
 include/net/vxlan.h |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index fa9dc45..6b65863 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1571,6 +1571,19 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
+bool vxlan_gso_check(struct sk_buff *skb)
+{
+	if ((skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) &&
+	    (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+	     skb->inner_protocol != htons(ETH_P_TEB) ||
+	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
+	      sizeof(struct udphdr) + sizeof(struct vxlanhdr))))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(vxlan_gso_check);
+
 #if IS_ENABLED(CONFIG_IPV6)
 static int vxlan6_xmit_skb(struct vxlan_sock *vs,
 			   struct dst_entry *dst, struct sk_buff *skb,
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index d5f59f3..afadf8e 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -45,6 +45,8 @@ int vxlan_xmit_skb(struct vxlan_sock *vs,
 		   __be32 src, __be32 dst, __u8 tos, __u8 ttl, __be16 df,
 		   __be16 src_port, __be16 dst_port, __be32 vni, bool xnet);
 
+bool vxlan_gso_check(struct sk_buff *skb);
+
 /* IP header + UDP + VXLAN + Ethernet header */
 #define VXLAN_HEADROOM (20 + 8 + 8 + 14)
 /* IPv6 header + UDP + VXLAN + Ethernet header */
-- 
1.7.10.4

