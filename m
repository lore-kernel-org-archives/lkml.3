Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966374AbaFQVtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:49:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54151 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407AbaFQVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ying Cai <ycai@google.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 043/212] ip_tunnel: Set network header properly for IP_ECN_decapsulate()
Date: Tue, 17 Jun 2014 14:42:17 -0700
Message-Id: <1403041506-13646-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Cai <ycai@google.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 1febfa1..30a6000 100644
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
1.9.1

