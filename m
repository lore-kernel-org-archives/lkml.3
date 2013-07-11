Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab3GKO0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43050 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab3GKO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/98] netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()
Date: Thu, 11 Jul 2013 15:24:18 +0100
Message-Id: <1373552708-15235-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ed82c437320c48a4032492f4a55a7e2c934158b6 upstream.

In (bc6bcb5 netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
packet boundary), the use of tcp_hdr was introduced. However, we
cannot assume that skb->transport_header is set for non-local packets.

Cc: Florian Westphal <fw@strlen.de>
Reported-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/xt_TCPOPTSTRIP.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 1eb1a44..b68fa19 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -48,11 +48,13 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 		return NF_DROP;
 
 	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr) ||
-	    tcp_hdr(skb)->doff * 4 > len)
+	if (len < (int)sizeof(struct tcphdr))
 		return NF_DROP;
 
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	if (tcph->doff * 4 > len)
+		return NF_DROP;
+
 	opt  = (u_int8_t *)tcph;
 
 	/*
-- 
1.8.1.2

