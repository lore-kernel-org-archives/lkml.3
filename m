Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab3HMP6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab3HMP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:31 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=RENQMlFli7EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pj_ymyU0sPUA:10 a=1XWaLZrsAAAA:8 a=VPW9pYw8AAAA:8 a=J1Y8HTJGAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=RL2k_qTqmsAA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155826.332162870@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Petre <daniel.petre@rcs-rds.ro>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [17/88] ip_tunnel: fix kernel panic with icmp_dest_unreach
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0017-ip_tunnel-fix-kernel-panic-with-icmp_dest_unreach.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a622260254ee481747cceaaa8609985b29a31565 ]

Daniel Petre reported crashes in icmp_dst_unreach() with following call
graph:

#3 [ffff88003fc03938] __stack_chk_fail at ffffffff81037f77
#4 [ffff88003fc03948] icmp_send at ffffffff814d5fec
#5 [ffff88003fc03ae8] ipv4_link_failure at ffffffff814a1795
#6 [ffff88003fc03af8] ipgre_tunnel_xmit at ffffffff814e7965
#7 [ffff88003fc03b78] dev_hard_start_xmit at ffffffff8146e032
#8 [ffff88003fc03bc8] sch_direct_xmit at ffffffff81487d66
#9 [ffff88003fc03c08] __qdisc_run at ffffffff81487efd
#10 [ffff88003fc03c48] dev_queue_xmit at ffffffff8146e5a7
#11 [ffff88003fc03c88] ip_finish_output at ffffffff814ab596

Daniel found a similar problem mentioned in
 http://lkml.indiana.edu/hypermail/linux/kernel/1007.0/00961.html

And indeed this is the root cause : skb->cb[] contains data fooling IP
stack.

We must clear IPCB in ip_tunnel_xmit() sooner in case dst_link_failure()
is called. Or else skb->cb[] might contain garbage from GSO segmentation
layer.

A similar fix was tested on linux-3.9, but gre code was refactored in
linux-3.10. I'll send patches for stable kernels as well.

Many thanks to Daniel for providing reports, patches and testing !

Reported-by: Daniel Petre <daniel.petre@rcs-rds.ro>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/ip_gre.c |    2 +-
 net/ipv4/ipip.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b062a98..4bdf061 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -756,6 +756,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -899,7 +900,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	skb_reset_transport_header(skb);
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 99af1f0..6cea400 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -481,6 +481,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -563,7 +564,6 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
-- 
1.7.10.4


