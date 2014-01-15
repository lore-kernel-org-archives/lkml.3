Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaAOC06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:26:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:36158 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaAOCYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:24:31 -0500
From: Ying Xue <ying.xue@windriver.com>
To: <davem@davemloft.net>
CC: <vfalico@redhat.com>, <john.r.fastabend@intel.com>,
        <stephen@networkplumber.org>, <antonio@meshcoding.com>,
        <dmitry.tarnyagin@lockless.no>, <socketcan@hartkopp.net>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 05/10] decnet: use __dev_get_by_index instead of dev_get_by_index to find interface
Date: Wed, 15 Jan 2014 10:23:40 +0800
Message-ID: <1389752625-23189-6-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389752625-23189-1-git-send-email-ying.xue@windriver.com>
References: <1389752625-23189-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following call chain we can identify that dn_cache_getroute() is
protected under rtnl_lock. So if we use __dev_get_by_index() instead
of dev_get_by_index() to find interface handlers in it, this would help
us avoid to change interface reference counter.

rtnetlink_rcv()
  rtnl_lock()
    netlink_rcv_skb()
      dn_cache_getroute()
  rtnl_unlock()

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 net/decnet/dn_route.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index ad2efa5..ce0cbbf 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1666,12 +1666,8 @@ static int dn_cache_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh)
 
 	if (fld.flowidn_iif) {
 		struct net_device *dev;
-		if ((dev = dev_get_by_index(&init_net, fld.flowidn_iif)) == NULL) {
-			kfree_skb(skb);
-			return -ENODEV;
-		}
-		if (!dev->dn_ptr) {
-			dev_put(dev);
+		dev = __dev_get_by_index(&init_net, fld.flowidn_iif);
+		if (!dev || !dev->dn_ptr) {
 			kfree_skb(skb);
 			return -ENODEV;
 		}
@@ -1693,8 +1689,6 @@ static int dn_cache_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh)
 		err = dn_route_output_key((struct dst_entry **)&rt, &fld, 0);
 	}
 
-	if (skb->dev)
-		dev_put(skb->dev);
 	skb->dev = NULL;
 	if (err)
 		goto out_free;
-- 
1.7.9.5

