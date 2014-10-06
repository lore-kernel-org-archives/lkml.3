Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaJFVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:51:43 -0400
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:57275 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751131AbaJFVvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:51:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:2915:3138:3139:3140:3141:3142:3353:3865:3866:3870:3871:3873:3874:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:13161:13229:13255:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat36_2ba8e1c96fe62
X-Filterd-Recvd-Size: 3183
Message-ID: <1412632298.2916.42.camel@joe-AO725>
Subject: [PATCH net-next] net: core: Quiet W=1 warnings for unused vars and
 static functions
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Date: Mon, 06 Oct 2014 14:51:38 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce noise when compiling W=1.

All the variables are unused.
The functions are not called outside of the file so static
is preferred.

Signed-off-by: Joe Perches <joe@perches.com>
---

John, can you please verify that these gen_stats accesses
are unnecessary?  I believe the compiler can elide them in
any case, but I'm not sure what you intended here.

 net/core/dev.c       | 4 ++--
 net/core/gen_stats.c | 4 ----
 net/core/rtnetlink.c | 3 +--
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1a90530..2049a17 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5239,7 +5239,7 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
-void netdev_adjacent_add_links(struct net_device *dev)
+static void netdev_adjacent_add_links(struct net_device *dev)
 {
 	struct netdev_adjacent *iter;
 
@@ -5264,7 +5264,7 @@ void netdev_adjacent_add_links(struct net_device *dev)
 	}
 }
 
-void netdev_adjacent_del_links(struct net_device *dev)
+static void netdev_adjacent_del_links(struct net_device *dev)
 {
 	struct netdev_adjacent *iter;
 
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 14681b9..01be9cf 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -106,13 +106,9 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
 	for_each_possible_cpu(i) {
 		struct gnet_stats_basic_cpu *bcpu = per_cpu_ptr(cpu, i);
 		unsigned int start;
-		__u64 bytes;
-		__u32 packets;
 
 		do {
 			start = u64_stats_fetch_begin_irq(&bcpu->syncp);
-			bytes = bcpu->bstats.bytes;
-			packets = bcpu->bstats.packets;
 		} while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));
 
 		bstats->bytes += bcpu->bstats.bytes;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a688268..c2fe350 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2917,7 +2917,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	struct net *net = sock_net(skb->sk);
 	rtnl_doit_func doit;
-	int sz_idx, kind;
+	int kind;
 	int family;
 	int type;
 	int err;
@@ -2933,7 +2933,6 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return 0;
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
-	sz_idx = type>>2;
 	kind = type&3;
 
 	if (kind != 2 && !netlink_net_capable(skb, CAP_NET_ADMIN))


