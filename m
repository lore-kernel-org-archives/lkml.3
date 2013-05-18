Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3ERDLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:11:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab3ERDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:19 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=8bKXFs38aGUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=M9DoCIHMhNUA:10 a=ykoPv_dRAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=hGjLu6hZXNMA:10 a=H_jQXghYZ-gA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021657.908124317@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@gnumonks.org>
Subject: [ 101/136 ] netfilter: ctnetlink: dont permit ct creation with random tuple
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0101-netfilter-ctnetlink-don-t-permit-ct-creation-with-ra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 442fad9423b78319e0019a7f5047eddf3317afbc ]

Userspace can cause kernel panic by not specifying orig/reply
tuple: kernel will create a tuple with random stack values.

Problem is that tuple.dst.dir will be random, too, which
causes nf_ct_tuplehash_to_ctrack() to return garbage.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@gnumonks.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netfilter/nf_conntrack_netlink.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9807f32..0f15779 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1579,6 +1579,9 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (nlh->nlmsg_flags & NLM_F_CREATE) {
 			enum ip_conntrack_events events;
 
+			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
+				return -EINVAL;
+
 			ct = ctnetlink_create_conntrack(net, zone, cda, &otuple,
 							&rtuple, u3);
 			if (IS_ERR(ct))
-- 
1.7.10.4


