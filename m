Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab3GZVH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:07:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103Ab3GZU6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/45] ipv6: dont call addrconf_dst_alloc again when enable lo
Date: Fri, 26 Jul 2013 13:57:34 -0700
Message-Id: <20130726205656.475992478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2357,6 +2357,9 @@ static void init_loopback(struct net_dev
 			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
 				continue;
 
+			if (sp_ifa->rt)
+				continue;
+
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
 			/* Failure cases are ignored */


