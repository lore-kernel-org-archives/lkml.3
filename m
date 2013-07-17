Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab3GQWyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:54:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab3GQWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 071/145] netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
Date: Wed, 17 Jul 2013 15:46:43 -0700
Message-Id: <1374101277-7915-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit bc6bcb59dd7c184d229f9e86d08aa56059938a4c upstream.

This target assumes that tcph->doff is well-formed, that may be well
not the case. Add extra sanity checkings to avoid possible crash due
to read/write out of the real packet boundary. After this patch, the
default action on malformed TCP packets is to drop them. Moreover,
fragments are skipped.

Reported-by: Rafal Kupka <rkupka@telemetry.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/xt_TCPOPTSTRIP.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 25fd1c4..1eb1a44 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -30,17 +30,28 @@ static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
 
 static unsigned int
 tcpoptstrip_mangle_packet(struct sk_buff *skb,
-			  const struct xt_tcpoptstrip_target_info *info,
+			  const struct xt_action_param *par,
 			  unsigned int tcphoff, unsigned int minlen)
 {
+	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
 	unsigned int optl, i, j;
 	struct tcphdr *tcph;
 	u_int16_t n, o;
 	u_int8_t *opt;
+	int len;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
 
 	if (!skb_make_writable(skb, skb->len))
 		return NF_DROP;
 
+	len = skb->len - tcphoff;
+	if (len < (int)sizeof(struct tcphdr) ||
+	    tcp_hdr(skb)->doff * 4 > len)
+		return NF_DROP;
+
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	opt  = (u_int8_t *)tcph;
 
@@ -76,7 +87,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 static unsigned int
 tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, par->targinfo, ip_hdrlen(skb),
+	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb),
 	       sizeof(struct iphdr) + sizeof(struct tcphdr));
 }
 
@@ -94,7 +105,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, par->targinfo, tcphoff,
+	return tcpoptstrip_mangle_packet(skb, par, tcphoff,
 	       sizeof(*ipv6h) + sizeof(struct tcphdr));
 }
 #endif
-- 
1.8.1.2

