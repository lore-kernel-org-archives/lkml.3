Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaFFTT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:19:26 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:45948 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaFFTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:19:24 -0400
Date: Fri, 6 Jun 2014 23:19:21 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
Message-Id: <20140606231921.2ff39106ac54216fd9170fae@qrator.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipv4_{update_pmtu,redirect} were called with tunnel's ifindex (t->dev is a 
tunnel netdevice). It caused wrong route lookup and failure of pmtu update or 
redirect. We should use the same ifindex that we use in ip_route_output_* in 
*tunnel_xmit code. It is t->parms.link .

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
---
 net/ipv4/ipip.c | 4 ++--
 net/ipv6/sit.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 812b183..09680dd 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -149,13 +149,13 @@ static int ipip_err(struct sk_buff *skb, u32 info)
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-				 t->dev->ifindex, 0, IPPROTO_IPIP, 0);
+				 t->parms.link, 0, IPPROTO_IPIP, 0);
 		err = 0;
 		goto out;
 	}
 
 	if (type == ICMP_REDIRECT) {
-		ipv4_redirect(skb, dev_net(skb->dev), t->dev->ifindex, 0,
+		ipv4_redirect(skb, dev_net(skb->dev), t->parms.link, 0,
 			      IPPROTO_IPIP, 0);
 		err = 0;
 		goto out;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index e5a453c..45397b2 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -560,12 +560,12 @@ static int ipip6_err(struct sk_buff *skb, u32 info)
 
 	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED) {
 		ipv4_update_pmtu(skb, dev_net(skb->dev), info,
-				 t->dev->ifindex, 0, IPPROTO_IPV6, 0);
+				 t->parms.link, 0, IPPROTO_IPV6, 0);
 		err = 0;
 		goto out;
 	}
 	if (type == ICMP_REDIRECT) {
-		ipv4_redirect(skb, dev_net(skb->dev), t->dev->ifindex, 0,
+		ipv4_redirect(skb, dev_net(skb->dev), t->parms.link, 0,
 			      IPPROTO_IPV6, 0);
 		err = 0;
 		goto out;
