Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3HMQHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:07:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680Ab3HMP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:32 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=K6asIFtlit4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Kv9yAtjYjgMA:10 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155826.627959742@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>, "David S. Miller" <davem@davemloft.net>
Subject: [19/88] ipv4: fix redirect handling for TCP packets
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0019-ipv4-fix-redirect-handling-for-TCP-packets.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michal Kubecek <mkubecek@suse.cz>

[ Upstream commit f96ef988cc603487c03a6de07807b06cbe641829 ]

Unlike ipv4_redirect() and ipv4_sk_redirect(), ip_do_redirect()
doesn't call __build_flow_key() directly but via
ip_rt_build_flow_key() wrapper. This leads to __build_flow_key()
getting pointer to IPv4 header of the ICMP redirect packet
rather than pointer to the embedded IPv4 header of the packet
initiating the redirect.

As a result, handling of ICMP redirects initiated by TCP packets
is broken. Issue was introduced by

	4895c771c ("ipv4: Add FIB nexthop exceptions.")

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/route.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 39de0ca..59781e0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -741,10 +741,15 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
 {
 	struct rtable *rt;
 	struct flowi4 fl4;
+	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	int oif = skb->dev->ifindex;
+	u8 tos = RT_TOS(iph->tos);
+	u8 prot = iph->protocol;
+	u32 mark = skb->mark;
 
 	rt = (struct rtable *) dst;
 
-	ip_rt_build_flow_key(&fl4, sk, skb);
+	__build_flow_key(&fl4, sk, iph, oif, tos, prot, mark, 0);
 	__ip_do_redirect(rt, skb, &fl4, true);
 }
 
-- 
1.7.10.4


