Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbaE2FI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:08:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbaE2Efu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>, Ying Cai <ycai@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 109/140] ip_tunnel: Set network header properly for IP_ECN_decapsulate()
Date: Wed, 28 May 2014 21:34:08 -0700
Message-Id: <20140529043103.601270036@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -438,6 +438,8 @@ int ip_tunnel_rcv(struct ip_tunnel *tunn
 		tunnel->i_seqno = ntohl(tpi->seq) + 1;
 	}
 
+	skb_reset_network_header(skb);
+
 	err = IP_ECN_decapsulate(iph, skb);
 	if (unlikely(err)) {
 		if (log_ecn_error)


