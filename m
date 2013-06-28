Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3F1TCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:02:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3F1S6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Kubecek <mkubecek@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 076/105] ipv4: fix redirect handling for TCP packets
Date: Fri, 28 Jun 2013 11:51:38 -0700
Message-Id: <1372445527-24414-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/route.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a0fcc47..70da494 100644
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
1.8.1.2

