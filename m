Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3FYSeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3FYSeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Kubecek <mkubecek@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 57/95] ipv4: fix redirect handling for TCP packets
Date: Tue, 25 Jun 2013 11:32:44 -0700
Message-Id: <20130625182200.093802936@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -737,10 +737,15 @@ static void ip_do_redirect(struct dst_en
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
 


