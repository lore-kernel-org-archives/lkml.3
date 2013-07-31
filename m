Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198Ab3GaNri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:47:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46862 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759576Ab3GaNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Gao feng" <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.232306487@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [02/84] ipv6: don't call addrconf_dst_alloc again when enable  lo
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit a881ae1f625c599b460cc8f8a7fcb1c438f699ad ]

If we disable all of the net interfaces, and enable
un-lo interface before lo interface, we already allocated
the addrconf dst in ipv6_add_addr. So we shouldn't allocate
it again when we enable lo interface.

Otherwise the message below will be triggered.
unregister_netdevice: waiting for sit1 to become free. Usage count = 1

This problem is introduced by commit 25fb6ca4ed9cad72f14f61629b68dc03c0d9713f
"net IPv6 : Fix broken IPv6 routing table after loopback down-up"

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d603caa..a7fe50f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2434,6 +2434,9 @@ static void init_loopback(struct net_device *dev)
 			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
 				continue;
 
+			if (sp_ifa->rt)
+				continue;
+
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
 			/* Failure cases are ignored */

