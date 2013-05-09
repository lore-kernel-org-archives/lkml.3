Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab3EIWdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3EIWc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 24/73] netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too
Date: Thu,  9 May 2013 15:31:47 -0700
Message-Id: <20130509222800.615292349@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit f83a7ea2075ca896f2dbf07672bac9cf3682ff74 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/ipt_rpfilter.c  |    8 +++++++-
 net/ipv6/netfilter/ip6t_rpfilter.c |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -66,6 +66,12 @@ static bool rpfilter_lookup_reverse(stru
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
@@ -76,7 +82,7 @@ static bool rpfilter_mt(const struct sk_
 	info = par->matchinfo;
 	invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (rpfilter_is_local(skb))
 		return true ^ invert;
 
 	iph = ip_hdr(skb);
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -71,6 +71,12 @@ static bool rpfilter_lookup_reverse6(con
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
@@ -78,7 +84,7 @@ static bool rpfilter_mt(const struct sk_
 	struct ipv6hdr *iph;
 	bool invert = info->flags & XT_RPFILTER_INVERT;
 
-	if (par->in->flags & IFF_LOOPBACK)
+	if (rpfilter_is_local(skb))
 		return true ^ invert;
 
 	iph = ipv6_hdr(skb);


