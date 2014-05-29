Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbaE2N7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:59:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59458 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933424AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ying Cai <ycai@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 091/103] ip_tunnel: Set network header properly for IP_ECN_decapsulate()
Date: Thu, 29 May 2014 15:49:16 +0200
Message-Id: <90ca7e93604cfb1f11c2ebf8faf476b3b0ea2e1f.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Cai <ycai@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit e96f2e7c430014eff52c93cabef1ad4f42ed0db1 ]

In ip_tunnel_rcv(), set skb->network_header to inner IP header
before IP_ECN_decapsulate().

Without the fix, IP_ECN_decapsulate() takes outer IP header as
inner IP header, possibly causing error messages or packet drops.

Note that this skb_reset_network_header() call was in this spot when
the original feature for checking consistency of ECN bits through
tunnels was added in eccc1bb8d4b4 ("tunnel: drop packet if ECN present
with not-ECT"). It was only removed from this spot in 3d7b46cd20e3
("ip_tunnel: push generic protocol handling to ip_tunnel module.").

Fixes: 3d7b46cd20e3 ("ip_tunnel: push generic protocol handling to ip_tunnel module.")
Reported-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Ying Cai <ycai@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ip_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 3bedb26cfb53..d626d4059a42 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -433,6 +433,8 @@ int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		tunnel->i_seqno = ntohl(tpi->seq) + 1;
 	}
 
+	skb_reset_network_header(skb);
+
 	err = IP_ECN_decapsulate(iph, skb);
 	if (unlikely(err)) {
 		if (log_ecn_error)
-- 
1.9.3

