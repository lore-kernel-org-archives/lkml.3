Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3ERDMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:12:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3ERDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:19 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ADZUxGX7H0cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mujkyXenZWAA:10 a=3HDBlxybAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=hGjLu6hZXNMA:10 a=m2JXGx9I94EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021658.069606191@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 102/136 ] netfilter: xt_rpfilter: skip locally generated broadcast/multicast,
 too
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0102-netfilter-xt_rpfilter-skip-locally-generated-broadca.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f83a7ea2075ca896f2dbf07672bac9cf3682ff74 ]

Alex Efros reported rpfilter module doesn't match following packets:
IN=br.qemu SRC=192.168.2.1 DST=192.168.2.255 [ .. ]
(netfilter bugzilla #814).

Problem is that network stack arranges for the locally generated broadcasts
to appear on the interface they were sent out, so the IFF_LOOPBACK check
doesn't trigger.

As -m rpfilter is restricted to PREROUTING, we can check for existing
rtable instead, it catches locally-generated broad/multicast case, too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/netfilter/ipt_rpfilter.c  |    8 +++++++-
 net/ipv6/netfilter/ip6t_rpfilter.c |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 31371be..5d60ca1 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -66,6 +66,12 @@ static bool rpfilter_lookup_reverse(struct flowi4 *fl4,
 	return dev_match;
 }
 
+static bool rpfilter_is_local(const struct sk_buff *skb)
+{
+	const struct rtable *rt = skb_rtable(skb);
+	return rt && (rt->rt_flags & RTCF_LOCAL);
+}
+
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rpfilter_info *info;
@@ -76,7 +82,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	info = par->matchinfo;
 	invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (rpfilter_is_local(skb))
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 5d1d8b0..a7b522f 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -71,6 +71,12 @@ static bool rpfilter_lookup_reverse6(const struct sk_buff *skb,
 	return ret;
 }
 
+static bool rpfilter_is_local(const struct sk_buff *skb)
+{
+	const struct rt6_info *rt = (const void *) skb_dst(skb);
+	return rt && (rt->rt6i_flags & RTF_LOCAL);
+}
+
 static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rpfilter_info *info = par->matchinfo;
@@ -78,7 +84,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6hdr *iph;
 	bool invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (rpfilter_is_local(skb))
 		return true ^ invert;
 
 	iph = ipv6_hdr(skb);
-- 
1.7.10.4


