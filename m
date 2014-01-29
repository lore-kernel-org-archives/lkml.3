Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbaA2GmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:42:05 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52287 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaA2GmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:42:02 -0500
Message-ID: <52E8A2AA.3090507@linux.vnet.ibm.com>
Date: Wed, 29 Jan 2014 12:11:46 +0530
From: Sohny Thomas <sthomas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        davem@davemloft.net, kumuda <kumuda@linux.vnet.ibm.com>
Subject: [PATCH] ipv6: default route for link local address is not added while
 assigning a address
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012906-1618-0000-0000-000005565972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this on netdev mailing list:
Default route for link local address is configured automatically if 
NETWORKING_IPV6=yes is in ifcfg-eth*.
When the route table for the interface is flushed and a new address is 
added to the same device with out removing linklocal addr, default route 
for link local address has to added by default.

I have found the issue to be caused by this checkin

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/ipv6?id=62b54dd91567686a1cb118f76a72d5f4764a86dd

According to this change :
He removes adding a link local route if any other address is added , 
applicable across all interfaces though there's mentioned only lo interface
So below patch fixes for other devices

Signed-off-by: Sohny THomas <sohthoma@linux.vnet.ibm.com>

-----

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f62c72b..a8a4df9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1763,6 +1763,16 @@ static int addrconf_ifid_infiniband(u8 *eui, 
struct net_device *dev)
         return 0;
  }

+static void addrconf_add_lroute(struct net_device *dev)
+{
+       struct in6_addr addr;
+
+       ipv6_addr_set(&addr,  htonl(0xFE800000), 0, 0, 0);
+       addrconf_prefix_route(&addr, 64, dev, 0, 0);
+}
+
+
+
  static int __ipv6_isatap_ifid(u8 *eui, __be32 addr)
  {
         if (addr == 0)
@@ -2010,8 +2020,10 @@ static struct inet6_dev *addrconf_add_dev(struct 
net_device *dev)
                 return ERR_PTR(-EACCES);

         /* Add default multicast route */
-       if (!(dev->flags & IFF_LOOPBACK))
+       if (!(dev->flags & IFF_LOOPBACK)){
                 addrconf_add_mroute(dev);
+               addrconf_add_lroute(dev);
+       }

         return idev;
  }

