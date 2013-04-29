Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab3D2TT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:19:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765Ab3D2TDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Balakumaran Kannan <Balakumaran.Kannan@ap.sony.com>,
        Maruthi Thotad <Maruthi.Thotad@ap.sony.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/34] net IPv6 : Fix broken IPv6 routing table after loopback down-up
Date: Mon, 29 Apr 2013 12:02:26 -0700
Message-Id: <20130429184703.058645961@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Balakumaran Kannan <kumaran.4353@gmail.com>

[ Upstream commit 25fb6ca4ed9cad72f14f61629b68dc03c0d9713f ]

IPv6 Routing table becomes broken once we do ifdown, ifup of the loopback(lo)
interface. After down-up, routes of other interface's IPv6 addresses through
'lo' are lost.

IPv6 addresses assigned to all interfaces are routed through 'lo' for internal
communication. Once 'lo' is down, those routing entries are removed from routing
table. But those removed entries are not being re-created properly when 'lo' is
brought up. So IPv6 addresses of other interfaces becomes unreachable from the
same machine. Also this breaks communication with other machines because of
NDISC packet processing failure.

This patch fixes this issue by reading all interface's IPv6 addresses and adding
them to IPv6 routing table while bringing up 'lo'.

==Testing==
Before applying the patch:
$ route -A inet6
Kernel IPv6 routing table
Destination                    Next Hop                   Flag Met Ref Use If
2000::20/128                   ::                         U    256 0     0 eth0
fe80::/64                      ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
::1/128                        ::                         Un   0   1     0 lo
2000::20/128                   ::                         Un   0   1     0 lo
fe80::xxxx:xxxx:xxxx:xxxx/128  ::                         Un   0   1     0 lo
ff00::/8                       ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
$ sudo ifdown lo
$ sudo ifup lo
$ route -A inet6
Kernel IPv6 routing table
Destination                    Next Hop                   Flag Met Ref Use If
2000::20/128                   ::                         U    256 0     0 eth0
fe80::/64                      ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
::1/128                        ::                         Un   0   1     0 lo
ff00::/8                       ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
$

After applying the patch:
$ route -A inet6
Kernel IPv6 routing
table
Destination                    Next Hop                   Flag Met Ref Use If
2000::20/128                   ::                         U    256 0     0 eth0
fe80::/64                      ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
::1/128                        ::                         Un   0   1     0 lo
2000::20/128                   ::                         Un   0   1     0 lo
fe80::xxxx:xxxx:xxxx:xxxx/128  ::                         Un   0   1     0 lo
ff00::/8                       ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
$ sudo ifdown lo
$ sudo ifup lo
$ route -A inet6
Kernel IPv6 routing table
Destination                    Next Hop                   Flag Met Ref Use If
2000::20/128                   ::                         U    256 0     0 eth0
fe80::/64                      ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
::1/128                        ::                         Un   0   1     0 lo
2000::20/128                   ::                         Un   0   1     0 lo
fe80::xxxx:xxxx:xxxx:xxxx/128  ::                         Un   0   1     0 lo
ff00::/8                       ::                         U    256 0     0 eth0
::/0                           ::                         !n   -1  1     1 lo
$

Signed-off-by: Balakumaran Kannan <Balakumaran.Kannan@ap.sony.com>
Signed-off-by: Maruthi Thotad <Maruthi.Thotad@ap.sony.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2399,6 +2399,9 @@ static void sit_add_v4_addrs(struct inet
 static void init_loopback(struct net_device *dev)
 {
 	struct inet6_dev  *idev;
+	struct net_device *sp_dev;
+	struct inet6_ifaddr *sp_ifa;
+	struct rt6_info *sp_rt;
 
 	/* ::1 */
 
@@ -2410,6 +2413,30 @@ static void init_loopback(struct net_dev
 	}
 
 	add_addr(idev, &in6addr_loopback, 128, IFA_HOST);
+
+	/* Add routes to other interface's IPv6 addresses */
+	for_each_netdev(dev_net(dev), sp_dev) {
+		if (!strcmp(sp_dev->name, dev->name))
+			continue;
+
+		idev = __in6_dev_get(sp_dev);
+		if (!idev)
+			continue;
+
+		read_lock_bh(&idev->lock);
+		list_for_each_entry(sp_ifa, &idev->addr_list, if_list) {
+
+			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
+				continue;
+
+			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
+
+			/* Failure cases are ignored */
+			if (!IS_ERR(sp_rt))
+				ip6_ins_rt(sp_rt);
+		}
+		read_unlock_bh(&idev->lock);
+	}
 }
 
 static void addrconf_add_linklocal(struct inet6_dev *idev, const struct in6_addr *addr)


