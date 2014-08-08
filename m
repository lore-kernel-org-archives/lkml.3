Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaHHVOC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:14:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41089 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaHHUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Popov <ixaphire@qrator.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 221/259] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
Date: Fri,  8 Aug 2014 13:40:44 -0700
Message-Id: <1407530482-4483-222-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Popov <ixaphire@qrator.net>

[ Upstream commit 2346829e641b804ece9ac9298136b56d9567c278 ]

ipv4_{update_pmtu,redirect} were called with tunnel's ifindex (t->dev is a
tunnel netdevice). It caused wrong route lookup and failure of pmtu update or
redirect. We should use the same ifindex that we use in ip_route_output_* in
*tunnel_xmit code. It is t->parms.link .

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ipip.c | 4 ++--
 net/ipv6/sit.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index af34bdb..1e625b0 100644
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
index cd4777e..8f59675 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -559,12 +559,12 @@ static int ipip6_err(struct sk_buff *skb, u32 info)
 
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
-- 
1.9.1

