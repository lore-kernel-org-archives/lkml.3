Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab3EGNlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3EGNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Balakumaran Kannan <Balakumaran.Kannan@ap.sony.com>,
        Maruthi Thotad <Maruthi.Thotad@ap.sony.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 043/118] net IPv6 : Fix broken IPv6 routing table after loopback down-up
Date: Tue,  7 May 2013 14:38:09 +0100
Message-Id: <1367933964-1564-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakumaran Kannan <kumaran.4353@gmail.com>

commit 25fb6ca4ed9cad72f14f61629b68dc03c0d9713f upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/addrconf.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 00188b3..2078f4e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2402,6 +2402,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 static void init_loopback(struct net_device *dev)
 {
 	struct inet6_dev  *idev;
+	struct net_device *sp_dev;
+	struct inet6_ifaddr *sp_ifa;
+	struct rt6_info *sp_rt;
 
 	/* ::1 */
 
@@ -2413,6 +2416,30 @@ static void init_loopback(struct net_device *dev)
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
-- 
1.8.1.2

