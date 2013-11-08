Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab3KHCes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:34:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab3KHCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christophe Gouault <christophe.gouault@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 25/91] vti: get rid of nf mark rule in prerouting
Date: Thu,  7 Nov 2013 18:14:40 -0800
Message-Id: <1383876946-2396-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Gouault <christophe.gouault@6wind.com>

[ Upstream commit 7263a5187f9e9de45fcb51349cf0e031142c19a1 ]

This patch fixes and improves the use of vti interfaces (while
lightly changing the way of configuring them).

Currently:

- it is necessary to identify and mark inbound IPsec
  packets destined to each vti interface, via netfilter rules in
  the mangle table at prerouting hook.

- the vti module cannot retrieve the right tunnel in input since
  commit b9959fd3: vti tunnels all have an i_key, but the tunnel lookup
  is done with flag TUNNEL_NO_KEY, so there no chance to retrieve them.

- the i_key is used by the outbound processing as a mark to lookup
  for the right SP and SA bundle.

This patch uses the o_key to store the vti mark (instead of i_key) and
enables:

- to avoid the need for previously marking the inbound skbuffs via a
  netfilter rule.
- to properly retrieve the right tunnel in input, only based on the IPsec
  packet outer addresses.
- to properly perform an inbound policy check (using the tunnel o_key
  as a mark).
- to properly perform an outbound SPD and SAD lookup (using the tunnel
  o_key as a mark).
- to keep the current mark of the skbuff. The skbuff mark is neither
  used nor changed by the vti interface. Only the vti interface o_key
  is used.

SAs have a wildcard mark.
SPs have a mark equal to the vti interface o_key.

The vti interface must be created as follows (i_key = 0, o_key = mark):

   ip link add vti1 mode vti local 1.1.1.1 remote 2.2.2.2 okey 1

The SPs attached to vti1 must be created as follows (mark = vti1 o_key):

   ip xfrm policy add dir out mark 1 tmpl src 1.1.1.1 dst 2.2.2.2 \
      proto esp mode tunnel
   ip xfrm policy add dir in  mark 1 tmpl src 2.2.2.2 dst 1.1.1.1 \
      proto esp mode tunnel

The SAs are created with the default wildcard mark. There is no
distinction between global vs. vti SAs. Just their addresses will
possibly link them to a vti interface:

   ip xfrm state add src 1.1.1.1 dst 2.2.2.2 proto esp spi 1000 mode tunnel \
                 enc "cbc(aes)" "azertyuiopqsdfgh"

   ip xfrm state add src 2.2.2.2 dst 1.1.1.1 proto esp spi 2000 mode tunnel \
                 enc "cbc(aes)" "sqbdhgqsdjqjsdfh"

To avoid matching "global" (not vti) SPs in vti interfaces, global SPs
should no use the default wildcard mark, but explicitly match mark 0.

To avoid a double SPD lookup in input and output (in global and vti SPDs),
the NOPOLICY and NOXFRM options should be set on the vti interfaces:

   echo 1 > /proc/sys/net/ipv4/conf/vti1/disable_policy
   echo 1 > /proc/sys/net/ipv4/conf/vti1/disable_xfrm

The outgoing traffic is steered to vti1 by a route via the vti interface:

   ip route add 192.168.0.0/16 dev vti1

The incoming IPsec traffic is steered to vti1 because its outer addresses
match the vti1 tunnel configuration.

Signed-off-by: Christophe Gouault <christophe.gouault@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_vti.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 5ccf343..d011525 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -323,8 +323,17 @@ static int vti_rcv(struct sk_buff *skb)
 	tunnel = vti_tunnel_lookup(dev_net(skb->dev), iph->saddr, iph->daddr);
 	if (tunnel != NULL) {
 		struct pcpu_tstats *tstats;
+		u32 oldmark = skb->mark;
+		int ret;
 
-		if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
+
+		/* temporarily mark the skb with the tunnel o_key, to
+		 * only match policies with this mark.
+		 */
+		skb->mark = be32_to_cpu(tunnel->parms.o_key);
+		ret = xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb);
+		skb->mark = oldmark;
+		if (!ret)
 			return -1;
 
 		tstats = this_cpu_ptr(tunnel->dev->tstats);
@@ -333,7 +342,6 @@ static int vti_rcv(struct sk_buff *skb)
 		tstats->rx_bytes += skb->len;
 		u64_stats_update_end(&tstats->syncp);
 
-		skb->mark = 0;
 		secpath_reset(skb);
 		skb->dev = tunnel->dev;
 		return 1;
@@ -365,7 +373,7 @@ static netdev_tx_t vti_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memset(&fl4, 0, sizeof(fl4));
 	flowi4_init_output(&fl4, tunnel->parms.link,
-			   be32_to_cpu(tunnel->parms.i_key), RT_TOS(tos),
+			   be32_to_cpu(tunnel->parms.o_key), RT_TOS(tos),
 			   RT_SCOPE_UNIVERSE,
 			   IPPROTO_IPIP, 0,
 			   dst, tiph->saddr, 0, 0);
-- 
1.8.1.2

