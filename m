Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab3GKO0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab3GKO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Oester <kernel@linuxace.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 50/98] netfilter: xt_TCPMSS: Fix IPv6 default MSS too
Date: Thu, 11 Jul 2013 15:24:20 +0100
Message-Id: <1373552708-15235-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

commit 70d19f805f8c047fc0a28dec9306b3773971c8d9 upstream.

As a followup to commit 409b545a ("netfilter: xt_TCPMSS: Fix violation
of RFC879 in absence of MSS option"), John Heffner points out that IPv6
has a higher MTU than IPv4, and thus a higher minimum MSS. Update TCPMSS
target to account for this, and update RFC comment.

While at it, point to more recent reference RFC1122 instead of RFC879.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/xt_TCPMSS.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index a77d786..cc2b572 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -44,11 +44,12 @@ optlen(const u_int8_t *opt, unsigned int offset)
 
 static int
 tcpmss_mangle_packet(struct sk_buff *skb,
-		     const struct xt_tcpmss_info *info,
+		     const struct xt_action_param *par,
 		     unsigned int in_mtu,
 		     unsigned int tcphoff,
 		     unsigned int minlen)
 {
+	const struct xt_tcpmss_info *info = par->targinfo;
 	struct tcphdr *tcph;
 	unsigned int tcplen, i;
 	__be16 oldval;
@@ -128,11 +129,17 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 	skb_put(skb, TCPOLEN_MSS);
 
-	/* RFC 879 states that the default MSS is 536 without specific
-	 * knowledge that the destination host is prepared to accept larger.
-	 * Since no MSS was provided, we MUST NOT set a value > 536.
+	/*
+	 * IPv4: RFC 1122 states "If an MSS option is not received at
+	 * connection setup, TCP MUST assume a default send MSS of 536".
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
 	 */
-	newmss = min(newmss, (u16)536);
+	if (par->family == NFPROTO_IPV4)
+		newmss = min(newmss, (u16)536);
+	else
+		newmss = min(newmss, (u16)1220);
 
 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
@@ -191,7 +198,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, par->targinfo,
+	ret = tcpmss_mangle_packet(skb, par,
 				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
@@ -220,7 +227,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, par->targinfo,
+	ret = tcpmss_mangle_packet(skb, par,
 				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
-- 
1.8.1.2

