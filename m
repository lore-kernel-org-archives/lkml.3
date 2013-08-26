Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3HZCmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:42:22 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60222 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab3HZCmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:42:20 -0400
Message-ID: <521AC0B8.5010300@gmail.com>
Date: Mon, 26 Aug 2013 10:43:04 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: zhuyj <zyjzyj2000@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ipv6:remove ipv6 global address after the interface is
 down
References: <521ABD33.7070905@gmail.com>
In-Reply-To: <521ABD33.7070905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34.x kernels require a similar logic change as commit 73a8bd74
[ipv6:Revert 'administrative down' address handling changes]
introduces for newer kernels.

In 2.6.34.x kernels, when an interface with ipv6 global address is
restarted, the ipv6 route item disappear, but ipv6 global address
still remains. Compared with kernel versions 3.4+, the ipv6 global
address and route item should both disappear. To be consistent with
kernel versions 3.4+, we remove ipv6 address from the interface that
is shutdown.

Signed-off-by: yanjun.zhu<yanjun.zhu@windriver.com>
---
  net/ipv6/addrconf.c |   68 +++++++++-----------------------------------------
  1 files changed, 13 insertions(+), 55 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 018f431..bcb9d24 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2652,10 +2652,9 @@ static void addrconf_bonding_change(struct net_device *dev, unsigned long event)
  static int addrconf_ifdown(struct net_device *dev, int how)
  {
  	struct inet6_dev *idev;
-	struct inet6_ifaddr *ifa, *keep_list, **bifa;
+	struct inet6_ifaddr *ifa, **bifa;
  	struct net *net = dev_net(dev);
-	int state;
-	int i;
+	int state, i;
  
  	ASSERT_RTNL();
  
@@ -2686,9 +2685,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
  
  		write_lock_bh(&addrconf_hash_lock);
  		while ((ifa = *bifa) != NULL) {
-			if (ifa->idev == idev &&
-			    (how || !(ifa->flags&IFA_F_PERMANENT) ||
-			     ipv6_addr_type(&ifa->addr) & IPV6_ADDR_LINKLOCAL)) {
+			if (ifa->idev == idev){
  				*bifa = ifa->lst_next;
  				ifa->lst_next = NULL;
  				__in6_ifa_put(ifa);
@@ -2726,65 +2723,27 @@ static int addrconf_ifdown(struct net_device *dev, int how)
  		write_lock_bh(&idev->lock);
  	}
  #endif
-	keep_list = NULL;
-	bifa = &keep_list;
  	while ((ifa = idev->addr_list) != NULL) {
  		idev->addr_list = ifa->if_next;
  		ifa->if_next = NULL;
-
  		addrconf_del_timer(ifa);
  
-		/* If just doing link down, and address is permanent
-		   and not link-local, then retain it. */
-		if (how == 0 &&
-		    (ifa->flags&IFA_F_PERMANENT) &&
-		    !(ipv6_addr_type(&ifa->addr) & IPV6_ADDR_LINKLOCAL)) {
-
-			/* Move to holding list */
-			*bifa = ifa;
-			bifa = &ifa->if_next;
-
-			/* If not doing DAD on this address, just keep it. */
-			if ((dev->flags&(IFF_NOARP|IFF_LOOPBACK)) ||
-			    idev->cnf.accept_dad <= 0 ||
-			    (ifa->flags & IFA_F_NODAD))
-				continue;
-
-			/* If it was tentative already, no need to notify */
-			if (ifa->flags & IFA_F_TENTATIVE)
-				continue;
-
-			/* Flag it for later restoration when link comes up */
-			ifa->flags |= IFA_F_TENTATIVE;
-			ifa->state = INET6_IFADDR_STATE_DAD;
-
-			write_unlock_bh(&idev->lock);
-
-			in6_ifa_hold(ifa);
-		} else {
-			write_unlock_bh(&idev->lock);
-			spin_lock_bh(&ifa->state_lock);
-			state = ifa->state;
-			ifa->state = INET6_IFADDR_STATE_DEAD;
-			spin_unlock_bh(&ifa->state_lock);
-
-			if (state == INET6_IFADDR_STATE_DEAD)
-				goto put_ifa;
+		write_unlock_bh(&idev->lock);
+		spin_lock_bh(&ifa->state_lock);
+		state = ifa->state;
+		ifa->state = INET6_IFADDR_STATE_DEAD;
+		spin_unlock_bh(&ifa->state_lock);
+
+		if (state != INET6_IFADDR_STATE_DEAD){
+			__ipv6_ifa_notify(RTM_DELADDR, ifa);
+			atomic_notifier_call_chain(&inet6addr_chain, NETDEV_DOWN, ifa);
  		}
  
-		__ipv6_ifa_notify(RTM_DELADDR, ifa);
-		if (ifa->state == INET6_IFADDR_STATE_DEAD)
-			atomic_notifier_call_chain(&inet6addr_chain,
-						   NETDEV_DOWN, ifa);
-
-put_ifa:
  		in6_ifa_put(ifa);
  
  		write_lock_bh(&idev->lock);
  	}
  
-	idev->addr_list = keep_list;
-
  	write_unlock_bh(&idev->lock);
  
  	/* Step 5: Discard multicast list */
@@ -4103,8 +4062,7 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
  		addrconf_leave_solict(ifp->idev, &ifp->addr);
  		dst_hold(&ifp->rt->u.dst);
  
-		if (ifp->state == INET6_IFADDR_STATE_DEAD &&
-		    ip6_del_rt(ifp->rt))
+		if (ip6_del_rt(ifp->rt))
  			dst_free(&ifp->rt->u.dst);
  		break;
  	}


On 08/26/2013 10:28 AM, zhuyj wrote:
> With two directly connected targets running kernel 2.6.34.x.
>
> TargetA ------------------------- TargetB
> 3000::1/64                        3000::2/64
>
> TargetA
>    - bring the interface down by doing an "ifconfig eth1 down"
>    - bring the interface back up by doing an "ifconfig eth1 up"
>
> TargetB
>    - ping6 3000::1
>      ping6 succeeds the first time
>    - after bringing the interface on TargetA down and then back up, 
> ping6 to the interface fails.
>
> The root cause is:
> IPv6 address 3000::1/64 remains while the ipv6 route on eth1 
> disappears. Thus on TargetB, running "ping6 3000::1" can not succeed.
> Compared with 3.4.x, ipv6 address and ipv6 route item are removed when 
> an interface is restarted in the.
>
> Best Regards!
>
> zhuyj
>

